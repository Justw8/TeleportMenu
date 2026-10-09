local _, tpm = ...
local Flyout = {}
tpm.Flyout = Flyout

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")
local MSQ = LibStub("Masque", true)
local MasqueGroup = MSQ and MSQ:Group(L["ADDON_NAME"])

--------------------------------------
-- Locales
--------------------------------------

local IsSpellKnown = C_SpellBook.IsSpellKnown

local flyOutButtons = {}
local flyOutButtonsPool = {}
local flyOutFrames = {}
local flyOutFramesPool = {}

--------------------------------------
-- Frames
--------------------------------------

local function CloseAllFlyouts()
	for _, frame in ipairs(flyOutFrames) do
		frame:Hide()
	end
end

local function createFlyOutButton(flyOutFrame, flyoutData, tooltipData, side) -- Flyout Data needs: id, name, iconId
	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local flyOutButton
	if next(flyOutButtonsPool) then
		flyOutButton = table.remove(flyOutButtonsPool)
	else
		flyOutButton = CreateFrame("Button", nil, side == "LEFT" and TeleportMeButtonsFrameLeft or TeleportMeButtonsFrameRight, "SecureActionButtonTemplate")


		function flyOutButton:SetFlyOutFrame(frame)
			self.flyoutFrame = frame
		end

		function flyOutButton:Recycle()
			self:ClearAllPoints()
			self:SetFlyOutFrame(nil)
			self:Hide()
			table.insert(flyOutButtonsPool, self)

			if MasqueGroup then
				MasqueGroup:RemoveButton(self)
			end
		end

		-- Text
		flyOutButton.text = flyOutButton:CreateFontString(nil, "OVERLAY")
		flyOutButton.text:SetPoint("BOTTOM", flyOutButton, "BOTTOM", 0, 5)
		flyOutButton.text:SetTextColor(1, 1, 1, 1)

		-- Icon
		flyOutButton.icon = flyOutButton:CreateTexture(nil, "BACKGROUND")
		flyOutButton.icon:SetAllPoints()

		-- Frame Levels
		flyOutButton:SetFrameStrata("HIGH")
		flyOutButton:SetFrameLevel(101)

		-- Mouse Interaction
		flyOutButton:EnableMouse(true)
		flyOutButton:RegisterForClicks("AnyDown", "AnyUp")
		flyOutButton:SetAttribute("useOnKeyDown", true)

		table.insert(flyOutButtons, flyOutButton)
	end

	flyOutButton:SetFlyOutFrame(flyOutFrame)

	-- Tooltips
	local tooltipType = "flyout"
	local tooltipId = flyoutData.id
	if tooltipData then
		tooltipType = tooltipData.type
		tooltipId = tooltipData.id
	end
	flyOutButton:SetScript("OnEnter", function(self)
		if InCombatLockdown() then
			tpm.Tooltip:SetCombat(self)
			return
		end
		CloseAllFlyouts()
		tpm.Tooltip:Set(self, tooltipType, tooltipId)
		self.flyoutFrame:Show()
	end)
	flyOutButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-- Text
	flyOutButton.text:Hide()
	if db["Button:Text:Show"] == true and flyoutData.name then
		flyOutButton.text:SetFont(STANDARD_TEXT_FONT, db["Button:Text:Size"], "OUTLINE")
		flyOutButton.text:SetText(flyoutData.name)
		flyOutButton.text:Show()
	end

	-- Texture
	flyOutButton.icon:SetTexture(flyoutData.iconId)
	local zoomFactor = tpm.TEXTURE_SCALE
	local offset = zoomFactor / 2
	flyOutButton.icon:SetTexCoord(offset, 1-offset, offset, 1-offset)

	-- Size
	flyOutButton:SetSize(globalWidth, globalHeight)
	flyOutButton:Show()

	if MasqueGroup then
		MasqueGroup:AddButton(flyOutButton, { Icon = flyOutButton.icon })
	end

	return flyOutButton
end

local function createFlyOutFrame(side)
	local flyOutFrame
	if next(flyOutFramesPool) then
		flyOutFrame = table.remove(flyOutFramesPool)
	else
		flyOutFrame = CreateFrame("Frame", "FlyOutFrame" .. #flyOutFrames + 1)

		function flyOutFrame:Recycle()
			self:ClearAllPoints()
			self:Hide()
			table.insert(flyOutFramesPool, self)
		end

		flyOutFrame:SetFrameStrata("HIGH")
		flyOutFrame:SetFrameLevel(103)
		flyOutFrame:SetPropagateMouseClicks(true)
		flyOutFrame:SetPropagateMouseMotion(true)
		flyOutFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			if not InCombatLockdown() then -- XXX Needed?
				self:Hide()
			end
		end)

		table.insert(flyOutFrames, flyOutFrame)
	end

	flyOutFrame:SetParent(side == "LEFT" and TeleportMeButtonsFrameLeft or TeleportMeButtonsFrameRight)
	flyOutFrame:Hide()

	return flyOutFrame
end

--------------------------------------
-- Functions
--------------------------------------

-- Spell flyouts from the game (mage teleports/portals, Hero's Path)
function Flyout:Create(flyoutData, side)
	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local ButtonFrame = side == "LEFT" and TeleportMeButtonsFrameLeft or TeleportMeButtonsFrameRight
	if db["Teleports:Seasonal:Only"] and (flyoutData.subtype == "path" and not flyoutData.currentExpansion) then
		return
	end
	local _, _, spells, flyoutKnown = GetFlyoutInfo(flyoutData.id)
	if not flyoutKnown then
		return
	end

	local yOffset = -globalHeight * ButtonFrame:GetButtonAmount()
	local flyOutFrame = createFlyOutFrame(side)
	flyOutFrame:SetPoint(side == "LEFT" and "RIGHT" or "LEFT", ButtonFrame, side == "LEFT" and "TOPLEFT" or "TOPRIGHT", side == "LEFT" and globalWidth or 0, yOffset)

	-- Flyout Main Button
	local button = createFlyOutButton(flyOutFrame, flyoutData, nil, side)
	button:SetPoint("LEFT", ButtonFrame, "TOPRIGHT", 0, yOffset)

	local childButtons = {}
	local flyoutsCreated = 0
	local rowNr = 1
	local inverse = db["Teleports:Mage:Reverse"] and flyoutData.subtype == "mage"
	local start, endLoop, step = 1, spells, 1
	if inverse then -- Inverse loop params
		start, endLoop, step = spells, 1, -1
	end
	for i = start, endLoop, step do
		local spellId = select(1, GetFlyoutSlotInfo(flyoutData.id, i))
		if IsSpellKnown(spellId) then
			if flyoutsCreated == db["Flyout:Max_Per_Row"] then
				flyoutsCreated = 0
				rowNr = rowNr + 1
			end
			flyoutsCreated = flyoutsCreated + 1
			local flyOutButton = tpm.SecureButton:Create(flyOutFrame, "spell", tpm:GetShortName(spellId), spellId)
			local offsetY = (rowNr - 1) * - globalHeight
			local offsetX = globalWidth * flyoutsCreated
			if side == "LEFT" then
				offsetX = -globalWidth * flyoutsCreated
			end
			flyOutButton:SetPoint(side == "LEFT" and "TOPRIGHT" or "TOPLEFT", flyOutFrame, side == "LEFT" and "TOPRIGHT" or "TOPLEFT", offsetX, offsetY)
			table.insert(childButtons, flyOutButton)
		end
	end

	local frameWidth = rowNr > 1 and globalWidth * (db["Flyout:Max_Per_Row"] + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)
	button.childButtons = childButtons
	return button
end

function Flyout:CreateSeasonal()
	local availableSeasonalTeleports = tpm.AvailableSeasonalTeleports
	if #availableSeasonalTeleports == 0 then
		return
	end

	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local tooltipData = { type = "seasonalteleport" }
	local seasonalFlyOutData = { id = -1, name = L["Season " .. tpm.settings.current_season], iconId = 5927657 }
	local yOffset = -globalHeight * TeleportMeButtonsFrameRight:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrameRight, "TOPRIGHT", 0, yOffset)

	local button = createFlyOutButton(flyOutFrame, seasonalFlyOutData, tooltipData, "RIGHT")
	button:SetPoint("LEFT", TeleportMeButtonsFrameRight, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	local rowNr = 1
	for _, spellId in ipairs(availableSeasonalTeleports) do
		if IsSpellKnown(spellId) then
			if flyoutsCreated == db["Flyout:Max_Per_Row"] then
				flyoutsCreated = 0
				rowNr = rowNr + 1
			end
			flyoutsCreated = flyoutsCreated + 1
			local text = tpm:GetIconText(spellId)
			local flyOutButton = tpm.SecureButton:Create(flyOutFrame, "spell", text, spellId)
			flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", globalWidth * flyoutsCreated, (rowNr - 1) * - globalHeight)
		end
	end
	local frameWidth = rowNr > 1 and globalWidth * (db["Flyout:Max_Per_Row"] + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)

	return button
end

function Flyout:CreateWormholes(flyoutData)
	local usableWormholes = tpm.AvailableWormholes:GetUsable()
	if #usableWormholes == 0 then
		return
	end

	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local yOffset = -globalHeight * TeleportMeButtonsFrameLeft:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame("LEFT")
	flyOutFrame:SetPoint("RIGHT", TeleportMeButtonsFrameLeft, "TOPLEFT", globalWidth, yOffset)

	local button = createFlyOutButton(flyOutFrame, flyoutData, { type = "profession", id = 202 }, "LEFT")
	button:SetPoint("LEFT", TeleportMeButtonsFrameLeft, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	local rowNr = 1
	for _, wormholeId in ipairs(usableWormholes) do
		if flyoutsCreated == db["Flyout:Max_Per_Row"] then
			flyoutsCreated = 0
			rowNr = rowNr + 1
		end
		flyoutsCreated = flyoutsCreated + 1
		local flyOutButton = tpm.SecureButton:Create(flyOutFrame, "toy", nil, wormholeId)
		flyOutButton:SetPoint("TOPRIGHT", flyOutFrame, "TOPRIGHT", -globalWidth * flyoutsCreated, (rowNr - 1) * - globalHeight)
	end
	local frameWidth = rowNr > 1 and globalWidth * (db["Flyout:Max_Per_Row"] + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)

	return button
end

function Flyout:CreateItemTeleports(flyoutData)
	if #tpm.AvailableItemTeleports == 0 then
		return
	end

	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local yOffset = -globalHeight * TeleportMeButtonsFrameLeft:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame("LEFT")
	flyOutFrame:SetPoint("RIGHT", TeleportMeButtonsFrameLeft, "TOPLEFT", globalWidth, yOffset)

	local button = createFlyOutButton(flyOutFrame, flyoutData, { type = "item_teleports" }, "LEFT")
	button:SetPoint("LEFT", TeleportMeButtonsFrameLeft, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	local rowNr = 1
	for _, itemTeleportId in ipairs(tpm.AvailableItemTeleports) do
		if flyoutsCreated == db["Flyout:Max_Per_Row"] then
			flyoutsCreated = 0
			rowNr = rowNr + 1
		end
		flyoutsCreated = flyoutsCreated + 1
		local isToy = tpm:IsToyTeleport(itemTeleportId)
		local flyOutButton = tpm.SecureButton:Create(flyOutFrame, isToy and "toy" or "item", nil, itemTeleportId)
		flyOutButton:SetPoint("TOPRIGHT", flyOutFrame, "TOPRIGHT", -globalWidth * flyoutsCreated, (rowNr - 1) * - globalHeight)
	end

	local frameWidth = rowNr > 1 and globalWidth * (db["Flyout:Max_Per_Row"] + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)

	return button
end

function Flyout:RecycleAll()
	for _, button in ipairs(flyOutButtons) do
		button:Recycle()
	end
	for _, frame in ipairs(flyOutFrames) do
		frame:Recycle()
	end
end
