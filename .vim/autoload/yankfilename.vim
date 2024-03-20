vim9script

export def YankFileName()
    var filename = expand("%:.")
    setreg('*', filename)
    setreg('+', filename)
    echo 'yanked: "' .. filename .. '"'
enddef

# https://github.com/[owner]/[repo]/blob/[git branch]/[filename]#L[lineNr]
export def YankGithubURL()
    # git@github.com:[owner]/[repo].git
    var remoteUrl = system('git remote get-url --push origin')
    remoteUrl = substitute(remoteUrl, '[\r\n]', '', '')
    remoteUrl = substitute(remoteUrl, 'git@', '', '')
    remoteUrl = substitute(remoteUrl, '\.git', '', '')
    remoteUrl = substitute(remoteUrl, ':', '/', '')

    var branch = systemlist('git rev-parse --abbrev-ref HEAD')[0]
    var filename = expand("%:.")
    var lineNr = line('.')

    var result = remoteUrl .. '/blob/' .. branch .. '/' .. filename .. '#L' .. lineNr

    setreg('*', result)
    setreg('+', result)
    echo 'yanked: "' .. result .. '"'
enddef
