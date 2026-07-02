/**
 * @typedef {Object} RecipeOperation
 * @property {string} path
 * @property {unknown} value
 */

/**
 * @typedef {Object} SettingsRecipe
 * @property {string} id
 * @property {string} title
 * @property {string} [description]
 * @property {string} [authorBandNick]
 * @property {'toggle'} mode
 * @property {RecipeOperation[]} on
 * @property {RecipeOperation[]} off
 * @property {'builtin' | 'custom'} source
 */

export {};
