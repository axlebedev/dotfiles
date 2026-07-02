import { BUILTIN_SETTINGS_RECIPES } from './recipes.constants.js';
import { getNestedValueBySegments } from '../../shared/lib/objectPaths.js';

const CUSTOM_RECIPES_STORAGE_KEY = 'ls-editor:settings-recipes';
const CREDENTIALS_FILE_PATH = 'src/credentials.json';
const DEFAULT_REGION = 'us-east-1';
const DEFAULT_APPROVED_RECIPES_KEY = 'approved-recipes.json';

function toIsoAmzDate(date) {
    const year = date.getUTCFullYear();
    const month = String(date.getUTCMonth() + 1).padStart(2, '0');
    const day = String(date.getUTCDate()).padStart(2, '0');
    const hours = String(date.getUTCHours()).padStart(2, '0');
    const minutes = String(date.getUTCMinutes()).padStart(2, '0');
    const seconds = String(date.getUTCSeconds()).padStart(2, '0');
    return `${year}${month}${day}T${hours}${minutes}${seconds}Z`;
}

function toDateStamp(date) {
    return toIsoAmzDate(date).slice(0, 8);
}

function toHex(uint8Array) {
    return Array.from(uint8Array).map((byte) => byte.toString(16).padStart(2, '0')).join('');
}

function encodeS3ObjectKey(objectKey) {
    return String(objectKey || '')
        .split('/')
        .map((segment) => encodeURIComponent(segment))
        .join('/');
}

async function sha256Hex(value) {
    const encoder = new TextEncoder();
    const bytes = typeof value === 'string' ? encoder.encode(value) : value;
    const hashBuffer = await crypto.subtle.digest('SHA-256', bytes);
    return toHex(new Uint8Array(hashBuffer));
}

async function hmacSha256(key, value) {
    const encoder = new TextEncoder();
    const cryptoKey = await crypto.subtle.importKey(
        'raw',
        key,
        { name: 'HMAC', hash: 'SHA-256' },
        false,
        ['sign'],
    );
    const signature = await crypto.subtle.sign('HMAC', cryptoKey, encoder.encode(value));
    return new Uint8Array(signature);
}

async function getSignatureKey(secretKey, dateStamp, region, service) {
    const encoder = new TextEncoder();
    const kDate = await hmacSha256(encoder.encode(`AWS4${secretKey}`), dateStamp);
    const kRegion = await hmacSha256(kDate, region);
    const kService = await hmacSha256(kRegion, service);
    return hmacSha256(kService, 'aws4_request');
}

async function loadS3Credentials() {
    try {
        const response = await fetch(chrome.runtime.getURL(CREDENTIALS_FILE_PATH), { cache: 'no-store' });
        if (!response.ok) return null;
        return response.json();
    } catch {
        return null;
    }
}

async function fetchApprovedRecipesFromS3(credentials) {
    const host = String(credentials?.HOST || '').trim().replace(/\/+$/, '');
    const accessKey = String(credentials?.AccessKey || '').trim();
    const secretKey = String(credentials?.SecretKey || '').trim();
    const bucket = String(credentials?.Bucket || '').trim();
    const region = String(credentials?.Region || DEFAULT_REGION).trim() || DEFAULT_REGION;
    const objectKey = String(credentials?.ApprovedRecipesKey || DEFAULT_APPROVED_RECIPES_KEY).trim() || DEFAULT_APPROVED_RECIPES_KEY;

    if (!host || !accessKey || !secretKey || !bucket) {
        return [];
    }

    const requestDate = new Date();
    const amzDate = toIsoAmzDate(requestDate);
    const dateStamp = toDateStamp(requestDate);
    const service = 's3';
    const payloadHash = await sha256Hex('');

    const encodedKey = encodeS3ObjectKey(objectKey);
    const requestUrl = `${host}/${bucket}/${encodedKey}`;
    const url = new URL(requestUrl);
    const canonicalUri = url.pathname;
    const canonicalQueryString = '';
    const canonicalHeaders = `host:${url.host}\nx-amz-content-sha256:${payloadHash}\nx-amz-date:${amzDate}\n`;
    const signedHeaders = 'host;x-amz-content-sha256;x-amz-date';
    const canonicalRequest = [
        'GET',
        canonicalUri,
        canonicalQueryString,
        canonicalHeaders,
        signedHeaders,
        payloadHash,
    ].join('\n');

    const credentialScope = `${dateStamp}/${region}/${service}/aws4_request`;
    const stringToSign = [
        'AWS4-HMAC-SHA256',
        amzDate,
        credentialScope,
        await sha256Hex(canonicalRequest),
    ].join('\n');

    const signingKey = await getSignatureKey(secretKey, dateStamp, region, service);
    const signature = toHex(await hmacSha256(signingKey, stringToSign));
    const authorizationHeader = `AWS4-HMAC-SHA256 Credential=${accessKey}/${credentialScope}, SignedHeaders=${signedHeaders}, Signature=${signature}`;

    const response = await fetch(requestUrl, {
        method: 'GET',
        headers: {
            Authorization: authorizationHeader,
            'x-amz-date': amzDate,
            'x-amz-content-sha256': payloadHash,
        },
        cache: 'no-store',
    });

    if (!response.ok) {
        return [];
    }

    const parsed = await response.json();
    const approvedRecipes = Array.isArray(parsed)
        ? parsed
        : (Array.isArray(parsed?.approvedRecipes) ? parsed.approvedRecipes : []);
    if (!approvedRecipes.length) return [];

    return approvedRecipes
        .map((rawRecipe) => normalizeRecipe(rawRecipe, 'builtin'))
        .filter(Boolean);
}

async function fetchApprovedRecipesByDirectUrl(credentials) {
    const directUrl = String(credentials?.ApprovedRecipesUrl || '').trim();
    if (!directUrl.length) {
        return [];
    }

    try {
        const response = await fetch(directUrl, { cache: 'no-store' });
        if (!response.ok) return [];
        const parsed = await response.json();
        const approvedRecipes = Array.isArray(parsed)
            ? parsed
            : (Array.isArray(parsed?.approvedRecipes) ? parsed.approvedRecipes : []);
        if (!approvedRecipes.length) return [];
        return approvedRecipes
            .map((rawRecipe) => normalizeRecipe(rawRecipe, 'builtin'))
            .filter(Boolean);
    } catch {
        return [];
    }
}

function cloneSerializable(value) {
    return JSON.parse(JSON.stringify(value));
}

function parsePath(path) {
    if (!path || typeof path !== 'string') return [];
    return path.split('.').filter(Boolean);
}

function normalizeOperation(rawOperation) {
    if (!rawOperation || typeof rawOperation !== 'object') {
        return null;
    }

    const path = typeof rawOperation.path === 'string' ? rawOperation.path.trim() : '';
    if (!path.length) {
        return null;
    }

    return {
        path,
        value: cloneSerializable(rawOperation.value)
    };
}

function normalizeOperations(rawOperations) {
    if (!Array.isArray(rawOperations)) return [];
    return rawOperations
        .map((rawOperation) => normalizeOperation(rawOperation))
        .filter(Boolean);
}

function normalizeRecipe(rawRecipe, source = 'custom') {
    if (!rawRecipe || typeof rawRecipe !== 'object') {
        return null;
    }

    const id = String(rawRecipe.id || '').trim();
    const title = String(rawRecipe.title || '').trim();
    const mode = rawRecipe.mode === 'toggle' ? 'toggle' : 'toggle';
    const on = normalizeOperations(rawRecipe.on);
    const off = normalizeOperations(rawRecipe.off);
    const description = rawRecipe.description ? String(rawRecipe.description) : '';
    const authorBandNick = rawRecipe.authorBandNick ? String(rawRecipe.authorBandNick).trim() : '';

    if (!id || !title || !on.length || !off.length) {
        return null;
    }

    return {
        id,
        title,
        description,
        authorBandNick,
        mode,
        on,
        off,
        source
    };
}

export function getBuiltinRecipes() {
    return BUILTIN_SETTINGS_RECIPES.map((recipe) => cloneSerializable(recipe));
}

export async function getCustomRecipes() {
    try {
        const storageData = await chrome.storage.local.get([CUSTOM_RECIPES_STORAGE_KEY]);
        const parsed = storageData?.[CUSTOM_RECIPES_STORAGE_KEY];
        if (!Array.isArray(parsed)) return [];

        return parsed
            .map((rawRecipe) => normalizeRecipe(rawRecipe, 'custom'))
            .filter(Boolean);
    } catch {
        return [];
    }
}

export async function getApprovedRecipes() {
    try {
        const credentials = await loadS3Credentials();
        if (!credentials || typeof credentials !== 'object') {
            return [];
        }

        const fromDirectUrl = await fetchApprovedRecipesByDirectUrl(credentials);
        if (fromDirectUrl.length) {
            return fromDirectUrl;
        }

        return fetchApprovedRecipesFromS3(credentials);
    } catch {
        return [];
    }
}

export async function saveCustomRecipes(recipes) {
    const normalizedRecipes = Array.isArray(recipes)
        ? recipes
            .map((recipe) => normalizeRecipe(recipe, 'custom'))
            .filter(Boolean)
        : [];

    await chrome.storage.local.set({
        [CUSTOM_RECIPES_STORAGE_KEY]: normalizedRecipes
    });
}

export async function getMergedRecipes() {
    const approvedRecipes = await getApprovedRecipes();
    const builtinRecipes = getBuiltinRecipes();
    const customRecipes = await getCustomRecipes();
    const byId = new Map();

    builtinRecipes.forEach((recipe) => {
        byId.set(recipe.id, recipe);
    });
    customRecipes.forEach((recipe) => {
        byId.set(recipe.id, recipe);
    });
    approvedRecipes.forEach((recipe) => {
        byId.set(recipe.id, recipe);
    });

    return Array.from(byId.values()).sort((left, right) => left.title.localeCompare(right.title));
}

export function evaluateRecipeState(settings, recipe) {
    const isOn = recipe.on.every((operation) => {
        const currentValue = getNestedValueBySegments(settings, parsePath(operation.path));
        return JSON.stringify(currentValue) === JSON.stringify(operation.value);
    });
    if (isOn) return 'on';

    const isOff = recipe.off.every((operation) => {
        const currentValue = getNestedValueBySegments(settings, parsePath(operation.path));
        return JSON.stringify(currentValue) === JSON.stringify(operation.value);
    });
    if (isOff) return 'off';

    return 'unknown';
}

export function parseRecipeOperationsJson(rawValue) {
    const parsed = JSON.parse(rawValue);
    if (!Array.isArray(parsed)) {
        return { ok: false, error: 'Ожидается JSON-массив операций.' };
    }

    const operations = normalizeOperations(parsed);
    if (!operations.length) {
        return { ok: false, error: 'Добавьте хотя бы одну операцию.' };
    }

    if (operations.length !== parsed.length) {
        return { ok: false, error: 'Каждая операция должна содержать path и value.' };
    }

    return { ok: true, value: operations };
}
