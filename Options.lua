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
}

-- Get all options and verify them
local function getOptions()
    local db = TeleportMenuDB
    for k, v in pairs(db) do
        if defaultsDB[k] == nil then
            db[k] = nil
        end
    end
    return db
end

local function resetOptions()
    TeleportMenuDB = defaultsDB
end

local function OnSettingChanged(_, setting, value)
	local variable = setting:GetVariable()
	TeleportMenuDB[variable] = value
    if variable == "Hearthstone_Dropdown" then
        tpm:updateHearthstone()
    end
end

local optionsCategory = Settings.RegisterVerticalLayoutCategory(ADDON_NAME)

function tpm:GetOptionsCategory()
    return optionsCategory:GetID()
end

function tpm:LoadOptions()
    local db = getOptions()

    do -- Enabled Checkbox
        local optionsKey = "enabled"
        local tooltip = L["Enable Tooltip"]
        local setting = Settings.RegisterAddOnSetting(optionsCategory, "Enabled_Toggle", optionsKey, db, type(defaultsDB[optionsKey]), L["Enabled"], defaultsDB[optionsKey])
        Settings.SetOnValueChangedCallback("Enabled_Toggle", OnSettingChanged)
        Settings.CreateCheckbox(optionsCategory, setting, tooltip)
    end

    -- do -- Icon Size Slider
    --     local optionsKey = "iconSize"
    --     local tooltip = "Increase or decrease the size of the icons."
    --     local options = Settings.CreateSliderOptions(10, 75, 1)
    --     local label = "%s px"

    --     local function GetValue()
    --         return TeleportMenuDB[optionsKey] or defaultsDB[optionsKey]
    --     end

    --     local function SetValue(value)
    --         TeleportMenuDB[optionsKey] = value
    --     end

    --     local setting = Settings.RegisterProxySetting(optionsCategory, "IconSize_Slider", type(defaultsDB[optionsKey]), "Icon Size", defaultsDB[optionsKey], GetValue, SetValue)

    --     local function Formatter(value)
	-- 		return label:format(value)
	-- 	end
    --     options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

    --     Settings.CreateSlider(optionsCategory, setting, options, tooltip)
    -- end

    do
        local optionsKey = "hearthstone"
        local tooltip = L["Hearthstone Toy Tooltip"]

        local function GetOptions()
            local container = Settings.CreateControlTextContainer()
            container:Add("none", L["None"])
            container:Add("rng", "|T1669494:16:16:0:0:64:64:4:60:4:60|t "..L["Random"])
            local startOption = 2
            local hearthstones = tpm:GetAvailableHearthstoneToys()
            for id, hearthstoneInfo in pairs(hearthstones) do
                container:Add(tostring(id), "|T"..hearthstoneInfo.texture..":16:16:0:0:64:64:4:60:4:60|t "..hearthstoneInfo.name)
            end
            return container:GetData()
        end

        local setting = Settings.RegisterAddOnSetting(optionsCategory, "Hearthstone_Dropdown", optionsKey, db, type(defaultsDB[optionsKey]), L["Hearthstone Toy"], defaultsDB[optionsKey])

        Settings.CreateDropdown(optionsCategory, setting, GetOptions, tooltip)
        Settings.SetOnValueChangedCallback("Hearthstone_Dropdown", OnSettingChanged)
    end

	Settings.RegisterAddOnCategory(optionsCategory)
end
