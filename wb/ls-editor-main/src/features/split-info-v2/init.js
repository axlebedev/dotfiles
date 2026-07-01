import {
    getSplitInfoV2,
    setSplitInfoV2,
    resetSplitInfoV2,
    getSplitInfoV2Backup,
} from '../../entities/split-info-v2/api.js';

const DEFAULT_STATE = {
    splitInfo: {
        common: [],
    },
};

function clone(value) {
    return JSON.parse(JSON.stringify(value));
}

function normalizeEntriesArray(value) {
    if (!Array.isArray(value)) return [];
    return value.map((item) => ({
        key: String(item && typeof item === 'object' && item.key !== undefined ? item.key : ''),
        value: String(item && typeof item === 'object' && item.value !== undefined ? item.value : ''),
    }));
}

function normalizeSplitInfoV2(rawValue) {
    const source = rawValue && typeof rawValue === 'object' && !Array.isArray(rawValue) ? clone(rawValue) : {};
    const splitInfoRaw = source.splitInfo && typeof source.splitInfo === 'object' && !Array.isArray(source.splitInfo)
        ? source.splitInfo
        : {};

    const normalizedSplitInfo = { common: normalizeEntriesArray(splitInfoRaw.common) };

    Object.keys(splitInfoRaw).forEach((sectionName) => {
        if (sectionName === 'common') return;
        normalizedSplitInfo[sectionName] = normalizeEntriesArray(splitInfoRaw[sectionName]);
    });

    return {
        ...source,
        ...DEFAULT_STATE,
        splitInfo: normalizedSplitInfo,
    };
}

function splitDataToModel(data) {
    const normalized = normalizeSplitInfoV2(data);
    const { splitInfo } = normalized;
    const meta = {};

    Object.keys(normalized).forEach((key) => {
        if (key !== 'splitInfo') {
            meta[key] = normalized[key];
        }
    });

    return { splitInfo, meta };
}

function parseMetaJson(value) {
    const trimmed = value.trim();
    if (!trimmed) return { ok: true, value: {} };

    try {
        const parsed = JSON.parse(trimmed);
        if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
            return { ok: false, error: 'Meta JSON должен быть объектом.' };
        }
        return { ok: true, value: parsed };
    } catch {
        return { ok: false, error: 'Некорректный JSON в Meta + extra.' };
    }
}

function compareByJSON(a, b) {
    return JSON.stringify(a) === JSON.stringify(b);
}

function buildChangesList(currentSplitInfo, currentMeta, backupSplitInfo, backupMeta) {
    const changes = [];

    const currentSectionNames = Object.keys(currentSplitInfo);
    const backupSectionNames = Object.keys(backupSplitInfo || {});
    const sectionNames = Array.from(new Set([...currentSectionNames, ...backupSectionNames])).sort((a, b) => {
        if (a === 'common') return -1;
        if (b === 'common') return 1;
        return a.localeCompare(b);
    });

    sectionNames.forEach((sectionName) => {
        const path = `splitInfo.${sectionName}`;
        const currentValue = currentSplitInfo[sectionName];
        const backupValue = backupSplitInfo ? backupSplitInfo[sectionName] : undefined;
        if (!compareByJSON(currentValue, backupValue)) {
            changes.push({ path, type: 'section', sectionName });
        }
    });

    if (!compareByJSON(currentMeta, backupMeta || {})) {
        changes.push({ path: 'meta', type: 'meta' });
    }

    return changes;
}

function collectDuplicateWarnings(splitInfo) {
    const warnings = [];
    Object.entries(splitInfo).forEach(([sectionName, entries]) => {
        const used = new Map();
        entries.forEach((entry) => {
            const key = String(entry?.key || '').trim();
            if (!key) return;
            used.set(key, (used.get(key) || 0) + 1);
        });
        const duplicates = Array.from(used.entries()).filter(([, count]) => count > 1).map(([key]) => key);
        if (duplicates.length) {
            warnings.push(`В секции "${sectionName}" дубли ключей: ${duplicates.join(', ')}`);
        }
    });
    return warnings;
}

export function initSplitInfoV2Feature() {
    const panel = document.getElementById('tab-split-info-v2-panel');
    const sectionsContainer = document.getElementById('split-info-v2-sections');
    const addSectionBtn = document.getElementById('split-info-v2-add-section-btn');
    const changedToggleBtn = document.getElementById('split-info-v2-changed-toggle-btn');
    const metaToggleBtn = document.getElementById('split-info-v2-meta-toggle-btn');
    const metaBlock = document.getElementById('split-info-v2-meta-block');
    const metaJsonInput = document.getElementById('split-info-v2-meta-json');
    const saveBtn = document.getElementById('split-info-v2-save-btn');
    const resetBtn = document.getElementById('split-info-v2-reset-btn');
    const statusElement = document.getElementById('split-info-v2-status');
    const warningElement = document.getElementById('split-info-v2-warning');
    const changedElement = document.getElementById('split-info-v2-changed');
    const addSectionModal = document.getElementById('split-info-v2-add-section-modal');
    const addSectionInput = document.getElementById('split-info-v2-section-name-input');
    const addSectionSubmit = document.getElementById('split-info-v2-add-section-submit');
    const addSectionCancel = document.getElementById('split-info-v2-add-section-cancel');
    const addSectionError = document.getElementById('split-info-v2-add-section-error');

    if (
        !panel || !sectionsContainer || !metaJsonInput || !saveBtn || !resetBtn
        || !changedToggleBtn || !metaToggleBtn || !metaBlock
        || !addSectionModal || !addSectionInput || !addSectionSubmit || !addSectionCancel || !addSectionError
    ) {
        return;
    }

    let splitInfo = { common: [] };
    let meta = {};
    let backupSplitInfo = null;
    let backupMeta = null;
    let isMetaVisible = false;
    let isChangedVisible = false;

    function setStatus(message, type = 'info') {
        if (!statusElement) return;
        statusElement.textContent = message;
        statusElement.classList.remove('hidden', 'info', 'success', 'error');
        statusElement.classList.add('status-message', type);
    }

    function clearStatus() {
        if (!statusElement) return;
        statusElement.textContent = '';
        statusElement.classList.add('hidden');
        statusElement.classList.remove('info', 'success', 'error');
    }

    function renderWarnings() {
        if (!warningElement) return;
        const warnings = collectDuplicateWarnings(splitInfo);
        if (!warnings.length) {
            warningElement.classList.add('hidden');
            warningElement.textContent = '';
            return;
        }
        warningElement.classList.remove('hidden');
        warningElement.textContent = warnings.join(' | ');
    }

    function clearAddSectionError() {
        addSectionError.textContent = '';
        addSectionError.classList.add('hidden');
    }

    function setAddSectionError(message) {
        addSectionError.textContent = message;
        addSectionError.classList.remove('hidden');
    }

    function closeAddSectionModal() {
        addSectionModal.classList.add('hidden');
        addSectionInput.value = '';
        clearAddSectionError();
    }

    function openAddSectionModal() {
        addSectionModal.classList.remove('hidden');
        addSectionInput.value = '';
        clearAddSectionError();
        addSectionInput.focus();
    }

    function submitAddSection() {
        const sectionName = addSectionInput.value.trim();
        if (!sectionName) {
            setAddSectionError('Название секции не может быть пустым.');
            return;
        }
        if (sectionName === 'common') {
            setAddSectionError('Секция "common" уже существует и не может быть добавлена повторно.');
            return;
        }
        if (Object.prototype.hasOwnProperty.call(splitInfo, sectionName)) {
            setAddSectionError(`Секция "${sectionName}" уже существует.`);
            return;
        }

        splitInfo[sectionName] = [];
        clearStatus();
        closeAddSectionModal();
        renderAll();
    }

    function createRowElement(sectionName, rowIndex, rowData) {
        const row = document.createElement('div');
        row.className = 'split-info-v2-row';
        row.dataset.section = sectionName;
        row.dataset.rowIndex = String(rowIndex);

        const keyInput = document.createElement('input');
        keyInput.className = 'request-input split-info-v2-key';
        keyInput.type = 'text';
        keyInput.placeholder = 'key';
        keyInput.value = rowData.key || '';

        const valueInput = document.createElement('input');
        valueInput.className = 'request-input split-info-v2-value';
        valueInput.type = 'text';
        valueInput.placeholder = 'value';
        valueInput.value = rowData.value || '';

        const removeBtn = document.createElement('button');
        removeBtn.className = 'split-info-v2-remove-row';
        removeBtn.type = 'button';
        removeBtn.textContent = '×';
        removeBtn.title = 'Удалить строку';

        row.appendChild(keyInput);
        row.appendChild(valueInput);
        row.appendChild(removeBtn);
        return row;
    }

    function createSectionElement(sectionName) {
        const section = document.createElement('div');
        section.className = 'split-info-v2-section';
        section.dataset.section = sectionName;

        const sectionHead = document.createElement('div');
        sectionHead.className = 'split-info-v2-section-head';

        const sectionTitle = document.createElement('div');
        sectionTitle.className = 'split-info-v2-section-title';
        sectionTitle.textContent = sectionName;

        const sectionControls = document.createElement('div');
        sectionControls.className = 'split-info-v2-section-controls';

        const addRowBtn = document.createElement('button');
        addRowBtn.className = 'button button--secondary';
        addRowBtn.type = 'button';
        addRowBtn.textContent = '+ Строка';
        addRowBtn.dataset.action = 'add-row';

        sectionControls.appendChild(addRowBtn);

        if (sectionName !== 'common') {
            const removeSectionBtn = document.createElement('button');
            removeSectionBtn.className = 'split-info-v2-remove-section';
            removeSectionBtn.type = 'button';
            removeSectionBtn.textContent = '×';
            removeSectionBtn.title = 'Удалить секцию';
            removeSectionBtn.dataset.action = 'remove-section';
            sectionControls.appendChild(removeSectionBtn);
        }

        sectionHead.appendChild(sectionTitle);
        sectionHead.appendChild(sectionControls);

        const rowsRoot = document.createElement('div');
        rowsRoot.className = 'split-info-v2-rows';

        const entries = Array.isArray(splitInfo[sectionName]) ? splitInfo[sectionName] : [];
        entries.forEach((entry, index) => {
            rowsRoot.appendChild(createRowElement(sectionName, index, entry));
        });

        section.appendChild(sectionHead);
        section.appendChild(rowsRoot);
        return section;
    }

    function readSectionValuesFromDOM() {
        const nextSplitInfo = {};
        const sectionElements = sectionsContainer.querySelectorAll('.split-info-v2-section');
        sectionElements.forEach((sectionElement) => {
            const sectionName = sectionElement.dataset.section;
            if (!sectionName) return;
            const rows = sectionElement.querySelectorAll('.split-info-v2-row');
            nextSplitInfo[sectionName] = Array.from(rows).map((row) => {
                const keyInput = row.querySelector('.split-info-v2-key');
                const valueInput = row.querySelector('.split-info-v2-value');
                return {
                    key: String(keyInput?.value || ''),
                    value: String(valueInput?.value || ''),
                };
            });
        });

        if (!Object.prototype.hasOwnProperty.call(nextSplitInfo, 'common')) {
            nextSplitInfo.common = [];
        }

        splitInfo = normalizeSplitInfoV2({ splitInfo: nextSplitInfo }).splitInfo;
    }

    function focusPath(path) {
        if (path === 'meta') {
            if (!isMetaVisible) {
                isMetaVisible = true;
                renderAll();
            }
            metaJsonInput.focus();
            metaJsonInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
            return;
        }

        const [, sectionName] = path.split('.');
        if (!sectionName) return;
        const section = sectionsContainer.querySelector(`.split-info-v2-section[data-section="${sectionName}"]`);
        if (!section) return;
        section.scrollIntoView({ behavior: 'smooth', block: 'center' });
        const firstInput = section.querySelector('input');
        if (firstInput) {
            firstInput.focus();
        }
    }

    function renderChangedList() {
        if (!changedElement) return;

        const changes = buildChangesList(splitInfo, meta, backupSplitInfo, backupMeta);
        const changedCount = changes.length;
        changedElement.innerHTML = '';
        changedToggleBtn.textContent = `Изменения (${changedCount})`;
        changedToggleBtn.classList.toggle('hidden', changedCount === 0);

        if (!changedCount) {
            changedElement.classList.add('hidden');
            changedToggleBtn.setAttribute('aria-expanded', 'false');
            isChangedVisible = false;
            return;
        }

        changes.forEach((change) => {
            const row = document.createElement('div');
            row.className = 'changed-row';

            const path = document.createElement('button');
            path.className = 'changed-link';
            path.type = 'button';
            path.textContent = change.path;
            path.title = change.path;
            path.addEventListener('click', () => {
                focusPath(change.path);
            });

            const revertBtn = document.createElement('button');
            revertBtn.className = 'changed-remove';
            revertBtn.type = 'button';
            revertBtn.textContent = '×';
            revertBtn.title = 'Вернуть к исходному';
            revertBtn.setAttribute('aria-label', `Убрать изменение ${change.path}`);
            revertBtn.addEventListener('click', () => {
                if (change.type === 'meta') {
                    meta = clone(backupMeta || {});
                } else if (change.type === 'section') {
                    const backupSection = backupSplitInfo ? backupSplitInfo[change.sectionName] : undefined;
                    if (backupSection === undefined && change.sectionName !== 'common') {
                        delete splitInfo[change.sectionName];
                    } else {
                        splitInfo[change.sectionName] = normalizeEntriesArray(backupSection);
                    }
                }
                renderAll();
            });

            row.appendChild(path);
            row.appendChild(revertBtn);
            changedElement.appendChild(row);
        });

        changedElement.classList.toggle('hidden', !isChangedVisible);
        changedToggleBtn.setAttribute('aria-expanded', isChangedVisible ? 'true' : 'false');
    }

    function renderSections() {
        sectionsContainer.innerHTML = '';
        const sectionNames = Object.keys(splitInfo).sort((a, b) => {
            if (a === 'common') return -1;
            if (b === 'common') return 1;
            return a.localeCompare(b);
        });

        sectionNames.forEach((sectionName) => {
            sectionsContainer.appendChild(createSectionElement(sectionName));
        });
    }

    function renderAll() {
        renderSections();
        metaJsonInput.value = JSON.stringify(meta, null, 2);
        metaBlock.classList.toggle('hidden', !isMetaVisible);
        metaToggleBtn.setAttribute('aria-expanded', isMetaVisible ? 'true' : 'false');
        metaToggleBtn.textContent = isMetaVisible
            ? 'Скрыть Meta + extra (JSON)'
            : 'Показать Meta + extra (JSON)';
        renderWarnings();
        renderChangedList();
    }

    function setLoadingState(disabled) {
        saveBtn.disabled = disabled;
        resetBtn.disabled = disabled;
        addSectionBtn.disabled = disabled;
        if (disabled) {
            changedToggleBtn.disabled = true;
        } else {
            changedToggleBtn.disabled = false;
        }
        sectionsContainer.querySelectorAll('input, button, textarea').forEach((el) => {
            el.disabled = disabled;
        });
        metaJsonInput.disabled = disabled;
        if (!disabled) {
            renderChangedList();
        }
    }

    sectionsContainer.addEventListener('click', (event) => {
        const target = event.target;
        if (!(target instanceof HTMLElement)) return;

        const sectionElement = target.closest('.split-info-v2-section');
        const sectionName = sectionElement?.dataset.section;
        if (!sectionName) return;

        if (target.dataset.action === 'add-row') {
            if (!Array.isArray(splitInfo[sectionName])) {
                splitInfo[sectionName] = [];
            }
            splitInfo[sectionName].push({ key: '', value: '' });
            renderAll();
            return;
        }

        if (target.dataset.action === 'remove-section') {
            if (sectionName !== 'common') {
                delete splitInfo[sectionName];
                renderAll();
            }
            return;
        }

        if (target.classList.contains('split-info-v2-remove-row')) {
            const rowElement = target.closest('.split-info-v2-row');
            if (!rowElement) return;
            const rowIndex = Number(rowElement.dataset.rowIndex);
            if (!Number.isInteger(rowIndex)) return;
            splitInfo[sectionName].splice(rowIndex, 1);
            renderAll();
        }
    });

    sectionsContainer.addEventListener('input', () => {
        readSectionValuesFromDOM();
        renderWarnings();
        renderChangedList();
    });

    metaJsonInput.addEventListener('input', () => {
        const metaResult = parseMetaJson(metaJsonInput.value);
        if (!metaResult.ok) {
            setStatus(metaResult.error, 'error');
        } else {
            clearStatus();
            meta = metaResult.value;
        }
        renderChangedList();
    });

    metaToggleBtn.addEventListener('click', () => {
        isMetaVisible = !isMetaVisible;
        renderAll();
    });

    addSectionBtn.addEventListener('click', () => {
        openAddSectionModal();
    });

    changedToggleBtn.addEventListener('click', () => {
        isChangedVisible = !isChangedVisible;
        renderChangedList();
    });

    addSectionSubmit.addEventListener('click', () => {
        submitAddSection();
    });

    addSectionCancel.addEventListener('click', () => {
        closeAddSectionModal();
    });

    addSectionInput.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault();
            submitAddSection();
        }
    });

    addSectionModal.addEventListener('click', (event) => {
        if (event.target === addSectionModal) {
            closeAddSectionModal();
        }
    });

    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' && !addSectionModal.classList.contains('hidden')) {
            closeAddSectionModal();
        }
    });

    saveBtn.addEventListener('click', async () => {
        readSectionValuesFromDOM();
        const parsedMeta = parseMetaJson(metaJsonInput.value);
        if (!parsedMeta.ok) {
            setStatus(parsedMeta.error, 'error');
            return;
        }

        meta = parsedMeta.value;
        splitInfo = normalizeSplitInfoV2({ splitInfo }).splitInfo;
        const payload = normalizeSplitInfoV2({
            ...meta,
            splitInfo,
        });

        setLoadingState(true);
        setStatus('Сохраняем splitInfoV2...', 'info');

        try {
            const response = await setSplitInfoV2(payload);
            if (response && response.success) {
                const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
                if (tab?.id) {
                    chrome.tabs.reload(tab.id);
                }
                window.close();
                return;
            }
            setStatus(response?.error || 'Не удалось сохранить splitInfoV2.', 'error');
        } catch {
            setStatus('Не удалось сохранить splitInfoV2.', 'error');
        } finally {
            setLoadingState(false);
        }
    });

    resetBtn.addEventListener('click', async () => {
        setLoadingState(true);
        setStatus('Сбрасываем splitInfoV2...', 'info');
        try {
            const response = await resetSplitInfoV2();
            if (response && response.success) {
                const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
                if (tab?.id) {
                    chrome.tabs.reload(tab.id);
                }
                window.close();
                return;
            }
            setStatus(response?.error || 'Не удалось выполнить сброс splitInfoV2.', 'error');
        } catch {
            setStatus('Не удалось выполнить сброс splitInfoV2.', 'error');
        } finally {
            setLoadingState(false);
        }
    });

    async function init() {
        setStatus('Загружаем splitInfoV2...', 'info');

        let sourceData = null;
        const dataResponse = await getSplitInfoV2();
        if (dataResponse?.success) {
            sourceData = dataResponse.data;
        }

        const model = splitDataToModel(sourceData);
        splitInfo = model.splitInfo;
        meta = model.meta;

        const backupResponse = await getSplitInfoV2Backup();
        if (backupResponse?.success) {
            const backupModel = splitDataToModel(backupResponse.data);
            backupSplitInfo = backupModel.splitInfo;
            backupMeta = backupModel.meta;
        } else {
            backupSplitInfo = clone(DEFAULT_STATE.splitInfo);
            backupMeta = {};
        }

        clearStatus();
        renderAll();
    }

    init();
}
