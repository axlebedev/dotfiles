async function getActiveTabId() {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    return tab?.id;
}

async function injectContentScript(tabId) {
    try {
        await chrome.scripting.executeScript({
            target: { tabId },
            files: ['src/processes/content/content.js'],
        });
        return true;
    } catch {
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

async function ensureContentReady() {
    const tabId = await getActiveTabId();
    if (!tabId) {
        return { success: false, error: 'Активная вкладка не найдена.' };
    }

    const injected = await injectContentScript(tabId);
    if (!injected) {
        return { success: false, error: 'Не удалось внедрить скрипт. Откройте не системную страницу и обновите вкладку.' };
    }

    return { success: true };
}

export async function getSplitInfoV2() {
    const ready = await ensureContentReady();
    if (!ready.success) return ready;
    return sendMessageToContent({ action: 'GET_SPLIT_INFO_V2' });
}

export async function setSplitInfoV2(payload) {
    return sendMessageToContent({ action: 'SET_SPLIT_INFO_V2', data: payload });
}

export async function resetSplitInfoV2() {
    const ready = await ensureContentReady();
    if (!ready.success) return ready;
    return sendMessageToContent({ action: 'RESET_SPLIT_INFO_V2' });
}

export async function getSplitInfoV2Backup() {
    return sendMessageToContent({ action: 'GET_SPLIT_INFO_V2_BACKUP' });
}
