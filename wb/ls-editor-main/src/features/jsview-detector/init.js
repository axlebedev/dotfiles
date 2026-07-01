import { fetchJsViewDetectorStatus, handleToggleJsViewDetector } from './run.js';

export function initJsViewDetectorFeature() {
    const toggleInput = document.getElementById('jsv-toggle-input');
    if (!toggleInput) return;

    const syncToggle = async () => {
        const result = await fetchJsViewDetectorStatus();
        if (result?.success) {
            toggleInput.checked = Boolean(result.enabled);
        }
    };

    toggleInput.addEventListener('change', async () => {
        const nextValue = toggleInput.checked;
        toggleInput.disabled = true;
        try {
            const result = await handleToggleJsViewDetector(nextValue);
            if (!result?.success) {
                toggleInput.checked = !nextValue;
                return;
            }
            toggleInput.checked = Boolean(result.enabled);
        } finally {
            toggleInput.disabled = false;
        }
    });

    syncToggle();
}
