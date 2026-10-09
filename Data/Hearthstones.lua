local _, tpm = ...

local AvailableHearthstones = {}
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

--- @type { [integer]: boolean|fun(): boolean|nil }
tpm.Hearthstones = {
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
	[228940] = true, -- Notorious Thread's Hearthstone
	[236687] = true, -- Explosive Hearthstone
	[235016] = true, -- Redeployment Module
	[245970] = true, -- P.O.S.T. Master's Express Hearthstone
	[246565] = true, -- Cosmic Hearthstone
	[257736] = true, -- Lightcalled Hearthstone
	[263489] = true, -- Naaru's Enfold
	[263933] = true, -- Preyseeker's Hearthstone
	[264367] = true, -- Mycomancer's Hearthspore
	[265100] = true, -- Corewarden's Hearthstone
	[281615] = true, -- Shadeweaver's Hearthstone
}

function tpm:GetAvailableHearthstoneToys()
	local hearthstoneNames = {}
	for _, toyId in pairs(AvailableHearthstones) do
		--- @type unknown, string, string | integer
		local _, name, texture = C_ToyBox.GetToyInfo(toyId)
		if not texture then
			texture = "Interface\\Icons\\inv_hearthstonepet"
		end
		if not name then
			name = tostring(toyId)
		end
		hearthstoneNames[toyId] = { name = name, texture = texture }
	end
	return hearthstoneNames
end

function tpm:UpdateAvailableHearthstones()
	AvailableHearthstones = {}
	for id, usable in pairs(tpm.Hearthstones) do
		if PlayerHasToy(id) then
			if type(usable) == "function" and usable() then
				table.insert(AvailableHearthstones, id)
			elseif usable == true then
				table.insert(AvailableHearthstones, id)
			end
		end
	end
	tpm.AvailableHearthstones = AvailableHearthstones
end

--------------------------------------
-- Random Hearthstone Pool
--------------------------------------

local RANDOM_EXCLUDED_KEY = "Teleports:Hearthstone:Random:Excluded"

-- Hearthstones the player excluded from the random pick, as { [toyId] = true }.
-- Stored as exclusions so newly collected hearthstones are included by default.
function tpm:GetRandomHearthstoneExclusions()
	local settingsDB = tpm:GetSettingsDB()
	local excluded = settingsDB[RANDOM_EXCLUDED_KEY]
	if type(excluded) ~= "table" then
		excluded = {}
		settingsDB[RANDOM_EXCLUDED_KEY] = excluded
	end
	return excluded
end

function tpm:IsHearthstoneInRandomPool(id)
	return not tpm:GetRandomHearthstoneExclusions()[id]
end

function tpm:SetHearthstoneInRandomPool(id, included)
	tpm:GetRandomHearthstoneExclusions()[id] = (not included) or nil
end

function tpm:ResetRandomHearthstonePool()
	wipe(tpm:GetRandomHearthstoneExclusions())
end

-- Available hearthstones that may be picked at random. Falls back to all of them
-- when everything is excluded, so the random button keeps working.
function tpm:GetRandomHearthstonePool()
	local pool = {}
	for _, id in ipairs(tpm.AvailableHearthstones) do
		if tpm:IsHearthstoneInRandomPool(id) then
			table.insert(pool, id)
		end
	end
	if #pool == 0 then
		return tpm.AvailableHearthstones
	end
	return pool
end

do
	local lastRandomHearthstone = nil
	function tpm:GetRandomHearthstone(retry)
		if #tpm.AvailableHearthstones == 0 then
			-- Toy data can be unavailable for a while (e.g. after a loading screen) without a
			-- TOYS_UPDATED afterwards, so check the toys again instead of staying empty.
			tpm:UpdateAvailableHearthstones()
		end
		local pool = tpm:GetRandomHearthstonePool()
		if #pool == 0 then
			return
		end
		if #pool == 1 then
			return pool[1]
		end -- Don't even bother
		local randomHs = pool[math.random(#pool)]
		if lastRandomHearthstone == randomHs then -- Don't fully randomize, always a new one
			randomHs = self:GetRandomHearthstone(true) --[[@as integer]]
		end
		if not retry then
			lastRandomHearthstone = randomHs
		end
		return randomHs
	end
end
