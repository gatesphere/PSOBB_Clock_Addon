-- Clock PSOBB Plugin
-- gatesphere
-- configuration.lua

local function ConfigurationWindow(configuration)
    local this = 
    {
        title = "Clock - Configuration",
        fontScale = 1.0,
        open = false,
        changed = false,
    }

    local _configuration = configuration

    local _showWindowSettings = function()
        local success
        
        if imgui.Checkbox("Enable", _configuration.enable) then
            _configuration.enable = not _configuration.enable
            this.changed = true
        end
        
        if imgui.Checkbox("Use 24 Hour Time", _configuration.time24h) then
            _configuration.time24h = not _configuration.time24h
            this.changed = true
        end
        
        if imgui.Checkbox("Show seconds", _configuration.show_seconds) then
            _configuration.show_seconds = not _configuration.show_seconds
            this.changed = true
        end
        
        if imgui.Checkbox("Show .beats", _configuration.show_beats) then
            _configuration.show_beats = not _configuration.show_beats
            this.changed = true
        end 
    end

    this.Update = function()
        if this.open == false then
            return
        end

        local success

        imgui.SetNextWindowSize(200, 200, 'FirstUseEver')
        success, this.open = imgui.Begin(this.title, this.open)
        imgui.SetWindowFontScale(this.fontScale)

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return 
{
    ConfigurationWindow = ConfigurationWindow,
}
