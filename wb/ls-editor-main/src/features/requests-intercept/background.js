// Service Worker:
// 1) Захватывает Authorization из запросов к *.wildberries.ru (webRequest)
// 2) Создаёт modifyHeaders-правила, которые ставят пойманный JWT
//    на запросы к стейдж-URL после declarativeNetRequest redirect.
//
// Redirect срезает Authorization при смене домена — modifyHeaders добавляет его обратно.

const MODIFY_RULE_ID_BASE = 3000;
const MODIFY_MAX_RULES = 100;
const AUTH_STORAGE_KEY = 'ls-editor:captured-auth';
const RULES_STORAGE_KEY = 'ls-editor:redirect-rules';

let capturedAuthHeader = null;

// --- Восстанавливаем JWT после перезапуска service worker ---
chrome.storage.session.get(AUTH_STORAGE_KEY, (data) => {
    capturedAuthHeader = data?.[AUTH_STORAGE_KEY] || null;
});

// --- Захватываем Authorization из любых запросов к wildberries.ru ---
chrome.webRequest.onBeforeSendHeaders.addListener(
    (details) => {
        if (!details.requestHeaders) return;

        const auth = details.requestHeaders.find(
            (h) => h.name.toLowerCase() === 'authorization',
        );

        if (auth?.value && auth.value.startsWith('Bearer ') && auth.value !== capturedAuthHeader) {
            capturedAuthHeader = auth.value;
            chrome.storage.session.set({ [AUTH_STORAGE_KEY]: capturedAuthHeader });
            applyModifyHeadersRules();
        }
    },
    { urls: ['*://*.wildberries.ru/*'] },
    ['requestHeaders', 'extraHeaders'],
);

// --- Создаём modifyHeaders-правила для стейдж-URL ---
const escapeRegExp = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

const getModifyRuleIds = () =>
    Array.from({ length: MODIFY_MAX_RULES }, (_, i) => MODIFY_RULE_ID_BASE + i);

async function applyModifyHeadersRules() {
    const data = await chrome.storage.session.get(RULES_STORAGE_KEY);
    const rules = data?.[RULES_STORAGE_KEY];

    const removeRuleIds = getModifyRuleIds();

    if (!capturedAuthHeader || !Array.isArray(rules) || !rules.length) {
        await chrome.declarativeNetRequest.updateSessionRules({ removeRuleIds, addRules: [] });
        return;
    }

    const addRules = rules.slice(0, MODIFY_MAX_RULES).map((rule, index) => ({
        id: MODIFY_RULE_ID_BASE + index,
        priority: 1,
        action: {
            type: 'modifyHeaders',
            requestHeaders: [
                { header: 'Authorization', operation: 'set', value: capturedAuthHeader },
            ],
        },
        condition: {
            regexFilter: `^${escapeRegExp(rule.targetUrl)}([/?#].*|$)`,
            resourceTypes: ['xmlhttprequest'],
        },
    }));

    await chrome.declarativeNetRequest.updateSessionRules({ removeRuleIds, addRules });
}

// --- Обновляем при изменении правил подмены ---
chrome.storage.session.onChanged.addListener((changes) => {
    if (RULES_STORAGE_KEY in changes) {
        applyModifyHeadersRules();
    }
});
