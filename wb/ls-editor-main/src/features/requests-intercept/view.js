export function mountRequestsInterceptView(containerElement) {
    if (!containerElement) return;

    containerElement.innerHTML = `
        <div id="tab-requests-panel" class="tab-panel hidden">
            <div class="requests-controls">
                <div id="requests-groups-container" class="requests-groups"></div>
                <datalist id="requests-source-host-hints"></datalist>
                <button id="requests-add-group-btn" class="button button--secondary" type="button">+ Добавить правило</button>
                <div class="requests-buttons">
                    <button id="requests-replace-btn" class="button">Заменить</button>
                    <button id="requests-reset-btn" class="button button--ghost" type="button">Сбросить</button>
                </div>
                <div id="requests-status" class="status-message hidden"></div>
            </div>
        </div>
    `;
}
