import { getJsViewDetectorStatus, setJsViewDetectorEnabled } from '../../entities/settings/api.js';

export async function fetchJsViewDetectorStatus() {
    return getJsViewDetectorStatus();
}

export async function handleToggleJsViewDetector(enabled) {
    return setJsViewDetectorEnabled(enabled);
}
