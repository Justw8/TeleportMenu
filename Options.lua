local ADDON_NAME, tpm = ...

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

-------------------------------------
-- Locales
--------------------------------------

function tpm:ConvertOldSettings()
	if not TeleportMenuDB then return end

	local mappedKeysToNewFormat = {
		enabled = "Enabled",
		debug = "Developers:Debug_Mode:Enabled",
		iconSize = "Button:Size",
		hearthstone = "Teleports:Hearthstone",
		buttonText = "Button:Text:Show",
		maxFlyoutIcons = "Flyout:Max_Per_Row",
		reverseMageFlyouts = "Teleports:Mage:Reverse",
		showOnlySeasonalHerosPath = "Teleports:Seasonal:Only"
	}

	for oldKey, newKey in pairs(mappedKeysToNewFormat) do
		if TeleportMenuDB[oldKey] ~= nil then
			TeleportMenuDB[newKey] = TeleportMenuDB[oldKey]
			TeleportMenuDB[oldKey] = nil
		end
	end

	TeleportMenuDB = setmetatable(TeleportMenuDB, {
		__index = tpm.SettingsBase
	})
end

-- Get all options and verify them
local RawSettings
function tpm:GetOptions()
	if not TeleportMenuDB then TeleportMenuDB = {} end
	tpm:ConvertOldSettings()
	RawSettings = TeleportMenuDB
	return RawSettings
end

local function OnSettingChanged(_, setting, value)
	local variable = setting:GetVariable()
	TeleportMenuDB[variable] = value
	tpm:ReloadFrames()
end

local root = CreateFrame("Frame", ADDON_NAME, InterfaceOptionsFramePanelContainer)
root.title = root:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
root.title:SetPoint("TOPLEFT", 7, -22)
root.title:SetText(L["ADDON_NAME"])
root.divider = root:CreateTexture(nil, "ARTWORK")
root.divider:SetAtlas("Options_HorizontalDivider", true)
root.divider:SetPoint("TOP", 0, -50)
root.logo = root:CreateTexture(nil, "ARTWORK")
root.logo:SetPoint("TOPRIGHT", root, "TOPRIGHT", -8, -14)
root.logo:SetTexture("Interface\\Icons\\inv_hearthstonepet")
root.logo:SetSize(30, 30)
root.logo:Show()

local rootCategory = Settings.RegisterCanvasLayoutCategory(root, L["ADDON_NAME"])
local generalOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["GENERAL"])
local buttonOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["BUTTON_SETTINGS"])
local teleportsOptions = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["TELEPORT_SETTINGS"])
local teleportFiltersFrame = CreateFrame("Frame", "TeleportFiltersFramePanel", InterfaceOptionsFramePanelContainer)
teleportFiltersFrame.title = teleportFiltersFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
teleportFiltersFrame.title:SetPoint("TOPLEFT", 7, -22)
teleportFiltersFrame.title:SetText(L["Teleports:Items:Filters"])
teleportFiltersFrame.divider = teleportFiltersFrame:CreateTexture(nil, "ARTWORK")
teleportFiltersFrame.divider:SetAtlas("Options_HorizontalDivider", true)
teleportFiltersFrame.divider:SetPoint("TOP", 0, -50)

local teleportFilters = Settings.RegisterCanvasLayoutSubcategory(teleportsOptions, teleportFiltersFrame, L["Teleports:Items:Filters"])
function tpm:GetOptionsCategory(category)
	if not category or category == "root" then
		return rootCategory:GetID()
	elseif category == "filters" then
		return teleportFilters:GetID()
	end
end

function tpm:LoadOptions()
	local db = tpm:GetOptions()
	local defaults = tpm.SettingsBase
	local ACTIVE_CONTRIBUTORS = { "Creator: Justw8", "Contributor(s): Mythi" }

	do -- Settings Landing Page
		local text = root:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetJustifyH("LEFT")
		text:SetText(L["ABOUT_ADDON"])
		text:SetWidth(640)
		text:SetPoint("TOPLEFT", root.divider, "BOTTOMLEFT", 0, -20)
		text:Show()

		local contributors = root:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		contributors:SetJustifyH("LEFT")
		contributors:SetText(L["ABOUT_CONTRIBUTORS"]:format(table.concat(ACTIVE_CONTRIBUTORS, "\n")))
		contributors:SetWidth(640)
		contributors:SetPoint("BOTTOMLEFT", root, 12, 20)
	end

	do
		local optionsKey = "Enabled"
		local tooltip = L["Enable Tooltip"]
		local setting = Settings.RegisterAddOnSetting(generalOptions, optionsKey, optionsKey, db, type(defaults[optionsKey]), L["Enabled"], defaults[optionsKey])
		Settings.SetOnValueChangedCallback(optionsKey, OnSettingChanged)
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

		local setting = Settings.RegisterAddOnSetting(teleportsOptions, optionsKey, optionsKey, db, type(defaults[optionsKey]), L["Hearthstone Toy"], defaults[optionsKey])
		Settings.CreateDropdown(teleportsOptions, setting, GetOptions, tooltip)
		Settings.SetOnValueChangedCallback(optionsKey, OnSettingChanged)
	end

	do -- ButtonText  Checkbox
		local optionsKey = "Button:Text:Show"
		local buttonText = L["ButtonText Tooltip"]
		local setting = Settings.RegisterAddOnSetting(buttonOptions, optionsKey, optionsKey, db, type(defaults[optionsKey]), L["ButtonText"], defaults[optionsKey])
		Settings.SetOnValueChangedCallback(optionsKey, OnSettingChanged)
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

		local setting = Settings.RegisterProxySetting(buttonOptions, optionsKey, type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

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

		local setting = Settings.RegisterProxySetting(buttonOptions, optionsKey, type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

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

		local setting = Settings.RegisterProxySetting(buttonOptions, optionsKey, type(defaults[optionsKey]), text, defaults[optionsKey], GetValue, SetValue)

		local function Formatter(value)
			return label:format(value)
		end
		options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, Formatter)

		Settings.CreateSlider(buttonOptions, setting, options, tooltip)
	end

	do -- Reverse the mage teleport flyouts
		local optionsKey = "Teleports:Mage:Reverse"
		local tooltip = L["Reverse Mage Flyouts Tooltip"]
		local setting = Settings.RegisterAddOnSetting(generalOptions, optionsKey, optionsKey, db, type(defaults[optionsKey]), L["Reverse Mage Flyouts"], defaults[optionsKey])
		Settings.SetOnValueChangedCallback(optionsKey, OnSettingChanged)
		Settings.CreateCheckbox(generalOptions, setting, tooltip)
	end

	do -- Seasonal Teleports Only
		local optionsKey = "Teleports:Seasonal:Only"
		local tooltip = L["Seasonal Teleports Toggle Tooltip"]
		local setting =
			Settings.RegisterAddOnSetting(generalOptions, optionsKey, optionsKey, db, type(defaults[optionsKey]), L["Seasonal Teleports"], defaults[optionsKey])
		Settings.SetOnValueChangedCallback(optionsKey, OnSettingChanged)
		Settings.CreateCheckbox(generalOptions, setting, tooltip)
	end

	do
		local loader = CreateFrame("Frame", nil, teleportFiltersFrame, "SpinnerTemplate")
		loader:SetWidth(100)
		loader:SetHeight(100)
		loader:SetPoint("CENTER")
		loader.text = loader:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge4")
		loader.text:SetText(string.upper(L["Common:Loading"]))
		loader.text:SetPoint("BOTTOM", loader, "TOP", 0, 10)

		local container = CreateFrame("Frame", nil, teleportFiltersFrame)
		container:SetPoint("TOPLEFT", teleportFiltersFrame.divider, "BOTTOMLEFT", 0, -4)
		container:SetPoint("BOTTOMRIGHT", teleportFiltersFrame, nil, -4, 0)
		container:Hide()

		tpm:SourceItemTeleportScrollBoxes(function()
			loader:Hide()
			container:Show()
		end)

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

		local function InitializeScrollBoxElement(frame, elementData)
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
				frame.ItemIcon:SetText("|T" .. elementData.icon .. ":13:13|t ")
			else
				frame.ItemIcon:SetText("")
			end

			frame:SetPushedTextOffset(0, 0)
			frame:SetHighlightAtlas("search-highlight")
			frame:SetNormalFontObject(GameFontHighlight)
			frame.fullName = elementData.name
			frame:SetText(frame.fullName)

			frame:GetFontString():SetTextColor(1, 1, 1, 1)
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
		end

		local function CreateScrollBox(parent, items_key, title)
			local ScrollBoxContainer = CreateFrame("Frame", nil, parent)

			local ScrollBoxTitle = ScrollBoxContainer:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
			ScrollBoxTitle:SetPoint("TOPLEFT", ScrollBoxContainer, 2, -8)
			ScrollBoxTitle:SetText(title)

			local ScrollBar = CreateFrame("EventFrame", nil, ScrollBoxContainer, "MinimalScrollBar")
			ScrollBar:SetPoint("TOPRIGHT", ScrollBoxContainer, -10, -12)
			ScrollBar:SetPoint("BOTTOMRIGHT", ScrollBoxContainer, -10, 5)

			local ScrollBox = CreateFrame("Frame", nil, ScrollBoxContainer, "WowScrollBoxList")
			ScrollBox:SetPoint("TOPLEFT", ScrollBoxTitle, "BOTTOMLEFT", -8, -4)
			ScrollBox:SetPoint("BOTTOMRIGHT", ScrollBar, "BOTTOMRIGHT", -3, 0)

			local view = CreateScrollBoxListLinearView()
			view:SetElementExtent(20)
			view:SetElementInitializer("Button", InitializeScrollBoxElement)
			ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, view)

			ScrollBoxContainer:SetScript("OnShow", function()
				ScrollBox:SetDataProvider(CreateDataProvider(tpm.player[items_key]))
			end)

			tpm.settings.scroll_box_views[items_key] = view

			return ScrollBoxContainer
		end

		local HeldItemsScrollBoxContainer = CreateScrollBox(container, "items_in_possession", L["Teleports:Items:Filters:Held_Items"])
		HeldItemsScrollBoxContainer:SetPoint("TOPLEFT", container)
		HeldItemsScrollBoxContainer:SetPoint("BOTTOMRIGHT", container, "BOTTOM")

		local ItemsToBeObtainedScrollBoxContainer = CreateScrollBox(container, "items_to_be_obtained", L["Teleports:Items:Filters:Items_To_Be_Obtained"])
		ItemsToBeObtainedScrollBoxContainer:SetPoint("TOPLEFT", HeldItemsScrollBoxContainer, "TOPRIGHT")
		ItemsToBeObtainedScrollBoxContainer:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT")
	end


	Settings.RegisterAddOnCategory(rootCategory)
	Settings.RegisterAddOnCategory(generalOptions)
	Settings.RegisterAddOnCategory(buttonOptions)
	Settings.RegisterAddOnCategory(teleportsOptions)
	Settings.RegisterAddOnCategory(teleportFilters)
end
