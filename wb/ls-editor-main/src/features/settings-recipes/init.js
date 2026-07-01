import { getSettings, applySettingsRecipe } from '../../entities/settings/api.js';
import { SETTINGS_SECTIONS } from '../settings-editor/render.js';
import { getNestedValueBySegments } from '../../shared/lib/objectPaths.js';
import { buildSelectMarkup, setSelectOptions } from '../../shared/ui/select.js';
import {
    getCustomRecipes,
    getMergedRecipes,
    saveCustomRecipes,
    evaluateRecipeState
} from '../settings-editor/recipes.api.js';

const MATTERMOST_WEBHOOK_URL = 'https://band.wb.ru/hooks/55msew43atgp9qttascip43kyy';
const RECIPE_VALUE_TYPE_OPTIONS = [
    { value: 'boolean', label: 'boolean' },
    { value: 'number', label: 'number' },
    { value: 'string', label: 'string' },
    { value: 'json', label: 'json' },
];

export function initSettingsRecipesFeature() {
    const recipesList = document.getElementById('recipes-list');
    const recipesStatus = document.getElementById('recipes-status');
    const addRecipeButton = document.getElementById('button-add-recipe');

    const addRecipeModal = document.getElementById('add-recipe-modal');
    const addRecipeIdInput = document.getElementById('add-recipe-id');
    const addRecipeTitleInput = document.getElementById('add-recipe-title-input');
    const addRecipeDescriptionInput = document.getElementById('add-recipe-description');
    const addRecipeAuthorInput = document.getElementById('add-recipe-author');
    const addRecipeOnOps = document.getElementById('add-recipe-on-ops');
    const addRecipeOffOps = document.getElementById('add-recipe-off-ops');
    const addRecipeOnFromSettings = document.getElementById('add-recipe-on-from-settings');
    const addRecipeOffFromSettings = document.getElementById('add-recipe-off-from-settings');
    const addRecipeOnAddRow = document.getElementById('add-recipe-on-add-row');
    const addRecipeOffAddRow = document.getElementById('add-recipe-off-add-row');
    const addRecipeError = document.getElementById('add-recipe-error');
    const addRecipeSubmit = document.getElementById('add-recipe-submit');
    const addRecipeCancel = document.getElementById('add-recipe-cancel');

    const recipeSettingPickerModal = document.getElementById('recipe-setting-picker-modal');
    const recipeSettingPickerSection = document.getElementById('recipe-setting-picker-section');
    const recipeSettingPickerKey = document.getElementById('recipe-setting-picker-key');
    const recipeSettingPickerPreview = document.getElementById('recipe-setting-picker-preview');
    const recipeSettingPickerError = document.getElementById('recipe-setting-picker-error');
    const recipeSettingPickerSubmit = document.getElementById('recipe-setting-picker-submit');
    const recipeSettingPickerCancel = document.getElementById('recipe-setting-picker-cancel');

    if (!recipesList || !recipesStatus) return;

    let currentSettings = null;
    let recipes = [];
    let isApplyingRecipe = false;
    let recipePickerScope = 'on';

    function setRecipesStatus(message, type = 'info') {
        recipesStatus.textContent = message;
        recipesStatus.classList.remove('hidden', 'info', 'success', 'error');
        recipesStatus.classList.add('status-message', type);
    }

    function clearAddRecipeError() {
        addRecipeError.textContent = '';
        addRecipeError.classList.add('hidden');
    }

    function setAddRecipeError(message) {
        addRecipeError.textContent = message;
        addRecipeError.classList.remove('hidden');
    }

    function clearSettingPickerError() {
        recipeSettingPickerError.textContent = '';
        recipeSettingPickerError.classList.add('hidden');
    }

    function setSettingPickerError(message) {
        recipeSettingPickerError.textContent = message;
        recipeSettingPickerError.classList.remove('hidden');
    }

    function cloneSerializableValue(value) {
        if (value === undefined) return undefined;
        return JSON.parse(JSON.stringify(value));
    }

    function closeRecipeSettingPickerModal() {
        recipeSettingPickerModal.classList.add('hidden');
        clearSettingPickerError();
    }

    function closeAddRecipeModal() {
        addRecipeModal.classList.add('hidden');
        closeRecipeSettingPickerModal();
        clearAddRecipeError();
    }

    function buildRecipeConfigPayload(recipe) {
        return {
            id: recipe.id,
            title: recipe.title,
            description: recipe.description || '',
            authorBandNick: recipe.authorBandNick || '',
            mode: 'toggle',
            on: recipe.on,
            off: recipe.off
        };
    }

    function formatRecipeConfig(recipe) {
        return JSON.stringify(buildRecipeConfigPayload(recipe), null, 2);
    }

    function buildMattermostWebhookPayload(recipe) {
        const configJson = formatRecipeConfig(recipe);
        const authorNick = String(recipe?.authorBandNick || '').trim();
        return {
            text: [
                `Новый/обновленный сценарий: "${recipe.title}" (id: ${recipe.id}).`,
                `Автор (Band): ${authorNick || 'не указан'}`,
                '',
                '```json',
                configJson,
                '```'
            ].join('\n')
        };
    }

    async function sendRecipeToMattermost(recipe) {
        const payload = buildMattermostWebhookPayload(recipe);
        const response = await fetch(MATTERMOST_WEBHOOK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        if (!response.ok) {
            const responseText = await response.text().catch(() => '');
            throw new Error(`Webhook вернул ${response.status}${responseText ? `: ${responseText}` : ''}`);
        }
    }

    function inferValueType(value) {
        if (typeof value === 'boolean') return 'boolean';
        if (typeof value === 'number' && Number.isFinite(value)) return 'number';
        if (typeof value === 'string') return 'string';
        return 'json';
    }

    function getEmptyValueByType(type) {
        if (type === 'boolean') return false;
        if (type === 'number') return 0;
        if (type === 'string') return '';
        return {};
    }

    function renderOperationValueField(rowElement, type, value) {
        const valueContainer = rowElement.querySelector('.recipe-op-value-container');
        valueContainer.innerHTML = '';

        if (type === 'boolean') {
            const row = document.createElement('div');
            row.className = 'recipe-op-boolean';

            const label = document.createElement('label');
            label.className = 'switch';
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.className = 'recipe-op-value';
            checkbox.checked = Boolean(value);

            const slider = document.createElement('span');
            slider.className = 'slider';

            const state = document.createElement('span');
            state.className = 'recipe-op-boolean-state';
            state.textContent = checkbox.checked ? 'true' : 'false';
            checkbox.addEventListener('change', () => {
                state.textContent = checkbox.checked ? 'true' : 'false';
            });

            label.appendChild(checkbox);
            label.appendChild(slider);
            row.appendChild(label);
            row.appendChild(state);
            valueContainer.appendChild(row);
            return;
        }

        if (type === 'number') {
            const numberInput = document.createElement('input');
            numberInput.type = 'number';
            numberInput.className = 'modal-input recipe-op-value';
            numberInput.value = Number.isFinite(Number(value)) ? String(Number(value)) : '0';
            valueContainer.appendChild(numberInput);
            return;
        }

        if (type === 'json') {
            const textarea = document.createElement('textarea');
            textarea.className = 'modal-input recipe-op-value';
            textarea.rows = 3;
            textarea.value = JSON.stringify(value, null, 2);
            valueContainer.appendChild(textarea);
            return;
        }

        const textInput = document.createElement('input');
        textInput.type = 'text';
        textInput.className = 'modal-input recipe-op-value';
        textInput.value = value === undefined || value === null ? '' : String(value);
        valueContainer.appendChild(textInput);
    }

    function createOperationRow(scope, operation = null) {
        const sourceOperation = operation || { path: '', value: '' };
        const type = inferValueType(sourceOperation.value);
        const originalValueSerialized = JSON.stringify(sourceOperation.value === undefined ? null : sourceOperation.value);
        const row = document.createElement('div');
        row.className = 'recipe-op-row';
        row.dataset.scope = scope;
        row.dataset.originalValue = originalValueSerialized;
        row.innerHTML = `
            <div class="recipe-op-path-row">
                <input class="modal-input recipe-op-path" type="text" placeholder="data.some.path" value="">
            </div>
            <div class="recipe-op-main-row">
                ${buildSelectMarkup({
                    className: 'modal-input recipe-op-type',
                    options: RECIPE_VALUE_TYPE_OPTIONS,
                })}
                <div class="recipe-op-value-container"></div>
            </div>
            <div class="recipe-op-controls">
                <button class="recipe-op-btn recipe-op-reset" type="button">Сброс</button>
                <button class="recipe-op-btn recipe-op-remove" type="button">Удалить</button>
            </div>
        `;

        const typeSelect = row.querySelector('.recipe-op-type');
        const pathInput = row.querySelector('.recipe-op-path');
        const removeButton = row.querySelector('.recipe-op-remove');
        const resetButton = row.querySelector('.recipe-op-reset');
        pathInput.value = sourceOperation.path || '';
        typeSelect.value = type;
        renderOperationValueField(row, type, sourceOperation.value);

        typeSelect.addEventListener('change', () => {
            renderOperationValueField(row, typeSelect.value, getEmptyValueByType(typeSelect.value));
        });

        removeButton.addEventListener('click', () => row.remove());
        resetButton.addEventListener('click', () => {
            let originalValue = null;
            try {
                originalValue = JSON.parse(row.dataset.originalValue);
            } catch {
                originalValue = null;
            }
            const originalType = inferValueType(originalValue);
            typeSelect.value = originalType;
            renderOperationValueField(row, originalType, originalValue);
        });

        return row;
    }

    function appendOperationRow(scope, operation = null) {
        const container = scope === 'on' ? addRecipeOnOps : addRecipeOffOps;
        container.appendChild(createOperationRow(scope, operation));
    }

    function readOperationRow(rowElement) {
        const pathInput = rowElement.querySelector('.recipe-op-path');
        const typeSelect = rowElement.querySelector('.recipe-op-type');
        const valueElement = rowElement.querySelector('.recipe-op-value');
        const path = pathInput.value.trim();
        const type = typeSelect.value;

        if (!path.length) return { ok: false, error: 'Путь не может быть пустым.' };

        if (type === 'boolean') return { ok: true, value: { path, value: Boolean(valueElement.checked) } };
        if (type === 'number') {
            const parsedNumber = Number(valueElement.value);
            if (!Number.isFinite(parsedNumber)) return { ok: false, error: `Некорректное число для пути "${path}".` };
            return { ok: true, value: { path, value: parsedNumber } };
        }
        if (type === 'json') {
            try {
                return { ok: true, value: { path, value: JSON.parse(valueElement.value) } };
            } catch {
                return { ok: false, error: `Некорректный JSON для пути "${path}".` };
            }
        }
        return { ok: true, value: { path, value: valueElement.value } };
    }

    function collectOperations(scope) {
        const container = scope === 'on' ? addRecipeOnOps : addRecipeOffOps;
        const rows = Array.from(container.querySelectorAll('.recipe-op-row'));
        if (!rows.length) return { ok: false, error: `Добавьте хотя бы одну операцию ${scope.toUpperCase()}.` };

        const operations = [];
        for (const row of rows) {
            const rowResult = readOperationRow(row);
            if (!rowResult.ok) return rowResult;
            operations.push(rowResult.value);
        }
        return { ok: true, value: operations };
    }

    function getSectionObject(section) {
        return getNestedValueBySegments(currentSettings, section.pathSegments);
    }

    function updateSettingPickerPreview() {
        const section = SETTINGS_SECTIONS.find((item) => item.path === recipeSettingPickerSection.value);
        if (!section) {
            recipeSettingPickerPreview.textContent = 'Секция не выбрана.';
            return;
        }
        const key = recipeSettingPickerKey.value;
        if (!key) {
            recipeSettingPickerPreview.textContent = 'Ключ не выбран.';
            return;
        }
        const path = [...section.pathSegments, key].join('.');
        const value = getNestedValueBySegments(currentSettings, [...section.pathSegments, key]);
        recipeSettingPickerPreview.textContent = `Path: ${path}\nValue: ${JSON.stringify(value)}`;
    }

    function refreshSettingPickerKeys() {
        const section = SETTINGS_SECTIONS.find((item) => item.path === recipeSettingPickerSection.value);
        setSelectOptions(recipeSettingPickerKey, []);
        if (!section) {
            recipeSettingPickerPreview.textContent = 'Секция не выбрана.';
            return;
        }

        const sectionObject = getSectionObject(section);
        const keys = sectionObject && typeof sectionObject === 'object' ? Object.keys(sectionObject) : [];
        if (!keys.length) {
            recipeSettingPickerPreview.textContent = `В секции "${section.title}" нет доступных ключей.`;
            return;
        }

        setSelectOptions(
            recipeSettingPickerKey,
            keys.map((key) => ({ value: key, label: key })),
        );
        updateSettingPickerPreview();
    }

    function openRecipeSettingPickerModal(scope) {
        if (!currentSettings) return;
        recipePickerScope = scope;
        setSelectOptions(
            recipeSettingPickerSection,
            SETTINGS_SECTIONS
                .filter((section) => {
                    const sectionObject = getSectionObject(section);
                    return Boolean(sectionObject && typeof sectionObject === 'object');
                })
                .map((section) => ({
                    value: section.path,
                    label: section.title,
                })),
        );
        refreshSettingPickerKeys();
        clearSettingPickerError();
        recipeSettingPickerModal.classList.remove('hidden');
    }

    function openAddRecipeModal() {
        addRecipeIdInput.value = '';
        addRecipeTitleInput.value = '';
        addRecipeDescriptionInput.value = '';
        addRecipeAuthorInput.value = '';
        addRecipeOnOps.innerHTML = '';
        addRecipeOffOps.innerHTML = '';
        appendOperationRow('on', { path: 'data.switches.enable2faForEmployee', value: false });
        appendOperationRow('off', { path: 'data.switches.enable2faForEmployee', value: true });
        clearAddRecipeError();
        addRecipeModal.classList.remove('hidden');
        addRecipeIdInput.focus();
    }

    async function refreshRecipes() {
        recipes = await getMergedRecipes();
    }

    function buildRecipeBadge(label, className) {
        const badge = document.createElement('span');
        badge.className = `recipe-badge ${className}`;
        badge.textContent = label;
        return badge;
    }

    async function renderRecipes() {
        recipesList.innerHTML = '';

        if (!recipes.length) {
            const emptyState = document.createElement('div');
            emptyState.className = 'recipe-description';
            emptyState.textContent = 'Сценарии пока не добавлены.';
            recipesList.appendChild(emptyState);
            return;
        }

        recipes.forEach((recipe) => {
            const recipeState = currentSettings ? evaluateRecipeState(currentSettings, recipe) : 'unknown';
            const card = document.createElement('div');
            card.className = 'recipe-card';

            const header = document.createElement('div');
            header.className = 'recipe-card-header';
            const titleWrap = document.createElement('div');
            const title = document.createElement('p');
            title.className = 'recipe-title';
            title.textContent = recipe.title;
            titleWrap.appendChild(title);
            if (recipe.description) {
                const description = document.createElement('p');
                description.className = 'recipe-description';
                description.textContent = recipe.description;
                titleWrap.appendChild(description);
            }
            header.appendChild(titleWrap);

            const switchLabel = document.createElement('label');
            switchLabel.className = 'switch';
            const switchInput = document.createElement('input');
            switchInput.type = 'checkbox';
            switchInput.checked = recipeState === 'on';
            switchInput.disabled = isApplyingRecipe || !currentSettings;
            const switchSlider = document.createElement('span');
            switchSlider.className = 'slider';
            switchLabel.appendChild(switchInput);
            switchLabel.appendChild(switchSlider);
            header.appendChild(switchLabel);
            card.appendChild(header);

            const meta = document.createElement('div');
            meta.className = 'recipe-meta';
            if (recipeState === 'on') {
                meta.appendChild(buildRecipeBadge('Включен', 'state-on'));
            } else if (recipeState === 'off') {
                meta.appendChild(buildRecipeBadge('Выключен', 'state-off'));
            } else {
                const unknownBadge = buildRecipeBadge('Требует проверки', 'state-unknown');
                unknownBadge.title = 'Текущие значения не совпадают полностью ни с ON, ни с OFF.';
                meta.appendChild(unknownBadge);
            }
            meta.appendChild(buildRecipeBadge(
                recipe.source === 'custom' ? 'Пользовательский' : 'Встроенный',
                recipe.source === 'custom' ? 'source-custom' : 'source-builtin'
            ));
            card.appendChild(meta);

            if (recipeState === 'unknown') {
                const actions = document.createElement('div');
                actions.className = 'recipe-actions';
                const sendMattermostButton = document.createElement('button');
                sendMattermostButton.type = 'button';
                sendMattermostButton.className = 'recipe-action-btn';
                sendMattermostButton.textContent = 'Отправить запрос на добавление';
                sendMattermostButton.addEventListener('click', async () => {
                    try {
                        await sendRecipeToMattermost(recipe);
                        setRecipesStatus(`Сценарий "${recipe.title}" отправлен в Mattermost.`, 'success');
                    } catch (error) {
                        setRecipesStatus(error.message || 'Не удалось отправить сценарий в Mattermost.', 'error');
                    }
                });
                actions.appendChild(sendMattermostButton);
                card.appendChild(actions);
            }

            switchInput.addEventListener('change', async () => {
                if (isApplyingRecipe || !currentSettings) return;
                const targetState = switchInput.checked ? 'on' : 'off';
                const operations = targetState === 'on' ? recipe.on : recipe.off;
                isApplyingRecipe = true;
                await renderRecipes();
                setRecipesStatus(`Применяем сценарий "${recipe.title}"...`, 'info');

                try {
                    const response = await applySettingsRecipe(operations);
                    if (!response || !response.success) {
                        throw new Error(response?.error || 'Не удалось применить сценарий.');
                    }
                    setRecipesStatus(`Сценарий "${recipe.title}" применен. Перезагружаем страницу...`, 'success');
                    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
                    if (tab?.id) chrome.tabs.reload(tab.id);
                    window.close();
                } catch (error) {
                    setRecipesStatus(error.message || 'Не удалось применить сценарий.', 'error');
                    isApplyingRecipe = false;
                    await refreshSettings();
                    await refreshRecipes();
                    await renderRecipes();
                }
            });

            recipesList.appendChild(card);
        });
    }

    async function refreshSettings() {
        const response = await getSettings();
        if (response && response.success) {
            currentSettings = response.data;
            return true;
        }
        currentSettings = null;
        return false;
    }

    addRecipeButton?.addEventListener('click', () => openAddRecipeModal());
    addRecipeCancel?.addEventListener('click', () => closeAddRecipeModal());
    addRecipeModal?.addEventListener('click', (event) => {
        if (event.target === addRecipeModal) closeAddRecipeModal();
    });

    addRecipeOnAddRow?.addEventListener('click', () => appendOperationRow('on'));
    addRecipeOffAddRow?.addEventListener('click', () => appendOperationRow('off'));
    addRecipeOnFromSettings?.addEventListener('click', () => openRecipeSettingPickerModal('on'));
    addRecipeOffFromSettings?.addEventListener('click', () => openRecipeSettingPickerModal('off'));
    recipeSettingPickerSection?.addEventListener('change', () => refreshSettingPickerKeys());
    recipeSettingPickerKey?.addEventListener('change', () => updateSettingPickerPreview());
    recipeSettingPickerCancel?.addEventListener('click', () => closeRecipeSettingPickerModal());
    recipeSettingPickerModal?.addEventListener('click', (event) => {
        if (event.target === recipeSettingPickerModal) closeRecipeSettingPickerModal();
    });

    recipeSettingPickerSubmit?.addEventListener('click', () => {
        const section = SETTINGS_SECTIONS.find((item) => item.path === recipeSettingPickerSection.value);
        if (!section) return setSettingPickerError('Секция не выбрана.');
        const key = recipeSettingPickerKey.value;
        if (!key) return setSettingPickerError('Ключ не выбран.');

        const path = [...section.pathSegments, key].join('.');
        const value = cloneSerializableValue(getNestedValueBySegments(currentSettings, [...section.pathSegments, key]));
        appendOperationRow(recipePickerScope, { path, value });
        closeRecipeSettingPickerModal();
    });

    addRecipeSubmit?.addEventListener('click', async () => {
        clearAddRecipeError();
        const id = addRecipeIdInput.value.trim();
        const title = addRecipeTitleInput.value.trim();
        const description = addRecipeDescriptionInput.value.trim();
        const authorBandNick = addRecipeAuthorInput.value.trim();
        if (!id.length) return setAddRecipeError('ID не может быть пустым.');
        if (!title.length) return setAddRecipeError('Название не может быть пустым.');

        const onResult = collectOperations('on');
        if (!onResult.ok) return setAddRecipeError(`ON: ${onResult.error}`);
        const offResult = collectOperations('off');
        if (!offResult.ok) return setAddRecipeError(`OFF: ${offResult.error}`);

        const customRecipes = await getCustomRecipes();
        const nextRecipe = {
            id,
            title,
            description,
            authorBandNick,
            mode: 'toggle',
            on: onResult.value,
            off: offResult.value,
            source: 'custom'
        };
        const recipeExists = customRecipes.some((recipe) => recipe.id === id);
        const nextCustomRecipes = recipeExists
            ? customRecipes.map((recipe) => (recipe.id === id ? nextRecipe : recipe))
            : [...customRecipes, nextRecipe];

        await saveCustomRecipes(nextCustomRecipes);
        await refreshRecipes();
        await renderRecipes();
        closeAddRecipeModal();
        setRecipesStatus(recipeExists ? 'Кастомный сценарий обновлен.' : 'Кастомный сценарий добавлен.', 'success');
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            closeAddRecipeModal();
            closeRecipeSettingPickerModal();
        }
    });

    (async () => {
        const settingsLoaded = await refreshSettings();
        await refreshRecipes();
        await renderRecipes();
        if (!settingsLoaded) {
            setRecipesStatus('Не удалось прочитать global-settings-v2 для вычисления статуса сценариев.', 'error');
        }
    })();
}
