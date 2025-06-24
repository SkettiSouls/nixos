local padding = os.getenv("PLP_PADDING")
local distance = os.getenv("PLP_DISTANCE")
local duration = os.getenv("PLP_DURATION")
local run_type = os.getenv("PLP_RUNTYPE")
distance = distance + padding

local function get_dpms()
  local var = os.getenv("PLP_WLCOMPOSITOR");
  local lower = string.lower(var)
  if lower == "niri" then
    return "niri msg action ", "power-off-monitors", "power-on-monitors"
  elseif lower == "hyprland" then
    return "hyprctl dispatch dpms ", "off", "on"
  end
end

local function notify(time, metric)
  os.execute('notify-send "Polyphasia" "Sleep cycle beings in ' .. time .. ' ' .. metric .. '"')
end

local function sleep(num, type)
  local type_char = string.sub(type, 1, 1)
  os.execute('sleep ' .. num .. type_char)
end

local function notify_sleep(notify, sleep, type)
  notify(notify, type)
  sleep(sleep, type)
end

local function begin()
  local cmd, off, on = get_dpms()
  if not cmd then
    os.execute'notify-send "Polyphasia" "No monitor control command found"'
    return
  end
  os.execute(cmd .. off)
  sleep(duration, 'hours')
  os.execute(cmd .. on)
end

local function prerun(dist)
  local exists = false
  io.popen('gammastep -o -O 1700')

  notify(dist, 'hour(s)')
  if dist >= 1.5 then
    sleep(dist - 1.0, 'hours')
    notify(1, 'hour')
    sleep(30, 'minutes')
    notify_sleep(30, 20, 'minutes')
    notify_sleep(10, 10, 'minutes')
  elseif dist >= 1.0 then
    sleep(dist - 0.5, 'hours')
    notify_sleep(30, 20, 'minutes')
    notify_sleep(10, 10, 'minutes')
  elseif dist >= 0.5 then
    sleep(dist - 0.167, 'hours')
    notify_sleep(10, 10, 'minutes')
  else
    sleep(dist, 'hours')
  end

  os.execute('pkill gammastep')
end

if run_type == 'padded' then
  prerun(distance)
elseif run_type == 'normal' then
  prerun(padding)
end

begin()
