-- Clock PSOBB Plugin
-- gatesphere
-- init.lua

-- Imports
local core_mainmenu = require("core_mainmenu")
local clock_cfg = require("Clock.configuration")
local optionsLoaded, options = pcall(require, "Clock.options")
local optionsFileName = "addons/Clock/options.lua"

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = options.configurationEnableWindow == nil and true or options.configurationEnableWindow
    options.enable = options.enable == nil and true or options.enable
    options.time24h = options.time24h == nil and false or options.time24h
    options.show_seconds = options.show_seconds == nil and true or options.show_seconds
    options.show_beats = options.show_beats == nil and true or options.show_beats
else
    options = 
    {
        configurationEnableWindow = true,
        enable = true,
        time24h = false,
        show_seconds = true,
        show_beats = true
    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return {\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write("\n")
		io.write(string.format("    time24h = %s,\n", tostring(options.time24h)))
		io.write(string.format("    show_seconds = %s,\n", tostring(options.show_seconds)))
		io.write(string.format("    show_beats = %s,\n", tostring(options.show_beats)))
        io.write("}\n")

        io.close(file)
    end
end

-- storage
local timestr = ""

-- helpers (thanks SO)
local function get_beats()
  local now = os.time()
  return (now+3600)%86400/86.4
end

local function recalculate_timestr()
  if options.time24h then
    if options.show_seconds then
      timestr = "%H:%M:%S"
    else
      timestr = "%H:%M"
    end
  else
    if options.show_seconds then
      timestr = "%I:%M:%S %p"
    else
      timestr = "%I:%M %p"
    end
  end
end

-- Do all the stuff
local function clock_window()
  -- draw the window
  if options.enable then
    imgui.Begin("Clock", nil, {"NoTitleBar", "AlwaysAutoResize"})
    
    -- grab current system time
    cur_time = os.date(timestr)
    imgui.Text(cur_time)
    
    if options.show_beats then
      imgui.Text(string.format("@%.0f .beats", get_beats()))
    end
    imgui.End()
  end
end

local function present()
    local changedOptions = false
    -- If the addon has never been used, open the config window
    -- and disable the config window setting
    if options.configurationEnableWindow then
       Clock_Config.open = true
       options.configurationEnableWindow = false
    end

    Clock_Config.Update()
    if Clock_Config.changed then
        changedOptions = true
        Clock_Config.changed = false
        SaveOptions(options)
        recalculate_timestr()
    end
    
    clock_window()
end

local function init()

  Clock_Config = clock_cfg.ConfigurationWindow(options)

  local function mainMenuButtonHandler()
      Clock_Config.open = not Clock_Config.open
  end
  
  core_mainmenu.add_button("Clock", mainMenuButtonHandler)
  
  if timestr == "" then
    recalculate_timestr()
  end
  
  return {
    name = 'Clock',
    version = '1.0',
    author = 'gatesphere',
    present = present,
  }
end

return {
  __addon = {
    init = init,
  }
}
