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

local covenantsMaxed = nil
local function GetCovenantData(id) -- the id is the achievement criteria index from Re-Re-Re-Renowned
	if covenantsMaxed then
		return covenantsMaxed[id]
	end
	covenantsMaxed = {}
	for i = 1, 4 do
		local _, _, completed = GetAchievementCriteriaInfo(15646, i)
		covenantsMaxed[i] = completed
	end
end

local availableHearthstones = {}
local hearthstoneToys = {
	[54452] = true, -- Ethereal Portal
	[64488] = true, -- The Innkeeper's Daughter
	[93672] = true, -- Dark Portal
	[142542] = true, -- Tome of Town Portal
	[162973] = true, -- Greatfather Winter's Hearthstone
	[163045] = true, -- Headless Horseman's Hearthstone
	[163206] = true, -- Weary Spirit Binding
	[165669] = true, -- Lunar Elder's Hearthstone
	[165670] = true, -- Peddlefeet's Lovely Hearthstone
	[165802] = true, -- Noble Gardener's Hearthstone
	[166746] = true, -- Fire Eater's Hearthstone
	[166747] = true, -- Brewfest Reveler's Hearthstone
	[168907] = true, -- Holographic Digitalization Hearthstone
	[172179] = true, -- Eternal Traveler's Hearthstone
	[180290] = function()
		-- Night Fae Hearthstone
		if GetCovenantData(3) then
			return true
		end
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 3 then
			return true
		end
	end,
	[182773] = function()
		-- Necrolord Hearthstone
		if GetCovenantData(2) then
			return true
		end
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 4 then
			return true
		end
	end,
	[183716] = function()
		-- Venthyr Sinstone
		if GetCovenantData(4) then
			return true
		end
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 2 then
			return true
		end
	end,
	[184353] = function()
		-- Kyrian Hearthstone
		if GetCovenantData(1) then
			return true
		end
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 1 then
			return true
		end
	end,
	[188952] = true, -- Dominated Hearthstone
	[190196] = true, -- Enlightened Hearthstone
	[190237] = true, -- Broker Translocation Matrix
	[193588] = true, -- Timewalker's Hearthstone
	[200630] = true, -- Ohnir Windsage's Hearthstone
	[206195] = true, -- Path of the Naaru
	[208704] = true, -- Deepdweller's Earthen Hearthstone
	[209035] = true, -- Hearthstone of the Flame
	[210455] = function()
		-- Draenic Hologem (Draenei and Lightforged Draenei only)
		local _, _, raceId = UnitRace("player")
		if raceId == 11 or raceId == 30 then
			return true
		end
	end,
	[212337] = true, -- Stone of the Hearth
	[228940] = true -- Notorious Thread's Hearthstone
}

local availableWormholes = {}
local wormholes = {
	30542, -- Dimensional Ripper - Area 52
	18984, -- Dimensional Ripper - Everlook
	18986, -- Ultrasafe Transporter: Gadgetzan
	30544, -- Ultrasafe Transporter: Toshley's Station
	48933, -- Wormhole Generator: Northrend
	87215, -- Wormhole Generator: Pandaria
	112059, -- Wormhole Centrifuge (Dreanor) 6
	151652, -- Wormhole Generator: Argus
	168807, -- Wormhole Generator: Kul Tiras 5
	168808, -- Wormhole Generator: Zandalar
	172924, -- Wormhole Generator: Shadowlands 3
	198156, -- Wyrmhole Generator: Dragon Isles 4
	221966 -- Wormhole Generator: Khaz Algar
}
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
	[446534] = L["Dornogal"]
}

local tpTable = {
	-- Hearthstones
	{id = 6948, type = "item", hearthstone = true}, -- Hearthstone
	{id = 556, type = "spell"}, -- Astral Recall (Shaman)
	{id = 110560, type = "toy", quest = {34378, 34586}}, -- Garrison Hearthstone
	{id = 140192, type = "toy", quest = {44184, 44663}}, -- Dalaran Hearthstone
	-- Engineering
	{type = "wormholes", iconId = 4620673}, -- Engineering Wormholes
	-- Class Teleports
	{id = 1, type = "flyout", iconId = 237509, subtype = "mage"}, -- Teleport (Mage) (Horde)
	{id = 8, type = "flyout", iconId = 237509, subtype = "mage"}, -- Teleport (Mage) (Alliance)
	{id = 11, type = "flyout", iconId = 135744, subtype = "mage"}, -- Portals (Mage) (Horde)
	{id = 12, type = "flyout", iconId = 135748, subtype = "mage"}, -- Portals (Mage) (Alliance)
	{id = 126892, type = "spell"}, -- Zen Pilgrimage (Monk)
	{id = 50977, type = "spell"}, -- Death Gate (Death Knight)
	{id = 193753, type = "spell"}, -- Dreamwalk (Druid)
	-- Dungeon/Raid Teleports
	{id = 230, type = "flyout", iconId = 574788, name = L["Cataclysm"], subtype = "path"}, -- Hero's Path: Cataclysm
	{id = 84, type = "flyout", iconId = 328269, name = L["Mists of Pandaria"], subtype = "path"}, -- Hero's Path: Mists of Pandaria
	{id = 96, type = "flyout", iconId = 1413856, name = L["Warlords of Draenor"], subtype = "path"}, -- Hero's Path: Warlords of Draenor
	{id = 224, type = "flyout", iconId = 1260827, name = L["Legion"], subtype = "path"}, -- Hero's Path: Legion
	{id = 223, type = "flyout", iconId = 1869493, name = L["Battle for Azeroth"], subtype = "path"}, -- Hero's Path: Battle for Azeroth
	{id = 220, type = "flyout", iconId = 236798, name = L["Shadowlands"], subtype = "path"}, -- Hero's Path: Shadowlands
	{id = 222, type = "flyout", iconId = 4062765, name = L["Shadowlands Raids"], subtype = "path"}, -- Hero's Path: Shadowlands Raids
	{id = 227, type = "flyout", iconId = 4640496, name = L["Dragonflight"], subtype = "path"}, -- Hero's Path: Dragonflight
	{id = 231, type = "flyout", iconId = 5342925, name = L["Dragonflight Raids"], subtype = "path"}, -- Hero's Path: Dragonflight Raids
	{id = 232, type = "flyout", iconId = 5872031, name = L["The War Within"], subtype = "path"} -- Hero's Path: The War Within
}

--------------------------------------
-- Texture Stuff
--------------------------------------

local function SetTextureByItemId(frame, itemId)
	frame:SetNormalTexture(DEFAULT_ICON) -- Temp while loading
	local item = Item:CreateFromItemID(tonumber(itemId))
	item:ContinueOnItemLoad(
		function()
			local icon = item:GetItemIcon()
			frame:SetNormalTexture(icon)
		end
	)
end

local function retrySetNormalTexture(button, itemId, attempt)
	local attempts = attempt or 1
	local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemId)
	if itemTexture then
		button:SetNormalTexture(itemTexture)
		return
	end
	if attempts < 5 then
		C_Timer.After(
			1,
			function()
				retrySetNormalTexture(button, itemId, attempts + 1)
			end
		)
	else
		print(APPEND .. L["Missing Texture %s"]:format(itemId))
	end
end

local function retryGetToyTexture(toyId, attempt)
	local attempts = attempt or 1
	local _, name, texture = C_ToyBox.GetToyInfo(toyId)
	if attempts < 5 then
		C_Timer.After(
			0.1,
			function()
				retryGetToyTexture(toyId, attempts + 1)
			end
		)
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
	if hs and db.hearthstone and db.hearthstone == "rng" then
		local bindLocation = GetBindLocation()
		GameTooltip:SetText(L["Random Hearthstone"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Tooltip"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Location"]:format(bindLocation), 1, 1, 1)
	elseif type == "item" then
		GameTooltip:SetItemByID(id)
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
		GameTooltip:SetText(L["Seasonal Teleports"], 1, 1, 1)
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
	flyOutButton:SetScript(
		"OnEnter",
		function(self)
			if InCombatLockdown() then
				setCombatTooltip(self)
				return
			end
			CloseAllFlyouts()
			setToolTip(self, tooltipType, tooltipId)
			self.flyoutFrame:Show()
		end
	)
	flyOutButton:SetScript(
		"OnLeave",
		function(self)
			GameTooltip:Hide()
		end
	)

	-- Text
	flyOutButton.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	flyOutButton.text:SetTextColor(1, 1, 1, 1)
	flyOutButton.text:Hide()
	if db.buttonText == true and flyoutData.name then
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
	flyOutFrame:SetScript(
		"OnLeave",
		function(self)
			GameTooltip:Hide()
			if not InCombatLockdown() then -- XXX Needed?
				self:Hide()
			end
		end
	)

	flyOutFrame:Hide()
	return flyOutFrame
end

-- Args
-- frame: Parent Frame
-- type: item, spell, toy type for the button click
-- text: Text to display on the button
-- id: id of the item, spell, or toy
-- hearthstone: boolean if the button is for a hearthstone (only used for tooltip atm)
local function CreateSecureButton(frame, type, text, id, hearthstone)
	local button
	if next(secureButtonsPool) then
		button = table.remove(secureButtonsPool)
	else
		button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")
		button.cooldownFrame = createCooldownFrame(button)
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)

		table.insert(secureButtons, button)
	end

	function button:Recycle()
		self:SetParent(nil)
		self:ClearAllPoints()
		self:Hide()
		table.insert(secureButtonsPool, self)
	end

	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")

	-- Text
	button.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	button.text:SetTextColor(1, 1, 1, 1)
	button.text:Hide()
	if db.buttonText == true and text then
		button.text:SetText(text)
		button.text:Show()
	end

	-- Scripts
	button:SetScript(
		"OnLeave",
		function(self)
			GameTooltip:Hide()
		end
	)
	button:SetScript(
		"OnEnter",
		function(self)
			setToolTip(self, type, id, hearthstone)
		end
	)
	button:SetScript(
		"OnShow",
		function(self)
			self.cooldownFrame:CheckCooldown(id, type)
		end
	)
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
	print(APPEND .. "No short name found for spellID " .. id .. ", please report this on GitHub")
end

function tpm:GetAvailableHearthstoneToys()
	local hearthstoneNames = {}
	for _, toyId in pairs(availableHearthstones) do
		local _, name, texture = C_ToyBox.GetToyInfo(toyId)
		if not texture then
			texture = DEFAULT_ICON
		end
		if not name then
			name = tostring(toyId)
		end
		hearthstoneNames[toyId] = {name = name, texture = texture}
	end
	return hearthstoneNames
end

function tpm:updateAvailableHearthstones()
	availableHearthstones = {}
	for id, usable in pairs(hearthstoneToys) do
		if PlayerHasToy(id) then
			if type(usable) == "function" and usable() then
				table.insert(availableHearthstones, id)
			elseif usable == true then
				table.insert(availableHearthstones, id)
			end
		end
	end
end

function tpm:updateAvailableWormholes()
	for _, id in ipairs(wormholes) do
		if PlayerHasToy(id) and C_ToyBox.IsToyUsable(id) then
			table.insert(availableWormholes, id)
		end
	end
end

function tpm:updateAvailableSeasonalTeleport()
	local playerFaction = UnitFactionGroup("player")
	local siegeOfBoralus = -1
	if playerFaction == "Alliance" then
		siegeOfBoralus = 445418
	else
		siegeOfBoralus = 464256
	end

	local challengeMapIdTospellID = {
		[353] = siegeOfBoralus, -- Siege of Boralus has two spells one for alliance and one for horde
		[375] = 354464, -- Mists
		[376] = 354462, -- Necrotic Wake
		[499] = 445444, -- Priory
		[500] = 445443, -- The Rookery
		[501] = 445269, -- Stonevault
		[502] = 445416, -- City of Threads
		[503] = 445417, -- Ara Ara
		[504] = 445441, -- Darkflame Cleft
		[505] = 445414, -- The Dawnbreaker
		[506] = 445440, -- Cinderbrew Meadery
		[507] = 445424 -- Grim Batol
	}

	for _, mapId in ipairs(C_ChallengeMode.GetMapTable()) do
		local spellID = challengeMapIdTospellID[mapId]
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
	if db.showOnlySeasonalHerosPath and flyoutData.subtype == "path" then
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

	local inverse = db.reverseMageFlyouts and flyoutData.subtype == "mage"
	local start, endLoop, step = 1, spells, 1
	if inverse then -- Inverse loop params
		start, endLoop, step = spells, 1, -1
	end
	for i = start, endLoop, step do
		local spellId = select(1, GetFlyoutSlotInfo(flyoutData.id, i))
		if IsSpellKnown(spellId) then
			if flyoutsCreated == db.maxFlyoutIcons then
				flyoutsCreated = 0
				rowNr = rowNr + 1
			end
			flyoutsCreated = flyoutsCreated + 1
			local flyOutButton = CreateSecureButton(flyOutFrame, "spell", shortNames[spellId], spellId)
			flyOutButton:SetPoint("TOPLEFT", flyOutFrame, "TOPLEFT", globalWidth * flyoutsCreated, (rowNr - 1) * -globalHeight)
			table.insert(childButtons, flyOutButton)
		end
	end

	local frameWidth = rowNr > 1 and globalWidth * (db.maxFlyoutIcons + 1) or globalWidth * (flyoutsCreated + 1)
	flyOutFrame:SetSize(frameWidth, globalHeight * rowNr)
	button.childButtons = childButtons
	return button
end

function tpm:CreateSeasonalTeleportFlyout()
	if #availableSeasonalTeleports == 0 then
		return
	end

	local tooltipData = {type = "seasonalteleport"}
	local seasonalFlyOutData = {id = -1, name = L["Season 1"], iconId = 5927657}
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
	if #availableWormholes == 0 then
		return
	end

	local yOffset = -globalHeight * TeleportMeButtonsFrame:GetButtonAmount()

	local flyOutFrame = createFlyOutFrame()
	flyOutFrame:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local button = createFlyOutButton(flyOutFrame, flyoutData, {type = "profession", id = 202})
	button:SetPoint("LEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)

	local flyoutsCreated = 0
	for _, wormholeId in ipairs(availableWormholes) do
		flyoutsCreated = flyoutsCreated + 1
		local flyOutButton = CreateSecureButton(flyOutFrame, "toy", nil, wormholeId)
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
	local texture
	if db.hearthstone == "rng" then
		local rng = math.random(#availableHearthstones)
		hearthstoneButton:SetNormalTexture(1669494) -- misc_rune_pvp_random
		hearthstoneButton:SetAttribute("type", "toy")
		hearthstoneButton:SetAttribute("toy", availableHearthstones[rng])
	elseif db.hearthstone ~= "none" then
		SetTextureByItemId(hearthstoneButton, db.hearthstone)
		hearthstoneButton:SetAttribute("type", "toy")
		hearthstoneButton:SetAttribute("toy", db.hearthstone)
		hearthstoneButton:SetScript(
			"OnEnter",
			function(self)
				setToolTip(self, "toy", db.hearthstone, true)
			end
		)
	else
		if C_Item.GetItemCount(6948) == 0 then
			print(APPEND .. L["No Hearthtone In Bags"])
			hearthstoneButton:Hide()
			return
		end
		SetTextureByItemId(hearthstoneButton, 6948)
		hearthstoneButton:SetAttribute("type", "item")
		hearthstoneButton:SetAttribute("item", "item:6948")
		hearthstoneButton:SetScript(
			"OnEnter",
			function(self)
				setToolTip(self, "item", 6948, true)
			end
		)
	end
	hearthstoneButton:Show()
end

function tpm:GetRandomHearthstone(retry)
	if #availableHearthstones == 0 then
		return
	end
	if #availableHearthstones == 1 then
		return availableHearthstones[1]
	end -- Don't even bother
	local randomHs = availableHearthstones[math.random(#availableHearthstones)]
	if lastRandomHearthstone == randomHs then -- Don't fully randomize, always a new one
		randomHs = self:GetRandomHearthstone(true)
	end
	if not retry then
		lastRandomHearthstone = randomHs
	end
	return randomHs
end

local function createAnchors()
	if InCombatLockdown() then
		return
	elseif TeleportMeButtonsFrame and not TeleportMeButtonsFrame.reload then
		if not db.enabled then
			TeleportMeButtonsFrame:Hide()
			return
		end
		if TeleportMeButtonsFrame:IsVisible() and db.hearthstone and db.hearthstone == "rng" then
			local rng = tpm:GetRandomHearthstone()
			TeleportMeButtonsFrame.hearthstoneButton:SetAttribute("toy", rng)
		end
		return
	end
	if not db.enabled then
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
		if teleport.hearthstone and db.hearthstone ~= "none" then -- Overwrite main HS with user set HS
			tpm:DebugPrint("Overwriting main HS with user set HS")
			teleport.type = "toy"
			known = true
			if db.hearthstone == "rng" then
				texture = 1669494 -- misc_rune_pvp_random
				teleport.id = tpm:GetRandomHearthstone()
			else
				teleport.id = db.hearthstone
			end
			tpm:DebugPrint("Overwrite Info:", known, teleport.id, teleport.type, texture)
		elseif teleport.type == "item" and C_Item.GetItemCount(teleport.id) > 0 then
			known = true
		elseif teleport.type == "toy" and PlayerHasToy(teleport.id) then
			if teleport.quest then
				known = tpm:checkQuestCompletion(teleport.quest)
			else
				known = true
			end
		elseif teleport.type == "spell" and IsSpellKnown(teleport.id) then
			known = true
		end

		if not known and teleport.hearthstone then -- Player has no HS in bags and not set a custom TP.
			print(APPEND .. L["No Hearthtone In Bags"])
		end

		-- Create Stuff
		if known and (teleport.type == "toy" or teleport.type == "item" or teleport.type == "spell") then
			tpm:DebugPrint(teleport.hearthstone)
			local button = CreateSecureButton(buttonsFrame, teleport.type, nil, teleport.id, teleport.hearthstone)
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
	if db.iconSize then
		globalWidth = db.iconSize
		globalHeight = db.iconSize
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

	TeleportMeButtonsFrame.reload = true

	createAnchors()
end

-- Slash Commands
SLASH_TPMENU1 = "/tpm"
SLASH_TPMENU2 = "/tpmenu"
SlashCmdList["TPMENU"] = function(msg)
	print(APPEND .. L["Opening Options Menu"])
	Settings.OpenToCategory(tpm:GetOptionsCategory())
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
		for _, itemId in ipairs(itemTable) do
			self.continuableContainer:AddContinuable(Item:CreateFromItemID(tonumber(itemId)))
		end
	end

	LoadItems(hearthstoneToys)
	LoadItems(wormholes)

	local allLoaded = true
	local function OnItemsLoaded()
		if allLoaded then
			tpm:Setup()
			tpm:LoadOptions()
		else
			checkItemsLoaded(self)
		end
	end

	allLoaded = self.continuableContainer:ContinueOnLoad(OnItemsLoaded)
end

function tpm:Setup()
	if db.iconSize then
		globalWidth = db.iconSize
		globalHeight = db.iconSize
	end

	tpm:updateAvailableHearthstones()
	tpm:updateAvailableWormholes()
	tpm:updateAvailableSeasonalTeleport()

	if db.hearthstone and db.hearthstone ~= "rng" and db.hearthstone ~= "none" and not PlayerHasToy(db.hearthstone) then
		print(APPEND .. L["Hearthone Reset Error"]:format(db.hearthstone))
		db.hearthstone = "none"
		tpm:updateHearthstone()
	end

	createAnchors()
	hooksecurefunc("ToggleGameMenu", createAnchors)
end

local function OnEvent(self, event, addOnName)
	if addOnName == "TeleportMenu" then
		db = tpm:GetOptions()
		db.debug = false
	elseif event == "PLAYER_LOGIN" then
		checkItemsLoaded(self)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", OnEvent)

-- Debug Functions
function tpm:DebugPrint(...)
	if not db.debug then
		return
	end
	print(APPEND, ...)
end
