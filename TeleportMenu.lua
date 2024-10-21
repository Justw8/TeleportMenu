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

--------------------------------------
-- Teleport Tables
--------------------------------------

local availableHearthstones = {}
local hearthstoneToys = {
	[54452] = true, -- Ethereal Portal
	[64488] = true, -- The Innkeeper's Daughter
	[93672] = true, -- Dark Portal
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
	[180290] = function() -- Night Fae Hearthstone
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 3 then return true end
	end,
	[182773] = function() -- Necrolord Hearthstone
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 4 then return true end
	end,
	[183716] = function() -- Venthyr Sinstone
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 2 then return true end
	end,
	[184353] = function() -- Kyrian Hearthstone
		local covenantID = C_Covenants.GetActiveCovenantID()
		if covenantID == 1 then return true end
	end,
	[188952] = true, -- Dominated Hearthstone
	[190196] = true, -- Enlightened Hearthstone
	[190237] = true, -- Broker Translocation Matrix
	[193588] = true, -- Timewalker's Hearthstone
	[200630] = true, -- Ohnir Windsage's Hearthstone
	[206195] = true, -- Path of the Naaru
	[208704] = true, -- Deepdweller's Earthen Hearthstone
	[209035] = true, -- Hearthstone of the Flame
	[228940] = true, -- Notorious Thread's Hearthstone
}

local availableBonusHearthstones = {}
local bonusHearthstones = {
	[142542] = true, -- Tome of Town Portal
	[210455] = function() -- Draenic Hologem (Draenei and Lightforged Draenei only)
		local _, _, raceId = UnitRace("player")
		if raceId == 11 or raceId == 30 then return true end
	end,
	[212337] = true, -- Stone of the Hearth
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
	221966, -- Wormhole Generator: Khaz Algar
}
local availableSeasonalTeleports = {}


local dungeons = {
	-- CATA
	{id=410080,name= "VP"},
	{id=424142,name= "ToTT"},
	{id=445424,name="GB"},
	-- MoP
	{id=131204,name= "TJS"},
	-- WoD
	{id=159901,name= "EB"},
	{id=159899,name= "SBG"},
	{id=159900,name= "GD"},
	{id=159896,name= "ID"},
	-- Legion
	{id=393764,name= "HoV"},
	{id=410078,name= "NL"},
	{id=393766,name= "CoS"},
	{id=373262,name= "KARA"},
	{id=424153,name= "BRH"},
	{id=424163,name= "DHT"},
	-- BFA
	{id=410071,name= "FH"},
	{id=410074,name= "UR"},
	{id=373274,name= "MECH"},
	{id=424167,name= "WM"},
	{id=424187,name= "AD"},
	{id=445418,name="SoB"},
	{id=464256,name="SoB"},
	-- SL
	{id=354462,name= "NW"},
	{id=354463,name= "PF"},
	{id=354464,name= "MoTS"},
	{id=354465,name= "HoA"},
	{id=354466,name= "SoA"},
	{id=354467,name= "ToP"},
	{id=354468,name= "DOS"},
	{id=354469,name= "SD"},
	{id=367416,name= "TAZ"},
	-- DF
	{id=393256,name= "RLP"},
	{id=393262,name= "NO"},
	{id=393267,name= "BH"},
	{id=393273,name= "AA"},
	{id=393276,name= "NELT"},
	{id=393279,name= "AV"},
	{id=393283,name= "HoI"},
	{id=393222,name= "ULD"},
	{id=424197,name= "DotI"},
	-- TWW
	{id=445416,name="CoT"},
	{id=445414,name="DB"},
	{id=445269,name="SV"},
	{id=445443,name="ROOK"},
	{id=445440,name="CBM"},
	{id=445444,name="PoSF"},
	{id=445417,name="AK"},
	{id=445441,name="DFC"},
}

local tpTable = {
	-- Hearthstones
	{id = 6948, type = "item", hearthstone = true}, -- Hearthstone
	{type = "bonusheartsones", iconId = 5524917}, -- Bonus Heartstones
	{id = 556, type = "spell"}, -- Astral Recall (Shaman)
	{id = 110560, type = "toy", quest={34378, 34586}}, -- Garrison Hearthstone
	{id = 140192, type = "toy", quest={44184, 44663}}, -- Dalaran Hearthstone

	-- Engineering
	{type = "wormholes", iconId = 4620673}, -- Engineering Wormholes

	-- Class Teleports
	{id = 1, type = "flyout", iconId = 237509}, -- Teleport (Mage)
	{id = 8, type = "flyout", iconId = 237509}, -- Teleport (Mage)
	{id = 11, type = "flyout", iconId = 135744}, -- Portals (Mage)
	{id = 12, type = "flyout", iconId = 135748}, -- Portals (Mage)
	{id = 126892, type = "spell"}, -- Zen Pilgrimage (Monk)
	{id = 50977, type = "spell"}, -- Death Gate (Death Knight)
	{id = 193753, type = "spell"}, -- Dreamwalk (Druid)

	-- Dungeon/Raid Teleports
	{id = 230, type = "flyout", iconId = 574788, name = "CATA"}, -- Hero's Path: Cataclysm
	{id = 84, type = "flyout", iconId = 328269, name = "MoP"}, -- Hero's Path: Mists of Pandaria
	{id = 96, type = "flyout", iconId = 1413856, name = "WoD"}, -- Hero's Path: Warlords of Draenor
	{id = 224, type = "flyout", iconId = 1260827, name = "LEGN"}, -- Hero's Path: Legion
	{id = 223, type = "flyout", iconId = 1869493, name = "BFA"}, -- Hero's Path: Battle for Azeroth
	{id = 220, type = "flyout", iconId = 236798, name = "SL"}, -- Hero's Path: Shadowlands
	{id = 222, type = "flyout", iconId = 4062765}, -- Hero's Path: Shadowlands Raids
	{id = 227, type = "flyout", iconId = 4640496, name = "DF"}, -- Hero's Path: Dragonflight
	{id = 231, type = "flyout", iconId = 5342925}, -- Hero's Path: Dragonflight Raids
	{id = 232, type = "flyout", iconId = 5872031, name = "TWW"}, -- Hero's Path: The War Within
}

--------------------------------------
-- Texture Stuff
--------------------------------------

local function SetTextureByItemId(frame, itemId)
	frame:SetNormalTexture(DEFAULT_ICON) -- Temp while loading
	local item = Item:CreateFromItemID(itemId)
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
		print(APPEND..L["Missing Texture %s"]:format(itemId))
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
-- Functions
--------------------------------------

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

function tpm:updateAvailableBonusHeartstones()
	availableBonusHearthstones = {}
	for id, usable in pairs(bonusHearthstones) do
		if PlayerHasToy(id) then
			if type(usable) == "function" and usable() then
				table.insert(availableBonusHearthstones, id)
			elseif usable == true then
				table.insert(availableBonusHearthstones, id)
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
		[507] = 445424, -- Grim Batol
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

function tpm:CreateHerosPathFlyout(flyoutId, iconId, yOffset,name)
	if db.showOnlySeasonalHerosPath then return end
    local _, _, spells, flyoutKnown = GetFlyoutInfo(flyoutId)
    if not flyoutKnown then return end

    local button = CreateFrame("Button", nil, TeleportMeButtonsFrame, "SecureActionButtonTemplate")
    yOffset = yOffset or -40 * TeleportMeButtonsFrame:GetButtonAmount()
	print(yOffset)
    button:SetSize(40, 40)
    button:SetNormalTexture(iconId)
    button:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
    button:EnableMouse(true)
    button:RegisterForClicks("AnyDown", "AnyUp")
    button:SetFrameStrata("HIGH")
    button:SetFrameLevel(101)
    button:SetScript("OnEnter", function(self)
        if InCombatLockdown() then
            tpm:setCombatTooltip(self)
            return
        end
        tpm:setToolTip(self, "flyout", flyoutId)
        self.flyOutFrame:Show()
    end)
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

	if db.buttonText == true and name then
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)
		button.text:SetText(name)
		button.text:SetTextColor(1,1,1,1)
	end

    local flyOutFrame = CreateFrame("Frame", nil, TeleportMeButtonsFrame)
    flyOutFrame:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
    flyOutFrame:SetFrameStrata("HIGH")
    flyOutFrame:SetFrameLevel(103)
    flyOutFrame:SetPropagateMouseClicks(true)
    flyOutFrame:SetPropagateMouseMotion(true)
    flyOutFrame.mainButton = button
    flyOutFrame:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
        if not InCombatLockdown() then
            self:Hide()
        end
    end)
    flyOutFrame:Hide()
    button.flyOutFrame = flyOutFrame

    local flyOutButtons = {}
    local flyoutsCreated = 0

    -- Check if reverseMageFlyouts is enabled
    local reverseMageFlyouts = TeleportMenuDB.reverseMageFlyouts

    -- Function to create a flyout button
    local function createFlyOutButton(spellID, index)
        local spellName = C_Spell.GetSpellName(spellID)
        local spellTexture = C_Spell.GetSpellTexture(spellID)
        local flyOutButton = CreateFrame("Button", nil, flyOutFrame, "SecureActionButtonTemplate")
        flyOutButton:SetSize(40, 40)
        flyOutButton:SetNormalTexture(spellTexture)
        flyOutButton:SetAttribute("type", "spell")
        flyOutButton:SetAttribute("spell", spellID)
        flyOutButton:SetPoint("RIGHT", flyOutFrame, "LEFT", 40 + (40 * index), 0)
        flyOutButton:EnableMouse(true)
        flyOutButton:RegisterForClicks("AnyDown", "AnyUp")
        flyOutButton:SetFrameStrata("HIGH")
        flyOutButton:SetFrameLevel(102)
        flyOutButton:SetScript("OnEnter", function(self)
            tpm:setToolTip(self, "spell", spellID)
        end)
        flyOutButton:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
        flyOutButton.cooldownFrame = tpm:createCooldownFrame(flyOutButton)
        flyOutButton.cooldownFrame:CheckCooldown(spellID)
        flyOutButton:SetScript("OnShow", function(self)
            self.cooldownFrame:CheckCooldown(spellID)
        end)
        return flyOutButton
    end

    -- Loop through spells, either forwards or backwards based on the setting
    if reverseMageFlyouts and (flyoutId == 1 or flyoutId == 8 or flyoutId == 11 or flyoutId == 12) then
        for i = spells, 1, -1 do
			local flyname = nil
            local spellID = select(1, GetFlyoutSlotInfo(flyoutId, i))
            if IsSpellKnown(spellID) then
				for _,v in pairs(dungeons) do
					if v.id == spellID then
						flyname = v.name
					end
				end
                flyoutsCreated = flyoutsCreated + 1
                local flyOutButton = createFlyOutButton(spellID, flyoutsCreated)
				if db.buttonText == true and flyname then
					flyOutButton.text = flyOutButton:CreateFontString(nil, "OVERLAY")
					flyOutButton.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
					flyOutButton.text:SetPoint("BOTTOM", flyOutButton, "BOTTOM", 0, 5)
					flyOutButton.text:SetText(flyname)
					flyOutButton.text:SetTextColor(1,1,1,1)
				end
                table.insert(flyOutButtons, flyOutButton)
            end
        end
    else
        for i = 1, spells do
			local flyname = nil
            local spellID = select(1, GetFlyoutSlotInfo(flyoutId, i))
            if IsSpellKnown(spellID) then
				for _,v in pairs(dungeons) do
					if v.id == spellID then
						flyname = v.name
					end
				end
                flyoutsCreated = flyoutsCreated + 1
                local flyOutButton = createFlyOutButton(spellID, flyoutsCreated)
				if db.buttonText == true and flyname then
					flyOutButton.text = flyOutButton:CreateFontString(nil, "OVERLAY")
					flyOutButton.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
					flyOutButton.text:SetPoint("BOTTOM", flyOutButton, "BOTTOM", 0, 5)
					flyOutButton.text:SetText(flyname)
					flyOutButton.text:SetTextColor(1,1,1,1)
				end
                table.insert(flyOutButtons, flyOutButton)
            end
        end
    end

    flyOutFrame:SetSize(40 + (40 * flyoutsCreated), 40)
    button.flyOutButtons = flyOutButtons
    return button
end

function tpm:updateMageFlyouts()
    local teleportButton = TeleportMeButtonsFrame.mageTeleportButton
    local portalButton = TeleportMeButtonsFrame.magePortalButton
    local _, _, _, _, teleportYOffset = teleportButton:GetPoint()
    local _, _, _, _, portalYOffset = portalButton:GetPoint()

    if select(4, GetFlyoutInfo(12)) then -- Player is Alliance
        local updatedTeleportButton = tpm:CreateHerosPathFlyout(1, 237509, teleportYOffset)
        local updatedPortalButton = tpm:CreateHerosPathFlyout(11, 135748, portalYOffset)
    else -- Player is Horde
        local updatedTeleportButton = tpm:CreateHerosPathFlyout(8, 237509, teleportYOffset)
        local updatedPortalButton = tpm:CreateHerosPathFlyout(12, 135748, portalYOffset)
    end

    TeleportMeButtonsFrame.mageTeleportButton = updatedTeleportButton
    TeleportMeButtonsFrame.magePortalButton = updatedPortalButton
end

function tpm:CreateSeasonalTeleportFlyout()
	if #availableSeasonalTeleports == 0 then return end

	local button = CreateFrame("Button", nil, TeleportMeButtonsFrame, "SecureActionButtonTemplate")
	local yOffset = -40 * TeleportMeButtonsFrame:GetButtonAmount()
	button:SetSize(40, 40)
	button:SetNormalTexture(5927657) -- Xal'atath Devour Affix Icon
	button:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetFrameStrata("HIGH")
	button:SetFrameLevel(101)
	button:SetScript("OnEnter", function(self)
		if InCombatLockdown() then
			tpm:setCombatTooltip(self)
			return
		end
		tpm:setToolTip(self, "seasonalteleport")
		self.flyOutFrame:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	if db.buttonText == true then
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)
		button.text:SetText("S1")
		button.text:SetTextColor(1,1,1,1)
	end

	local flyOutFrame = CreateFrame("Frame", nil, TeleportMeButtonsFrame)
	flyOutFrame:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	flyOutFrame:SetFrameStrata("HIGH")
	flyOutFrame:SetFrameLevel(103)
	flyOutFrame:SetPropagateMouseClicks(true)
	flyOutFrame:SetPropagateMouseMotion(true)
	flyOutFrame.mainButton = button
	flyOutFrame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		if not InCombatLockdown() then
			self:Hide()
		end
	end)
	flyOutFrame:Hide()
	button.flyOutFrame = flyOutFrame

	local flyOutButtons = {}
	local flyoutsCreated = 0
	for _, spellID in ipairs(availableSeasonalTeleports) do
		local flyname = nil
		if IsSpellKnown(spellID) then

			for _,v in pairs(dungeons) do
				if v.id == spellID then
					flyname = v.name
				end
			end

			flyoutsCreated = flyoutsCreated + 1
			local xOffset = 40 * flyoutsCreated
			local spellName = C_Spell.GetSpellName(spellID)
			local spellTexture = C_Spell.GetSpellTexture(spellID)
			local flyOutButton = CreateFrame("Button", nil, flyOutFrame," SecureActionButtonTemplate")
			flyOutButton:SetSize(40, 40)
			flyOutButton:SetNormalTexture(spellTexture)
			flyOutButton:SetAttribute("type", "spell")
			flyOutButton:SetAttribute("spell", spellID)
			flyOutButton:SetPoint("RIGHT", flyOutFrame, "LEFT", 40 + xOffset, 0)
			flyOutButton:EnableMouse(true)
			flyOutButton:RegisterForClicks("AnyDown", "AnyUp")
			flyOutButton:SetFrameStrata("HIGH")
			flyOutButton:SetFrameLevel(102)
			flyOutButton:SetScript("OnEnter", function(self)
				tpm:setToolTip(self, "spell", spellID)
			end)
			flyOutButton:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			flyOutButton.cooldownFrame = tpm:createCooldownFrame(flyOutButton)
			flyOutButton.cooldownFrame:CheckCooldown(spellID)
			flyOutButton:SetScript("OnShow", function(self)
				self.cooldownFrame:CheckCooldown(spellID)
			end)

			if db.buttonText == true and flyname then
				flyOutButton.text = flyOutButton:CreateFontString(nil, "OVERLAY")
				flyOutButton.text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
				flyOutButton.text:SetPoint("BOTTOM", flyOutButton, "BOTTOM", 0, 5)
				flyOutButton.text:SetText(flyname)
				flyOutButton.text:SetTextColor(1,1,1,1)
			end
			
			table.insert(flyOutButtons, flyOutButton)
		end
	end
	flyOutFrame:SetSize(40 + (40 * flyoutsCreated), 40)

	button.flyOutButtons = flyOutButtons
	return button
end


function tpm:CreateWormholeFlyout(iconId)
	if #availableWormholes == 0 then return end
	local button = CreateFrame("Button", nil, TeleportMeButtonsFrame, "SecureActionButtonTemplate")
	local yOffset = -40 * TeleportMeButtonsFrame:GetButtonAmount()
	button:SetSize(40, 40)
	button:SetNormalTexture(iconId)
	button:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetFrameStrata("HIGH")
	button:SetFrameLevel(101)
	button:SetScript("OnEnter", function(self)
		if InCombatLockdown() then
			tpm:setCombatTooltip(self)
			return
		end
		tpm:setToolTip(self, "profession", 202) -- Engineering
		self.flyOutFrame:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	local flyOutFrame = CreateFrame("Frame", nil, TeleportMeButtonsFrame)
	flyOutFrame:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	flyOutFrame:SetFrameStrata("HIGH")
	flyOutFrame:SetFrameLevel(103)
	flyOutFrame:SetPropagateMouseClicks(true)
	flyOutFrame:SetPropagateMouseMotion(true)
	flyOutFrame.mainButton = button
	flyOutFrame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		if not InCombatLockdown() then
			self:Hide()
		end
	end)
	flyOutFrame:Hide()
	button.flyOutFrame = flyOutFrame

	local flyOutButtons = {}
	local flyoutsCreated = 0
	for _, wormholeId in ipairs(availableWormholes) do
		local flyOutButton = CreateFrame("Button", nil, flyOutFrame," SecureActionButtonTemplate")
		local xOffset = 40 + (40 * flyoutsCreated)
		flyOutButton:SetSize(40, 40)
		SetTextureByItemId(flyOutButton, wormholeId) -- async load texture
		flyOutButton:SetAttribute("type", "toy")
		flyOutButton:SetAttribute("toy", wormholeId)
		flyOutButton:SetPoint("RIGHT", flyOutFrame, "LEFT", 40 + xOffset, 0)
		flyOutButton:EnableMouse(true)
		flyOutButton:RegisterForClicks("AnyDown", "AnyUp")
		flyOutButton:SetFrameStrata("HIGH")
		flyOutButton:SetFrameLevel(102)
		flyOutButton:SetScript("OnEnter", function(self)
			tpm:setToolTip(self, "toy", wormholeId)
		end)
		flyOutButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		flyOutButton.cooldownFrame = tpm:createCooldownFrame(flyOutButton)
		flyOutButton.cooldownFrame:CheckCooldown(wormholeId, "toy")
		flyOutButton:SetScript("OnShow", function(self)
			self.cooldownFrame:CheckCooldown(wormholeId, "toy")
		end)
		table.insert(flyOutButtons, flyOutButton)
		flyoutsCreated = flyoutsCreated + 1
	end
	flyOutFrame:SetSize(40 + (40 * flyoutsCreated), 40)

	button.flyOutButtons = flyOutButtons
	return button
end

function tpm:CreateBonusHearthstoneFlyout(iconId)
	if #availableBonusHearthstones == 0 then return end
	local button = CreateFrame("Button", nil, TeleportMeButtonsFrame, "SecureActionButtonTemplate")
	local yOffset = -40 * TeleportMeButtonsFrame:GetButtonAmount()
	button:SetSize(40, 40)
	button:SetNormalTexture(iconId)
	button:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetFrameStrata("HIGH")
	button:SetFrameLevel(101)
	button:SetScript("OnEnter", function(self)
		if InCombatLockdown() then
			tpm:setCombatTooltip(self)
			return
		end
		tpm:setToolTip(self, "bonusheartsones")
		self.flyOutFrame:Show()
	end)
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	local flyOutFrame = CreateFrame("Frame", nil, TeleportMeButtonsFrame)
	flyOutFrame:SetPoint("TOPLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, yOffset)
	flyOutFrame:SetFrameStrata("HIGH")
	flyOutFrame:SetFrameLevel(103)
	flyOutFrame:SetPropagateMouseClicks(true)
	flyOutFrame:SetPropagateMouseMotion(true)
	flyOutFrame.mainButton = button
	flyOutFrame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		if not InCombatLockdown() then
			self:Hide()
		end
	end)
	flyOutFrame:Hide()
	button.flyOutFrame = flyOutFrame

	local flyOutButtons = {}
	local flyoutsCreated = 0
	for _, toyId in ipairs(availableBonusHearthstones) do
		local flyOutButton = CreateFrame("Button", nil, flyOutFrame," SecureActionButtonTemplate")
		local xOffset = 40 + (40 * flyoutsCreated)
		flyOutButton:SetSize(40, 40)
		SetTextureByItemId(flyOutButton, toyId) -- async load texture
		flyOutButton:SetAttribute("type", "toy")
		flyOutButton:SetAttribute("toy", toyId)
		flyOutButton:SetPoint("RIGHT", flyOutFrame, "LEFT", 40 + xOffset, 0)
		flyOutButton:EnableMouse(true)
		flyOutButton:RegisterForClicks("AnyDown", "AnyUp")
		flyOutButton:SetFrameStrata("HIGH")
		flyOutButton:SetFrameLevel(102)
		flyOutButton:SetScript("OnEnter", function(self)
			tpm:setToolTip(self, "toy", toyId)
		end)
		flyOutButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		flyOutButton.cooldownFrame = tpm:createCooldownFrame(flyOutButton)
		flyOutButton.cooldownFrame:CheckCooldown(toyId, "toy")
		flyOutButton:SetScript("OnShow", function(self)
			self.cooldownFrame:CheckCooldown(toyId, "toy")
		end)
		table.insert(flyOutButtons, flyOutButton)
		flyoutsCreated = flyoutsCreated + 1
	end
	flyOutFrame:SetSize(40 + (40 * flyoutsCreated), 40)

	button.flyOutButtons = flyOutButtons
	return button
end


function tpm:setCombatTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, 0)
	GameTooltip:SetText(L["Not In Combat Tooltip"], 1, 1, 1)
	GameTooltip:Show()
end

function tpm:setToolTip(self, type, id, hs)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, 0)
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
	elseif type == "bonusheartsones" then
		GameTooltip:SetText(L["Bonus Hearthstones"], 1, 1, 1)
		GameTooltip:AddLine(L["Bonus Hearthstones Tooltip"], 1, 1, 1)
	elseif type == "seasonalteleport" then
		GameTooltip:SetText(L["Seasonal Teleports"], 1, 1, 1)
		GameTooltip:AddLine(L["Seasonal Teleports Tooltip"], 1, 1, 1)
	end
	GameTooltip:Show()
end

function tpm:createCooldownFrame(frame)
	if frame.cooldownFrame then return frame.cooldownFrame end
    local cooldownFrame = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    cooldownFrame:SetAllPoints()

	function cooldownFrame:CheckCooldown(id, type)
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

function tpm:updateHearthstone()
	local hearthstoneButton = TeleportMeButtonsFrame.hearthstoneButton
	if not hearthstoneButton then return end
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
	else
		if GetItemCount(6948) == 0 then
			print(APPEND..L["No Hearthtone In Bags"])
			hearthstoneButton:Hide()
			return
		end
		SetTextureByItemId(hearthstoneButton, 6948)
		hearthstoneButton:SetAttribute("type", "item")
		hearthstoneButton:SetAttribute("item", "item:6948")
	end
	hearthstoneButton:Show()
end

function tpm:GetRandomHearthstone(retry)
	if #availableHearthstones == 0 then return end
	if #availableHearthstones == 1 then return availableHearthstones[1] end -- Don't even bother
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
	elseif TeleportMeButtonsFrame then
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
	if not db.enabled then return end
	local buttonsFrame = CreateFrame("Frame", "TeleportMeButtonsFrame", GameMenuFrame)
	buttonsFrame:SetSize(1, 1)
	buttonsFrame:SetPoint("TOPLEFT", GameMenuFrame, "TOPRIGHT", 0, 0)

	TeleportMeButtonsFrame.buttonAmount = 0
	function buttonsFrame:IncrementButtons()
		TeleportMeButtonsFrame.buttonAmount = TeleportMeButtonsFrame.buttonAmount + 1
	end

	function buttonsFrame:GetButtonAmount()
		return TeleportMeButtonsFrame.buttonAmount
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
		elseif teleport.type == "item" and GetItemCount(teleport.id) > 0 then
			local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(teleport.id)
        	texture = itemTexture
			known = true
		elseif teleport.type == "toy" and PlayerHasToy(teleport.id) then
			local _, name, iconId = C_ToyBox.GetToyInfo(teleport.id)
			texture = iconId
			if teleport.quest then
				known = tpm:checkQuestCompletion(teleport.quest)
			else
				known = true
			end
		elseif teleport.type == "spell" and IsSpellKnown(teleport.id) then
			texture = C_Spell.GetSpellTexture(teleport.id)
			known = true
		end

		if not known and teleport.hearthstone then -- Player has no HS in bags and not set a custom TP.
			print(APPEND..L["No Hearthtone In Bags"])
		end

		-- Create Stuff
		if known and (teleport.type == "toy" or teleport.type == "item" or teleport.type == "spell") then
			tpm:DebugPrint(teleport.hearthstone)
			local button = CreateFrame("Button", nil, buttonsFrame," SecureActionButtonTemplate")
			local yOffset = -40 * TeleportMeButtonsFrame:GetButtonAmount()
			button:SetSize(40, 40)
			if not texture then
				C_Timer.After(0.7, function()
					retrySetNormalTexture(button, teleport.id)
				end)
				texture = DEFAULT_ICON
			end
			button:SetNormalTexture(texture)
			if teleport.type == "item" then
				button:SetAttribute("type", teleport.type)
				button:SetAttribute(teleport.type, "item:"..teleport.id)
			else
				button:SetAttribute("type", teleport.type)
				button:SetAttribute(teleport.type, teleport.id)
			end
			button:SetPoint("TOPLEFT", buttonsFrame, "TOPRIGHT", 0, yOffset)
			button:EnableMouse(true)
			button:RegisterForClicks("AnyDown", "AnyUp")
			button:SetFrameStrata("HIGH")
			button:SetFrameLevel(101)
			button.cooldownFrame = tpm:createCooldownFrame(button)
			button.cooldownFrame:CheckCooldown(teleport.id, teleport.type)
			button:SetScript("OnEnter", function(self)
				tpm:setToolTip(self, teleport.type, teleport.id, teleport.hearthstone)
			end)
			button:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			button:SetScript("OnShow", function(self)
				self.cooldownFrame:CheckCooldown(teleport.id, teleport.type)
			end)

			if teleport.hearthstone then -- store to replace item later
				buttonsFrame.hearthstoneButton = button
			end
			TeleportMeButtonsFrame:IncrementButtons()
		elseif teleport.type == "wormholes" then
			local created = tpm:CreateWormholeFlyout(teleport.iconId)
			if created then
				TeleportMeButtonsFrame:IncrementButtons()
			end
		elseif teleport.type == "bonusheartsones" then
			local created = tpm:CreateBonusHearthstoneFlyout(teleport.iconId)
			if created then
				TeleportMeButtonsFrame:IncrementButtons()
			end
		elseif teleport.type == "flyout" then
			local created = tpm:CreateHerosPathFlyout(teleport.id, teleport.iconId, nil ,teleport.name or nil)
			if created then
				-- Save Teleport button for replacement later
				if teleport.id == 1 or teleport.id == 8 then
					buttonsFrame.mageTeleportButton = created
				end
				-- Save Portal button for replacement later
				if teleport.id == 11 or teleport == 12 then
					buttonsFrame.magePortalButton = created
				end
					

				TeleportMeButtonsFrame:IncrementButtons()
			end
		end
	end

	function CreateCurrentSeasonTeleports()
		local created = tpm:CreateSeasonalTeleportFlyout()
		if created then
			TeleportMeButtonsFrame:IncrementButtons()
		end
	end

	CreateCurrentSeasonTeleports()
end

-- Slash Commands
SLASH_TPMENU1 = "/tpm"
SLASH_TPMENU2 = "/tpmenu"
SlashCmdList["TPMENU"] = function(msg)
	if msg == "current" then
		if db.hearthstone == "none" then
			print(APPEND..L["No alternative Hearthstone"])
		else
			print(APPEND..L["Current Hearthstone"]:format(db.hearthstone))
		end
		return
	end

	if msg == "clear" then
		if not InCombatLockdown() then
			db.hearthstone = "none"
			tpm:updateHearthstone()
			print(APPEND..L["Hearthstone Reset"])
		else
			print(APPEND..L["Not In Combat Print"])
		end
		return
	end

	if msg == "list" then
		print(APPEND..L["Available Hearthstones Print"])
		for id, _ in pairs(hearthstoneToys) do
			if PlayerHasToy(id) then
				local _, name = C_ToyBox.GetToyInfo(id)
				print(id.." - "..name)
			end
		end
		return
	end

	if msg == "rng" then
		if not availableHearthstones or #availableHearthstones == 0 then
			print(APPEND..L["No Hearthone Toys"])
			return
		end
		db.hearthstone = msg
		print(APPEND..L["Hearthstone Random Set"])
		tpm:updateHearthstone()
		return
	end

    local id = tonumber(msg)
	if id and hearthstoneToys[id] and PlayerHasToy(id) then
		local _, name = C_ToyBox.GetToyInfo(id)
		db.hearthstone = id
		tpm:updateHearthstone()
		print(APPEND..L["New Hearthstone Set"]:format(name))
	else
		print(APPEND..L["Available Commands"])
		print(L["List Command"])
		print(L["Current Command"])
		print(L["Clear Command"])
		print(L["ItemId Command"])
		print(L["Rng Command"])
		Settings.OpenToCategory(tpm:GetOptionsCategory())
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
		for _, itemId in ipairs(itemTable) do
			self.continuableContainer:AddContinuable(Item:CreateFromItemID(itemId))
		end
	end

	LoadItems(hearthstoneToys)
	LoadItems(wormholes)
	LoadItems(bonusHearthstones)

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
	tpm:updateAvailableHearthstones()
	tpm:updateAvailableBonusHeartstones()
	tpm:updateAvailableWormholes()
	tpm:updateAvailableSeasonalTeleport()

	if db.hearthstone and db.hearthstone ~= "rng" and db.hearthstone ~= "none" and not PlayerHasToy(db.hearthstone) then
		print(APPEND..L["Hearthone Reset Error"]:format(db.hearthstone))
		db.hearthstone = "none"
		tpm:updateHearthstone()
	end

	createAnchors()
	hooksecurefunc("ToggleGameMenu", createAnchors)
end

local function OnEvent(self, event, addOnName)
	if addOnName == "TeleportMenu" then
		db = TeleportMenuDB or {}
		TeleportMenuDB = db
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
	if not db.debug then return end
	print(APPEND, ...)
end
