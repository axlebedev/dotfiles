import { getSettings, setSettings, resetSettings, getBackup } from '../../entities/settings/api.js';
import {
    buildSettingsAccordion,
    renderChangedList,
    SETTINGS_SECTIONS
} from './render.js';
import {
    decodePathSegments,
    setNestedValueBySegments,
    getNestedValueBySegments,
    deleteNestedValueBySegments
} from '../../shared/lib/objectPaths.js';
import { setSelectOptions } from '../../shared/ui/select.js';

const FLAG_VALUE_TYPE_OPTIONS = [
    { value: 'boolean', label: 'Boolean' },
    { value: 'number', label: 'Number' },
    { value: 'string', label: 'String' },
    { value: 'json', label: 'JSON' },
];

export function initSettingsEditorFeature() {
    const loader = document.getElementById('loader');
    const controls = document.getElementById('controls');
    const errorMessage = document.getElementById('error-message');
    const accordionContainer = document.getElementById('accordion-container');
    const saveButton = document.getElementById('button-save');
    const resetButton = document.getElementById('button-reset');
    const addFlagButton = document.getElementById('button-add-flag');
    const searchInput = document.getElementById('search-input');
    const changedContainer = document.getElementById('changed-container');

    const addFlagModal = document.getElementById('add-flag-modal');
    const addFlagSection = document.getElementById('add-flag-section');
    const addFlagKey = document.getElementById('add-flag-key');
    const addFlagType = document.getElementById('add-flag-type');
    const addFlagValueContainer = document.getElementById('add-flag-value-container');
    const addFlagError = document.getElementById('add-flag-error');
    const addFlagSubmit = document.getElementById('add-flag-submit');
    const addFlagCancel = document.getElementById('add-flag-cancel');

    const resetConfirmModal = document.getElementById('reset-confirm-modal');
    const resetConfirmSubmit = document.getElementById('reset-confirm-submit');
    const resetConfirmCancel = document.getElementById('reset-confirm-cancel');

    let currentSettings = null;
    saveButton.classList.add('hidden');

    function showError(message) {
        loader.classList.add('hidden');
        errorMessage.textContent = message;
        errorMessage.classList.remove('hidden');
    }

    function applySearchFilter() {
        const searchTerm = searchInput.value.toLowerCase();
        accordionContainer.querySelectorAll('.accordion-section').forEach((section) => {
            let hasVisibleItem = false;
            const content = section.querySelector('.accordion-content');
            content.querySelectorAll('.setting-item').forEach((item) => {
                const isMatch = item.dataset.key.includes(searchTerm);
                item.style.display = isMatch ? 'flex' : 'none';
                if (isMatch) hasVisibleItem = true;
            });
            section.style.display = hasVisibleItem || !searchTerm ? 'block' : 'none';
            const header = section.querySelector('.accordion-header');
            if (searchTerm && hasVisibleItem && !header.classList.contains('active')) {
                header.click();
            }
        });
    }

    function clearAddFlagError() {
        addFlagError.textContent = '';
        addFlagError.classList.add('hidden');
    }

    function cloneSerializableValue(value) {
        if (value === undefined) return undefined;
        return JSON.parse(JSON.stringify(value));
    }

    function setAddFlagError(message) {
        addFlagError.textContent = message;
        addFlagError.classList.remove('hidden');
    }

    function renderAddFlagValueInput() {
        const type = addFlagType.value;
        addFlagValueContainer.innerHTML = '';

        if (type === 'boolean') {
            addFlagValueContainer.innerHTML = `
                <label class="switch">
                    <input id="add-flag-value-boolean" type="checkbox" checked>
                    <span class="slider"></span>
                </label>
            `;
            return;
        }

        if (type === 'number') {
            addFlagValueContainer.innerHTML = '<input id="add-flag-value-number" class="modal-input" type="number" value="0">';
            return;
        }

        if (type === 'json') {
            addFlagValueContainer.innerHTML = '<textarea id="add-flag-value-json" class="modal-input" placeholder="{\n  \"enabled\": true\n}"></textarea>';
            return;
        }

        addFlagValueContainer.innerHTML = '<input id="add-flag-value-string" class="modal-input" type="text" value="">';
    }

    function parseAddFlagValue() {
        const type = addFlagType.value;

        if (type === 'boolean') {
            return { ok: true, value: document.getElementById('add-flag-value-boolean').checked };
        }

        if (type === 'number') {
            const raw = document.getElementById('add-flag-value-number').value;
            const parsedNumber = Number(raw);
            if (!Number.isFinite(parsedNumber)) {
                return { ok: false, error: 'Введите корректное числовое значение.' };
            }
            return { ok: true, value: parsedNumber };
        }

        if (type === 'json') {
            const raw = document.getElementById('add-flag-value-json').value;
            try {
                return { ok: true, value: JSON.parse(raw) };
            } catch {
                return { ok: false, error: 'Некорректный JSON.' };
            }
        }

        return { ok: true, value: document.getElementById('add-flag-value-string').value };
    }

    function closeAddFlagModal() {
        addFlagModal.classList.add('hidden');
        clearAddFlagError();
    }

    function closeResetConfirmModal() {
        resetConfirmModal.classList.add('hidden');
    }

    function openResetConfirmModal() {
        resetConfirmModal.classList.remove('hidden');
    }

    function openAddFlagModal() {
        if (!currentSettings) return;

        setSelectOptions(
            addFlagSection,
            SETTINGS_SECTIONS.map((section) => ({
                value: section.path,
                label: section.title,
            })),
        );

        addFlagKey.value = '';
        addFlagType.value = 'boolean';
        renderAddFlagValueInput();
        clearAddFlagError();
        addFlagModal.classList.remove('hidden');
        addFlagKey.focus();
    }

    async function updateChangedList() {
        try {
            const backupResponse = await getBackup();
            if (!backupResponse || !backupResponse.success) {
                changedContainer.classList.add('hidden');
                saveButton.classList.add('hidden');
                return;
            }
            const changedCount = renderChangedList(accordionContainer, changedContainer, backupResponse.data, {
                onRevertChange: async ({ segments, hasBackupValue, backupValue }) => {
                    if (hasBackupValue) {
                        setNestedValueBySegments(currentSettings, segments, cloneSerializableValue(backupValue));
                    } else {
                        deleteNestedValueBySegments(currentSettings, segments);
                    }
                    await rebuildSettingsView();
                }
            });
            saveButton.classList.toggle('hidden', changedCount <= 0);
        } catch {
            changedContainer.classList.add('hidden');
            saveButton.classList.add('hidden');
        }
    }

    async function rebuildSettingsView() {
        buildSettingsAccordion(accordionContainer, currentSettings);
        applySearchFilter();
        await updateChangedList();
    }

    searchInput.addEventListener('input', () => applySearchFilter());
    addFlagButton.addEventListener('click', () => openAddFlagModal());
    addFlagCancel.addEventListener('click', () => closeAddFlagModal());
    addFlagModal.addEventListener('click', (event) => {
        if (event.target === addFlagModal) closeAddFlagModal();
    });
    resetConfirmCancel.addEventListener('click', () => closeResetConfirmModal());
    resetConfirmModal.addEventListener('click', (event) => {
        if (event.target === resetConfirmModal) closeResetConfirmModal();
    });

    addFlagType.addEventListener('change', () => {
        clearAddFlagError();
        renderAddFlagValueInput();
    });

    addFlagSubmit.addEventListener('click', async () => {
        clearAddFlagError();
        const key = addFlagKey.value;
        if (!key.length) return setAddFlagError('Ключ не может быть пустым.');

        const valueResult = parseAddFlagValue();
        if (!valueResult.ok) return setAddFlagError(valueResult.error);

        const selectedSection = SETTINGS_SECTIONS.find((section) => section.path === addFlagSection.value);
        if (!selectedSection) return setAddFlagError('Секция не найдена.');

        let targetObject = getNestedValueBySegments(currentSettings, selectedSection.pathSegments);
        if (!targetObject || typeof targetObject !== 'object' || Array.isArray(targetObject)) {
            setNestedValueBySegments(currentSettings, selectedSection.pathSegments, {});
            targetObject = getNestedValueBySegments(currentSettings, selectedSection.pathSegments);
        }

        if (Object.prototype.hasOwnProperty.call(targetObject, key)) {
            const approved = confirm(`Ключ '${key}' уже существует в секции '${selectedSection.title}'. Перезаписать значение?`);
            if (!approved) return;
        }

        targetObject[key] = valueResult.value;
        await rebuildSettingsView();
        closeAddFlagModal();
    });

    saveButton.addEventListener('click', async () => {
        if (!currentSettings) return;
        const inputs = accordionContainer.querySelectorAll('[data-path-id]');
        let parseError = false;

        inputs.forEach((input) => {
            if (parseError) return;
            const pathSegments = decodePathSegments(input.dataset.pathId);
            const type = input.dataset.type;
            let value;

            if (type === 'boolean') {
                value = input.checked;
            } else if (type === 'object') {
                try {
                    value = JSON.parse(input.value);
                } catch {
                    alert(`Ошибка: Некорректный формат JSON для ключа '${pathSegments.join('.')}'`);
                    parseError = true;
                    return;
                }
            } else if (type === 'number') {
                value = Number(input.value);
            } else {
                value = input.value;
            }

            setNestedValueBySegments(currentSettings, pathSegments, value);
        });

        if (parseError) return;

        const saveResponse = await setSettings(currentSettings);
        if (saveResponse && saveResponse.success) {
            const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
            if (tab?.id) chrome.tabs.reload(tab.id);
            window.close();
        } else {
            showError(saveResponse ? saveResponse.error : 'Ошибка сохранения.');
        }
    });

    async function performResetSettings() {
        try {
            const saveResponse = await resetSettings();
            if (saveResponse && saveResponse.success) {
                const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
                if (tab?.id) chrome.tabs.reload(tab.id);
                window.close();
            } else {
                showError(saveResponse ? saveResponse.error : 'Ошибка сброса.');
            }
        } catch {
            showError('Ошибка сброса. Попробуйте обновить страницу и повторить.');
        }
    }

    resetButton.addEventListener('click', () => openResetConfirmModal());
    resetConfirmSubmit.addEventListener('click', async () => {
        closeResetConfirmModal();
        await performResetSettings();
    });

    accordionContainer.addEventListener('input', () => { updateChangedList(); });
    accordionContainer.addEventListener('change', () => { updateChangedList(); });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            closeAddFlagModal();
            closeResetConfirmModal();
        }
    });

    async function init() {
        setSelectOptions(addFlagType, FLAG_VALUE_TYPE_OPTIONS, 'boolean');

        const response = await getSettings();
        if (response && response.success) {
            currentSettings = response.data;
            await rebuildSettingsView();
            loader.classList.add('hidden');
            controls.classList.remove('hidden');
        } else {
            showError(response ? response.error : 'Нет ответа от страницы. Возможно, ключ \'global-settings-v2\' не найден в localStorage. Попробуйте перезагрузить страницу.');
        }
    }

    init();
}
