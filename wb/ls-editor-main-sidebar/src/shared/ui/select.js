const escapeHtml = (value) =>
    String(value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');

const normalizeOption = (option) => {
    if (option && typeof option === 'object') {
        const value = option.value ?? '';
        return {
            value: String(value),
            label: String(option.label ?? value),
            disabled: Boolean(option.disabled),
        };
    }

    return {
        value: String(option ?? ''),
        label: String(option ?? ''),
        disabled: false,
    };
};

export const buildSelectOptionsMarkup = (options = [], selectedValue = null) => {
    const selected = selectedValue === null || selectedValue === undefined ? null : String(selectedValue);
    return options
        .map((option) => normalizeOption(option))
        .map((option) => {
            const isSelected = selected !== null && option.value === selected;
            return `<option value="${escapeHtml(option.value)}"${option.disabled ? ' disabled' : ''}${isSelected ? ' selected' : ''}>${escapeHtml(option.label)}</option>`;
        })
        .join('');
};

export const buildSelectMarkup = ({
    id = '',
    className = '',
    options = [],
    selectedValue = null,
    extraAttributes = '',
} = {}) => {
    const idAttribute = id ? ` id="${escapeHtml(id)}"` : '';
    const classAttribute = className ? ` class="${escapeHtml(className)}"` : '';
    return `<select${idAttribute}${classAttribute}${extraAttributes ? ` ${extraAttributes}` : ''}>${buildSelectOptionsMarkup(options, selectedValue)}</select>`;
};

export const setSelectOptions = (selectElement, options = [], selectedValue = null) => {
    if (!selectElement) return;
    selectElement.innerHTML = buildSelectOptionsMarkup(options, selectedValue);
    if (selectedValue !== null && selectedValue !== undefined) {
        selectElement.value = String(selectedValue);
    }
};
