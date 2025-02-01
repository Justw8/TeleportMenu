local _, tpm = ...

function tpm:GetAvailableItemTeleports()
	return tpm.AvailableItemTeleports
end

function tpm:UpdateAvailableItemTeleports()
	AvailableItemTeleports = {}
	for _, id in ipairs(tpm.ItemTeleports) do
		if C_Item.GetItemCount(id) > 0 and TeleportMenuDB[id] == true then
			table.insert(AvailableItemTeleports, id)
		end
	end
	tpm.AvailableItemTeleports = AvailableItemTeleports
end