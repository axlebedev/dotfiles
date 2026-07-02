import { buildSelectMarkup } from '../../shared/ui/select.js';

export function mountSettingsRecipesView(containerElement) {
    if (!containerElement) return;

    containerElement.innerHTML = `
        <div id="tab-recipes-panel" class="tab-panel hidden">
            <div id="recipes-section" class="recipes-section">
                <div class="recipes-header">
                    <div class="recipes-title-wrap">
                        <h2 class="recipes-title">Сценарии</h2>
                        <p class="recipes-subtitle">Быстрые переключатели для сложных наборов изменений.</p>
                    </div>
                    <button id="button-add-recipe" class="button button--secondary" type="button">+ Сценарий</button>
                </div>
                <div id="recipes-status" class="status-message hidden"></div>
                <div id="recipes-list" class="recipes-list"></div>
            </div>
        </div>

        <div id="add-recipe-modal" class="modal-overlay hidden">
            <div class="modal-dialog modal-dialog-recipe" role="dialog" aria-modal="true" aria-labelledby="add-recipe-title">
                <h2 id="add-recipe-title">Добавить сценарий</h2>

                <label class="modal-label" for="add-recipe-id">ID</label>
                <input id="add-recipe-id" class="modal-input" type="text" placeholder="Например: wb-disable-2fa-for-employee">

                <label class="modal-label" for="add-recipe-title-input">Название</label>
                <input id="add-recipe-title-input" class="modal-input" type="text" placeholder="Короткое название сценария">

                <label class="modal-label" for="add-recipe-description">Описание</label>
                <input id="add-recipe-description" class="modal-input" type="text" placeholder="Опционально">

                <label class="modal-label" for="add-recipe-author">Band ник автора</label>
                <input id="add-recipe-author" class="modal-input" type="text" placeholder="например: zakir.gafiiatov">

                <label class="modal-label">Операции ON</label>
                <div class="recipe-ops-actions">
                    <button id="add-recipe-on-from-settings" class="button button--secondary recipe-op-action" type="button">+ Из списка</button>
                    <button id="add-recipe-on-add-row" class="button button--secondary recipe-op-action" type="button">+ Пустая</button>
                </div>
                <div id="add-recipe-on-ops" class="recipe-ops-list"></div>

                <label class="modal-label">Операции OFF</label>
                <div class="recipe-ops-actions">
                    <button id="add-recipe-off-from-settings" class="button button--secondary recipe-op-action" type="button">+ Из списка</button>
                    <button id="add-recipe-off-add-row" class="button button--secondary recipe-op-action" type="button">+ Пустая</button>
                </div>
                <div id="add-recipe-off-ops" class="recipe-ops-list"></div>

                <div id="add-recipe-error" class="modal-error hidden"></div>

                <div class="modal-actions">
                    <button id="add-recipe-submit" class="button modal-button" type="button">Сохранить</button>
                    <button id="add-recipe-cancel" class="button button-muted modal-button" type="button">Отмена</button>
                </div>
            </div>
        </div>

        <div id="recipe-setting-picker-modal" class="modal-overlay hidden">
            <div class="modal-dialog modal-dialog-warning" role="dialog" aria-modal="true" aria-labelledby="recipe-setting-picker-title">
                <h2 id="recipe-setting-picker-title">Добавить из списка настроек</h2>

                <label class="modal-label" for="recipe-setting-picker-section">Секция</label>
                ${buildSelectMarkup({
                    id: 'recipe-setting-picker-section',
                    className: 'modal-input',
                })}

                <label class="modal-label" for="recipe-setting-picker-key">Ключ</label>
                ${buildSelectMarkup({
                    id: 'recipe-setting-picker-key',
                    className: 'modal-input',
                })}

                <p id="recipe-setting-picker-preview" class="modal-text"></p>
                <div id="recipe-setting-picker-error" class="modal-error hidden"></div>

                <div class="modal-actions">
                    <button id="recipe-setting-picker-submit" class="button modal-button" type="button">Добавить</button>
                    <button id="recipe-setting-picker-cancel" class="button button-muted modal-button" type="button">Отмена</button>
                </div>
            </div>
        </div>
    `;
}
