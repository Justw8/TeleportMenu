local _, tpm = ...

function tpm:GetAvailableItemTeleports()
	return tpm.AvailableItemTeleports
end

local cachedToys = {}
function tpm:IsToyTeleport(id)
	return cachedToys[id] or false
end

function tpm:UpdateAvailableItemTeleports()
	local AvailableItemTeleports = {}

	for id, _ in pairs(tpm.ItemTeleports) do
		local hasItem = (C_Item.GetItemCount(id) or 0) > 0
		local isToy = select(1, C_ToyBox.GetToyInfo(id)) ~= nil
		local usableToy = isToy and PlayerHasToy(id)
		if (hasItem or usableToy) and TeleportMenuDB[id] == true then
			cachedToys[id] = isToy
			table.insert(AvailableItemTeleports, id)
		end
	end

	tpm.AvailableItemTeleports = AvailableItemTeleports
end
