// Мост между MAIN world и chrome API (ISOLATED world).
// 1) Передаёт правила подмены из chrome.storage.session в MAIN world.
// 2) Проксирует fetch-запросы через service worker расширения (обход CORS).
(() => {
    // --- Передача правил подмены ---
    chrome.storage.session.get('ls-editor:redirect-rules', (data) => {
        const rules = data?.['ls-editor:redirect-rules'];
        if (!Array.isArray(rules) || !rules.length) return;

        const encoded = JSON.stringify(rules);
        document.documentElement.setAttribute('data-ls-editor-rules', encoded);
        document.documentElement.dispatchEvent(
            new CustomEvent('ls-editor:redirect-rules', { detail: encoded }),
        );
    });

    // --- Прокси fetch через service worker ---
    window.addEventListener('message', (event) => {
        if (event.data?.source !== 'ls-editor-proxy-request') return;

        const { requestId, url, method, headers, body } = event.data;

        chrome.runtime.sendMessage(
            { action: 'proxy-fetch', url, method, headers, body },
            (response) => {
                window.postMessage(
                    {
                        source: 'ls-editor-proxy-response',
                        requestId,
                        response: response || { error: true, message: 'No response from service worker' },
                    },
                    '*',
                );
            },
        );
    });
})();
