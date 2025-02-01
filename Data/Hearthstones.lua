local _, tpm = ...

AvailableHearthstones = {}

function tpm:GetAvailableHearthstoneToys()
	local hearthstoneNames = {}
	for _, toyId in pairs(AvailableHearthstones) do
		local _, name, texture = C_ToyBox.GetToyInfo(toyId)
		if not texture then
			texture = tpm.FRAME_CONSTANTS.DEFAULT_ICON
		end
		if not name then
			name = tostring(toyId)
		end
		hearthstoneNames[toyId] = {name = name, texture = texture}
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

function tpm:GetRandomHearthstone(retry)
    local lastRandomHearthstone
    if #tpm.AvailableHearthstones == 0 then
		return
	end
	if #tpm.AvailableHearthstones == 1 then
		return tpm.AvailableHearthstones[1]
	end -- Don't even bother
	local randomHs = tpm.AvailableHearthstones[math.random(#tpm.AvailableHearthstones)]
	if lastRandomHearthstone == randomHs then -- Don't fully randomize, always a new one
		randomHs = self:GetRandomHearthstone(true)
	end
	if not retry then
		lastRandomHearthstone = randomHs
	end
	return randomHs
end
