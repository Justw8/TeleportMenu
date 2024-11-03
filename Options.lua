local ADDON_NAME, tpm = ...

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

-------------------------------------
-- Locales
--------------------------------------

local defaultsDB = {
    enabled = true,
    iconSize = 40,
    hearthstone = "none",
    maxFlyoutIcons = 5,
    reverseMageFlyouts = false,
    buttonText = true,
    showOnlySeasonalHerosPath = false
}

-- Get all options and verify them
function tpm:GetOptions()
    local db = TeleportMenuDB or {}
    for k, v in pairs(db) do -- Remove any invalid options
        if defaultsDB[k] == nil then
            db[k] = nil
        end
    end
    for k, v in pairs(defaultsDB) do -- Set Defaults
        if db[k] == nil then
            db[k] = v
        end
    end
    TeleportMenuDB = db
    return db
end

local function OnSettingChanged(_, setting, value)
    local variable = setting:GetVariable()
    TeleportMenuDB[variable] = value
    tpm:ReloadFrames()
end

local optionsCategory = Settings.RegisterVerticalLayoutCategory(ADDON_NAME)

function tpm:GetOptionsCategory()
    return optionsCategory:GetID()
end

function tpm:LoadOptions()
    local db = tpm:GetOptions()

    do
        local optionsKey = "enabled"
        local tooltip = L["Enable Tooltip"]
        local setting = Settings.RegisterAddOnSetting(optionsCategory, "Enabled_Toggle", optionsKey, db, type(defaultsDB[optionsKey]), L["Enabled"], defaultsDB[optionsKey])
        Settings.SetOnValueChangedCallback("Enabled_Toggle", OnSettingChanged)
        Settings.CreateCheckbox(optionsCategory, setting, tooltip)
    end

    do
        local optionsKey = "hearthstone"
        local tooltip = L["Hearthstone Toy Tooltip"]

        local function GetOptions()
            local container = Settings.CreateControlTextContainer()
            container:Add("none", L["None"])
            container:Add("rng", "|T1669494:16:16:0:0:64:64:4:60:4:60|t " .. L["Random"])
            local startOption = 2
            local hearthstones = tpm:GetAvailableHearthstoneToys()
            for id, hearthstoneInfo in pairs(hearthstones) do
                container:Add(tostring(id), "|T" .. hearthstoneInfo.texture .. ":16:16:0:0:64:64:4:60:4:60|t " .. hearthstoneInfo.name)
            end
            return container:GetData()
        end

        local setting = Settings.RegisterAddOnSetting(optionsCategory, "Hearthstone_Dropdown", optionsKey, db, type(defaultsDB[optionsKey]), L["Hearthstone Toy"], defaultsDB[optionsKey])
        Settings.CreateDropdown(optionsCategory, setting, GetOptions, tooltip)
        Settings.SetOnValueChangedCallback("Hearthstone_Dropdown", OnSettingChanged)
    end

    do -- ButtonText  Checkbox
        local optionsKey = "buttonText"
        local buttonText = L["ButtonText Tooltip"]
        local setting = Settings.RegisterAddOnSetting(optionsCategory, "ButtonText_Toggle", optionsKey, db, type(defaultsDB[optionsKey]), L["ButtonText"], defaultsDB[optionsKey])
        Settings.SetOnValueChangedCallback("ButtonText_Toggle", OnSettingChanged)
        Settings.CreateCheckbox(optionsCategory, setting, buttonText)
    end

    do -- Icon Size Slider
        local optionsKey = "iconSize"
        local text = L["Icon Size"]
        local tooltip = L["Icon Size Tooltip"]
        local options = Settings.CreateSliderOptions(10, 75, 1)
        local label = L["%s px"]

        local function GetValue()
            return TeleportMenuDB[optionsKey] or defaultsDB[optionsKey]
        end

        local function SetValue(value)
            TeleportMenuDB[optionsKey] = value
            tpm:ReloadFrames()
        end

        local setting = Settings.RegisterProxySetting(optionsCategory, "IconSize_Slider", type(defaultsDB[optionsKey]), text, defaultsDB[optionsKey], GetValue, SetValue)

        local function Formatter(value)
            return label:format(value)
        end
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

        Settings.CreateSlider(optionsCategory, setting, options, tooltip)
    end

    do -- Max Flyout Icons
        local optionsKey = "maxFlyoutIcons"
        local text = L["Icons Per Flyout Row"]
        local tooltip = L["Icons Per Flyout Row Tooltip"]
        local options = Settings.CreateSliderOptions(1, 20, 1)
        local label = L["%s icons"]

        local function GetValue()
            return TeleportMenuDB[optionsKey] or defaultsDB[optionsKey]
        end

        local function SetValue(value)
            TeleportMenuDB[optionsKey] = value
            tpm:ReloadFrames()
        end

        local setting = Settings.RegisterProxySetting(optionsCategory, "MaxFlyoutIcons_Slider", type(defaultsDB[optionsKey]), text, defaultsDB[optionsKey], GetValue, SetValue)

        local function Formatter(value)
            return label:format(value)
        end
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

        Settings.CreateSlider(optionsCategory, setting, options, tooltip)
    end

    do -- Reverse the mage teleport flyouts
        local optionsKey = "reverseMageFlyouts"
        local tooltip = L["Reverse Mage Flyouts Tooltip"]
        local setting = Settings.RegisterAddOnSetting(optionsCategory, "reverseMageFlyouts_Checkbox", optionsKey, db, type(defaultsDB[optionsKey]), L["Reverse Mage Flyouts"], defaultsDB[optionsKey])
        Settings.SetOnValueChangedCallback("reverseMageFlyouts_Checkbox", OnSettingChanged)
        Settings.CreateCheckbox(optionsCategory, setting, tooltip)
    end

    do -- Seasonal Teleports Only
        local optionsKey = "showOnlySeasonalHerosPath"
        local tooltip = L["Seasonal Teleports Toggle Tooltip"]
        local setting =
            Settings.RegisterAddOnSetting(optionsCategory, "ShowOnlySeasonalHerosPath_Checkbox", optionsKey, db, type(defaultsDB[optionsKey]), L["Seasonal Teleports"], defaultsDB[optionsKey])
        Settings.SetOnValueChangedCallback("ShowOnlySeasonalHerosPath_Checkbox", OnSettingChanged)
        Settings.CreateCheckbox(optionsCategory, setting, tooltip)
    end

    Settings.RegisterAddOnCategory(optionsCategory)
end
