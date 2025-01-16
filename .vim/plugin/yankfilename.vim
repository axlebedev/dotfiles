vim9script

def YankFileName()
    var filename = expand("%:.")
    setreg('*', filename)
    setreg('+', filename)
    echo 'yanked: "' .. filename .. '"'
enddef

def YankFileNameForDebug()
    var filename = expand("%:.")->split('/')[1 : ]->join('/') .. ':' .. line('.')
    setreg('*', filename)
    setreg('+', filename)
    echo 'yanked: "' .. filename .. '"'
enddef


# https://github.com/[owner]/[repo]/blob/[git branch]/[filename]#L[lineNr]
def YankGithubURL()
    # also may be CocCommand git.copyUrl

    # git@github.com:[owner]/[repo].git
    var remoteUrl = system('git remote get-url --push origin')
    remoteUrl = substitute(remoteUrl, '[\r\n]', '', '')
    remoteUrl = substitute(remoteUrl, 'git@', '', '')
    remoteUrl = substitute(remoteUrl, '\.git', '', '')
    remoteUrl = substitute(remoteUrl, ':', '/', '')
    remoteUrl = substitute(remoteUrl, 'ssh\/\/\/', '', '')
    remoteUrl = substitute(remoteUrl, '\:\d\+', '', '')

    var branchName = systemlist('git rev-parse --abbrev-ref HEAD')[0]
    var filename = expand("%:.")
    var lineNr = line('.')

    var blob = remoteUrl =~ 'gitea' ? '/src/branch/' : '/blob/'
    var result = remoteUrl .. blob .. branchName .. '/' .. filename .. '#L' .. lineNr

    setreg('*', result)
    setreg('+', result)
    echo 'yanked: "' .. result .. '"'
enddef

nnoremap yf <ScriptCmd>YankFileName()<CR>
nnoremap yff <ScriptCmd>YankFileNameForDebug()<CR>
nnoremap yg <ScriptCmd>YankGithubURL()<CR>
