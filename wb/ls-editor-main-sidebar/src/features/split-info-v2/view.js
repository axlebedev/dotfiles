export function mountSplitInfoV2View(containerElement) {
    if (!containerElement) return;

    containerElement.innerHTML = `
        <div id="tab-split-info-v2-panel" class="tab-panel hidden">
            <div class="split-info-v2-controls">
                <div id="split-info-v2-status" class="status-message hidden"></div>
                <div id="split-info-v2-warning" class="status-message warning hidden"></div>

                <div class="split-info-v2-header">
                    <h2 class="split-info-v2-title">splitInfo</h2>
                    <div class="split-info-v2-actions">
                        <button
                            id="split-info-v2-changed-toggle-btn"
                            class="button button--secondary split-info-v2-changed-toggle-btn"
                            type="button"
                            aria-expanded="false"
                        >
                            Изменения (0)
                        </button>
                        <button id="split-info-v2-add-section-btn" class="button button--secondary" type="button">+ Секция</button>
                    </div>
                </div>

                <div id="split-info-v2-changed" class="split-info-v2-changed hidden"></div>

                <div id="split-info-v2-sections" class="split-info-v2-sections"></div>

                <button
                    id="split-info-v2-meta-toggle-btn"
                    class="button button--secondary split-info-v2-meta-toggle-btn"
                    type="button"
                    aria-expanded="false"
                >
                    Показать Meta + extra (JSON)
                </button>
                <div id="split-info-v2-meta-block" class="split-info-v2-meta-block hidden">
                    <label class="split-info-v2-meta-label" for="split-info-v2-meta-json">Meta + extra (JSON)</label>
                    <textarea id="split-info-v2-meta-json" class="modal-input split-info-v2-meta-json" spellcheck="false"></textarea>
                </div>

                <div class="split-info-v2-buttons">
                    <button id="split-info-v2-save-btn" class="button" type="button">Сохранить и перезагрузить</button>
                    <button id="split-info-v2-reset-btn" class="button button--ghost" type="button">Сбросить</button>
                </div>
            </div>

            <div id="split-info-v2-add-section-modal" class="modal-overlay hidden">
                <div class="modal-dialog" role="dialog" aria-modal="true" aria-labelledby="split-info-v2-add-section-title">
                    <h2 id="split-info-v2-add-section-title">Добавить секцию</h2>
                    <label class="modal-label" for="split-info-v2-section-name-input">Название секции</label>
                    <input
                        id="split-info-v2-section-name-input"
                        class="modal-input"
                        type="text"
                        placeholder="Например: search"
                    >
                    <div id="split-info-v2-add-section-error" class="modal-error hidden"></div>
                    <div class="modal-actions">
                        <button id="split-info-v2-add-section-submit" class="button modal-button" type="button">Добавить</button>
                        <button id="split-info-v2-add-section-cancel" class="button button-muted modal-button" type="button">Отмена</button>
                    </div>
                </div>
            </div>
        </div>
    `;
}
