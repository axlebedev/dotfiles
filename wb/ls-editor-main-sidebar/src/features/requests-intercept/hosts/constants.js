import { COMMON_DEV_HOSTS } from './common.dev.js';
import { COMMON_RELEASE_HOSTS } from './common.release.js';

const URL_WITH_PROTOCOL_PATTERN = /^(https?):\/\/([^/?#:]+)(?::(\d+))?(?:[/?#]|$)/i;
const PROXY_URL_PATTERN = /^\/https?\//i;
const PROXY_ORIGIN_PATTERN = /^\/(https?)\/([^/?#:]+)(?::(\d+))?(?:[/?#]|$)/i;
const BARE_HOST_PATTERN = /^([a-z0-9.-]+\.[a-z]{2,})(?::(\d+))?(?:[/?#]|$)/i;

const buildOrigin = (protocol, host, port) => `${protocol}://${host}${port ? `:${port}` : ''}`;

const extractUrlHint = (rawValue) => {
    if (typeof rawValue !== 'string') return null;
    const value = rawValue.trim();
    if (!value) return null;

    if (PROXY_URL_PATTERN.test(value)) {
        const match = value.match(PROXY_ORIGIN_PATTERN);
        if (!match?.[2]) return null;
        return buildOrigin(match[1], match[2], match[3]);
    }

    const urlMatch = value.match(URL_WITH_PROTOCOL_PATTERN);
    if (urlMatch?.[2]) {
        return buildOrigin(urlMatch[1], urlMatch[2], urlMatch[3]);
    }

    const bareHostMatch = value.match(BARE_HOST_PATTERN);
    if (bareHostMatch?.[1]) {
        return buildOrigin('https', bareHostMatch[1], bareHostMatch[2]);
    }

    return null;
};

const collectHostHints = (...hostMaps) => {
    const uniqOrigins = new Set();

    hostMaps.forEach((hostMap) => {
        Object.values(hostMap || {}).forEach((value) => {
            const origin = extractUrlHint(value);
            if (origin) {
                uniqOrigins.add(origin);
            }
        });
    });

    return Array.from(uniqOrigins).sort((a, b) => a.localeCompare(b));
};

export const REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_RELEASE = collectHostHints(COMMON_RELEASE_HOSTS);
export const REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_DEV = collectHostHints(COMMON_DEV_HOSTS);
export const REQUESTS_INTERCEPT_SOURCE_HOST_HINTS = collectHostHints(COMMON_RELEASE_HOSTS, COMMON_DEV_HOSTS);
