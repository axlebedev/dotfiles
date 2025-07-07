vim9script

export def Unmerged(): void
    call fzf#vim#files('', {
                \    'source': 'git diff --name-only --diff-filter=U',
                \    'sink': 'e',
                \    'options': '--prompt="Unmerged> "'
                \ })
enddef
