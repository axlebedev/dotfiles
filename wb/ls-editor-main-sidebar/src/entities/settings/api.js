async function getActiveTabId() {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    return tab?.id;
}

async function injectContentScript(tabId) {
    try {
        await chrome.scripting.executeScript({
            target: { tabId },
            files: ['src/processes/content/content.js']
        });
        return true;
    } catch (error) {
        return false;
    }
}

async function sendMessageToContent(message) {
    const tabId = await getActiveTabId();
    if (!tabId) {
        throw new Error('Активная вкладка не найдена.');
    }
    return chrome.tabs.sendMessage(tabId, message);
}

export async function getSettings() {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'GET_SETTINGS' });
}

export async function setSettings(data) {
    return sendMessageToContent({ action: 'SET_SETTINGS', data });
}

export async function resetSettings() {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'RESET_SETTINGS' });
}

export async function getBackup() {
    return sendMessageToContent({ action: 'GET_BACKUP' });
}

export async function applySettingsRecipe(operations) {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'APPLY_SETTINGS_RECIPE', operations });
}

export async function runJsViewDetector() {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'RUN_JSVIEW_DETECTOR' });
}

export async function getJsViewDetectorStatus() {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'GET_JSVIEW_DETECTOR_STATUS' });
}

export async function setJsViewDetectorEnabled(enabled) {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }
    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }
    return sendMessageToContent({ action: 'SET_JSVIEW_DETECTOR_ENABLED', enabled: Boolean(enabled) });
}
