import {
    getNestedValue,
    setNestedValueBySegments,
    flattenObjectEntries,
    encodePathSegments,
    decodePathSegments
} from '../../shared/lib/objectPaths.js';

export const SETTINGS_SECTIONS = [
    { title: 'Switches', path: 'data.switches', pathSegments: ['data', 'switches'] },
    { title: 'Variables', path: 'data.variables', pathSegments: ['data', 'variables'] },
    { title: 'Currencies', path: 'data.currencies', pathSegments: ['data', 'currencies'] },
    { title: 'Mobile App: Objects', path: 'data.mobileAppVariables.objects', pathSegments: ['data', 'mobileAppVariables', 'objects'] },
    { title: 'Mobile App: Numbers', path: 'data.mobileAppVariables.numbers', pathSegments: ['data', 'mobileAppVariables', 'numbers'] },
    { title: 'Mobile App: Services', path: 'data.mobileAppVariables.services', pathSegments: ['data', 'mobileAppVariables', 'services'] }
];

export function createSettingControl(containerElement, key, value, pathSegments) {
    const item = document.createElement('div');
    item.className = 'setting-item';
    item.dataset.key = key.toLowerCase();
    item.dataset.pathId = encodePathSegments(pathSegments);

    const labelWrapper = document.createElement('div');
    labelWrapper.className = 'label-wrapper';
    labelWrapper.textContent = key;

    const inputWrapper = document.createElement('div');
    inputWrapper.className = 'input-wrapper';

    if (typeof value === 'boolean') {
        inputWrapper.innerHTML = `
            <label class="switch">
                <input type="checkbox" data-path-id="${item.dataset.pathId}" data-type="boolean" ${value ? 'checked' : ''}>
                <span class="slider"></span>
            </label>
        `;
    } else if (typeof value === 'number') {
        inputWrapper.innerHTML = `<input type="number" class="value-input" value="${value}" data-path-id="${item.dataset.pathId}" data-type="number">`;
    } else if (value !== null && typeof value === 'object') {
        const textarea = document.createElement('textarea');
        textarea.className = 'value-input';
        textarea.dataset.pathId = item.dataset.pathId;
        textarea.dataset.type = 'object';
        textarea.textContent = JSON.stringify(value, null, 2);
        inputWrapper.appendChild(textarea);
    } else {
        inputWrapper.innerHTML = `<input type="text" class="value-input" value="${value === null ? '' : value}" data-path-id="${item.dataset.pathId}" data-type="string">`;
    }

    item.appendChild(labelWrapper);
    item.appendChild(inputWrapper);
    containerElement.appendChild(item);
}

export function buildSettingsAccordion(accordionContainer, settings) {
    accordionContainer.innerHTML = '';
    for (const { title, path, pathSegments } of SETTINGS_SECTIONS) {
        const dataObject = getNestedValue(settings, path);
        if (!dataObject) continue;

        const section = document.createElement('div');
        section.className = 'accordion-section';

        const header = document.createElement('button');
        header.className = 'accordion-header';
        header.innerHTML = `<span class="accordion-title">${title}</span><img src="icons/chevron-r.min.svg" class="chevron" alt="">`;

        const content = document.createElement('div');
        content.className = 'accordion-content';

        for (const settingKey in dataObject) {
            if (Object.hasOwnProperty.call(dataObject, settingKey)) {
                createSettingControl(content, settingKey, dataObject[settingKey], [...pathSegments, settingKey]);
            }
        }

        header.addEventListener('click', () => {
            header.classList.toggle('active');
            if (content.style.maxHeight) {
                content.style.maxHeight = null;
            } else {
                content.style.maxHeight = content.scrollHeight + 'px';
            }
        });

        section.appendChild(header);
        section.appendChild(content);
        accordionContainer.appendChild(section);
    }
}

export function collectValuesFromDOM(accordionContainer) {
    const inputs = accordionContainer.querySelectorAll('[data-path-id]');
    const result = {};
    inputs.forEach((input) => {
        const pathSegments = decodePathSegments(input.dataset.pathId);
        const type = input.dataset.type;
        if (type === 'boolean') {
            setNestedValueBySegments(result, pathSegments, input.checked);
        } else if (type === 'object') {
            try {
                setNestedValueBySegments(result, pathSegments, JSON.parse(input.value));
            } catch {
                setNestedValueBySegments(result, pathSegments, null);
            }
        } else if (type === 'number') {
            setNestedValueBySegments(result, pathSegments, Number(input.value));
        } else {
            setNestedValueBySegments(result, pathSegments, input.value);
        }
    });
    return result;
}

export function findInputForSegments(accordionContainer, segments) {
    let currentSegments = [...segments];
    while (currentSegments.length) {
        const pathId = encodePathSegments(currentSegments);
        const element = accordionContainer.querySelector(`[data-path-id="${pathId}"]`);
        if (element) return element;
        currentSegments = currentSegments.slice(0, -1);
    }
    return null;
}

export function renderChangedList(accordionContainer, changedContainer, backupData, handlers = {}) {
    const currentTree = collectValuesFromDOM(accordionContainer);
    const flatCurrent = flattenObjectEntries(currentTree);
    const flatBackup = flattenObjectEntries(backupData);
    const backupByPathId = new Map(flatBackup.map((entry) => [encodePathSegments(entry.segments), entry.value]));
    const changedEntries = flatCurrent
        .filter((entry) => {
            const pathId = encodePathSegments(entry.segments);
            return JSON.stringify(entry.value) !== JSON.stringify(backupByPathId.get(pathId));
        })
        .sort((a, b) => a.segments.join('.').localeCompare(b.segments.join('.')));

    changedContainer.innerHTML = '';

    if (!changedEntries.length) {
        changedContainer.classList.add('hidden');
        return 0;
    }

    const listRoot = document.createElement('div');
    changedEntries.forEach(({ segments }) => {
        const pathId = encodePathSegments(segments);
        const pathLabel = segments.join('.');
        const hasBackupValue = backupByPathId.has(pathId);
        const backupValue = backupByPathId.get(pathId);

        const row = document.createElement('div');
        row.className = 'changed-row';

        const linkButton = document.createElement('button');
        linkButton.className = 'changed-link';
        linkButton.textContent = pathLabel;
        linkButton.title = pathLabel;
        linkButton.addEventListener('click', () => {
            if (handlers.onSelectChange) {
                handlers.onSelectChange({ segments, pathLabel });
                return;
            }
            const input = findInputForSegments(accordionContainer, segments);
            if (!input) return;
            const section = input.closest('.accordion-section');
            const header = section.querySelector('.accordion-header');
            if (!header.classList.contains('active')) {
                header.click();
            }
            const row = input.closest('.setting-item');
            row.scrollIntoView({ behavior: 'smooth', block: 'center' });
            row.classList.add('highlight');
            setTimeout(() => row.classList.remove('highlight'), 1200);
        });

        const removeButton = document.createElement('button');
        removeButton.className = 'changed-remove';
        removeButton.type = 'button';
        removeButton.textContent = '×';
        removeButton.title = 'Вернуть к исходному значению';
        removeButton.setAttribute('aria-label', `Убрать изменение ${pathLabel}`);
        removeButton.addEventListener('click', (event) => {
            event.stopPropagation();
            if (handlers.onRevertChange) {
                handlers.onRevertChange({
                    segments,
                    pathLabel,
                    hasBackupValue,
                    backupValue
                });
            }
        });

        row.appendChild(linkButton);
        row.appendChild(removeButton);
        listRoot.appendChild(row);
    });
    changedContainer.appendChild(listRoot);
    changedContainer.classList.remove('hidden');
    return changedEntries.length;
}
