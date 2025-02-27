local _, tpm = ...

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

--------------------------------------
-- Locales
--------------------------------------

local db = {}
local APPEND = L["AddonNamePrint"]
local DEFAULT_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local globalWidth, globalHeight = 40, 40 -- defaults

--------------------------------------
-- Teleport Tables
--------------------------------------

local availableSeasonalTeleports = {}

local shortNames = {
	-- CATA
	[410080] = L["The Vortex Pinnacle"],
	[424142] = L["Throne of the Tides"],
	[445424] = L["Grim Batol"],
	-- MoP
	[131204] = L["Temple of the Jade Serpentl"],
	[131205] = L["Stormstout Brewery"],
	[131206] = L["Shado-Pan Monastery"],
	[131222] = L["Mogu'shan Palace"],
	[131225] = L["Gate of the Setting Sun"],
	[131228] = L["Siege of Niuzao Temple"],
	[131229] = L["Scarlet Monastery"],
	[131231] = L["Scarlet Halls"],
	[131232] = L["Scholomance"],
	-- WoD
	[159901] = L["The Everblooml"],
	[159899] = L["Shadowmoon Burial Grounds"],
	[159900] = L["Grimrail Depot"],
	[159896] = L["Iron Docks"],
	[159895] = L["Bloodmaul Slag Mines"],
	[159897] = L["Auchindoun"],
	[159898] = L["Skyreach"],
	[159902] = L["Upper Blackrock Spire"],
	-- Legion
	[393764] = L["Halls of Valor"],
	[410078] = L["Neltharion's Lair"],
	[393766] = L["Court of Stars"],
	[373262] = L["Karazhan"],
	[424153] = L["Black Rook Hold"],
	[424163] = L["Darkheart Thicket"],
	-- BFA
	[410071] = L["Freehold"],
	[410074] = L["The Underrot"],
	[373274] = L["Mechagon"],
	[424167] = L["Waycrest Manor"],
	[424187] = L["Atal'Dazar"],
	[445418] = L["Siege of Boralus"],
	[464256] = L["Siege of Boralus"],
	[467553] = L["The MOTHERLODE!!"],
	[467555] = L["The MOTHERLODE!!"],
	-- SL
	[354462] = L["The Necrotic Wake"],
	[354463] = L["Plaguefall"],
	[354464] = L["Mists of Tirna Scithe"],
	[354465] = L["Halls of Atonement"],
	[354466] = L["Bastion"],
	[354467] = L["Theater of Pain"],
	[354468] = L["De Other Side"],
	[354469] = L["Sanguine Depths"],
	[367416] = L["Tazavesh, the Veiled Market"],
	-- SL R
	[373190] = L["Castle Nathria"],
	[373191] = L["Sanctum of Domination"],
	[373192] = L["Sepulcher of the First Ones"],
	-- DF
	[393256] = L["Ruby Life Pools"],
	[393262] = L["The Nokhud Offensive"],
	[393267] = L["Brackenhide Hollow"],
	[393273] = L["Algeth'ar Academy"],
	[393276] = L["Neltharus"],
	[393279] = L["The Azure Vault"],
	[393283] = L["Halls of Infusion"],
	[393222] = L["Uldaman"],
	[424197] = L["Dawn of the Infinite"],
	-- DF R
	[432254] = L["Vault of the Incarnates"],
	[432257] = L["Aberrus, the Shadowed Crucible"],
	[432258] = L["Amirdrassil, the Dream's Hope"],
	-- TWW
	[445416] = L["City of Threads"],
	[445414] = L["The Dawnbreaker"],
	[445269] = L["The Stonevault"],
	[445443] = L["The Rookery"],
	[445440] = L["Cinderbrew Meadery"],
	[445444] = L["Priory of the Sacred Flame"],
	[445417] = L["Ara-Kara, City of Echoes"],
	[445441] = L["Darkflame Cleft"],
	[1216786] = L["Operation: Floodgate"],
	-- Mage teleports
	[3561] = L["Stormwind"],
	[3562] = L["Ironforge"],
	[3563] = L["Undercity"],
	[3565] = L["Darnassus"],
	[3566] = L["Thunder Bluff"],
	[3567] = L["Orgrimmar"],
	[32271] = L["Exodar"],
	[32272] = L["Silvermoon"],
	[33690] = L["Shattrath"],
	[35715] = L["Shattrath"],
	[49358] = L["Stonard"],
	[49359] = L["Theramore"],
	[53140] = L["Dalaran - Northrend"],
	[88342] = L["Tol Barad"], -- Alliance
	[88344] = L["Tol Barad"], -- Horde
	[120145] = L["Dalaran - Ancient"],
	[132621] = L["Vale of Eternal Blossoms"], -- Alliance
	[132627] = L["Vale of Eternal Blossoms"], -- Horde
	[176242] = L["Warspear"],
	[176248] = L["Stormshield"],
	[193759] = L["Hall of the Guardian"],
	[224869] = L["Dalaran - Broken Isles"],
	[281403] = L["Boralus"],
	[281404] = L["Dazar'alor"],
	[344587] = L["Oribos"],
	[395277] = L["Valdrakken"],
	[446540] = L["Dornogal"],
	-- Mage portals
	[10059] = L["Stormwind"],
	[11416] = L["Ironforge"],
	[11417] = L["Orgrimmar"],
	[11418] = L["Undercity"],
	[11419] = L["Darnassus"],
	[11420] = L["Thunder Bluff"],
	[32266] = L["Exodar"],
	[32267] = L["Silvermoon"],
	[33691] = L["Shattrath"],
	[35717] = L["Shattrath"],
	[49360] = L["Theramore"],
	[49361] = L["Stonard"],
	[53142] = L["Dalaran - Northrend"],
	[88345] = L["Tol Barad"], -- Alliance
	[88346] = L["Tol Barad"], -- Horde
	[120146] = L["Dalaran - Ancient"],
	[132620] = L["Vale of Eternal Blossoms"], -- Alliance
	[132626] = L["Vale of Eternal Blossoms"], -- Horde
	[176244] = L["Warspear"],
	[176246] = L["Stormshield"],
	[224871] = L["Dalaran - Broken Isles"],
	[281400] = L["Boralus"],
	[281402] = L["Dazar'alor"],
	[344597] = L["Oribos"],
	[395289] = L["Valdrakken"],
	[446534] = L["Dornogal"],
}

local tpTable = {
	-- Hearthstones
	{ id = 6948, type = "item", hearthstone = true }, -- Hearthstone
	{ id = 556, type = "spell" }, -- Astral Recall (Shaman)
	{ id = 110560, type = "toy", quest = { 34378, 34586 } }, -- Garrison Hearthstone
	{ id = 140192, type = "toy", quest = { 44184, 44663 } }, -- Dalaran Hearthstone
	-- Engineering
	{ type = "wormholes", iconId = 4620673 }, -- Engineering Wormholes
	{ type = "item_teleports", iconId = 133655 }, -- Item Teleports
	-- Class Teleports
	{ id = 1, type = "flyout", iconId = 237509, subtype = "mage" }, -- Teleport (Mage) (Horde)
	{ id = 8, type = "flyout", iconId = 237509, subtype = "mage" }, -- Teleport (Mage) (Alliance)
	{ id = 11, type = "flyout", iconId = 135744, subtype = "mage" }, -- Portals (Mage) (Horde)
	{ id = 12, type = "flyout", iconId = 135748, subtype = "mage" }, -- Portals (Mage) (Alliance)
	{ id = 126892, type = "spell" }, -- Zen Pilgrimage (Monk)
	{ id = 50977, type = "spell" }, -- Death Gate (Death Knight)
	{ id = 18960, type = "spell" }, -- Teleport: Moonglade (Druid)
	{ id = 193753, type = "spell" }, -- Dreamwalk (Druid) (replaces Teleport: Moonglade)
	-- Racials
	{ id = 312370, type = "spell" }, -- Make Camp (Vulpera)
	{ id = 312372, type = "spell" }, -- Return to Camp (Vulpera)

	-- Dungeon/Raid Teleports
	{ id = 230, type = "flyout", iconId = 574788, name = L["Cataclysm"], subtype = "path" }, -- Hero's Path: Cataclysm
	{ id = 84, type = "flyout", iconId = 328269, name = L["Mists of Pandaria"], subtype = "path" }, -- Hero's Path: Mists of Pandaria
	{ id = 96, type = "flyout", iconId = 1413856, name = L["Warlords of Draenor"], subtype = "path" }, -- Hero's Path: Warlords of Draenor
	{ id = 224, type = "flyout", iconId = 1260827, name = L["Legion"], subtype = "path" }, -- Hero's Path: Legion
	{ id = 223, type = "flyout", iconId = 1869493, name = L["Battle for Azeroth"], subtype = "path" }, -- Hero's Path: Battle for Azeroth
	{ id = 220, type = "flyout", iconId = 236798, name = L["Shadowlands"], subtype = "path" }, -- Hero's Path: Shadowlands
	{ id = 222, type = "flyout", iconId = 4062765, name = L["Shadowlands Raids"], subtype = "path" }, -- Hero's Path: Shadowlands Raids
	{ id = 227, type = "flyout", iconId = 4640496, name = L["Dragonflight"], subtype = "path" }, -- Hero's Path: Dragonflight
	{ id = 231, type = "flyout", iconId = 5342925, name = L["Dragonflight Raids"], subtype = "path" }, -- Hero's Path: Dragonflight Raids
	{ id = 232, type = "flyout", iconId = 5872031, name = L["The War Within"], subtype = "path" }, -- Hero's Path: The War Within
}

local GetItemCount = C_Item.GetItemCount

--------------------------------------
-- Texture Stuff
--------------------------------------

local function SetTextureByItemId(frame, itemId)
	frame:SetNormalTexture(DEFAULT_ICON) -- Temp while loading
	local item = Item:CreateFromItemID(tonumber(itemId))
	item:ContinueOnItemLoad(function()
		local icon = item:GetItemIcon()
		frame:SetNormalTexture(icon)
	end)
end

local function retrySetNormalTexture(button, itemId, attempt)
	local attempts = attempt or 1
	local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemId)
	if itemTexture then
		button:SetNormalTexture(itemTexture)
		return
	end
	if attempts < 5 then
		C_Timer.After(1, function()
			retrySetNormalTexture(button, itemId, attempts + 1)
		end)
	else
		print(APPEND .. L["Missing Texture %s"]:format(itemId))
	end
end

local function retryGetToyTexture(toyId, attempt)
	local attempts = attempt or 1
	local _, name, texture = C_ToyBox.GetToyInfo(toyId)
	if attempts < 5 then
		C_Timer.After(0.1, function()
			retryGetToyTexture(toyId, attempts + 1)
		end)
	end
end

--------------------------------------
--- Tooltip
--------------------------------------

local function setCombatTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	local yOffset = globalHeight / 2
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	GameTooltip:SetText(L["Not In Combat Tooltip"], 1, 1, 1)
	GameTooltip:Show()
end

local function setToolTip(self, type, id, hs)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	local yOffset = globalHeight / 2
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	if hs and db["Teleports:Hearthstone"] and db["Teleports:Hearthstone"] == "rng" then
		local bindLocation = GetBindLocation()
		GameTooltip:SetText(L["Random Hearthstone"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Tooltip"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Location"]:format(bindLocation), 1, 1, 1)
	elseif type == "item" then
		GameTooltip:SetItemByID(id)
	elseif type == "item_teleports" then
		GameTooltip:SetText(L["Item Teleports"] .. "\n" .. L["Item Teleports Tooltip"], 1, 1, 1)
	elseif type == "toy" then
		GameTooltip:SetToyByItemID(id)
	elseif type == "spell" then
		GameTooltip:SetSpellByID(id)
	elseif type == "flyout" then
		local name = GetFlyoutInfo(id)
		GameTooltip:SetText(name, 1, 1, 1)
	elseif type == "profession" then
		local professionInfo = C_TradeSkillUI.GetProfessionInfoBySkillLineID(id)
		if professionInfo then
			GameTooltip:SetText(professionInfo.professionName, 1, 1, 1)
		end
	elseif type == "seasonalteleport" then
		local currExpID = GetExpansionLevel()
		local expName = _G["EXPANSION_NAME" .. currExpID]
		local title = MYTHIC_DUNGEON_SEASON:format(expName, tpm.settings.current_season)
		GameTooltip:SetText(title, 1, 1, 1)
		GameTooltip:AddLine(L["Seasonal Teleports Tooltip"], 1, 1, 1)
	end
	GameTooltip:Show()
end

--------------------------------------
-- Frames
--------------------------------------

local flyOutButtons = {}
local flyOutButtonsPool = {}
local flyOutFrames = {}
local flyOutFramesPool = {}
local secureButtons = {}
local secureButtonsPool = {}

local function createCooldownFrame(frame)
	if frame.cooldownFrame then
		return frame.cooldownFrame
	end
	local cooldownFrame = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	cooldownFrame:SetAllPoints()

	function cooldownFrame:CheckCooldown(id, type)
		if not id then
			return
		end
		local start, duration, enabled
		if type == "toy" or type == "item" then
			start, duration, enabled = C_Item.GetItemCooldown(id)
		else
			local cooldown = C_Spell.GetSpellCooldown(id)
			start = cooldown.startTime
			duration = cooldown.duration
			enabled = true
		end
		if enabled and duration > 0 then
			self:SetCooldown(start, duration)
		else
			self:Clear()
		end
	end

	return cooldownFrame
end

local function CloseAllFlyouts()
	for _, frame in ipairs(flyOutFrames) do
		frame:Hide()
	end
end

local function createFlyOutButton(flyOutFrame, flyoutData, tooltipData) -- Flyout Data needs: id, name, iconId
	local flyOutButton
	if next(flyOutButtonsPool) then
		flyOutButton = table.remove(flyOutButtonsPool)
	else
		flyOutButton = CreateFrame("Button", nil, TeleportMeButtonsFrame, "SecureActionButtonTemplate")
		flyOutButton.text = flyOutButton:CreateFontString(nil, "OVERLAY")
		flyOutButton.text:SetPoint("BOTTOM", flyOutButton, "BOTTOM", 0, 5)

		table.insert(flyOutButtons, flyOutButton)
	end

	-- Functions
	function flyOutButton:SetFlyOutFrame(frame)
		flyOutButton.flyoutFrame = frame
	end

	flyOutButton:SetFlyOutFrame(flyOutFrame)

	function flyOutButton:Recycle()
		self:ClearAllPoints()
		self:SetFlyOutFrame(nil)
		self:Hide()
		table.insert(flyOutButtonsPool, self)
	end

	-- Mouse Interaction
	flyOutButton:EnableMouse(true)
	flyOutButton:RegisterForClicks("AnyDown", "AnyUp")

	-- Tooltips
	local tooltipType = "flyout"
	local tooltipId = flyoutData.id
	if tooltipData then
		tooltipType = tooltipData.type
		tooltipId = tooltipData.id
	end
	flyOutButton:SetScript("OnEnter", function(self)
		if InCombatLockdown() then
			setCombatTooltip(self)
			return
		end
		CloseAllFlyouts()
		setToolTip(self, tooltipType, tooltipId)
		self.flyoutFrame:Show()
	end)
	flyOutButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-- Text
	flyOutButton.text:SetFont(STANDARD_TEXT_FONT, db["Button:Text:Size"], "OUTLINE")
	flyOutButton.text:SetTextColor(1, 1, 1, 1)
	flyOutButton.text:Hide()
	if db["Button:Text:Show"] == true and flyoutData.name then
		flyOutButton.text:SetText(flyoutData.name)
		flyOutButton.text:Show()
	end

	-- Texture
	flyOutButton:SetNormalTexture(flyoutData.iconId)

	-- Positioning/Size
	flyOutButton:SetFrameStrata("HIGH")
	flyOutButton:SetFrameLevel(101)
	flyOutButton:SetSize(globalWidth, globalHeight)

	flyOutButton:Show()
	return flyOutButton
end

local function createFlyOutFrame()
	local flyOutFrame
	if next(flyOutFramesPool) then
		flyOutFrame = table.remove(flyOutFramesPool)
	else
		flyOutFrame = CreateFrame("Frame", "FlyOutFrame" .. #flyOutFrames + 1, TeleportMeButtonsFrame)
		table.insert(flyOutFrames, flyOutFrame)
	end

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

	flyOutFrame:Hide()
	return flyOutFrame
end

---@param id ItemInfo
---@return boolean
local function IsItemEquipped(id)
	return C_Item.IsEquippableItem(id) and C_Item.IsEquippedItem(id)
end

local function ClearAllInvalidHighlights()
	for _, button in pairs(secureButtons) do
		button:ClearHighlightTexture()

		if button:GetAttribute("item") ~= nil then
			local id = string.match(button:GetAttribute("item"), "%d+")
			if IsItemEquipped(id) then
				button:Highlight()
			end
		end
	end
end

---@param frame Frame
---@param type string
---@param text string|nil
---@param id integer
---@param hearthstone? boolean
---@return Frame
local function CreateSecureButton(frame, type, text, id, hearthstone)
	local button
	if next(secureButtonsPool) then
		button = table.remove(secureButtonsPool)
	else
		button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")
		button.cooldownFrame = createCooldownFrame(button)
		button.text = button:CreateFontString(nil, "OVERLAY")
		button:LockHighlight()
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)
		table.insert(secureButtons, button)
	end

	function button:Recycle()
		self:SetParent(nil)
		self:ClearAllPoints()
		self:Hide()
		if type == "item" and not C_Item.IsEquippedItem(id) then
			self:ClearHighlightTexture()
		end
		table.insert(secureButtonsPool, self)
	end

	function button:Highlight()
		self:SetHighlightAtlas("talents-node-choiceflyout-square-green")
	end

	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")

	-- Text
	button.text:SetFont(STANDARD_TEXT_FONT, db["Button:Text:Size"], "OUTLINE")
	button.text:SetTextColor(1, 1, 1, 1)
	button.text:Hide()
	if db["Button:Text:Show"] == true and text then
		button.text:SetText(text)
		button.text:Show()
	end

	-- Scripts
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	button:SetScript("OnEnter", function(self)
		setToolTip(self, type, id, hearthstone)
	end)
	button:SetScript("OnShow", function(self)
		self.cooldownFrame:CheckCooldown(id, type)
	end)
	button:SetScript("PostClick", function(self)
		if type == "item" and C_Item.IsEquippableItem(id) then
			C_Timer.After(0.25, function() -- Slight delay due to equipping the item not being instant.
				if IsItemEquipped(id) then
					ClearAllInvalidHighlights()
					self:Highlight()
				end
			end)
		end
	end)
	button.cooldownFrame:CheckCooldown(id, type)

	-- Textures
	if type == "spell" then
		local spellTexture = C_Spell.GetSpellTexture(id)
		button:SetNormalTexture(spellTexture)
	else -- item or toy
		SetTextureByItemId(button, id)
	end

	-- Attributes
	button:SetAttribute("type", type)
	if type == "item" then
		button:SetAttribute(type, "item:" .. id)
		if C_Item.IsEquippableItem(id) and IsItemEquipped(id) then
			button:Highlight()
		end
	else
		button:SetAttribute(type, id)
	end

	-- Positioning/Size
	button:SetParent(frame)
	button:SetSize(globalWidth, globalHeight)
	button:SetFrameStrata("HIGH")
	button:SetFrameLevel(102) -- This needs to be lower than the flyout frame

	button:Show()
	return button
end

--------------------------------------
-- Functions
--------------------------------------

function tpm:GetIconText(spellId)
	local text = shortNames[spellId]
	if text then
		return text
	end
	print(APPEND .. "No short name found for spellID " .. spellId .. ", please report this on GitHub")
end

function tpm:UpdateAvailableSeasonalTeleports()
	availableSeasonalTeleports = {}
	local playerFaction = UnitFactionGroup("player")
	local siegeOfBoralus = -1
	local motherlode = -1
	if playerFaction == "Alliance" then
		siegeOfBoralus = 445418
		motherlode = 467553
	else
		siegeOfBoralus = 464256
		motherlode = 467555
	end

	local seasonalTeleports = {
		-- TWW S1
		[1] = {
			[353] = siegeOfBoralus, -- Siege of Boralus has two spells one for alliance and one for horde
			[375] = 354464, -- Mists
			[376] = 354462, -- Necrotic Wake
			[501] = 445269, -- Stonevault
			[502] = 445416, -- City of Threads
			[503] = 445417, -- Ara Ara
			[505] = 445414, -- The Dawnbreaker
			[507] = 445424, -- Grim Batol
		},
		-- TWW S2
		[2] = {
			[247] = motherlode, -- The MOTHERLODE!!
			[370] = 373274, -- Operation: Mechagon - Workshop
			[382] = 354467, -- Theater of Pain
			[499] = 445444, -- Priory of the Sacred Flame
			[500] = 445443, -- The Rookery
			[504] = 445441, -- Darkflame Cleft
			[506] = 445440, -- Cinderbrew Meadery
			[525] = 1216786, -- Operation: Floodgate
		},
	}

	for _, mapId in ipairs(C_ChallengeMode.GetMapTable()) do
		local spellID = seasonalTeleports[tpm.settings.current_season][mapId]
		if spellID and IsSpellKnown(spellID) then
			table.insert(availableSeasonalTeleports, spellID)
		end
	end
end

function tpm:checkQuestCompletion(quest)
	if type(quest) == "table" then
		for _, questID in ipairs(quest) do
			if C_QuestLog.IsQuestFlaggedCompleted(questID) then
				return true
			end
		end
	else
		return C_QuestLog.IsQuestFlaggedCompleted(quest)
	end
end

function tpm:CreateFlyout(flyoutData)
	if db["Teleports:Seasonal:Only"] and flyoutData.subtype == "path" then
		return
	end
	local _, _, spells, flyoutKnown = GetFlyoutInfo(flyoutData.id)
	if not flyoutKnown then
		return
	end

	local yOffset = -globalHeight * TeleportMeButtonsFrame:GetButtonAmount()
	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	-- Flyout Main Button
	local button = createFlyOutButton(flyOutFrame, flyoutData)
	button:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

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
			local flyOutButton = CreateSecureButton(flyOutFrame, "spell", shortNames[spellId], spellId)
			flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", globalWidth * flyoutsCreated, (rowNr - 1) * -globalHeight)
			table.insert(childButtons, flyOutButton)
		end
	end

	local frameWidth = rowNr > 1 and globalWidth * (db["Flyout:Max_Per_Row"] + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)
	button.childButtons = childButtons
	return button
end

function tpm:CreateSeasonalTeleportFlyout()
	if #availableSeasonalTeleports == 0 then
		return
	end

	local tooltipData = { type = "seasonalteleport" }
	local seasonalFlyOutData = { id = -1, name = L["Season " .. tpm.settings.current_season], iconId = 5927657 }
	local yOffset = -globalHeight * TeleportMeButtonsFrame:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local button = createFlyOutButton(flyOutFrame, seasonalFlyOutData, tooltipData)
	button:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	for _, spellId in ipairs(availableSeasonalTeleports) do
		local flyname = nil
		if IsSpellKnown(spellId) then
			flyoutsCreated = flyoutsCreated + 1
			local text = tpm:GetIconText(spellId)
			local flyOutButton = CreateSecureButton(flyOutFrame, "spell", text, spellId)
			local xOffset = globalWidth * flyoutsCreated
			flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", xOffset, 0)
		end
	end
	flyOutFrame:SetSize(globalWidth + (globalWidth * flyoutsCreated), globalHeight)

	return button
end

function tpm:CreateWormholeFlyout(flyoutData)
	local usableWormholes = tpm.AvailableWormholes:GetUsable()
	if #usableWormholes == 0 then
		return
	end

	local yOffset = -globalHeight * TeleportMeButtonsFrame:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local button = createFlyOutButton(flyOutFrame, flyoutData, { type = "profession", id = 202 })
	button:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	for _, wormholeId in ipairs(usableWormholes) do
		flyoutsCreated = flyoutsCreated + 1
		local flyOutButton = CreateSecureButton(flyOutFrame, "toy", nil, wormholeId)
		local xOffset = globalWidth * flyoutsCreated
		flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", xOffset, 0)
	end
	flyOutFrame:SetSize(globalWidth * (flyoutsCreated + 1), globalHeight)

	return button
end

function tpm:CreateItemTeleportsFlyout(flyoutData)
	if #tpm.AvailableItemTeleports == 0 then
		return
	end

	local yOffset = -globalHeight * TeleportMeButtonsFrame:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local button = createFlyOutButton(flyOutFrame, flyoutData, { type = "item_teleports" })
	button:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	for _, itemTeleportId in ipairs(tpm.AvailableItemTeleports) do
		flyoutsCreated = flyoutsCreated + 1
		local flyOutButton = CreateSecureButton(flyOutFrame, "item", nil, itemTeleportId)
		local xOffset = globalWidth * flyoutsCreated
		flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", xOffset, 0)
	end
	flyOutFrame:SetSize(globalWidth * (flyoutsCreated + 1), globalHeight)

	return button
end

function tpm:updateHearthstone()
	local hearthstoneButton = TeleportMeButtonsFrame.hearthstoneButton
	if not hearthstoneButton then
		return
	end

	if db["Teleports:Hearthstone"] == "rng" then
		local rng = math.random(#tpm.AvailableHearthstones)
		hearthstoneButton:SetNormalTexture(1669494) -- misc_rune_pvp_random
		hearthstoneButton:SetAttribute("type", "toy")
		hearthstoneButton:SetAttribute("toy", tpm.AvailableHearthstones[rng])
	elseif db["Teleports:Hearthstone"] ~= "none" then
		SetTextureByItemId(hearthstoneButton, db["Teleports:Hearthstone"])
		hearthstoneButton:SetAttribute("type", "toy")
		hearthstoneButton:SetAttribute("toy", db["Teleports:Hearthstone"])
		hearthstoneButton:SetScript("OnEnter", function(self)
			setToolTip(self, "toy", db["Teleports:Hearthstone"], true)
		end)
	else
		if C_Item.GetItemCount(6948) == 0 then
			print(APPEND .. L["No Hearthtone In Bags"])
			hearthstoneButton:Hide()
			return
		end
		SetTextureByItemId(hearthstoneButton, 6948)
		hearthstoneButton:SetAttribute("type", "item")
		hearthstoneButton:SetAttribute("item", "item:6948")
		hearthstoneButton:SetScript("OnEnter", function(self)
			setToolTip(self, "item", 6948, true)
		end)
	end
	hearthstoneButton:Show()
end

local function createAnchors()
	if TeleportMeButtonsFrame and not TeleportMeButtonsFrame.reload then
		if not db["Enabled"] then
			TeleportMeButtonsFrame:Hide()
			return
		end
		if TeleportMeButtonsFrame:IsVisible() and db["Teleports:Hearthstone"] and db["Teleports:Hearthstone"] == "rng" then
			local rng = tpm:GetRandomHearthstone()
			TeleportMeButtonsFrame.hearthstoneButton:SetAttribute("toy", rng)
		end
		ClearAllInvalidHighlights()
		return
	end
	if not db["Enabled"] then
		return
	end
	local buttonsFrame = TeleportMeButtonsFrame or CreateFrame("Frame", "TeleportMeButtonsFrame", GameMenuFrame)
	buttonsFrame.reload = nil
	buttonsFrame:SetSize(1, 1)
	local yOffset = globalHeight / 2
	buttonsFrame:SetPoint("TOPLEFT", GameMenuFrame, "TOPRIGHT", 0, -yOffset)

	buttonsFrame.buttonAmount = 0
	function buttonsFrame:IncrementButtons()
		self.buttonAmount = self.buttonAmount + 1
	end

	function buttonsFrame:GetButtonAmount()
		return self.buttonAmount
	end

	for i, teleport in ipairs(tpTable) do
		local texture
		local known

		-- Checks and overwrites
		if teleport.hearthstone and db["Teleports:Hearthstone"] ~= "none" then -- Overwrite main HS with user set HS
			tpm:DebugPrint("Overwriting main HS with user set HS")
			teleport.type = "toy"
			known = true
			if db["Teleports:Hearthstone"] == "rng" then
				texture = 1669494 -- misc_rune_pvp_random
				teleport.id = tpm:GetRandomHearthstone()
			else
				teleport.id = db["Teleports:Hearthstone"]
			end
			tpm:DebugPrint("Overwrite Info:", known, teleport.id, teleport.type, texture)
		elseif teleport.type == "item" and C_Item.GetItemCount(teleport.id) > 0 then
			known = true
		elseif
			teleport.type == "toy" and PlayerHasToy(teleport.id --[[@as integer]])
		then
			if teleport.quest then
				known = tpm:checkQuestCompletion(teleport.quest)
			else
				known = true
			end
		elseif
			teleport.type == "spell" and IsSpellKnown(teleport.id --[[@as integer]])
		then
			known = true
		end

		if not known and teleport.hearthstone then -- Player has no HS in bags and not set a custom TP.
			print(APPEND .. L["No Hearthtone In Bags"])
		end

		-- Create Stuff
		if known and (teleport.type == "toy" or teleport.type == "item" or teleport.type == "spell") then
			tpm:DebugPrint(teleport.hearthstone)
			local button = CreateSecureButton(buttonsFrame, teleport.type, nil, teleport.id --[[@as integer]], teleport.hearthstone)
			local yOffset = -globalHeight * buttonsFrame:GetButtonAmount()
			button:SetPoint("LEFT", buttonsFrame, "TOPRIGHT", 0, yOffset)
			if teleport.hearthstone then -- store to replace item later
				buttonsFrame.hearthstoneButton = button
			end
			buttonsFrame:IncrementButtons()
		elseif teleport.type == "wormholes" then
			local created = tpm:CreateWormholeFlyout(teleport)
			if created then
				buttonsFrame:IncrementButtons()
			end
		elseif teleport.type == "item_teleports" then
			local created = tpm:CreateItemTeleportsFlyout(teleport)
			if created then
				buttonsFrame:IncrementButtons()
			end
		elseif teleport.type == "flyout" then
			local created = tpm:CreateFlyout(teleport)
			if created then
				buttonsFrame:IncrementButtons()
			end
		end
	end

	function CreateCurrentSeasonTeleports()
		local created = tpm:CreateSeasonalTeleportFlyout()
		if created then
			buttonsFrame:IncrementButtons()
		end
	end

	CreateCurrentSeasonTeleports()
	tpm:updateHearthstone() -- XXX Temp as this fixes the rng icon if it's selected
end

function tpm:ReloadFrames()
	if InCombatLockdown() then
		return
	end
	if db["Button:Size"] then
		globalWidth = db["Button:Size"]
		globalHeight = db["Button:Size"]
	end

	for _, button in ipairs(flyOutButtons) do
		button:Recycle()
	end
	for _, frame in ipairs(flyOutFrames) do
		frame:Recycle()
	end
	for _, secureButton in ipairs(secureButtons) do
		secureButton:Recycle()
	end

	if TeleportMeButtonsFrame then
		TeleportMeButtonsFrame.reload = true
	end

	createAnchors()
end

-- Slash Commands
SLASH_TPMENU1 = "/tpm"
SLASH_TPMENU2 = "/tpmenu"
SlashCmdList["TPMENU"] = function(msg)
	local args = { (" "):split(msg:lower()) }
	msg = args[1]

	if msg == "" then
		Settings.OpenToCategory(tpm:GetOptionsCategory())
	elseif msg == "filters" then
		Settings.OpenToCategory(tpm:GetOptionsCategory(msg))
	else
		print(APPEND .. " unknown command: " .. msg)
	end
end
--------------------------------------
-- Loading
--------------------------------------

local function checkItemsLoaded(self)
	if self.continuableContainer then
		self.continuableContainer:Cancel()
	end

	self.continuableContainer = ContinuableContainer:Create()

	local function LoadItems(itemTable)
		for id, _ in ipairs(itemTable) do
			self.continuableContainer:AddContinuable(Item:CreateFromItemID(id))
		end
	end

	LoadItems(tpm.Wormholes)
	LoadItems(tpm.Hearthstones)
	LoadItems(tpm.ItemTeleports)

	local allLoaded = true
	local function OnItemsLoaded()
		if allLoaded then
			tpm:Setup()
			tpm:LoadOptions()
			self:UnregisterEvent("ADDON_LOADED")
		else
			checkItemsLoaded(self)
		end
	end

	allLoaded = self.continuableContainer:ContinueOnLoad(OnItemsLoaded)
end

function tpm:Setup()
	if db["Button:Size"] then
		globalWidth = db["Button:Size"]
		globalHeight = db["Button:Size"]
	end

	tpm:UpdateAvailableHearthstones()
	tpm:UpdateAvailableWormholes()
	tpm:UpdateAvailableSeasonalTeleports()
	tpm:UpdateAvailableItemTeleports()

	if
		db["Teleports:Hearthstone"]
		and db["Teleports:Hearthstone"] ~= "rng"
		and db["Teleports:Hearthstone"] ~= "none"
		and not PlayerHasToy(db["Teleports:Hearthstone"] --[[@as integer]])
	then
		print(APPEND .. L["Hearthone Reset Error"]:format(db["Teleports:Hearthstone"]))
		db["Teleports:Hearthstone"] = "none"
		tpm:updateHearthstone()
	end

	hooksecurefunc("ToggleGameMenu", tpm.ReloadFrames)
end

-- Event Handlers
local events = {}
local normalizedSeasons = {
	[13] = 1, -- TWW Season 1
	[14] = 2, -- TWW Season 2
}
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:RegisterEvent("CVAR_UPDATE")
f:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...)
end)

function events:ADDON_LOADED(...)
	local addOnName = ...

	if addOnName == "TeleportMenu" then
		db = tpm:GetOptions()
		tpm.settings.current_season = normalizedSeasons[tonumber(C_CVar.GetCVar("newMythicPlusSeason"))] or 1

		db.debug = false
		f:UnregisterEvent("ADDON_LOADED")
	end
end

function events:CVAR_UPDATE(...)
	local name, value = ...
	if name == "newMythicPlusSeason" then
		tpm.settings.current_season = normalizedSeasons[tonumber(value)] or 1
		if TeleportMeButtonsFrame then
			tpm:UpdateAvailableSeasonalTeleports()
			tpm:ReloadFrames()
		end
	end
end

function events:PLAYER_LOGIN(...)
	checkItemsLoaded(f)
	f:UnregisterEvent("PLAYER_LOGIN")
end

function events:BAG_UPDATE_DELAYED()
	--- @type Item[]
	local items_in_possession = CopyTable(tpm.player.items_in_possession)

	--- @type Item[]
	local items_to_be_obtained = CopyTable(tpm.player.items_to_be_obtained)

	-- Scan bags for items supposedly in possession
	for _, item in pairs(items_in_possession) do
		if GetItemCount(item.id) == 0 then
			tpm:RemoveItemFromPossession(item.id)
		end
	end

	-- Scan bags for items supposedly NOT in possession
	for _, item in pairs(items_to_be_obtained) do
		if GetItemCount(item.id) > 0 then
			tpm:AddItemToPossession(item.id)
		end
	end
end

-- Debug Functions
function tpm:DebugPrint(...)
	if not db.debug then
		return
	end
	print(APPEND, ...)
end
