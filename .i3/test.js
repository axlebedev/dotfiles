#!/usr/bin/env node
// Split monitor vertically into 2 equal size virtual monitors

const { execSync } = require('child_process')
const { argv } = require('process')

// xrandr --current | grep -w "HDMI-0" | awk '{print $3}' > 2560x1440+0+0
// full   : 2560 1440
// primary: 1920 1080
// padding-left:  320
// padding-right: 320
// padding-top:  180
// padding-bottom: 180

/*
 * ##########################################################
 * #              #                            #            #
 * #              #     VMON_TOP               #            #
 * #              #                            #            #
 * #              ##############################            #
 * #              #                            #            #
 * # VMON_LEFT    #                            # VMON_RIGHT #
 * #              #     VMON_PRIMARY           #            #
 * #              #                            #            #
 * #              #                            #            #
 * #              ##############################            #
 * #              #                            #            #
 * #              #     VMON_BOTTOM (not used) #            #
 * #              #                            #            #
 * ##########################################################
 */

// VMON_LEFT: { top: 0, left: 0, width: padding_left, height: full_height }
// VMON_RIGHT: { top: 0, left: full_width - padding_right, width:  padding_raigh, height: full_height }
// VMON_TOP: { top: 0, left: padding_left, width: full_width - padding_left - padding_right, height: padding_top }
// VMON_BOTTOM: { top: full_height - padding_bottom, left: padding_left, width: full_width - padding_left - padding_right, height: padding_bottom }
//
// VMON_PRIMARY: { top: padding_top, left: padding_left, width: full_width - padding_left - padding_right, height: full_height - padding_top - padding_bottom }

const OUTPUT = 'DP-1'
const targetVals = {
  paddingLeft:  250,
  paddingRight: 400,
  paddingTop:  150,
  paddingBottom: 160,
}
// const targetWidth_px = 2050
// const targetHeight_px = 1300

const I3_MSG_CMD = "i3-msg"
const VMON_PRIMARY = 'VMON_PRIMARY'
const VMON_TOP = 'VMON_TOP'
const VMON_BOTTOM = 'VMON_BOTTOM'
const VMON_RIGHT = 'VMON_RIGHT'
const VMON_LEFT = 'VMON_LEFT'

let display = null

function runCommand(command) {
  try {
    return execSync(command).toString().trim()
  } catch (error) {
    console.error(`Error executing command: ${command}`)
    process.exit(1)
  }
}

function notifySend(title, message = '') {
  return runCommand(`notify-send '${title}' '${message}'`)
}

function getWorkspaces() {
  // const res = JSON.parse(runCommand(I3_MSG_CMD + ' -t get_outputs'))
  const res = JSON.parse(runCommand(I3_MSG_CMD + ' -t get_workspaces'))
  const primary = [OUTPUT, VMON_PRIMARY]
  const paddings = [VMON_TOP, VMON_LEFT, VMON_RIGHT, VMON_BOTTOM]
  const onPrimary = res
    .filter(item => primary.includes(item.output))
    .map(item => item.name)

  const onPaddings = res
    .filter(item => paddings.includes(item.output))
    .map(item => item.name)
  console.log('%c11111', 'background:#00ff9f', 'onPrimary=', onPrimary)
  console.log('%c11111', 'background:#00ff9f', 'onPaddings=', onPaddings)
}

function moveWorkspacesOnPrimary() {
  const { onPrimary, onPaddings } = getWorkspaces()
  [onPrimary, onPaddings].forEach(workspace => {
    runCommand(I3_MSG_CMD + ' focus workspace ' + workspace + '; move workspace to output ' + OUTPUT)
  })
}

const output = runCommand("xrandr --current | grep primary | awk '{print $1}'")

console.log('%c11111', 'background:#00ff9f', 'output=', output);
