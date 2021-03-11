function! openjstest#OpenJsTest() abort
    let currentDir = expand('%:h')
    let currentFileName = expand('%:t')
    let isTestFile = stridx(currentDir, '__test__')

    " without ext: expand('%:t:r')
    let extensionLength = 3 " '.js'
    let testStrLength = 5 " '-test'

    if (isTestFile != -1)
        " go to from test to source file
        let sourceDir = expand('%:h:h')
        let fileName = currentFileName[0 : -(testStrLength + extensionLength + 1)]
        execute 'edit ' . sourceDir . '/' . fileName . '.js'
    else " if !isTestFile
        let fileName = currentFileName[0 : -(extensionLength + 1)] . '-test' . '.js'
        " go to test file
        let testFileName = currentDir . '/__test__/' . fileName
        execute 'edit ' . testFileName
    endif
endfunction
