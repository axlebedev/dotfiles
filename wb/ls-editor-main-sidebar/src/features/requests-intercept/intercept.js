const RULE_ID_BASE = 2000;
const MAX_RULES = 100;
const STORAGE_KEY = 'ls-editor:requests-redirect';
const SESSION_STORAGE_KEY = 'ls-editor:redirect-rules';
const RESOURCE_TYPES = [
    'main_frame',
    'sub_frame',
    'stylesheet',
    'script',
    'image',
    'font',
    'xmlhttprequest',
    'ping',
    'media',
    'other',
];

const ensureApiAvailability = () => {
    if (!chrome?.declarativeNetRequest?.updateSessionRules) {
        throw new Error('API declarativeNetRequest недоступно. Проверьте разрешения в манифесте.');
    }
};

const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

const getAllRuleIds = () => Array.from({ length: MAX_RULES }, (_, index) => RULE_ID_BASE + index);

const normalizePrefix = (rawUrl) => {
    try {
        const url = new URL(rawUrl);
        const normalizedPath = url.pathname.replace(/\/+$/, '');
        return normalizedPath ? `${url.origin}${normalizedPath}` : url.origin;
    } catch {
        throw new Error(`Некорректный URL: ${rawUrl}`);
    }
};

const buildRedirectRule = (id, sourcePrefix, targetPrefix) => ({
    id,
    priority: 1,
    action: {
        type: 'redirect',
        redirect: {
            regexSubstitution: `${targetPrefix}\\1`,
        },
    },
    condition: {
        regexFilter: `^${escapeRegExp(sourcePrefix)}([/?#].*|$)`,
        resourceTypes: RESOURCE_TYPES,
    },
});

const updateSessionRules = async (rules) => {
    ensureApiAvailability();
    await new Promise((resolve, reject) => {
        chrome.declarativeNetRequest.updateSessionRules(
            {
                removeRuleIds: getAllRuleIds(),
                addRules: Array.isArray(rules) ? rules : [],
            },
            () => {
                const lastError = chrome.runtime.lastError;
                if (lastError) {
                    reject(new Error(lastError.message));
                    return;
                }
                resolve();
            },
        );
    });
};

const saveRulesToSessionStorage = async (rules) => {
    try {
        await chrome.storage.session.set({ [SESSION_STORAGE_KEY]: rules || [] });
    } catch (e) {
        console.warn('Не удалось сохранить правила в chrome.storage.session:', e);
    }
};

const injectFetchInterceptor = async (rules) => {
    try {
        const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
        if (!activeTab?.id) return;

        await chrome.scripting.executeScript({
            target: { tabId: activeTab.id },
            world: 'MAIN',
            files: ['src/features/requests-intercept/content-fetch-interceptor.js'],
        });

        await chrome.scripting.executeScript({
            target: { tabId: activeTab.id },
            world: 'MAIN',
            func: (encoded) => {
                document.documentElement.setAttribute('data-ls-editor-rules', encoded);
                document.documentElement.dispatchEvent(
                    new CustomEvent('ls-editor:redirect-rules', { detail: encoded }),
                );
            },
            args: [JSON.stringify(rules)],
        });
    } catch (e) {
        console.warn('Не удалось внедрить перехватчик fetch:', e);
    }
};

const clearFetchInterceptor = async () => {
    try {
        await chrome.storage.session.remove(SESSION_STORAGE_KEY);

        const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
        if (!activeTab?.id) return;

        await chrome.scripting.executeScript({
            target: { tabId: activeTab.id },
            world: 'MAIN',
            func: () => {
                if (window.__lsEditorOriginalFetch) {
                    window.fetch = window.__lsEditorOriginalFetch;
                    delete window.__lsEditorOriginalFetch;
                }
                if (window.__lsEditorOriginalXHROpen) {
                    XMLHttpRequest.prototype.open = window.__lsEditorOriginalXHROpen;
                    delete window.__lsEditorOriginalXHROpen;
                }
                window.__lsEditorRedirectRules = [];
                window.__lsEditorFetchInterceptorActive = false;
                document.documentElement.removeAttribute('data-ls-editor-rules');
            },
        });
    } catch (e) {
        console.warn('Не удалось очистить перехватчик fetch:', e);
    }
};

export const applyRequestRedirect = async (rulesOrSourceUrl, maybeTargetUrl) => {
    let pairs;

    if (Array.isArray(rulesOrSourceUrl)) {
        pairs = rulesOrSourceUrl;
    } else {
        const sourceUrl = rulesOrSourceUrl;
        const targetUrl = maybeTargetUrl;
        if (!sourceUrl || !targetUrl) {
            throw new Error('Укажите оба URL для подмены запроса.');
        }
        pairs = [{ sourceUrl, targetUrl }];
    }

    if (!pairs.length) {
        throw new Error('Не указано ни одного правила подмены запросов.');
    }

    const normalizedPairs = pairs.map((pair) => {
        const sourceUrl = normalizePrefix(pair.sourceUrl);
        const targetUrl = normalizePrefix(pair.targetUrl);
        return { sourceUrl, targetUrl };
    });

    const rules = normalizedPairs.slice(0, MAX_RULES).map((pair, index) =>
        buildRedirectRule(RULE_ID_BASE + index, pair.sourceUrl, pair.targetUrl),
    );

    await updateSessionRules(rules);
    await saveRulesToSessionStorage(normalizedPairs);
    await injectFetchInterceptor(normalizedPairs);

    const payload = {
        rules: normalizedPairs,
        updatedAt: Date.now(),
    };

    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(payload));
    } catch (e) {
        throw new Error('Правила применены, но не удалось сохранить данные в localStorage.');
    }

    return { success: true };
};

export const clearRequestRedirectRule = async () => {
    await updateSessionRules(null);
    await clearFetchInterceptor();
    try {
        localStorage.removeItem(STORAGE_KEY);
    } catch {
        // Игнорируем ошибку удаления из localStorage
    }
    return { success: true };
};

export const getRequestRedirectRule = async () => {
    try {
        const raw = localStorage.getItem(STORAGE_KEY);
        if (!raw) {
            return null;
        }
        const parsed = JSON.parse(raw);

        if (parsed && Array.isArray(parsed.rules)) {
            return parsed;
        }

        if (parsed && parsed.sourceUrl && parsed.targetUrl) {
            return {
                rules: [
                    {
                        sourceUrl: parsed.sourceUrl,
                        targetUrl: parsed.targetUrl,
                    },
                ],
                updatedAt: parsed.updatedAt || null,
            };
        }

        return null;
    } catch {
        return null;
    }
};

