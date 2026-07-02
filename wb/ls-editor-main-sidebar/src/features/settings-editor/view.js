import { buildSelectMarkup } from '../../shared/ui/select.js';

const FLAG_VALUE_TYPE_OPTIONS = [
    { value: 'boolean', label: 'Boolean' },
    { value: 'number', label: 'Number' },
    { value: 'string', label: 'String' },
    { value: 'json', label: 'JSON' },
];

export function mountSettingsEditorView(containerElement) {
    if (!containerElement) return;

    containerElement.innerHTML = `
        <div id="tab-flags-panel" class="tab-panel">
            <div id="loader">Загрузка...</div>
            <div id="error-message" class="hidden"></div>
            
            <div id="controls" class="hidden">
                <div class="search-row">
                    <input type="text" id="search-input" placeholder="Поиск по ключу...">
                    <div class="search-actions">
                        <button id="button-add-flag" class="button button-add-flag" type="button" aria-label="Добавить флаг" title="Добавить флаг">+</button>
                        <button id="button-reset" class="button button-icon" aria-label="Сбросить к исходным" title="Сбросить к исходным"><img class="reload" src="icons/reload.min.svg" alt="Сбросить к исходным"></button>
                    </div>
                </div>
                <div class="buttons-container">
                    <button id="button-save" class="button">Сохранить и перезагрузить</button>
                </div>
                <div id="changed-container" class="hidden"></div>
                <div id="accordion-container"></div>
            </div>
        </div>

        <div id="add-flag-modal" class="modal-overlay hidden">
            <div class="modal-dialog" role="dialog" aria-modal="true" aria-labelledby="add-flag-title">
                <h2 id="add-flag-title">Добавить флаг</h2>

                <label class="modal-label" for="add-flag-section">Секция</label>
                ${buildSelectMarkup({
                    id: 'add-flag-section',
                    className: 'modal-input',
                })}

                <label class="modal-label" for="add-flag-key">Ключ</label>
                <input id="add-flag-key" class="modal-input" type="text" placeholder="Например: newFeatureX">

                <label class="modal-label" for="add-flag-type">Тип значения</label>
                ${buildSelectMarkup({
                    id: 'add-flag-type',
                    className: 'modal-input',
                    options: FLAG_VALUE_TYPE_OPTIONS,
                    selectedValue: 'boolean',
                })}

                <label class="modal-label">Значение</label>
                <div id="add-flag-value-container"></div>

                <div id="add-flag-error" class="modal-error hidden"></div>

                <div class="modal-actions">
                    <button id="add-flag-submit" class="button modal-button" type="button">Добавить</button>
                    <button id="add-flag-cancel" class="button button-muted modal-button" type="button">Отмена</button>
                </div>
            </div>
        </div>

        <div id="reset-confirm-modal" class="modal-overlay hidden">
            <div class="modal-dialog modal-dialog-warning" role="dialog" aria-modal="true" aria-labelledby="reset-confirm-title">
                <h2 id="reset-confirm-title">Сбросить настройки?</h2>
                <p class="modal-text">
                    Все текущие изменения будут удалены, а настройки вернутся к исходному состоянию.
                    Созданные вручную флаги также будут потеряны.
                </p>
                <div class="modal-actions">
                    <button id="reset-confirm-submit" class="button modal-button" type="button">Сбросить</button>
                    <button id="reset-confirm-cancel" class="button button-muted modal-button" type="button">Отмена</button>
                </div>
            </div>
        </div>
    `;
}
