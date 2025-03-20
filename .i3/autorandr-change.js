#!/bin/node

const execSync = require('child_process').execSync

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms)
  })
}

function getActiveOutputs() {
    const activeMonitors = execSync('xrandr --listactivemonitors', { encoding: 'utf8' })
        .split('\n')
        .slice(1)
        .filter(Boolean)
        .map((line) => line.split(' ').pop())

    return activeMonitors
}

function getActiveConf() {
    const currentConf = execSync('autorandr --current', { encoding: 'utf8' })
    return currentConf
}

async function main() {
    const currentConf = getActiveConf()
    getActiveOutputs().forEach((output) => {
        execSync(`i3-save-tree --output ${output} > ~/.i3-tmp/${currentConf}/output_${output}.json`)
    })

    execSync('autorandr --change')

    await sleep(100)

    getActiveOutputs().forEach((output) => {
        execSync(`i3-msg "output ${output}; append_layout /.i3-tmp/${currentConf}/output_${output}.json"`)
    })

    execSync('setxkbmap -layout us,ru -option "grp:shift_caps_switch" -option "kpdl:dot"')
}
