local ADDON_NAME, tpm = ...

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

-------------------------------------
-- Locales
--------------------------------------
SettingsBase = {
	__index = {
		["Enabled"] = false,
		["Teleports:Seasonal:Only"] = false,
		["Teleports:Mage:Reverse"] = false,
		["Teleports:Hearthstone"] = "none",
		["Button:Size"] = 40,
		["Button:Text:Size"] = 14,
		["Button:Text:Show"] = true,
		["Flyout:Max_Per_Row"] = 5,
        [202046] = false,     -- Lucky Tortollan Charm
        [63206] = UnitFactionGroup("player") == "Alliance",      -- Wrap of Unity: Stormwind
        [63352] = UnitFactionGroup("player") == "Alliance",      -- Shroud of Cooperation: Stormwind
        [65360] = UnitFactionGroup("player") == "Alliance",      -- Cloak of Coordination: Stormwind
        [95051] = UnitFactionGroup("player") == "Alliance",      -- The Brassiest Knuckle (Bizmo's Brawlpub)
        [118907] = UnitFactionGroup("player") == "Alliance",      -- Pit Fighter's Punching Ring (Bizmo's Brawlpub)
        [63207] = UnitFactionGroup("player") == "Horde",      -- Wrap of Unity: Orgrimmar
        [63353] = UnitFactionGroup("player") == "Horde",      -- Shroud of Cooperation: Orgrimmar
        [65274] = UnitFactionGroup("player") == "Horde",      -- Cloak of Coordination: Orgrimmar
        [95050] = UnitFactionGroup("player") == "Horde",      -- The Brassiest Knuckle (Brawl'gar Arena)
        [118908] = UnitFactionGroup("player") == "Horde",      -- Pit Fighter's Punching Ring (Brawl'gar Arena)
        [58487] = true,     -- Potion of Deepholm
        [61379] = true,     -- Gidwin's Hearthstone
        [63378] = true,     -- Hellscream's Reach Tabard
        [63379] = true,     -- Baradin's Wardens Tabard
        [64457] = true,     -- The Last Relic of Argus
        [64488] = true,     -- The Innkeeper's Daughter
        [68808] = true,     -- Hero's Hearthstone
        [68809] = true,     -- Veteran's Hearthstone
        [87548] = true,     -- Lorewalker's Lodestone
        [92510] = true,     -- Vol'jin's Hearthstone
        [93672] = true,     -- Dark Portal (MoP)
        [95567] = true,     -- Kirin Tor Beacon
        [95568] = true,     -- Sunreaver Beacon
        [103678] = true,      -- Time-Lost Artifact
        [110560] = true,      -- Garrison Hearthstone
        [117389] = true,      -- Draenor Archaeologist's Lodestone
        [118662] = true,      -- Bladespire Relic
        [118663] = true,      -- Relic of Karabor
        [119183] = true,      -- Scroll of Risky Recall
        [128502] = true,      -- Hunter's Seeking Crystal
        [128503] = true,      -- Master Hunter's Seeking Crystal
        [128353] = true,      -- Admiral's Compass
        [129276] = true,      -- Beginner's Guide to Dimensional Rifting
        [132119] = true,      -- Orgrimmar Portal Stone
        [132120] = true,      -- Stormwind Portal Stone
        [132517] = true,      -- Intra-Dalaran Wormhole Generator
        [132523] = true,      -- Reaves Battery
        [138448] = true,      -- Emblem of Margoss
        [139590] = true,      -- Scroll of Teleport: Ravenholdt
        [139599] = true,      -- Empowered Ring of the Kirin Tor
        [140192] = true,      -- Dalaran Hearthstone
        [140493] = true,      -- Adept's Guide to Dimensional Rifting
        [141013] = true,      -- Scroll of Town Portal: Shala'nir
        [141014] = true,      -- Scroll of Town Portal: Sashj'tar
        [141015] = true,      -- Scroll of Town Portal: Kal'delar
        [141016] = true,      -- Scroll of Town Portal: Faronaar
        [141017] = true,      -- Scroll of Town Portal: Lian'tril
        [141324] = true,      -- Talisman of the Shal'dorei
        [141605] = true,      -- Flight Master's Whistle
        [142298] = true,      -- Astonishingly Scarlet Slippers
        [142469] = true,      -- Violet Seal of the Grand Magus
        [142542] = true,      -- Tome of Town Portal (Diablo 3 event)
        [142543] = true,      -- Scroll of Town Portal (Diablo 3 event)
        [144341] = true,      -- Rechargeable Reaves Battery
        [144391] = true,      -- Pugilist's Powerful Punching Ring (Alliance)
        [144392] = true,      -- Pugilist's Powerful Punching Ring (Horde)
        [150733] = true,      -- Scroll of Town Portal (Ar'gorok in Arathi)
        [159224] = true,      -- Zuldazar Hearthstone
        [160219] = true,      -- Scroll of Town Portal (Stromgarde in Arathi)
        [162973] = true,      -- Greatfather Winter's Hearthstone
        [163045] = true,      -- Headless Horseman's Hearthstone
        [163694] = true,      -- Scroll of Luxurious Recall
        [166559] = true,      -- Commander's Signet of Battle
        [166560] = true,      -- Captain's Signet of Command
        [165669] = true,      -- Lunar Elder's Hearthstone
        [165670] = true,      -- Peddlefeet's Lovely Hearthstone
        [165802] = true,      -- Noble Gardener's Hearthstone
        [166746] = true,      -- Fire Eater's Hearthstone
        [166747] = true,      -- Brewfest Reveler's Hearthstone
        [167075] = true,      -- Ultrasafe Transporter: Mechagon
        [168862] = true,      -- G.E.A.R. Tracking Beacon
        [168907] = true,      -- Holographic Digitalization Hearthstone
        [169064] = true,      -- Montebank's Colorful Cloak
        [169297] = true,      -- Stormpike Insignia
        [172179] = true,      -- Eternal Traveler's Hearthstone
        [172203] = true,      -- Cracked Hearthstone
        [173373] = true,      -- Faol's Hearthstone
        [173430] = true,      -- Nexus Teleport Scroll
        [173532] = true,      -- Tirisfal Camp Scroll
        [173528] = true,      -- Gilded Hearthstone
        [173537] = true,      -- Glowing Hearthstone
        [173716] = true,      -- Mossy Hearthstone
        [180290] = true,      -- Night Fae Hearthstone
        [180817] = true,      -- Cypher of Relocation (Ve'nari's Refuge)
        [181163] = true,      -- Scroll of Teleport: Theater of Pain
        [182773] = true,      -- Necrolord's Hearthstone
        [183716] = true,      -- Venthyr Sinstone
        [184353] = true,      -- Kyrian Hearthstone
        [184500] = true,      -- Attendant's Pocket Portal: Bastion
        [184501] = true,      -- Attendant's Pocket Portal: Revendreth
        [184502] = true,      -- Attendant's Pocket Portal: Maldraxxus
        [184503] = true,      -- Attendant's Pocket Portal: Ardenweald
        [184504] = true,      -- Attendant's Pocket Portal: Oribos
        [188952] = true,      -- Dominated Hearthstone
        [189827] = true,      -- Cartel Xy's Proof of Initiation
        [190196] = true,      -- Enlightened Hearthstone
        [190237] = true,      -- Broker Translocation Matrix
        [191029] = true,      -- Lilian's Hearthstone
        [193588] = true,      -- Timewalker's Hearthstone
        [200630] = true,      -- Ohn'ir Windsage's Hearthstone
        [201957] = true,      -- Thrall's Hearthstone
        [204481] = true,      -- Morqut Hearth Totem
        [205255] = true,      -- Niffen Diggin' Mitts
        [205456] = true,      -- Lost Dragonscale (1)
        [205458] = true,      -- Lost Dragonscale (2)
        [211788] = true,      -- Tess's Peacebloom
	}
}


-- Get all options and verify them
local RawSettings;
function tpm:GetOptions()
	if not TeleportMenuDB then TeleportMenuDB = {} end
	RawSettings = TeleportMenuDB
	setmetatable(RawSettings, SettingsBase)
    return RawSettings
end

local function OnSettingChanged(_, setting, value)
    local variable = setting:GetVariable()
    TeleportMenuDB[variable] = value
    tpm:ReloadFrames()
end

local root = CreateFrame("Frame", ADDON_NAME, InterfaceOptionsFramePanelContainer);
local rootCategory = Settings.RegisterCanvasLayoutCategory(root, L["ADDON_NAME"])
local generalOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["GENERAL"])
local buttonOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["BUTTON_SETTINGS"])
local teleportsOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["TELEPORT_SETTINGS"])
local teleportFiltersFrame = CreateFrame("Frame", "TeleportFiltersFramePanel", InterfaceOptionsFramePanelContainer)
teleportFiltersFrame.title = teleportFiltersFrame:CreateFontString(nil,"ARTWORK","GameFontHighlightHuge")
teleportFiltersFrame.title:SetPoint("TOPLEFT",7,-22)
teleportFiltersFrame.title:SetText(L["Teleports:Items:Filters"])
teleportFiltersFrame.divider = teleportFiltersFrame:CreateTexture(nil,"ARTWORK")
teleportFiltersFrame.divider:SetAtlas("Options_HorizontalDivider",true)
teleportFiltersFrame.divider:SetPoint("TOP",0,-50)

local teleportFilters = Settings.RegisterCanvasLayoutSubcategory(teleportsOptions, teleportFiltersFrame, L["Teleports:Items:Filters"])
function tpm:GetOptionsCategory()
    return rootCategory:GetID()
end

function tpm:LoadOptions()
    local db = tpm:GetOptions()
	local defaults = SettingsBase["__index"]
	local ACTIVE_CONTRIBUTORS = {
		"Creator: Justw8",
	}

	do -- Settings Landing Page
		local header = root:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		header:SetJustifyH("LEFT")
		header:SetText(L["ADDON_NAME"])
		header:SetTextHeight(20)
		header:SetWordWrap(false)
		header:SetPoint("TOPLEFT", root, "TOPLEFT", 8, -8);
		header:Show()

		local logo = root:CreateTexture(nil, "ARTWORK");
		logo:SetPoint("TOPRIGHT", root, "TOPRIGHT", -8, -2);
		logo:SetTexture("Interface\\Icons\\inv_hearthstonepet");
		logo:SetSize(30, 30);
		logo:Show();
	
		local text = root:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetJustifyH("LEFT")
		text:SetText(L["ABOUT_ADDON"])
		text:SetWidth(640)
		text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, 20);
		text:Show()

		local contributors = root:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		contributors:SetJustifyH("LEFT")
		contributors:SetText(L["ABOUT_CONTRIBUTORS"]:format(table.concat(ACTIVE_CONTRIBUTORS, "\n")))
		contributors:SetWidth(640)
		contributors:SetPoint("BOTTOMLEFT", root, 0, 20)
	end

    do
        local optionsKey = "Enabled"
        local tooltip = L["Enable Tooltip"]
        local setting = Settings.RegisterAddOnSetting(generalOptions, "Enabled_Toggle", optionsKey, db, type(defaults[optionsKey]), L["Enabled"], defaults[optionsKey])
        Settings.SetOnValueChangedCallback("Enabled_Toggle", OnSettingChanged)
        Settings.CreateCheckbox(generalOptions, setting, tooltip)
    end

    do
        local optionsKey = "Teleports:Hearthstone"
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

        local setting = Settings.RegisterAddOnSetting(teleportsOptions, "Hearthstone_Dropdown", optionsKey, db, type(defaults[optionsKey]), L["Hearthstone Toy"], defaults[optionsKey])
        Settings.CreateDropdown(teleportsOptions, setting, GetOptions, tooltip)
        Settings.SetOnValueChangedCallback("Hearthstone_Dropdown", OnSettingChanged)
    end

    do -- ButtonText  Checkbox
        local optionsKey = "Button:Text:Show"
        local buttonText = L["ButtonText Tooltip"]
        local setting = Settings.RegisterAddOnSetting(buttonOptions, "ButtonText_Toggle", optionsKey, db, type(defaults[optionsKey]), L["ButtonText"], defaults[optionsKey])
        Settings.SetOnValueChangedCallback("ButtonText_Toggle", OnSettingChanged)
        Settings.CreateCheckbox(buttonOptions, setting, buttonText)
    end

	do -- Font Size Slider
        local optionsKey = "Button:Text:Size"
        local text = L["BUTTON_FONT_SIZE"]
        local tooltip = L["BUTTON_FONT_SIZE_TOOLTIP"]
        local options = Settings.CreateSliderOptions(6, 40, 1)
        local label = L["%s px"]

        local function GetValue()
            return TeleportMenuDB[optionsKey] or defaults[optionsKey]
        end

        local function SetValue(value)
            TeleportMenuDB[optionsKey] = value
            tpm:ReloadFrames()
        end

        local setting = Settings.RegisterProxySetting(buttonOptions, "ButtonFontSize_Slider", type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

        local function Formatter(value)
            return label:format(value)
        end
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

        Settings.CreateSlider(buttonOptions, setting, options, tooltip)
    end

    do -- Icon Size Slider
        local optionsKey = "Button:Size"
        local text = L["Icon Size"]
        local tooltip = L["Icon Size Tooltip"]
        local options = Settings.CreateSliderOptions(10, 75, 1)
        local label = L["%s px"]

        local function GetValue()
            return TeleportMenuDB[optionsKey] or defaults[optionsKey]
        end

        local function SetValue(value)
            TeleportMenuDB[optionsKey] = value
            tpm:ReloadFrames()
        end

        local setting = Settings.RegisterProxySetting(buttonOptions, "IconSize_Slider", type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

        local function Formatter(value)
            return label:format(value)
        end
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

        Settings.CreateSlider(buttonOptions, setting, options, tooltip)
    end

    do -- Max Flyout Icons
        local optionsKey = "Flyout:Max_Per_Row"
        local text = L["Icons Per Flyout Row"]
        local tooltip = L["Icons Per Flyout Row Tooltip"]
        local options = Settings.CreateSliderOptions(1, 20, 1)
        local label = L["%s icons"]

        local function GetValue()
            return TeleportMenuDB[optionsKey] or defaults[optionsKey]
        end

        local function SetValue(value)
            TeleportMenuDB[optionsKey] = value
            tpm:ReloadFrames()
        end

        local setting = Settings.RegisterProxySetting(buttonOptions, "MaxFlyoutIcons_Slider", type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

        local function Formatter(value)
            return label:format(value)
        end
        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

        Settings.CreateSlider(buttonOptions, setting, options, tooltip)
    end

    do -- Reverse the mage teleport flyouts
        local optionsKey = "Teleports:Mage:Reverse"
        local tooltip = L["Reverse Mage Flyouts Tooltip"]
        local setting = Settings.RegisterAddOnSetting(generalOptions, "reverseMageFlyouts_Checkbox", optionsKey, db, type(defaults[optionsKey]), L["Reverse Mage Flyouts"], defaults[optionsKey])
        Settings.SetOnValueChangedCallback("reverseMageFlyouts_Checkbox", OnSettingChanged)
        Settings.CreateCheckbox(generalOptions, setting, tooltip)
    end

    do -- Seasonal Teleports Only
        local optionsKey = "Teleports:Seasonal:Only"
        local tooltip = L["Seasonal Teleports Toggle Tooltip"]
        local setting =
            Settings.RegisterAddOnSetting(generalOptions, "ShowOnlySeasonalHerosPath_Checkbox", optionsKey, db, type(defaults[optionsKey]), L["Seasonal Teleports"], defaults[optionsKey])
        Settings.SetOnValueChangedCallback("ShowOnlySeasonalHerosPath_Checkbox", OnSettingChanged)
        Settings.CreateCheckbox(generalOptions, setting, tooltip)
    end

    do
        local items = {}
        for _, id in pairs(tpm.ItemTeleports) do
            local item = Item:CreateFromItemID(id)
            
            table.insert(items, {
                id = id,
                name = item:GetItemName(),
                icon = item:GetItemIcon()
            })
        end
       
        local container = CreateFrame("Frame", nil, teleportFiltersFrame)
        container:SetPoint("TOPLEFT", teleportFiltersFrame.divider, "BOTTOMLEFT", 0, -4)
        container:SetPoint("BOTTOMRIGHT", teleportFiltersFrame, nil, -4, 0)

        local scrollBar = CreateFrame("EventFrame", nil, container, "MinimalScrollBar")
        scrollBar:SetPoint("TOPRIGHT", -10, -5)
        scrollBar:SetPoint("BOTTOMRIGHT", -10, 5)
        local scrollBox = CreateFrame("Frame", nil, container, "WowScrollBoxList")
        scrollBox:SetPoint("TOPLEFT", 2, -2)
        scrollBox:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMLEFT", -3, 0)


        local function SetItemIcon(frame)
            frame.ItemIcon = frame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
            frame.ItemIcon:SetSize(15, 15)
            frame.ItemIcon:SetPoint("TOPLEFT", 23, -2.5)
        end

        local function SetEnabledIndicator(frame)
            frame.EnabledIndicator = frame:CreateTexture()
            frame.EnabledIndicator:SetSize(15, 15)
            frame.EnabledIndicator:SetPoint("TOPLEFT", 4, -2.5)
        end

        local view = CreateScrollBoxListLinearView()
        view:SetElementExtent(20)
        view:SetElementInitializer("Button", function(frame, elementData)
            local function SetValue(value)
                TeleportMenuDB[elementData.id] = value
                tpm:UpdateAvailableItemTeleports()
                tpm:ReloadFrames()
            end
            if not frame.ItemIcon then
                SetItemIcon(frame)
                SetEnabledIndicator(frame)
            end

            if elementData.icon and elementData.icon ~= nil then
                frame.ItemIcon:SetText("|T"..elementData.icon..":13:13|t ")
            else
                frame.ItemIcon:SetText("")
            end
            frame:SetPushedTextOffset(0, 0)
            frame:SetHighlightAtlas("search-highlight")
            frame:SetNormalFontObject(GameFontHighlight)
            frame.fullName = elementData.name
            frame:SetText(frame.fullName)
            frame:GetFontString():SetPoint("LEFT", 42, 0)
            frame:GetFontString():SetPoint("RIGHT", -20, 0)
            frame:GetFontString():SetJustifyH("LEFT")
            frame:SetScript("OnClick", function()
                if db[elementData.id] == true then
                    SetValue(false)
                else
                    SetValue(true)
                end
                frame.UpdateVisual()
            end)
            frame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	            GameTooltip:SetItemByID(elementData.id)
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            frame.UpdateVisual = function()
                if db[elementData.id] == true then
                    frame.EnabledIndicator:SetAtlas("common-icon-checkmark-yellow")
                else
                    frame.EnabledIndicator:SetAtlas("common-icon-redx")
                end
            end
            frame:UpdateVisual()
        end)
        ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)

        container:SetScript("OnShow", function()
            scrollBox:SetDataProvider(CreateDataProvider(items), true)
        end)
    end


    Settings.RegisterAddOnCategory(rootCategory)
	Settings.RegisterAddOnCategory(generalOptions)
	Settings.RegisterAddOnCategory(buttonOptions)
	Settings.RegisterAddOnCategory(teleportsOptions)
	Settings.RegisterAddOnCategory(teleportFilters)
end
