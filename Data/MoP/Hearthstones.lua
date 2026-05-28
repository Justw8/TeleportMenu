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

do
	local lastRandomHearthstone = nil
	function tpm:GetRandomHearthstone(retry)
		if #tpm.AvailableHearthstones == 0 then
			return
		end
		if #tpm.AvailableHearthstones == 1 then
			return tpm.AvailableHearthstones[1]
		end -- Don't even bother
		local randomHs = tpm.AvailableHearthstones[math.random(#tpm.AvailableHearthstones)]
		if lastRandomHearthstone == randomHs then -- Don't fully randomize, always a new one
			randomHs = self:GetRandomHearthstone(true) --[[@as integer]]
		end
		if not retry then
			lastRandomHearthstone = randomHs
		end
		return randomHs
	end
end
