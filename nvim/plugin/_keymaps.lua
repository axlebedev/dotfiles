-- import 'vim-js-fastlog.vim' as jsLog
-- import 'chase.vim' as chase
--
-- import autoload '../autoload/globalfind.vim'
-- import autoload '../autoload/opennextbuf.vim'
-- import autoload '../autoload/htmlbeautify.vim'
-- import autoload '../autoload/increasefoldlevel.vim'
-- import autoload '../autoload/logfunction.vim'
-- import autoload '../autoload/removeqfitem.vim'
-- import autoload '../autoload/updatebuffer.vim'
-- import autoload './refactor.vim'
-- import autoload './quickfix-utils.vim' as quickfixUtils

vim.g.mapleader = " "

vim.keymap.set("n", "<Tab>", "%<CMD>FindCursor 0 500<CR>")

vim.keymap.set("v", "<Tab>", "%")

-- Make moving in line a bit more convenient
vim.keymap.set("n", "gg", "cursor(1, 1)", { silent = true })
vim.keymap.set("n", "$", "g_")
vim.keymap.set("v", "$", "g_")
vim.keymap.set("o", "$", "g_")
vim.keymap.set("n", "$$", "$")
vim.keymap.set("v", "$$", "$")
vim.keymap.set("o", "$$", "$")
vim.keymap.set("n", "0", "^")
vim.keymap.set("v", "0", "^")
vim.keymap.set("o", "0", "^")
vim.keymap.set("n", "00", "0")
vim.keymap.set("v", "00", "0")
vim.keymap.set("o", "00", "0")
vim.keymap.set("n", "f;", "g_")
vim.keymap.set("v", "f;", "g_")
vim.keymap.set("o", "f;", "g_")

-- fast save file, close file
vim.keymap.set("n", "<leader>w", "<cmd>w!<cr>")
vim.keymap.set("v", "<leader>w", "<cmd>w!<cr>")

-- Если просто закрыть fugitive-буфер - то закроется весь вим.
-- Поэтому делаем такой костыль
local au_dont_close_fugitive = vim.api.nvim_create_augroup("au_dont_close_fugitive", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "fugitive://*",
  group = au_dont_close_fugitive,
  callback = function()
    -- By default it's set bufhidden=delete in plugin source. I dont need it
    vim.opt.bufhidden = ''
  end,
})
local CloseBufferSafeFugitive = function()
    local buf = vim.fn.bufnr('%')
    local filesLength = #vim.api.nvim_list_bufs()
    if filesLength <= 1 then
      if vim.bo.filetype == 'alpha' then
        vim.cmd('qa!')
      else
        vim.cmd('Alpha')
      end
    else
      vim.cmd('bprev')
    end

    vim.api.nvim_buf_delete(buf, {})

    if vim.bo.buftype == 'quickfix' or vim.bo.buftype == 'terminal' then
      vim.cmd('Alpha')
    end
end
vim.keymap.set('n', '<leader>q', CloseBufferSafeFugitive, { silent = true })

-- new empty buffer
vim.keymap.set({ "n", "v" }, "<leader>x", "<cmd>Alpha<cr>")

-- split line
vim.keymap.set("n", "<leader>s", "a<CR><Esc>")

-- comfortable navigation through windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- visual select last visual selection
-- ХЗ почему я постоянно путаю
vim.keymap.set("n", "vg", "gv")

-- visual select last pasted text
vim.keymap.set("n", "vp", "`[v`]")

-- NvimTree mappings
vim.keymap.set('n', '<F2>', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>tt', ':NvimTreeFindFile<CR>')

-- don't reset visual selection after indent
vim.keymap.set("x", ">", ">gv", { silent = true })
vim.keymap.set("x", "<", "<gv", { silent = true })

-- Movement in wrapped lines
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")

-- insert blank line
vim.keymap.set("n", "<leader>o", "o<Esc>")

-- save file under root
vim.keymap.set("c", "w!!", "w !sudo tee % >/dev/null")

-- replace selection
vim.keymap.set("v", "<C-h>", '"hy:%s/<C-r>h//gc<left><left><left><C-r>h')

-- pretty find
vim.keymap.set("v", "//", '"py/<C-R>p<CR>')

-- close all other buffers
vim.keymap.set("n", "bo", "<cmd>BufOnly<CR>")

-- Now we don't have to move our fingers so far when we want to scroll through
-- the command history; also, don't forget the q: command
vim.keymap.set("c", "<c-j>", "<down>")
vim.keymap.set("c", "<c-k>", "<up>")

-- dont insert annoying 'PrtSc' code
vim.keymap.set("i", "<t_%9>", "<nop>")

local submode = require("submode")
submode.create("Resize", {
    mode = "n",
    enter = "<C-r>",
    leave = { "q", "<Esc>" },
    default = function(register)
        register('h', ':vertical resize -1<cr>')
        register('l', ':vertical resize +1<cr>')
        register('k', ':resize -1<cr>')
        register('j', ':resize +1<cr>')
    end
})

submode.create("Foldlevel", {
  mode = "n",
  enter = "<leader>fo",
  leave = { "q", "<Esc>" },
  default = function(register)
    register('-', require('foldlevel').decreaseFoldlevel)
    register('<', require('foldlevel').decreaseFoldlevel)
    register('h', require('foldlevel').decreaseFoldlevel)
    register('+', require('foldlevel').increaseFoldlevel)
    register('>', require('foldlevel').increaseFoldlevel)
    register('l', require('foldlevel').increaseFoldlevel)
    register('0', ':setlocal foldlevel=0<cr>')
    register('9', ':setlocal foldlevel=99<cr>')
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("user-event", {}),
  pattern = "SubmodeEnterPre", -- Name of user events
  callback = function(env)
    require('notify')(string.format("submode: %s", env.data.name), vim.log.levels.WARN)
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = true })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fugitive*", "git" },
  callback = function()
    vim.keymap.set("n", "q", CloseBufferSafeFugitive, { buffer = true })
  end,
})

vim.keymap.set("n", "<leader>a", "<cmd>ArgWrap<CR>", { silent = true })

vim.keymap.set('n', '<leader>t', '<cmd>Telescope find_files hidden=true<CR>', { noremap = false })
vim.keymap.set('n', '<leader>b', '<cmd>Telescope buffers<CR>', { noremap = false })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope commands<CR>', { noremap = false })
vim.keymap.set('n', 'sft', '<cmd>Telescope filetypes<CR>', { noremap = false })

-- TODO refactor
-- nnoremap <silent> <leader>r <Plug>(refactor-commands)
-- vnoremap <silent> <leader>r <Plug>(refactor-commands)
-- nnoremap <silent> rr <Plug>(refactor-commands)
-- vnoremap <silent> rr <Plug>(refactor-commands)

-- get current highlight group under cursor
vim.keymap.set({ "n", "v" }, "<F10>", function()
  vim.cmd([[
    echo 'hi<' .. synID(line('.'), col('.'), 1)->synIDattr('name') .. '> '
          .. 'transparent<' .. synID(line('.'), col('.'), 0)->synIDattr('name') .. '>'
          .. ' lo<' .. synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name') .. '>'
  ]])
end)

vim.keymap.set("n", "Y", "y$")
vim.keymap.set("v", "p", "pgvy")
-- replace word under cursor with last yanked
vim.keymap.set("n", "wp", "mmviwpgvy`m")
vim.keymap.set("n", "p", "p`]", { silent = true })

-- I dont need ex mode
vim.keymap.set("n", "Q", "@@")

-- beautify json, need "sudo apt install jq"
vim.keymap.set("n", "<leader>bj", "<cmd>%!jq .<cr>")
vim.keymap.set("v", "<leader>bj", "<cmd>'<,'>!jq .<cr>")

ClapOpen = function(command_str)
  while vim.fn.winnr("$") > 1 and (vim.fn.expand("%"):match("NERD_tree") or vim.bo.ft == "help" or vim.bo.ft == "qf") do
    vim.cmd("wincmd w")
  end
  vim.cmd("normal! " .. command_str .. "<cr>")
end

-- TODO autoload opennextbuf
-- nnoremap <silent> <leader>j <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(1)')<CR>
-- nnoremap <silent> <leader>k <ScriptCmd>ClapOpen(':vim9cmd opennextbuf.OpenNextBuf(0)')<CR>

vim.keymap.set("n", "<leader>f", "<cmd>FindCursor #CC0000 500<cr>")

-- TODO autoload globalfind
-- # Global find fix: use 'ag' and open quickfix {{{
-- nnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>
-- vnoremap <C-f> <ScriptCmd>globalfind.Grep()<CR>
-- nnoremap <C-f><C-t> <ScriptCmd>globalfind.FilterTestEntries()<cr>
-- nnoremap <C-f><C-d> <ScriptCmd>quickfixUtils.DeduplicateQuickfixList()<cr>

-- TODO plugin JsFastLog
-- # jsLog.JsFastLog mapping {{{
-- nnoremap <leader>l <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_simple')<cr>g@
-- vnoremap <leader>l <ScriptCmd>jsLog.JsFastLog_simple(visualmode())<cr>
--
-- nnoremap <leader>ll <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_JSONstringify')<cr>g@
-- vnoremap <leader>ll <ScriptCmd>jsLog.JsFastLog_JSONstringify(visualmode())<cr>
--
-- nnoremap <leader>lk <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_variable')<cr>g@
-- nmap <leader>lkk <leader>lkiW
-- vnoremap <leader>lk <ScriptCmd>jsLog.JsFastLog_variable(visualmode())<cr>
--
-- vnoremap <leader>lt <ScriptCmd>jsLog.JsFastLog_string_trace(visualmode())<cr>
--
-- nnoremap <leader>ld <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_function')<cr>g@
-- vnoremap <leader>ld <ScriptCmd>jsLog.JsFastLog_function(visualmode())<cr>
--
-- nnoremap <leader>ls <ScriptCmd>set operatorfunc=function('jsLog.JsFastLog_string')<cr>g@
-- vnoremap <leader>ls <ScriptCmd>jsLog.JsFastLog_string(visualmode())<cr>
--
-- nnoremap <leader>lss <ScriptCmd>jsLog.JsFastLog_separator()<cr>
-- nnoremap <leader>lsn <ScriptCmd>jsLog.JsFastLog_lineNumber()<cr>
-- # }}}

-- TODO lsp hover
-- nnoremap <silent> K <CMD>call CocActionAsync("doHover")<CR>
-- def JumpDefinitionFindCursor(command: string)
--     # setreg('/', expand('<cword>'))
--     exe command
--     timer_start(100, (id) => findcursor#FindCursor('#d6d8fa', 0))
-- enddef
-- def GoToDef()
--     if (['typescript', 'typescriptreact', 'javascript', 'javascriptreact']->index(&ft) != -1)
--         JumpDefinitionFindCursor("CocCommand tsserver.goToSourceDefinition")
--         return
--     endif
--
--     if (expand('<cword>') == 'import')
--         keepjumps search('from')
--         keepjumps normal! Wl
--         JumpDefinitionFindCursor("call CocAction('jumpDefinition')")
--         return
--     endif
--     var single_letter = getline('.')[col('.') - 1]
--     while (single_letter == ' ' || single_letter == '<')
--         normal! w
--         single_letter = getline('.')[col('.') - 1]
--     endwhile
--
--     var savedCursor = getcurpos()
--     JumpDefinitionFindCursor("call CocAction('jumpImplementation')")
--     if (savedCursor == getcurpos())
--         JumpDefinitionFindCursor("call CocAction('jumpDefinition')")
--     endif
-- enddef
-- nnoremap gd <ScriptCmd>GoToDef()<CR>
-- nnoremap gdd <ScriptCmd>JumpDefinitionFindCursor("call CocAction('jumpDefinition')")<CR>
-- nnoremap gi <ScriptCmd>JumpDefinitionFindCursor("call CocAction('jumpImplementation')")<CR>
-- nnoremap gt <ScriptCmd>JumpDefinitionFindCursor("call CocAction('jumpTypeDefinition')")<CR>

local ToggleQuickFix = function()
  local quickfix_windows = vim.fn.getwininfo():filter(function(info) return info.quickfix end)
  if vim.tbl_isempty(quickfix_windows) then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end
vim.keymap.set("n", "co", ToggleQuickFix, { silent = true })

-- TODO plugin vim-indexed-search
-- noremap <silent> <plug>(slash-after) <CMD>execute("FindCursor #d6d8fa 0<bar>ShowSearchIndex")<CR>

-- этот момент заебал
vim.keymap.set("c", "<C-f>", "<NOP>")

vim.keymap.set("n", "<BS>", "==")
vim.keymap.set("v", "<BS>", "=")

vim.keymap.set("n", "x", "\"_x", { silent = true })
-- Для того чтобы поменять местами буквы - оставляем дефолтное поведение
vim.keymap.set("n", "xp", "xp")

-- TODO autoload refactor
-- nnoremap <silent> elf <ScriptCmd>refactor.EslintFile()<CR>

-- TODO plugin Chase
-- nnoremap ~ <ScriptCmd>chase.Next()<CR>
-- vnoremap ~ <ScriptCmd>chase.Next()<CR>
-- nnoremap ! <ScriptCmd>chase.Prev()<CR>
-- vnoremap ! <ScriptCmd>chase.Prev()<CR>

vim.keymap.set("n", "q", "<NOP>")
vim.keymap.set("n", "<C-q>", "q")

-- TODO linting
-- nnoremap ad <ScriptCmd>ALEDisable<CR>

-- wrap visual selection into function block 
vim.keymap.set("v", "<C-b>", '"bdi{<CR>return <C-r>b;<CR>}<Esc>=ib')

local FoldSelection = function()
  local saved = vim.opt.foldmethod
  vim.opt_local.foldmethod = 'manual'
  vim.cmd('normal! zf')
end
vim.keymap.set('v', 'zf', FoldSelection)

-- TODO autoload logfunction
-- nnoremap lf <ScriptCmd>logfunction.LogFunction()<CR>

vim.keymap.set("n", "ZC", "zC")
vim.keymap.set("n", "ZO", "zO")

vim.keymap.set("n", "H", "zc")

-- TODO lsp reference used
-- def RefUsed(cleanImports: bool)
--     const word = expand('<cword>')
--     setreg('/', word)
--     execute "normal \<Plug>(coc-references-used)"
--     if (cleanImports)
--         var DoCleanImports = () => {
--             if (&ft == 'qf')
--                 removeqfitem.FilterQFWithWord('import')
--                 removeqfitem.FilterQFWithWord('\<\/')
--             else
--                 # timer_start(100, (id) => DoCleanImports())
--             endif
--         } 
--         timer_start(300, (id) => DoCleanImports())
--     endif
-- enddef
-- nmap <silent>gr <ScriptCmd>RefUsed(true)<CR>
-- nmap <silent>grr <ScriptCmd>RefUsed(false)<CR>

-- Yank with keeping cursor position in visual mode {{{
local Keepcursor_visual_wrapper = function(command)
  vim.cmd("normal! gv" .. command)
  vim.cmd("normal! gv<ESC>")
end
vim.keymap.set("x", "y", function() Keepcursor_visual_wrapper("y") end, { silent = true })
vim.keymap.set("x", "Y", function() Keepcursor_visual_wrapper("Y") end, { silent = true })
-- }}}

-- Repeat on every line {{{
-- repeat last command for each line of a visual selection
vim.keymap.set("v", ".", "<cmd>normal .<CR>")
vim.keymap.set("x", ".", "<cmd>normal .<CR>")
-- replay @q macro for each line of a visual selection
vim.keymap.set("v", "@q", ":normal @q<CR>")
vim.keymap.set("v", "@@", ":normal @@<CR>")
-- }}}

vim.keymap.set("n", "U", "<C-r>")

-- TODO function object
-- # select in function by coc.nvim
-- xmap if <Plug>(coc-funcobj-i)
-- omap if <Plug>(coc-funcobj-i)
-- xmap af <Plug>(coc-funcobj-a)
-- omap af <Plug>(coc-funcobj-a)

-- TODO class object
-- # select in class by coc.nvim
-- xmap ic <Plug>(coc-classobj-i)
-- omap ic <Plug>(coc-classobj-i)
-- xmap ac <Plug>(coc-classobj-a)
-- omap ac <Plug>(coc-classobj-a)

-- TODO autoload updatebuffer
-- nnoremap <silent> <F5> <ScriptCmd>updatebuffer.UpdateBuffer(0)<CR>
-- nnoremap <silent> <F5><F5> <ScriptCmd>updatebuffer.UpdateBuffer(1)<CR>

vim.keymap.set('n', 'yf', '<cmd>YankFileName<cr>')
vim.keymap.set('n', 'yff', '<cmd>YankFileNameForDebug<cr>')
vim.keymap.set('n', 'yg', '<cmd>YankGithubURLMaster<cr>')
vim.keymap.set('n', 'ygg', '<cmd>YankGithubURL<cr>')

-- TODO: plugin vim-require-to-import
-- nnoremap rti <ScriptCmd>RequireToImport<CR>
-- nnoremap itr <ScriptCmd>ImportToRequire<CR>

vim.keymap.set("n", "<2-LeftMouse>", "yiW")

-- TODO lsp coctree analog
-- def CloseCoctreeWindowsPreserveCursor(): void
--   var save_view = winsaveview()
--   var save_win = winnr()
--
--   var have_coctree = false
--
--   for w in range(winnr('$'), 1, -1)
--     execute(':' .. w .. 'wincmd w')
--     if &filetype ==# 'coctree'
--       have_coctree = true
--       execute 'close'
--     endif
--   endfor
--
--   if win_gotoid(win_getid(save_win)) == 0
--     wincmd w
--   endif
--   winrestview(save_view)
--
--   if !have_coctree
--     execute 'call CocAction("showOutline")'
--   endif
-- enddef
--
-- nnoremap <F4> <ScriptCmd>CloseCoctreeWindowsPreserveCursor()<CR>

vim.keymap.set("n", "sw", function() vim.o.wrap = not vim.o.wrap end)

vim.keymap.set("n", "<F1>", "<cmd>Telescope help_tags<cr>")
