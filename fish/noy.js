const child_process = require('child_process');
const fs = require('fs');
const process = require('process');

const FZF_CMD = 'fzf --layout=reverse --bind=esc:abort --height=20 --scheme=history --bind esc:'
const PACKAGE_JSON = 'package.json'

const getScripts = (filename, program) => {
    let data = fs.readFileSync(filename, 'utf8')
    data = JSON.parse(data);
    data = data.scripts
    data = Object.keys(data)
    data = data.sort()
    data = data.map((script) => `${program} ${script}`)
    return data
}

const getWorkspaces = (filename) => {
    let data = fs.readFileSync(filename, 'utf8')
    data = JSON.parse(data);
    data = data.workspaces
    if (Array.isArray(data)) {
        console.log('%c11111', 'background:#d0ff00', 'isArray');
        console.log('%c11111', 'background:#d0ff00', 'data=', data);
        return data
    }
    console.log('%c11111', 'background:#d0ff00', 'isObject');
    console.log('%c11111', 'background:#d0ff00', 'data=', data);
}

const cdToWorkingDir = () => {
    while (!fs.existsSync(PACKAGE_JSON)) {
        if (process.cwd() === '/') {
            return 1
        }
        process.chdir('..')
    }
    return 0
}

const getPackageManager = (cwd = null) => {
    const currentDir = cwd || process.cwd()

    if (fs.existsSync(PACKAGE_JSON)) {
        let data = fs.readFileSync(PACKAGE_JSON, 'utf8')
        if (data.packageManager) {
            process.chdir(currentDir)
            return data.packageManager.split('@')[0]
        }
        if (fs.existsSync('yarn.lock')) {
            process.chdir(currentDir)
            return 'yarn'
        }
        if (fs.existsSync('package-lock.json')) {
            process.chdir(currentDir)
            return 'npm'
        }
    }

    if (process.cwd() === '/') {
        return ''
    }
    process.chdir('..')
    return getPackageManager(currentDir)
}

const main = () => {
    const isNotInPackageJson = cdToWorkingDir()

    if (isNotInPackageJson) {
        console.log('n')
        return
    }

    const programT = getPackageManager()
    const program = programT === 'npm' ? 'npm run' : programT
    const scripts = getScripts(PACKAGE_JSON, program).join('\n')

    try {
        const result = child_process.execSync(
            `echo "${scripts}" | ${FZF_CMD}`,
            { encoding: "UTF-8" },
        )
        console.log(result)
    } catch (error) {}
}

main()
