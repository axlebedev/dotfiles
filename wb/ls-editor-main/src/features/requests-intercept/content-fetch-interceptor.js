// Перехватчик fetch/XHR для подмены запросов с сохранением заголовков.
// fetch — проксируется через service worker расширения (обход CORS и проблем с сертификатами).
// XHR — URL подменяется на уровне JS (fallback).
(() => {
    // --- Proxy: MAIN world ↔ ISOLATED bridge ↔ service worker ---
    let proxyCounter = 0;
    const proxyPending = new Map();
    const PROXY_TIMEOUT = 30000;

    window.addEventListener('message', (event) => {
        if (event.data?.source !== 'ls-editor-proxy-response') return;
        const { requestId, response } = event.data;
        const pending = proxyPending.get(requestId);
        if (!pending) return;

        clearTimeout(pending.timer);
        proxyPending.delete(requestId);

        if (response?.error) {
            pending.reject(new TypeError(response.message || 'Proxy fetch failed'));
            return;
        }

        pending.resolve(
            new Response(response.body, {
                status: response.status,
                statusText: response.statusText,
                headers: response.headers,
            }),
        );
    });

    const proxyFetch = (url, method, headers, body) => {
        const requestId = ++proxyCounter;
        return new Promise((resolve, reject) => {
            const timer = setTimeout(() => {
                proxyPending.delete(requestId);
                reject(new TypeError('ls-editor proxy: timeout'));
            }, PROXY_TIMEOUT);

            proxyPending.set(requestId, { resolve, reject, timer });

            window.postMessage(
                {
                    source: 'ls-editor-proxy-request',
                    requestId,
                    url,
                    method,
                    headers,
                    body,
                },
                '*',
            );
        });
    };

    // --- Извлечение заголовков из fetch-аргументов ---
    const readHeaders = (h, result) => {
        if (!h) return;
        // Headers-like объект (нативный или полифил) — у него есть forEach
        if (typeof h.forEach === 'function') {
            h.forEach((value, key) => { result[key] = value; });
        } else if (Array.isArray(h)) {
            h.forEach(([key, value]) => { result[key] = value; });
        } else if (typeof h === 'object') {
            for (const [key, value] of Object.entries(h)) {
                result[key] = value;
            }
        }
    };

    const extractHeaders = (input, init) => {
        const result = {};

        // Заголовки из Request-like объекта (input может быть Request или его полифил)
        if (input && typeof input === 'object' && input.headers) {
            readHeaders(input.headers, result);
        }

        // Заголовки из init перезаписывают заголовки из input
        if (init?.headers) {
            readHeaders(init.headers, result);
        }

        return result;
    };

    // --- Применение правил ---
    const applyRedirectRules = (rules) => {
        if (!Array.isArray(rules) || !rules.length) return;

        window.__lsEditorRedirectRules = rules;

        if (window.__lsEditorFetchInterceptorActive) return;
        window.__lsEditorFetchInterceptorActive = true;

        const originalFetch = window.fetch;
        const originalXHROpen = XMLHttpRequest.prototype.open;

        window.__lsEditorOriginalFetch = originalFetch;
        window.__lsEditorOriginalXHROpen = originalXHROpen;

        const rewriteUrl = (url) => {
            if (!url) return null;
            const str = typeof url === 'string' ? url : url.toString();
            for (const rule of window.__lsEditorRedirectRules) {
                if (str.startsWith(rule.sourceUrl)) {
                    return str.replace(rule.sourceUrl, rule.targetUrl);
                }
            }
            return null;
        };

        // Fetch — через прокси service worker (обход CORS/cert)
        window.fetch = function (input, init) {
            let url;
            if (typeof input === 'string') {
                url = input;
            } else if (input && typeof input === 'object') {
                url = input.href || input.url || null;
            }

            const newUrl = rewriteUrl(url);

            if (newUrl !== null) {
                const method =
                    init?.method ||
                    (input && typeof input === 'object' && input.method) ||
                    'GET';
                const headers = extractHeaders(input, init);
                const body =
                    (typeof init?.body === 'string' ? init.body : null) ||
                    (typeof input?.body === 'string' ? input.body : null);

                return proxyFetch(newUrl, method, headers, body);
            }

            return originalFetch.call(this, input, init);
        };

        // XHR — URL-rewrite (fallback, без прокси)
        XMLHttpRequest.prototype.open = function (method, url, ...rest) {
            const newUrl = rewriteUrl(url);
            if (newUrl !== null) {
                return originalXHROpen.call(this, method, newUrl, ...rest);
            }
            return originalXHROpen.call(this, method, url, ...rest);
        };
    };

    // Получаем правила от bridge-скрипта через CustomEvent
    document.documentElement.addEventListener('ls-editor:redirect-rules', (event) => {
        try {
            applyRedirectRules(JSON.parse(event.detail));
        } catch {}
    });

    // Проверяем data-атрибут, если bridge отработал раньше
    try {
        const existing = document.documentElement.getAttribute('data-ls-editor-rules');
        if (existing) {
            applyRedirectRules(JSON.parse(existing));
        }
    } catch {}
})();
