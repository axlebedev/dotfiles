function! yankfilename#YankFileName()
    let filename = expand("%:.")
    let @* = filename
    let @+ = filename
    echo 'yanked: "' . filename . '"'
endfunction

" https://github.com/[owner]/[repo]/blob/[git branch]/[filename]#L[lineNr]
function! yankfilename#YankGithubURL()
    "git@github.com:[owner]/[repo].git
    let remoteUrl = system('git remote get-url --push origin')
    let ownerRepo = split(remoteUrl, ':')[1] " [owner]/[repo].git
    let repoGit = split(ownerRepo, '/')[1]

    let owner = split(ownerRepo, '/')[0]
    let repo = split(repoGit, '\.')[0]

    let branch = systemlist('git rev-parse --abbrev-ref HEAD')[0]
    let filename = expand("%:.")
    let lineNr = line('.')

    let result = 'https://github.com/'.owner.'/'.repo.'/blob/'.branch.'/'.filename.'#L'.lineNr

    let @* = result
    let @+ = result
    echo 'yanked: "' . result . '"'
endfunction
