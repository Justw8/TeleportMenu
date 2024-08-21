local _, addonTbl = ...

local validHearthstoneToys = {
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
	[180290] = true, -- Night Fae Hearthstone
	[182773] = true, -- Necrolord Hearthstone
	[183716] = true, -- Venthyr Sinstone
	[184353] = true, -- Kyrian Hearthstone
	[188952] = true, -- Dominated Hearthstone
	[190196] = true, -- Enlightened Hearthstone
	[190237] = true, -- Broker Translocation Matrix
	[193588] = true, -- Timewalker's Hearthstone x
	[200630] = true, -- Ohnir Windsage's Hearthstone x
	[206195] = true, -- Path of the Naaru
	[208704] = true, -- Deepdweller's Earthen Hearthstone x
	[209035] = true, -- Hearthstone of the Flame x
	[210455] = true, -- Draenic Hologem
	[212337] = true, -- Stone of the Hearth
}

local toyTable = {
	{id = 6948, type = "item", hearthstone = true}, -- Hearthstone
	{id = 110560, type = "toy"}, -- Garrison Hearthstone
	{id = 140192, type = "toy"}, -- Dalaran Hearthstone
	{id = 230, type = "flyout", iconId = 574788}, -- Hero's Path: Cataclysm
	{id = 84, type = "flyout", iconId = 626190}, -- Hero's Path: Mists of Pandaria
	{id = 96, type = "flyout", iconId = 896622}, -- Hero's Path: Warlords of Draenor
	{id = 223, type = "flyout", iconId = 2967107}, -- Hero's Path: Battle for Azeroth
	{id = 224, type = "flyout", iconId = 237559}, -- Hero's Path: Legion
	{id = 220, type = "flyout", iconId = 2998183}, -- Hero's Path: Shadowlands
	{id = 222, type = "flyout", iconId = 4254080}, -- Hero's Path: Shadowlands Raids
	{id = 227, type = "flyout", iconId = 4640496}, -- Hero's Path: Dragonflight
	{id = 231, type = "flyout", iconId = 5342925}, -- Hero's Path: Dragonflight Raids
	--{id = 233, type = "flyout", iconId = 5872031}, -- Hero's Path: The War Within
}

local function setCombatTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, 0)
	GameTooltip:SetText("\124cFFFF0000<Not available in combat>\124r", 1, 1, 1)
	GameTooltip:Show()
end

local function setToolTip(self, type, id)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrame, "TOPRIGHT", 0, 0)
	if type == "item" then
		GameTooltip:SetItemByID(id)
	elseif type == "spell" then
		GameTooltip:SetSpellByID(id)
	elseif type == "flyout" then
		local name = GetFlyoutInfo(id)
		GameTooltip:SetText(name, 1, 1, 1)
	end
	GameTooltip:Show()
end

local function createCooldownFrame(frame)
	if frame.cooldownFrame then return frame.cooldownFrame end
    local cooldownFrame = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
    cooldownFrame:SetAllPoints()

	function cooldownFrame:CheckCooldown(id, type)
		local start, duration, enabled
		if type == "toy" or type == "item" then
			start, duration, enabled = GetItemCooldown(id)
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

local function createAnchors()
	if InCombatLockdown() or TeleportMeButtonsFrame then return end
	local buttonsFrame = CreateFrame("Frame", "TeleportMeButtonsFrame", GameMenuFrame)
	buttonsFrame:SetSize(1, 1)
	buttonsFrame:SetPoint("TOPLEFT", GameMenuFrame, "TOPRIGHT", 0, 0)

	local created = 0
	for i, toy in ipairs(toyTable) do
		if toy.hearthstone and TeleportMenuDB.hearthstone then -- Overwrite main HS with user set HS
			toy.id = TeleportMenuDB.hearthstone
			toy.type = "toy"
		end
		local texture
		local known
		local flyOutSpellsKnown
		if toy.type == "item" then
			local _, _, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(toy.id)
        	texture = itemTexture
			known = GetItemCount(toy.id) > 0
		elseif toy.type == "toy" and PlayerHasToy(toy.id) then
			local _, name, iconId = C_ToyBox.GetToyInfo(toy.id)
			texture = iconId
			known = true
		elseif toy.type == "flyout" then
			local name, desc, amount, flyoutKnown = GetFlyoutInfo(toy.id)
			if flyoutKnown then
				flyOutSpellsKnown = amount
				texture = toy.iconId
				known = flyoutKnown
			end
		end
		if known and (toy.type == "toy" or toy.type == "item") then
			created = created + 1
			local button = CreateFrame("Button", nil, buttonsFrame," SecureActionButtonTemplate");
			local yOffset = 40 + (-40 * created)
			button:SetSize(40, 40)
			button:SetNormalTexture(texture)
			if toy.type == "item" then
				button:SetAttribute("type", toy.type)
				button:SetAttribute(toy.type, "item:"..toy.id)
			else
				button:SetAttribute("type", toy.type)
				button:SetAttribute(toy.type, toy.id)
			end
			button:SetPoint("TOPLEFT", buttonsFrame, "TOPRIGHT", 0, yOffset)
			button:EnableMouse(true)
			button:RegisterForClicks("AnyDown")
			button:SetFrameStrata("HIGH")
			button:SetFrameLevel(101)
			button.cooldownFrame = createCooldownFrame(button)
			button.cooldownFrame:CheckCooldown(toy.id, toy.type)
			button:SetScript("OnEnter", function(self)
				setToolTip(self, "item", toy.id)
			end)
			button:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)
			button:SetScript("OnShow", function(self)
				self.cooldownFrame:CheckCooldown(toy.id, toy.type)
			end)

		elseif known and toy.type == "flyout" then
			created = created + 1
			local button = CreateFrame("Button", nil, buttonsFrame, "SecureActionButtonTemplate");
			local yOffset = 40 + (-40 * created)
			button:SetSize(40, 40)
			button:SetNormalTexture(texture)
			button:SetPoint("TOPLEFT", buttonsFrame, "TOPRIGHT", 0, yOffset)
			button:EnableMouse(true)
			button:RegisterForClicks("AnyDown")
			button:SetFrameStrata("HIGH")
			button:SetFrameLevel(101)
			button:SetScript("OnEnter", function(self)
				if InCombatLockdown() then
					setCombatTooltip(self)
					return
				end
				setToolTip(self, "flyout", toy.id)
				self.flyOutFrame:Show()
			end)
			button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)

			local flyOutFrame = CreateFrame("Frame", nil, buttonsFrame);
			flyOutFrame:SetPoint("TOPLEFT", buttonsFrame, "TOPRIGHT", 0, yOffset)
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
			for i = 1, flyOutSpellsKnown do
				local spellID = select(1, GetFlyoutSlotInfo(toy.id, i))
				if IsSpellKnown(spellID) then
					flyoutsCreated = flyoutsCreated + 1
					local xOffset = 40 * flyoutsCreated
					local spellName = C_Spell.GetSpellName(spellID)
					local spellTexture = C_Spell.GetSpellTexture(spellID)
					local flyOutButton = CreateFrame("Button", nil, flyOutFrame," SecureActionButtonTemplate");
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
						setToolTip(self, "spell", spellID)
					end)
					flyOutButton:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
					flyOutButton.cooldownFrame = createCooldownFrame(flyOutButton)
					flyOutButton.cooldownFrame:CheckCooldown(spellID)
					flyOutButton:SetScript("OnShow", function(self)
						self.cooldownFrame:CheckCooldown(spellID)
					end)
					table.insert(flyOutButtons, flyOutButton)
				end
			end

			flyOutFrame:SetSize(40 + (40 * flyoutsCreated), 40)

			button.flyOutButtons = flyOutButtons
		end
	end

	buttonsFrame:Show()
end

-- Slash Commands
local APPEND = "\124cFFFF0000TeleportMenu:\124r "
SLASH_TPMENU1 = "/tp"
SLASH_TPMENU2 = "/tpmenu"
SlashCmdList["TPMENU"] = function(msg)
	if msg == "list" then
		print(APPEND.."Available Hearthstone toys: [id - name]")
		for id, _ in pairs(validHearthstoneToys) do
			if PlayerHasToy(id) then
				local _, name = C_ToyBox.GetToyInfo(id)
				print(id.." - "..name)
			end
		end
		return
	end

    local id = tonumber(msg)
	if id and validHearthstoneToys[id] and PlayerHasToy(id) then
		local _, name = C_ToyBox.GetToyInfo(id)
		TeleportMenuDB.hearthstone = id
		local msg = "New Hearthstone set to: "..name.."!"
		if TeleportMeButtonsFrame then
			msg = msg + "\nPlease reloadui or relog for it to take effect."
		end
		print(APPEND..msg)
	else
		print(APPEND.."Available Commands:")
		print("/tp list - List all valid Hearthstone toys in your collection.")
		print("/tp [itemId] - Set a valid Hearthstone toy as your alternative Hearthstone.")
	end
end

-- Loading
local function OnEvent(self, event, addOnName)
	if addOnName == "TeleportMenu" then
		TeleportMenuDB = TeleportMenuDB or {}
		if TeleportMenuDB.hearthstone and not PlayerHasToy(TeleportMenuDB.hearthstone) then
			print(APPEND.."We reset your heartstone to default because the toy with itemID: "..TeleportMenuDB.hearthstone.." is not in your collection.")
			TeleportMenuDB.hearthstone = nil
		end
		createAnchors()
		hooksecurefunc("ToggleGameMenu", createAnchors)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", OnEvent)
