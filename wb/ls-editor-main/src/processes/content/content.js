function getJsViewDetectorState() {
  if (!window.__ls_editor_jsv_detector__) {
    window.__ls_editor_jsv_detector__ = {
      enabled: false,
      observer: null,
      delayTimer: null,
      newNodes: [],
      painted: new Map(),
    };
  }

  return window.__ls_editor_jsv_detector__;
}

function paintJSViewElement(state, element) {
  if (!element || !element.style) return;

  if (!state.painted.has(element)) {
    state.painted.set(element, {
      border: element.style.border,
      borderColor: element.style.borderColor,
    });
  }

  if (element.style.border) {
    element.style.borderColor = 'red';
  } else {
    element.style.border = '1px solid red';
  }
}

function findJSView(state, node) {
  if (!node || !node.hasAttribute) {
    return;
  }

  if (node.hasAttribute('data-jsv')) {
    paintJSViewElement(state, node);
  } else {
    node.querySelectorAll('[data-jsv]').forEach((el) => paintJSViewElement(state, el));
  }

  const uniqParent = [];

  if (node.getAttribute && node.getAttribute('type')?.includes('jsv#') && node.parentNode && !uniqParent.includes(node.parentNode)) {
    uniqParent.push(node.parentNode);
  }

  node.querySelectorAll('[type^="jsv#"]').forEach((el) => {
    if (el.parentNode && !uniqParent.includes(el.parentNode)) {
      uniqParent.push(el.parentNode);
    }
  });

  uniqParent.forEach((el) => {
    el.childNodes.forEach((child) => {
      const element = child;
      if (element.tagName !== 'SCRIPT' && element.style) {
        paintJSViewElement(state, element);
      }
    });
  });
}

function processNewNodes(state) {
  state.newNodes.forEach((node) => {
    findJSView(state, node);
  });
  state.newNodes = [];
  state.delayTimer = null;
}

function startJsViewDetector() {
  const state = getJsViewDetectorState();
  if (state.enabled) {
    return { success: true, enabled: true, alreadyRunning: true };
  }

  state.enabled = true;
  window.__ls_editor_jsv_detector_started__ = true;

  findJSView(state, document.body);

  const callback = (mutationList) => {
    for (const mutation of mutationList) {
      for (const addedNode of mutation.addedNodes) {
        if (!state.delayTimer) {
          state.delayTimer = setTimeout(() => {
            processNewNodes(state);
          }, 1000);
        }
        state.newNodes.push(addedNode);
      }
    }
  };

  state.observer = new MutationObserver(callback);
  state.observer.observe(document.body, {
    childList: true,
    subtree: true,
  });

  return { success: true, enabled: true, alreadyRunning: false };
}

function stopJsViewDetector() {
  const state = getJsViewDetectorState();

  if (state.delayTimer) {
    clearTimeout(state.delayTimer);
    state.delayTimer = null;
  }

  if (state.observer) {
    state.observer.disconnect();
    state.observer = null;
  }

  state.newNodes = [];
  state.enabled = false;
  window.__ls_editor_jsv_detector_started__ = false;

  state.painted.forEach((styles, element) => {
    if (!element || !element.style) return;
    element.style.border = styles.border || '';
    element.style.borderColor = styles.borderColor || '';
  });
  state.painted.clear();

  return { success: true, enabled: false };
}

function parsePathSegments(path) {
  return String(path || '')
    .split('.')
    .filter(Boolean)
    .map((segment) => (/^\d+$/.test(segment) ? Number(segment) : segment));
}

function setValueByPath(target, path, value) {
  const segments = parsePathSegments(path);
  if (!segments.length) {
    throw new Error(`Некорректный путь '${path}'.`);
  }

  let cursor = target;
  for (let index = 0; index < segments.length - 1; index += 1) {
    const segment = segments[index];
    const nextSegment = segments[index + 1];

    if (typeof segment === 'number') {
      if (!Array.isArray(cursor)) {
        throw new Error(`Путь '${path}' ожидает массив на сегменте ${segment}.`);
      }
      if (
        cursor[segment] === undefined
        || cursor[segment] === null
        || typeof cursor[segment] !== 'object'
      ) {
        cursor[segment] = typeof nextSegment === 'number' ? [] : {};
      }
      cursor = cursor[segment];
      continue;
    }

    if (
      cursor[segment] === undefined
      || cursor[segment] === null
      || typeof cursor[segment] !== 'object'
    ) {
      cursor[segment] = typeof nextSegment === 'number' ? [] : {};
    }
    cursor = cursor[segment];
  }

  const lastSegment = segments[segments.length - 1];
  if (typeof lastSegment === 'number') {
    if (!Array.isArray(cursor)) {
      throw new Error(`Путь '${path}' ожидает массив в последнем сегменте.`);
    }
    cursor[lastSegment] = value;
    return;
  }
  cursor[lastSegment] = value;
}

function applyRecipeOperations(settings, operations) {
  if (!Array.isArray(operations) || !operations.length) {
    throw new Error('Список операций пуст.');
  }

  operations.forEach((operation) => {
    if (!operation || typeof operation.path !== 'string') {
      throw new Error('Каждая операция должна содержать поле path.');
    }
    setValueByPath(settings, operation.path, operation.value);
  });
}

chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    const STORAGE_KEY = 'global-settings-v2';
    const BACKUP_KEY = 'global-settings-v2:backup';
    const SPLIT_INFO_V2_STORAGE_KEY = 'splitInfoV2';
    const SPLIT_INFO_V2_BACKUP_KEY = 'splitInfoV2:backup';
  
    if (request.action === "GET_SETTINGS") {
      try {
        const settingsRaw = localStorage.getItem(STORAGE_KEY);
        if (settingsRaw) {
          if (localStorage.getItem(BACKUP_KEY) === null) {
            localStorage.setItem(BACKUP_KEY, settingsRaw);
          }
          const settings = JSON.parse(settingsRaw);
          sendResponse({ success: true, data: settings });
        } else {
          sendResponse({ success: false, error: `Ключ '${STORAGE_KEY}' не найден в localStorage.` });
        }
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка парсинга JSON из localStorage: " + e.message });
      }
    }
  
    if (request.action === "SET_SETTINGS") {
      try {
        const newSettingsString = JSON.stringify(request.data);
        localStorage.setItem(STORAGE_KEY, newSettingsString);
        sendResponse({ success: true });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка сохранения данных в localStorage: " + e.message });
      }
    }

    if (request.action === "APPLY_SETTINGS_RECIPE") {
      try {
        const settingsRaw = localStorage.getItem(STORAGE_KEY);
        if (!settingsRaw) {
          sendResponse({ success: false, error: `Ключ '${STORAGE_KEY}' не найден в localStorage.` });
          return true;
        }
        if (localStorage.getItem(BACKUP_KEY) === null) {
          localStorage.setItem(BACKUP_KEY, settingsRaw);
        }

        const settings = JSON.parse(settingsRaw);
        applyRecipeOperations(settings, request.operations);
        localStorage.setItem(STORAGE_KEY, JSON.stringify(settings));
        sendResponse({ success: true });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка применения сценария: " + e.message });
      }
    }

    if (request.action === "RESET_SETTINGS") {
      try {
        const backupRaw = localStorage.getItem(BACKUP_KEY);
        if (backupRaw) {
          localStorage.setItem(STORAGE_KEY, backupRaw);
          sendResponse({ success: true });
        } else {
          sendResponse({ success: false, error: `Бэкап не найден.` });
        }
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка сброса: " + e.message });
      }
    }
    
    if (request.action === "GET_BACKUP") {
      try {
        const backupRaw = localStorage.getItem(BACKUP_KEY);
        if (backupRaw) {
          sendResponse({ success: true, data: JSON.parse(backupRaw) });
        } else {
          sendResponse({ success: false, error: `Бэкап не найден.` });
        }
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка чтения бэкапа: " + e.message });
      }
    }

    if (request.action === "GET_SPLIT_INFO_V2") {
      try {
        const splitInfoRaw = localStorage.getItem(SPLIT_INFO_V2_STORAGE_KEY);
        if (splitInfoRaw && localStorage.getItem(SPLIT_INFO_V2_BACKUP_KEY) === null) {
          localStorage.setItem(SPLIT_INFO_V2_BACKUP_KEY, splitInfoRaw);
        }
        if (!splitInfoRaw) {
          sendResponse({ success: true, data: null });
          return true;
        }
        sendResponse({ success: true, data: JSON.parse(splitInfoRaw) });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка чтения splitInfoV2 из localStorage: " + e.message });
      }
    }

    if (request.action === "SET_SPLIT_INFO_V2") {
      try {
        if (localStorage.getItem(SPLIT_INFO_V2_BACKUP_KEY) === null) {
          const currentValue = localStorage.getItem(SPLIT_INFO_V2_STORAGE_KEY);
          if (currentValue !== null) {
            localStorage.setItem(SPLIT_INFO_V2_BACKUP_KEY, currentValue);
          }
        }
        localStorage.setItem(SPLIT_INFO_V2_STORAGE_KEY, JSON.stringify(request.data));
        sendResponse({ success: true });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка сохранения splitInfoV2 в localStorage: " + e.message });
      }
    }

    if (request.action === "RESET_SPLIT_INFO_V2") {
      try {
        const splitInfoBackupRaw = localStorage.getItem(SPLIT_INFO_V2_BACKUP_KEY);
        if (splitInfoBackupRaw !== null) {
          localStorage.setItem(SPLIT_INFO_V2_STORAGE_KEY, splitInfoBackupRaw);
        } else {
          localStorage.removeItem(SPLIT_INFO_V2_STORAGE_KEY);
        }
        sendResponse({ success: true });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка сброса splitInfoV2: " + e.message });
      }
    }

    if (request.action === "GET_SPLIT_INFO_V2_BACKUP") {
      try {
        const splitInfoBackupRaw = localStorage.getItem(SPLIT_INFO_V2_BACKUP_KEY);
        if (splitInfoBackupRaw) {
          sendResponse({ success: true, data: JSON.parse(splitInfoBackupRaw) });
        } else {
          sendResponse({ success: false, error: 'Бэкап splitInfoV2 не найден.' });
        }
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка чтения бэкапа splitInfoV2: " + e.message });
      }
    }
  
    if (request.action === "RUN_JSVIEW_DETECTOR") {
      try {
        sendResponse(startJsViewDetector());
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка запуска детектора: " + e.message });
      }
    }

    if (request.action === "GET_JSVIEW_DETECTOR_STATUS") {
      try {
        const state = getJsViewDetectorState();
        sendResponse({ success: true, enabled: Boolean(state.enabled) });
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка получения статуса детектора: " + e.message });
      }
    }

    if (request.action === "SET_JSVIEW_DETECTOR_ENABLED") {
      try {
        const enabled = Boolean(request.enabled);
        const response = enabled ? startJsViewDetector() : stopJsViewDetector();
        sendResponse(response);
      } catch (e) {
        sendResponse({ success: false, error: "Ошибка переключения детектора: " + e.message });
      }
    }
  
    return true;
  });
