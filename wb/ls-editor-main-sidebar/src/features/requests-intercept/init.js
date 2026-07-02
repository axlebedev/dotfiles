import { applyRequestRedirect, clearRequestRedirectRule, getRequestRedirectRule } from './intercept.js';
import {
    REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_DEV,
    REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_RELEASE,
} from './hosts/constants.js';

const RELEASE_SITE_ORIGIN = 'https://www.wildberries.ru';

export function initRequestsInterceptFeature() {
    const requestsGroupsContainer = document.getElementById('requests-groups-container');
    const requestsAddGroupBtn = document.getElementById('requests-add-group-btn');
    const requestsReplaceBtn = document.getElementById('requests-replace-btn');
    const requestsResetBtn = document.getElementById('requests-reset-btn');
    const requestsStatus = document.getElementById('requests-status');
    const sourceHintsElement = document.getElementById('requests-source-host-hints');

    function setRequestsStatus(message, type = 'info') {
        if (!requestsStatus) return;
        requestsStatus.textContent = message;
        requestsStatus.classList.remove('hidden', 'info', 'success', 'error');
        requestsStatus.classList.add('status-message', type);
    }

    function clearRequestsStatus() {
        if (!requestsStatus) return;
        requestsStatus.textContent = '';
        requestsStatus.classList.add('hidden');
        requestsStatus.classList.remove('info', 'success', 'error');
    }

    function toggleRequestsControls(disabled) {
        if (requestsReplaceBtn) requestsReplaceBtn.disabled = disabled;
        if (requestsResetBtn) requestsResetBtn.disabled = disabled;
        if (requestsGroupsContainer) {
            requestsGroupsContainer
                .querySelectorAll('input, button')
                .forEach((control) => {
                    control.disabled = disabled;
                });
        }
        if (requestsAddGroupBtn) requestsAddGroupBtn.disabled = disabled;
    }

    function clearRequestGroup(group) {
        if (!group) return;
        const sourceInput = group.querySelector('.request-input-source');
        const targetInput = group.querySelector('.request-input-target');
        if (sourceInput) sourceInput.value = '';
        if (targetInput) targetInput.value = '';
    }

    function removeOrClearRequestGroup(group) {
        if (!requestsGroupsContainer || !group) return;
        const groupsCount = requestsGroupsContainer.querySelectorAll('.request-group').length;
        if (groupsCount <= 1) {
            clearRequestGroup(group);
            syncRequestGroupsActions();
            return;
        }
        group.remove();
        syncRequestGroupsActions();
    }

    function syncRequestGroupsActions() {
        if (!requestsGroupsContainer) return;
        const groups = Array.from(requestsGroupsContainer.querySelectorAll('.request-group'));
        const shouldHideDelete = groups.length <= 1;
        groups.forEach((group) => {
            const deleteButton = group.querySelector('.request-group-action-delete');
            if (!deleteButton) return;
            deleteButton.classList.toggle('request-group-action-hidden', shouldHideDelete);
        });
    }

    function createRequestGroup(initialSource = '', initialTarget = '') {
        const group = document.createElement('div');
        group.className = 'request-group';

        group.innerHTML = `
            <div class="request-group-actions">
                <button class="request-group-action request-group-action-clear" type="button">Очистить</button>
                <button class="request-group-action request-group-action-delete" type="button">Удалить</button>
            </div>
            <label class="input-field">
                <span>URL сервиса</span>
                <input class="request-input request-input-source" type="text" list="requests-source-host-hints" placeholder="https://service.example/api">
            </label>
            <label class="input-field">
                <span>URL стейджа</span>
                <input class="request-input request-input-target" type="text" placeholder="https://stage.example/api">
            </label>
        `;

        const sourceInput = group.querySelector('.request-input-source');
        const targetInput = group.querySelector('.request-input-target');
        const clearGroupBtn = group.querySelector('.request-group-action-clear');
        const deleteGroupBtn = group.querySelector('.request-group-action-delete');
        if (sourceInput) sourceInput.value = initialSource;
        if (targetInput) targetInput.value = initialTarget;
        clearGroupBtn?.addEventListener('click', () => {
            clearRequestGroup(group);
            clearRequestsStatus();
        });
        deleteGroupBtn?.addEventListener('click', () => {
            removeOrClearRequestGroup(group);
            clearRequestsStatus();
        });

        return group;
    }

    function renderHostHints(listElement, values) {
        if (!listElement || !Array.isArray(values)) return;
        listElement.innerHTML = values
            .map((host) => `<option value="${host}"></option>`)
            .join('');
    }

    async function resolveSourceHostHintsByActiveTab() {
        try {
            const [activeTab] = await chrome.tabs.query({ active: true, currentWindow: true });
            if (!activeTab?.url) {
                return REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_DEV;
            }

            const activeUrl = new URL(activeTab.url);
            if (activeUrl.origin === RELEASE_SITE_ORIGIN) {
                return REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_RELEASE;
            }

            return REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_DEV;
        } catch {
            return REQUESTS_INTERCEPT_SOURCE_HOST_HINTS_DEV;
        }
    }

    function collectRequestRules() {
        if (!requestsGroupsContainer) return [];
        const groups = Array.from(requestsGroupsContainer.querySelectorAll('.request-group'));
        return groups
            .map((group) => {
                const sourceInput = group.querySelector('.request-input-source');
                const targetInput = group.querySelector('.request-input-target');
                const sourceUrl = sourceInput?.value.trim();
                const targetUrl = targetInput?.value.trim();
                return { sourceUrl, targetUrl };
            })
            .filter((pair) => pair.sourceUrl && pair.targetUrl);
    }

    async function hydrateRequestsForm() {
        if (!requestsGroupsContainer) {
            return;
        }

        if (!requestsGroupsContainer.querySelector('.request-group')) {
            requestsGroupsContainer.appendChild(createRequestGroup());
        }

        try {
            const existingRule = await getRequestRedirectRule();
            if (existingRule && Array.isArray(existingRule.rules) && existingRule.rules.length) {
                requestsGroupsContainer.innerHTML = '';
                existingRule.rules.forEach((rule) => {
                    const group = createRequestGroup(rule.sourceUrl, rule.targetUrl);
                    requestsGroupsContainer.appendChild(group);
                });
                syncRequestGroupsActions();

                try {
                    await applyRequestRedirect(existingRule.rules);
                    setRequestsStatus('Правила подмены активны.', 'info');
                } catch (ruleError) {
                    console.error('Не удалось восстановить правила подмены запросов:', ruleError);
                    setRequestsStatus(
                        ruleError.message || 'Не удалось повторно применить сохранённые правила.',
                        'error',
                    );
                }
            } else {
                clearRequestsStatus();
            }
        } catch (error) {
            setRequestsStatus(error.message || 'Не удалось прочитать сохранённое правило.', 'error');
        }

        syncRequestGroupsActions();
    }

    requestsAddGroupBtn?.addEventListener('click', () => {
        if (!requestsGroupsContainer) return;
        requestsGroupsContainer.appendChild(createRequestGroup());
        syncRequestGroupsActions();
    });

    requestsReplaceBtn?.addEventListener('click', async () => {
        const rules = collectRequestRules();

        if (!rules.length) {
            setRequestsStatus('Укажите хотя бы одно правило подмены (оба URL в группе).', 'error');
            return;
        }

        toggleRequestsControls(true);
        setRequestsStatus('Применяем правила подмены...', 'info');

        try {
            await applyRequestRedirect(rules);
            setRequestsStatus('Правила активированы. Обновите страницу для применения.', 'success');
        } catch (error) {
            setRequestsStatus(error.message || 'Не удалось применить правила.', 'error');
        } finally {
            toggleRequestsControls(false);
        }
    });

    requestsResetBtn?.addEventListener('click', async () => {
        toggleRequestsControls(true);
        setRequestsStatus('Удаляем правила...', 'info');
        try {
            await clearRequestRedirectRule();
            if (requestsGroupsContainer) {
                requestsGroupsContainer.innerHTML = '';
                requestsGroupsContainer.appendChild(createRequestGroup());
            }
            syncRequestGroupsActions();
            setRequestsStatus('Правила подмены отключены.', 'success');
        } catch (error) {
            setRequestsStatus(error.message || 'Не удалось удалить правила.', 'error');
        } finally {
            toggleRequestsControls(false);
        }
    });

    (async () => {
        const sourceHostHints = await resolveSourceHostHintsByActiveTab();
        renderHostHints(sourceHintsElement, sourceHostHints);
        hydrateRequestsForm();
    })();
}
