-- vim: ts=2 sw=2 et ai cindent syntax=lua

local function read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return content:gsub("%s+", "")  -- Remove any trailing whitespace
end

-- path {{{
path = os.getenv("HOME") .. '/dotfiles/conky/'
-- }}}

-- internetInterface {{{
local handler_internetInterface = io.popen("ip addr | awk '/state UP/ {print $2}' | sed 's/.$//'")
internetInterface = handler_internetInterface:read('*a')
handler_internetInterface:close()
-- }}}

-- hwMonitorPath {{{
local current_hwmon = ''
for hwmon in io.popen('ls -d /sys/devices/platform/coretemp.0/hwmon/hwmon*'):lines() do
    -- Check if the 'name' file contains 'coretemp'
    local name = read_file(hwmon .. "/name")
    if name == "coretemp" then
        current_hwmon = name
        break
    end
end
hwMonitorPath = '/sys/devices/platform/coretemp.0/hwmon/' .. current_hwmon .. '/temp1_input'
-- }}}

-- coresNum {{{
local handle_coresNum = io.popen('cat /proc/cpuinfo | grep processor | wc -l')
coresNum = tonumber(handle_coresNum:read('*a'))
handle_coresNum:close()
-- }}}

-- {{{
local handle_thermal_zone = io.popen("grep -E 'x86_pkg_temp' /sys/class/thermal/thermal_zone*/type | cut -d'/' -f5 | xargs -I{} echo {}")
thermalZone = handle_thermal_zone:read('*a'):match("^%s*(.-)%s*$")
handle_thermal_zone:close()
-- }}}
