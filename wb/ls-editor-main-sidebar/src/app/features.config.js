import { mountRequestsInterceptView } from '../features/requests-intercept/view.js';
import { initRequestsInterceptFeature } from '../features/requests-intercept/init.js';
import { mountSplitInfoV2View } from '../features/split-info-v2/view.js';
import { initSplitInfoV2Feature } from '../features/split-info-v2/init.js';
// import { mountSettingsRecipesView } from '../features/settings-recipes/view.js';
// import { initSettingsRecipesFeature } from '../features/settings-recipes/init.js';

export const FEATURE_MENU_CONFIG = [
    {
        id: 'home',
        title: 'Главная',
        panelId: 'tab-home-panel',
    },
    {
        id: 'flags',
        title: 'Управление флагами',
        panelId: 'tab-flags-panel',
    },
    {
        id: 'split-info-v2',
        title: 'Сплиттер',
        panelId: 'tab-split-info-v2-panel',
        slotId: 'feature-split-info-v2-slot',
        mount: mountSplitInfoV2View,
        init: initSplitInfoV2Feature,
    },
    // TODO: разобраться с местом хранения конфига
    // {
    //     id: 'recipes',
    //     title: 'Сценарии',
    //     panelId: 'tab-recipes-panel',
    //     slotId: 'feature-settings-recipes-slot',
    //     mount: mountSettingsRecipesView,
    //     init: initSettingsRecipesFeature,
    // },
    {
        id: 'jsv',
        title: 'Js View Detector',
        panelId: 'tab-jsv-panel',
    },
    {
        id: 'requests',
        title: 'Подмена запросов',
        panelId: 'tab-requests-panel',
        slotId: 'feature-requests-intercept-slot',
        mount: mountRequestsInterceptView,
        init: initRequestsInterceptFeature,
    },
];
