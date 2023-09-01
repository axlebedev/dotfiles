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
    var ownerRepo = split(remoteUrl, ':')[1] # [owner]/[repo].git
    var repoGit = split(ownerRepo, '/')[1]

    var owner = split(ownerRepo, '/')[0]
    var repo = split(repoGit, '\.')[0]

    var branch = systemlist('git rev-parse --abbrev-ref HEAD')[0]
    var filename = expand("%:.")
    var lineNr = line('.')

    var result = 'https://github.com/' .. owner .. '/' .. repo .. '/blob/' .. branch .. '/' .. filename .. '#L' .. lineNr

    setreg('*', result)
    setreg('+', result)
    echo 'yanked: "' .. result .. '"'
enddef
