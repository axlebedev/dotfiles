export function getNestedValue(sourceObject, path) {
    return path.split('.').reduce((accumulator, key) => (accumulator && accumulator[key] !== undefined ? accumulator[key] : undefined), sourceObject);
}

function escapePathSegment(segment) {
    return String(segment).replace(/~/g, '~0').replace(/\//g, '~1');
}

function unescapePathSegment(segment) {
    return segment.replace(/~1/g, '/').replace(/~0/g, '~');
}

export function encodePathSegments(segments) {
    return `/${segments.map((segment) => escapePathSegment(segment)).join('/')}`;
}

export function decodePathSegments(pathId) {
    if (!pathId) {
        return [];
    }
    if (!pathId.startsWith('/')) {
        return pathId.split('.');
    }
    const rawSegments = pathId.slice(1);
    if (!rawSegments.length) {
        return [];
    }
    return rawSegments.split('/').map((segment) => unescapePathSegment(segment));
}

export function setNestedValue(targetObject, path, value) {
    const keys = path.split('.');
    const lastKey = keys.pop();
    const lastObject = keys.reduce((obj, key) => {
        if (!obj[key] || typeof obj[key] !== 'object') {
            obj[key] = {};
        }
        return obj[key];
    }, targetObject);
    lastObject[lastKey] = value;
}

export function getNestedValueBySegments(sourceObject, segments) {
    return segments.reduce((accumulator, key) => (accumulator && accumulator[key] !== undefined ? accumulator[key] : undefined), sourceObject);
}

export function setNestedValueBySegments(targetObject, segments, value) {
    const keys = [...segments];
    const lastKey = keys.pop();
    if (lastKey === undefined) return;

    const lastObject = keys.reduce((obj, key) => {
        if (!obj[key] || typeof obj[key] !== 'object') {
            obj[key] = {};
        }
        return obj[key];
    }, targetObject);

    lastObject[lastKey] = value;
}

export function deleteNestedValueBySegments(targetObject, segments) {
    if (!segments.length) return;

    const keys = [...segments];
    const lastKey = keys.pop();
    const parent = keys.reduce((obj, key) => {
        if (!obj || typeof obj !== 'object') {
            return undefined;
        }
        return obj[key];
    }, targetObject);

    if (!parent || typeof parent !== 'object') return;
    delete parent[lastKey];
}

export function flattenObject(nestedObject, prefix = '') {
    return Object.keys(nestedObject || {}).reduce((accumulator, key) => {
        const composedKey = prefix ? `${prefix}.${key}` : key;
        const value = nestedObject[key];
        if (value !== null && typeof value === 'object' && !Array.isArray(value)) {
            Object.assign(accumulator, flattenObject(value, composedKey));
        } else {
            accumulator[composedKey] = value;
        }
        return accumulator;
    }, {});
}

export function flattenObjectEntries(nestedObject, prefixSegments = []) {
    return Object.keys(nestedObject || {}).reduce((accumulator, key) => {
        const value = nestedObject[key];
        const nextSegments = [...prefixSegments, key];
        if (value !== null && typeof value === 'object' && !Array.isArray(value)) {
            accumulator.push(...flattenObjectEntries(value, nextSegments));
        } else {
            accumulator.push({ segments: nextSegments, value });
        }
        return accumulator;
    }, []);
}
