import { fetchJsViewDetectorStatus, handleToggleJsViewDetector } from '../features/jsview-detector/run.js';
import { initSettingsEditorFeature } from '../features/settings-editor/init.js';
import { initViewMenuFeature } from '../features/view-menu/init.js';
import { FEATURE_MENU_CONFIG } from './features.config.js';

document.addEventListener('DOMContentLoaded', async () => {
    const jsvToggleInput = document.getElementById('jsv-toggle-input');

    FEATURE_MENU_CONFIG.forEach((feature) => {
        if (!feature.mount || !feature.slotId) return;
        const slotElement = document.getElementById(feature.slotId);
        feature.mount(slotElement);
    });

    async function syncJsViewDetectorToggle() {
        if (!jsvToggleInput) return;
        const result = await fetchJsViewDetectorStatus();
        if (!result || !result.success) return;
        jsvToggleInput.checked = Boolean(result.enabled);
    }

    const { switchTab } = initViewMenuFeature(FEATURE_MENU_CONFIG);

    function renderHomeFeaturesList() {
        const container = document.getElementById('home-features-list');
        if (!container) return;

        const featuresForHome = FEATURE_MENU_CONFIG.filter((feature) => feature.id !== 'home');
        container.innerHTML = '';

        featuresForHome.forEach((feature) => {
            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'home-feature-item';
            button.textContent = feature.title;
            button.addEventListener('click', () => {
                switchTab(feature.id);
            });
            container.appendChild(button);
        });
    }

    if (jsvToggleInput) {
        jsvToggleInput.addEventListener('change', async () => {
            const nextValue = jsvToggleInput.checked;
            jsvToggleInput.disabled = true;
            try {
                const result = await handleToggleJsViewDetector(nextValue);
                if (!result || !result.success) {
                    jsvToggleInput.checked = !nextValue;
                    alert(result?.error || 'Не удалось переключить детектор.');
                    return;
                }
                jsvToggleInput.checked = Boolean(result.enabled);
            } finally {
                jsvToggleInput.disabled = false;
            }
        });
    }

    FEATURE_MENU_CONFIG.forEach((feature) => {
        if (typeof feature.init === 'function') {
            feature.init();
        }
    });

    initSettingsEditorFeature();
    renderHomeFeaturesList();
    syncJsViewDetectorToggle();
    switchTab('home');
});
