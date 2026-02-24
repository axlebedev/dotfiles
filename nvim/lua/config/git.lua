return {
    -- git
    { 'tpope/vim-fugitive' },
    { 'jreybert/vimagit' },
    { 'junegunn/gv.vim', cmd = 'GV' },
    { 'akinsho/git-conflict.nvim',
        version = "*",
        config = true,
        opts = {
            default_mappings = {
                ours = 'co',
                theirs = 'ct',
                both = 'cb',
                next = ']c',
                prev = '[c',
            },
        }
    },
}
