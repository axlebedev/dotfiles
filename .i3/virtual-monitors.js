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

const OUTPUT = 'HDMI-0'
const targetVals = {
  paddingLeft:  370,
  paddingRight: 270,
  paddingTop:  200,
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

const isMonitorSplit = (vmonName) => runCommand('xrandr --listmonitors').includes(vmonName)

const offsetStr = (offset) => offset < 0 ? offset : `+${offset}`

// xrandr --current | grep -w "HDMI-0" | awk '{print $3}'
// 2560x1440+1920+0
// 1: 1280x1440+1920+0
// 2: 1280x1440+3200+0
function initCurrentResolutionAndSize() {
  // 2560x1440+1920+0 {width}x{height}+{offset_x}+{offset_y}
  const resolutionString = runCommand(`xrandr --current | grep -w "${OUTPUT}"`)
  const match = resolutionString.match(/^.* (\d+)x(\d+)([+-]\d+)([+-]\d+).* (\d+)mm.* (\d+)mm$/);

  const width_px = parseInt(match[1], 10);
  const height_px = parseInt(match[2], 10);
  const offsetX = parseInt(match[3], 10);
  const offsetY = parseInt(match[4], 10);
  const width_mm = parseInt(match[5], 10);
  const height_mm = parseInt(match[6], 10);
  display = { width_px, height_px, offsetX, offsetY, width_mm, height_mm }
}

function pxToMm(px) {
  return Math.floor((px / display.width_px) * display.width_mm)
}

const getConfigStr = ({ width_px, height_px, offsetX, offsetY, width_mm, height_mm }) =>
  `${width_px}/${width_mm}x${height_px}/${height_mm}${offsetStr(offsetX)}${offsetStr(offsetY)}`

function getLeftConfig() {
  // VMON_LEFT: { top: 0, left: 0, width: padding_left, height: full_height }
  const newWidth_px = targetVals.paddingLeft;
  const newHeight_px = display.height_px;
  return {
    width_px: newWidth_px,
    width_mm: pxToMm(newWidth_px),
    height_px: newHeight_px,
    height_mm: pxToMm(newHeight_px),
    offsetX: display.offsetX,
    offsetY: display.offsetY,
  }
}

function getTopConfig() {
  // VMON_TOP: { top: 0, left: padding_left, width: full_width - padding_left - padding_right, height: padding_top }
  const newWidth_px = display.width_px - targetVals.paddingLeft - targetVals.paddingRight;
  const newHeight_px = targetVals.paddingTop;
  return {
    width_px: newWidth_px,
    width_mm: pxToMm(newWidth_px),
    height_px: newHeight_px,
    height_mm: pxToMm(newHeight_px),
    offsetX: display.offsetX + targetVals.paddingLeft,
    offsetY: display.offsetY,
  }
}

function getPrimaryConfig() {
  // VMON_PRIMARY: { top: padding_top, left: padding_left, width: full_width - padding_left - padding_right, height: full_height - padding_top - padding_bottom }
  const newWidth_px = display.width_px - targetVals.paddingLeft - targetVals.paddingRight;
  const newHeight_px = display.height_px - targetVals.paddingTop - targetVals.paddingBottom;
  return {
    width_px: newWidth_px,
    width_mm: pxToMm(newWidth_px),
    height_px: newHeight_px,
    height_mm: pxToMm(newHeight_px),
    offsetX: display.offsetX + targetVals.paddingLeft,
    offsetY: display.offsetY + targetVals.paddingTop,
  }
}

function getBottomConfig() {
  // VMON_BOTTOM: { top: full_height - padding_bottom, left: padding_left, width: full_width - padding_left - padding_right, height: padding_bottom }
  const newWidth_px = display.width_px - targetVals.paddingLeft - targetVals.paddingRight;
  const newHeight_px = targetVals.paddingBottom;
  return {
    width_px: newWidth_px,
    width_mm: pxToMm(newWidth_px),
    height_px: newHeight_px,
    height_mm: pxToMm(newHeight_px),
    offsetX: display.offsetX + targetVals.paddingLeft,
    offsetY: display.offsetY + display.height_px - targetVals.paddingBottom,
  }
}

function getRightConfig() {
  // VMON_RIGHT: { top: 0, left: full_width - padding_right, width:  padding_raigh, height: full_height }
  const newWidth_px = targetVals.paddingRight;
  const newHeight_px = display.height_px;
  return {
    width_px: newWidth_px,
    width_mm: pxToMm(newWidth_px),
    height_px: newHeight_px,
    height_mm: pxToMm(newHeight_px),
    offsetX: display.offsetX + display.width_px - targetVals.paddingRight,
    offsetY: display.offsetY,
  }
}

function splitMonitor() {
  if (isMonitorSplit(VMON_PRIMARY)) {
    notifySend('Monitor is already split')
    return
  }

  initCurrentResolutionAndSize()

  runCommand(`xrandr --setmonitor ${VMON_PRIMARY} ${getConfigStr(getPrimaryConfig())} ${OUTPUT}`)
  runCommand(`xrandr --setmonitor ${VMON_LEFT} ${getConfigStr(getLeftConfig())} ${OUTPUT}`)
  runCommand(`xrandr --setmonitor ${VMON_TOP} ${getConfigStr(getTopConfig())} ${OUTPUT}`)
  runCommand(`xrandr --setmonitor ${VMON_RIGHT} ${getConfigStr(getRightConfig())} ${OUTPUT}`)
  runCommand(`xrandr --setmonitor ${VMON_BOTTOM} ${getConfigStr(getBottomConfig())} ${OUTPUT}`)
  runCommand(`${I3_MSG_CMD} "focus output ${VMON_LEFT}; workspace 101"`)
  runCommand(`${I3_MSG_CMD} "focus output ${VMON_TOP}; workspace 102"`)
  runCommand(`${I3_MSG_CMD} "focus output ${VMON_RIGHT}; workspace 103"`)
  runCommand(`${I3_MSG_CMD} "focus output ${VMON_BOTTOM}; workspace 104"`)
  runCommand(`${I3_MSG_CMD} "focus output ${VMON_PRIMARY}"`)

  notifySend('Virtual monitors were created')
}

function unsplitMonitor() {
  runCommand(`xrandr --delmonitor ${VMON_PRIMARY}`)
  runCommand(`xrandr --delmonitor ${VMON_TOP}`)
  runCommand(`xrandr --delmonitor ${VMON_RIGHT}`)
  runCommand(`xrandr --delmonitor ${VMON_BOTTOM}`)
  runCommand(`xrandr --delmonitor ${VMON_LEFT}`)

  notifySend('Virtual monitors were deleted')
}

function toggleMonitor() {
  if (isMonitorSplit(VMON_PRIMARY)) {
    unsplitMonitor()
  } else {
    splitMonitor()
  }
}

// Main execution
const action = argv[2]

switch (action) {
  case 'on':
    splitMonitor()
    break
  case 'off':
    unsplitMonitor()
    break
  default:
    toggleMonitor()
    break
}

runCommand('killall dunst')
setTimeout(
  () => runCommand(I3_MSG_CMD + ' restart'),
  300,
)
