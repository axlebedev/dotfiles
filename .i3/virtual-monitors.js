#!/usr/bin/env node
// Split monitor vertically into 2 equal size virtual monitors

const { execSync } = require('child_process')
const { argv } = require('process')

/*
 * ###########################################
 * #                            #            #
 * #     VMON_TOP               #            #
 * #                            #            #
 * ##############################            #
 * #                            #            #
 * #                            # VMON_RIGHT #
 * #     VMON_PRIMARY           #            #
 * #                            #            #
 * #                            #            #
 * ##############################            #
 * #                            #            #
 * #     VMON_BOTTOM (not used) #            #
 * #                            #            #
 * ###########################################
 */

const OUTPUT = 'HDMI-0'
const targetWidth_px = 2050
const targetHeight_px = 1300

  const I3_MSG_CMD = "i3-msg"
const VMON_PRIMARY = 'VMON_BOTTOM_LEFT_PRIMARY'
const VMON_TOP = 'VMON_TOP'
// const VMON_BOTTOM = 'VMON_BOTTOM'
const VMON_RIGHT = 'VMON_RIGHT'

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
function getCurrentResolutionAndSize() {
  // 2560x1440+1920+0 {width}x{height}+{offset_x}+{offset_y}
  const resolutionString = runCommand(`xrandr --current | grep -w "${OUTPUT}"`)
  const match = resolutionString.match(/^.* (\d+)x(\d+)([+-]\d+)([+-]\d+).* (\d+)mm.* (\d+)mm$/);

  const width_px = parseInt(match[1], 10);
  const height_px = parseInt(match[2], 10);
  const offsetX = parseInt(match[3], 10);
  const offsetY = parseInt(match[4], 10);
  const width_mm = parseInt(match[5], 10);
  const height_mm = parseInt(match[6], 10);
  return { width_px, height_px, offsetX, offsetY, width_mm, height_mm }
}

const getConfigStr = ({ width_px, height_px, offsetX, offsetY, width_mm, height_mm }) =>
  `${width_px}/${width_mm}x${height_px}/${height_mm}${offsetStr(offsetX)}${offsetStr(offsetY)}`

function getTopConfig(monitorConfig) {
  const newWidth_px = targetWidth_px
  const newWidth_mm = Math.floor((newWidth_px / monitorConfig.width_px) * monitorConfig.width_mm)

  const newHeight_px = monitorConfig.height_px - targetHeight_px
  const newHeight_mm = Math.floor((newHeight_px / monitorConfig.height_px) * monitorConfig.height_mm)

  return {
    width_px: newWidth_px,
    width_mm: newWidth_mm,
    height_px: newHeight_px,
    height_mm: newHeight_mm,
    offsetX: monitorConfig.offsetX,
    offsetY: monitorConfig.offsetY,
  }
}


// `${newWidth_px}/${newWidth_mm}x${height_px}/${height_mm}${offsetStr(offsetX)}${offsetStr(offsetY)}`
// `2000/777x1000/555+3200+0`
function getPrimaryConfig(monitorConfig, topConfig) {
  const newWidth_px = targetWidth_px
  const newWidth_mm = Math.floor((newWidth_px / monitorConfig.width_px) * monitorConfig.width_mm)

  const newHeight_px = targetHeight_px
  const newHeight_mm = Math.floor((newHeight_px / monitorConfig.height_px) * monitorConfig.height_mm)

  return {
    width_px: newWidth_px,
    width_mm: newWidth_mm,
    height_px: newHeight_px,
    height_mm: newHeight_mm,
    offsetX: monitorConfig.offsetX,
    offsetY: monitorConfig.offsetY + topConfig.height_px,
  }
}

function getRightConfig(monitorConfig, primaryConfig) {
  const newWidth_px = monitorConfig.width_px - targetWidth_px
  const newWidth_mm = Math.floor((newWidth_px / monitorConfig.width_px) * monitorConfig.width_mm)

  const newHeight_px = monitorConfig.height_px
  const newHeight_mm = monitorConfig.height_mm

  return {
    width_px: newWidth_px,
    width_mm: newWidth_mm,
    height_px: newHeight_px,
    height_mm: newHeight_mm,
    offsetX: monitorConfig.offsetX + primaryConfig.width_px,
    offsetY: monitorConfig.offsetY,
  }
}

function splitMonitor() {
  if (isMonitorSplit(VMON_PRIMARY)) {
    notifySend('Monitor is already split')
    return
  }

  const monitorConfig = getCurrentResolutionAndSize()
  const topConfig = getTopConfig(monitorConfig)
  const primaryConfig = getPrimaryConfig(monitorConfig, topConfig)
  const rightConfig = getRightConfig(monitorConfig, primaryConfig)

  runCommand(`xrandr --setmonitor ${VMON_PRIMARY} ${getConfigStr(primaryConfig)} ${OUTPUT}`)
  runCommand(`xrandr --setmonitor ${VMON_TOP} ${getConfigStr(topConfig)} none`)
  runCommand(`xrandr --setmonitor ${VMON_RIGHT} ${getConfigStr(rightConfig)} none`)

  // runCommand(`${I3_MSG_CMD} focus output ${VMON_TOP}, workspace 11`)
  // runCommand(`${I3_MSG_CMD} focus output ${VMON_RIGHT}, workspace 10`)
fi

  notifySend('Virtual monitors were created')
}

function unsplitMonitor() {
  runCommand(`xrandr --delmonitor ${VMON_PRIMARY}`)
  runCommand(`xrandr --delmonitor ${VMON_TOP}`)
  runCommand(`xrandr --delmonitor ${VMON_RIGHT}`)

  notifySend('Virtual monitors were deleted')
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
    console.log('Usage: monitor-split on|off')
    process.exit(1)
}
