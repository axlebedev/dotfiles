export function initViewMenuFeature(features) {
    const viewMenu = document.getElementById('view-menu');

    if (!viewMenu || !Array.isArray(features) || !features.length) {
        return {
            switchTab: () => {},
        };
    }

    let viewMenuItems = [];

    const panelsByView = new Map(
        features.map((feature) => [feature.id, document.getElementById(feature.panelId)]),
    );

    function renderViewMenu() {
        viewMenu.innerHTML = '';
        viewMenu.setAttribute('role', 'tablist');
        features.forEach((feature, index) => {
            const menuItem = document.createElement('button');
            menuItem.className = 'tab-btn';
            if (index === 0) menuItem.classList.add('active');
            menuItem.dataset.view = feature.id;
            menuItem.setAttribute('role', 'tab');
            menuItem.setAttribute('aria-selected', index === 0 ? 'true' : 'false');
            menuItem.setAttribute('aria-controls', feature.panelId);
            menuItem.type = 'button';
            menuItem.textContent = feature.title;
            viewMenu.appendChild(menuItem);
        });
        viewMenuItems = Array.from(viewMenu.querySelectorAll('.tab-btn'));
    }

    function switchTab(tab) {
        viewMenuItems.forEach((item) => {
            const isActive = item.dataset.view === tab;
            item.classList.toggle('active', isActive);
            item.setAttribute('aria-selected', isActive ? 'true' : 'false');
        });
        features.forEach((feature) => {
            const panel = panelsByView.get(feature.id);
            if (!panel) return;
            const isActive = feature.id === tab;
            panel.classList.toggle('hidden', !isActive);
            panel.setAttribute('role', 'tabpanel');
            panel.setAttribute('aria-hidden', isActive ? 'false' : 'true');
        });
    }

    renderViewMenu();

    viewMenuItems.forEach((item) => {
        item.addEventListener('click', () => {
            switchTab(item.dataset.view);
        });
    });

    return {
        switchTab,
    };
}
