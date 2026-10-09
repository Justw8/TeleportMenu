local ADDON_NAME, tpm = ...

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

-------------------------------------
-- Locales
--------------------------------------

function tpm:GetSettingsDB()
	TeleportMenuDB = TeleportMenuDB or {}
	TeleportMenuCharDB = TeleportMenuCharDB or {}
	if TeleportMenuCharDB.useCharacterSettings and TeleportMenuCharDB.settings then
		return TeleportMenuCharDB.settings
	end
	return TeleportMenuDB
end

local options = setmetatable({}, {
	__index = function(_, key)
		local value = tpm:GetSettingsDB()[key]
		if value == nil then
			return tpm.SettingsBase[key]
		end
		return value
	end,
	__newindex = function(_, key, value)
		tpm:GetSettingsDB()[key] = value
	end,
})

function tpm:GetOptions()
	return options
end

function tpm:IsUsingCharacterSettings()
	return TeleportMenuCharDB and TeleportMenuCharDB.useCharacterSettings == true
end

-- The first time a character switches to its own settings, they start as a copy of the
-- account settings. After that the character keeps its own, even when switching back and forth.
function tpm:SetUsingCharacterSettings(enabled)
	TeleportMenuCharDB = TeleportMenuCharDB or {}
	if enabled and not TeleportMenuCharDB.settings then
		TeleportMenuCharDB.settings = CopyTable(TeleportMenuDB or {})
	end
	TeleportMenuCharDB.useCharacterSettings = enabled
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

--------------------------------------
-- Pages
--------------------------------------

-- All our pages are canvas pages with our own controls instead of Blizzard's vertical
-- layout. That avoids Blizzard's Defaults button, whose "All Settings" option would also
-- reset our settings. Each page gets its own Defaults button that only resets that page.

local ROW_HEIGHT = 34
local CONTROL_OFFSET = 220 -- Distance from the row label to its control

StaticPopupDialogs["TELEPORTMENU_RESET_PAGE"] = {
	text = L["Reset Page Confirm"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(_, onReset)
		onReset()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
}

local function ShowTooltip(owner, title, text)
	GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
	GameTooltip:SetText(title, 1, 1, 1)
	if text then
		GameTooltip:AddLine(text, nil, nil, nil, true)
	end
	GameTooltip:Show()
end

local function HideTooltip()
	GameTooltip:Hide()
end

-- A custom settings page with a title and divider, like the Blizzard ones
local function CreateCanvasPage(name, title)
	local frame = CreateFrame("Frame", name, InterfaceOptionsFramePanelContainer)
	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
	frame.title:SetPoint("TOPLEFT", 7, -22)
	frame.title:SetText(title)
	frame.divider = frame:CreateTexture(nil, "ARTWORK")
	frame.divider:SetAtlas("Options_HorizontalDivider", true)
	frame.divider:SetPoint("TOP", 0, -50)

	frame.rowCount = 0
	frame.refreshers = {}

	-- Updates every control on the page to the current setting values
	function frame:Refresh()
		for _, refresh in ipairs(self.refreshers) do
			refresh()
		end
	end

	function frame:AddRefresher(refresh)
		table.insert(self.refreshers, refresh)
	end

	-- Start hidden: the Settings panel shows the page when it's opened, so OnShow fires
	-- every time. Without this the page counts as shown from creation (its parent doesn't
	-- exist anymore) and OnShow never fires.
	frame:Hide()
	frame:SetScript("OnShow", frame.Refresh)

	-- onReset resets this page's settings; the page is refreshed afterwards
	function frame:AddDefaultsButton(onReset)
		local button = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
		button:SetSize(110, 22)
		button:SetPoint("TOPRIGHT", self, "TOPRIGHT", -10, -18)
		button:SetText(DEFAULTS)
		button:SetScript("OnClick", function()
			StaticPopup_Show("TELEPORTMENU_RESET_PAGE", title, nil, function()
				onReset()
				self:Refresh()
				tpm:RefreshAvailableTeleports()
			end)
		end)
	end

	-- A row with a label on the left; the control goes CONTROL_OFFSET to the right of it
	function frame:AddRow(text, tooltip)
		local row = CreateFrame("Frame", nil, self)
		row:SetPoint("TOPLEFT", self.divider, "BOTTOMLEFT", 0, -10 - self.rowCount * ROW_HEIGHT)
		row:SetPoint("RIGHT", self, "RIGHT", -10, 0)
		row:SetHeight(ROW_HEIGHT)
		row:SetScript("OnEnter", function(s)
			ShowTooltip(s, text, tooltip)
		end)
		row:SetScript("OnLeave", HideTooltip)

		row.label = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		row.label:SetPoint("LEFT", 8, 0)
		row.label:SetText(text)

		self.rowCount = self.rowCount + 1
		return row
	end

	function frame:AddToggle(text, tooltip, getValue, setValue)
		local row = self:AddRow(text, tooltip)
		local checkbox = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
		checkbox:SetPoint("LEFT", row.label, "LEFT", CONTROL_OFFSET - 4, 0)
		checkbox:SetScript("OnClick", function(s)
			setValue(s:GetChecked())
		end)
		checkbox:HookScript("OnEnter", function(s)
			ShowTooltip(s, text, tooltip)
		end)
		checkbox:HookScript("OnLeave", HideTooltip)

		self:AddRefresher(function()
			checkbox:SetChecked(getValue() == true)
		end)
	end

	function frame:AddCheckbox(optionsKey, text, tooltip)
		self:AddToggle(text, tooltip, function()
			return options[optionsKey]
		end, function(checked)
			options[optionsKey] = checked
			tpm:ReloadFrames()
		end)
	end

	function frame:AddSlider(optionsKey, text, tooltip, minValue, maxValue, step, formatter)
		local row = self:AddRow(text, tooltip)
		local slider = CreateFrame("Frame", nil, row, "MinimalSliderWithSteppersTemplate")
		slider:SetPoint("LEFT", row.label, "LEFT", CONTROL_OFFSET, 0)
		slider:SetWidth(280)

		local steps = math.floor((maxValue - minValue) / step + 0.5)
		local formatters = { [MinimalSliderWithSteppersMixin.Label.Right] = formatter }
		local refreshing = false

		slider:RegisterCallback(MinimalSliderWithSteppersMixin.Event.OnValueChanged, function(_, value)
			if refreshing then -- Init also fires this; don't save values we only displayed
				return
			end
			options[optionsKey] = value
			tpm:ReloadFrames()
		end, slider)

		self:AddRefresher(function()
			refreshing = true
			slider:Init(options[optionsKey], minValue, maxValue, steps, formatters)
			refreshing = false
		end)
	end

	return frame
end

local rootCategory = Settings.RegisterCanvasLayoutCategory(root, L["ADDON_NAME"])
local generalFrame = CreateCanvasPage("TeleportMenuGeneralPanel", L["GENERAL"])
local generalOptions = Settings.RegisterCanvasLayoutSubcategory(rootCategory, generalFrame, L["GENERAL"])
local buttonFrame = CreateCanvasPage("TeleportMenuButtonPanel", L["BUTTON_SETTINGS"])
local buttonOptions = Settings.RegisterCanvasLayoutSubcategory(rootCategory, buttonFrame, L["BUTTON_SETTINGS"])
local hearthstoneFrame = CreateCanvasPage("TeleportMenuHearthstonePanel", L["HEARTHSTONE_SETTINGS"])
local hearthstoneOptions = Settings.RegisterCanvasLayoutSubcategory(rootCategory, hearthstoneFrame, L["HEARTHSTONE_SETTINGS"])
local teleportFiltersFrame = CreateCanvasPage("TeleportFiltersFramePanel", L["Teleports:Items:Filters"])
local teleportFilters = Settings.RegisterCanvasLayoutSubcategory(rootCategory, teleportFiltersFrame, L["Teleports:Items:Filters"])
function tpm:GetOptionsCategory(category)
	if not category or category == "root" then
		return rootCategory:GetID()
	elseif category == "filters" then
		return teleportFilters:GetID()
	end
end

--------------------------------------
-- Toggle Lists
--------------------------------------

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

local function InitializeToggleRow(frame, elementData, isEnabled, setEnabled)
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
		setEnabled(elementData.id, not isEnabled(elementData.id))
		frame.UpdateVisual()
	end)
	frame:SetScript("OnEnter", function(s)
		GameTooltip:SetOwner(s, "ANCHOR_CURSOR")
		GameTooltip:SetItemByID(elementData.id)
	end)
	frame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	frame.UpdateVisual = function()
		if isEnabled(elementData.id) then
			frame.EnabledIndicator:SetAtlas("common-icon-checkmark-yellow")
		else
			frame.EnabledIndicator:SetAtlas("common-icon-redx")
		end
	end
	frame:UpdateVisual()
end

-- A titled, scrollable list of { id, name, icon } entries that can each be toggled on/off.
-- isEnabled(id) and setEnabled(id, value) read and write the underlying setting.
local function CreateToggleList(parent, title, isEnabled, setEnabled)
	local ScrollBoxContainer = CreateFrame("Frame", nil, parent)

	local ScrollBoxTitle = ScrollBoxContainer:CreateFontString(nil, "ARTWORK", "GameFontHighlightMedium")
	ScrollBoxTitle:SetTextColor(NORMAL_FONT_COLOR:GetRGB()) -- Same yellow as the other option labels
	ScrollBoxTitle:SetPoint("TOPLEFT", ScrollBoxContainer, 2, -8)
	ScrollBoxTitle:SetText(title)

	local ScrollBar = CreateFrame("EventFrame", nil, ScrollBoxContainer, "MinimalScrollBar")
	ScrollBar:SetPoint("TOPRIGHT", ScrollBoxContainer, -10, -12)
	ScrollBar:SetPoint("BOTTOMRIGHT", ScrollBoxContainer, -10, 5)

	local ScrollBox = CreateFrame("Frame", nil, ScrollBoxContainer, "WowScrollBoxList")
	ScrollBox:SetPoint("TOPLEFT", ScrollBoxTitle, "BOTTOMLEFT", -8, -10)
	ScrollBox:SetPoint("BOTTOMRIGHT", ScrollBar, "BOTTOMRIGHT", -3, 0)

	local view = CreateScrollBoxListLinearView()
	view:SetElementExtent(20)
	view:SetElementInitializer("Button", function(frame, elementData)
		InitializeToggleRow(frame, elementData, isEnabled, setEnabled)
	end)
	ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, view)
	ScrollUtil.AddManagedScrollBarVisibilityBehavior(ScrollBox, ScrollBar) -- Only show the scrollbar when the list doesn't fit

	return ScrollBoxContainer, ScrollBox, view
end

function tpm:LoadOptions()
	local db = tpm:GetOptions()
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

	do -- General page
		local keys = { "Enabled", "Teleports:Mage:Reverse", "General:AutoClose", "Teleports:Seasonal:Only" }
		-- Character Settings are not reset by Defaults: it chooses where settings are stored, it isn't a setting itself
		generalFrame:AddToggle(L["Character Settings"], L["Character Settings Tooltip"], function()
			return tpm:IsUsingCharacterSettings()
		end, function(checked)
			tpm:SetUsingCharacterSettings(checked)
			generalFrame:Refresh() -- Other pages refresh when opened
			tpm:RefreshAvailableTeleports()
		end)
		generalFrame:AddCheckbox("Enabled", L["Enabled"], L["Enable Tooltip"])
		generalFrame:AddCheckbox("Teleports:Mage:Reverse", L["Reverse Mage Flyouts"], L["Reverse Mage Flyouts Tooltip"])
		generalFrame:AddCheckbox("General:AutoClose", L["Auto Close"], L["Auto Close Tooltip"])
		generalFrame:AddCheckbox("Teleports:Seasonal:Only", L["Seasonal Teleports"], L["Seasonal Teleports Toggle Tooltip"])
		generalFrame:AddDefaultsButton(function()
			for _, key in ipairs(keys) do
				options[key] = nil
			end
		end)
		generalFrame:Refresh()
	end

	do -- Button page
		local keys = { "Button:Text:Show", "Button:Text:Size", "Button:Size", "Flyout:Max_Per_Row", "Button:Texture:Zoom" }
		local function Pixels(value)
			return L["%s px"]:format(value)
		end

		buttonFrame:AddCheckbox("Button:Text:Show", L["ButtonText"], L["ButtonText Tooltip"])
		buttonFrame:AddSlider("Button:Text:Size", L["BUTTON_FONT_SIZE"], L["BUTTON_FONT_SIZE_TOOLTIP"], 6, 40, 1, Pixels)
		buttonFrame:AddSlider("Button:Size", L["Icon Size"], L["Icon Size Tooltip"], 10, 75, 1, Pixels)
		buttonFrame:AddSlider("Flyout:Max_Per_Row", L["Icons Per Flyout Row"], L["Icons Per Flyout Row Tooltip"], 1, 20, 1, function(value)
			return L["%s icons"]:format(value)
		end)
		buttonFrame:AddSlider("Button:Texture:Zoom", L["Icon Texture Zoom"], L["Icon Texture Zoom Tooltip"], 0, 0.3, 0.01, function(value)
			return ("%d%%"):format(value * 100)
		end)
		buttonFrame:AddDefaultsButton(function()
			for _, key in ipairs(keys) do
				options[key] = nil
			end
		end)
		buttonFrame:Refresh()
	end

	do -- Hearthstone page: toy dropdown, plus the random pool list when Random is selected
		local optionsKey = "Teleports:Hearthstone"

		-- Owned hearthstone toys as { id, name, icon }, sorted by name
		local function GetSortedHearthstones()
			local hearthstones = {}
			for id, hearthstoneInfo in pairs(tpm:GetAvailableHearthstoneToys()) do
				table.insert(hearthstones, { id = id, name = hearthstoneInfo.name, icon = hearthstoneInfo.texture })
			end
			table.sort(hearthstones, function(a, b)
				return a.name < b.name
			end)
			return hearthstones
		end

		local row = hearthstoneFrame:AddRow(L["Hearthstone Toy"], L["Hearthstone Toy Tooltip"])
		local dropdown = CreateFrame("DropdownButton", nil, row, "WowStyle1DropdownTemplate")
		dropdown:SetPoint("LEFT", row.label, "LEFT", CONTROL_OFFSET, 0)
		dropdown:SetWidth(280)
		dropdown:HookScript("OnEnter", function(s)
			ShowTooltip(s, L["Hearthstone Toy"], L["Hearthstone Toy Tooltip"])
		end)
		dropdown:HookScript("OnLeave", HideTooltip)

		local poolContainer, poolScrollBox = CreateToggleList(hearthstoneFrame, L["Teleports:Hearthstone:Random:Pool"], function(id)
			return tpm:IsHearthstoneInRandomPool(id)
		end, function(id, value)
			tpm:SetHearthstoneInRandomPool(id, value)
			tpm:ReloadFrames()
		end)
		poolContainer:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 0, -6)
		poolContainer:SetPoint("BOTTOMRIGHT", hearthstoneFrame, "BOTTOMRIGHT", -4, 0)

		local function Refresh()
			dropdown:GenerateMenu() -- Updates the selected text
			poolContainer:SetShown(db[optionsKey] == "rng")
			poolScrollBox:SetDataProvider(CreateDataProvider(GetSortedHearthstones()), ScrollBoxConstants.RetainScrollPosition)
		end

		local function IsSelected(value)
			return tostring(db[optionsKey]) == value
		end

		local function SetSelected(value)
			options[optionsKey] = value
			tpm:ReloadFrames()
			Refresh()
		end

		local function IconText(texture, text)
			return "|T" .. texture .. ":16:16:0:0:64:64:4:60:4:60|t " .. text
		end

		dropdown:SetupMenu(function(_, rootDescription)
			rootDescription:SetScrollMode(400)
			rootDescription:CreateRadio(L["None"], IsSelected, SetSelected, "none")
			rootDescription:CreateRadio(L["Disabled"], IsSelected, SetSelected, "disabled")
			rootDescription:CreateRadio(IconText(1669494, L["Random"]), IsSelected, SetSelected, "rng")
			for _, hearthstone in ipairs(GetSortedHearthstones()) do
				rootDescription:CreateRadio(IconText(hearthstone.icon, hearthstone.name), IsSelected, SetSelected, tostring(hearthstone.id))
			end
		end)

		-- Owned hearthstones can change after login (TOYS_UPDATED), see RefreshAvailableTeleports
		function tpm:RefreshHearthstoneOptions()
			Refresh()
		end
		hearthstoneFrame:AddRefresher(Refresh)
		hearthstoneFrame:AddDefaultsButton(function()
			options[optionsKey] = nil
			tpm:ResetRandomHearthstonePool()
		end)
		hearthstoneFrame:Refresh()
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

		local function IsItemEnabled(id)
			return db[id] == true
		end

		local function SetItemEnabled(id, value)
			options[id] = value
			tpm:RefreshAvailableTeleports()
		end

		local function CreateScrollBox(parent, items_key, title)
			local ScrollBoxContainer, ScrollBox, view = CreateToggleList(parent, title, IsItemEnabled, SetItemEnabled)

			ScrollBoxContainer:SetScript("OnShow", function()
				ScrollBox:SetDataProvider(CreateDataProvider(tpm.player[items_key]))
			end)

			tpm.settings.scroll_box_views[items_key] = view

			ScrollBox:SetDataProvider(CreateDataProvider(tpm.player[items_key]))
			return ScrollBoxContainer
		end

		local HeldItemsScrollBoxContainer = CreateScrollBox(container, "items_in_possession", L["Teleports:Items:Filters:Held_Items"])
		HeldItemsScrollBoxContainer:SetPoint("TOPLEFT", container)
		HeldItemsScrollBoxContainer:SetPoint("BOTTOMRIGHT", container, "BOTTOM")

		local ItemsToBeObtainedScrollBoxContainer = CreateScrollBox(container, "items_to_be_obtained", L["Teleports:Items:Filters:Items_To_Be_Obtained"])
		ItemsToBeObtainedScrollBoxContainer:SetPoint("TOPLEFT", HeldItemsScrollBoxContainer, "TOPRIGHT")
		ItemsToBeObtainedScrollBoxContainer:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT")

		teleportFiltersFrame:AddRefresher(function()
			for items_key, view in pairs(tpm.settings.scroll_box_views) do
				view:SetDataProvider(CreateDataProvider(tpm.player[items_key]), ScrollBoxConstants.RetainScrollPosition)
			end
		end)
		teleportFiltersFrame:AddDefaultsButton(function()
			for id in pairs(tpm.ItemTeleports) do
				options[id] = nil
			end
		end)
	end


	Settings.RegisterAddOnCategory(rootCategory)
	Settings.RegisterAddOnCategory(generalOptions)
	Settings.RegisterAddOnCategory(buttonOptions)
	Settings.RegisterAddOnCategory(hearthstoneOptions)
	Settings.RegisterAddOnCategory(teleportFilters)
end
