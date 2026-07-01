export function mountJsViewDetectorView(containerElement) {
    if (!containerElement) return;

    containerElement.innerHTML = `
        <div id="tab-jsv-panel" class="tab-panel hidden">
            <div class="jsv-controls">
                <div class="jsv-toggle-row">
                    <span class="jsv-toggle-label">Подсветка JSView-компонентов</span>
                    <label class="switch jsv-toggle-switch">
                        <input id="jsv-toggle-input" type="checkbox">
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="hint">Переключатель включает/выключает подсветку и отслеживание новых узлов.</div>
            </div>
        </div>
    `;
}
