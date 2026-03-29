local _, tpm = ...

local push, sort = table.insert, table.sort

--- @alias Item { id: integer, name: string, icon: integer }
--- @class Player
--- @field items_in_possession Item[]
--- @field items_to_be_obtained Item[]
tpm.player = {
	items_in_possession = {},
	items_to_be_obtained = {},
}

--- @param item_id integer
function tpm:AddItemToPossession(item_id)
	for key, item in pairs(tpm.player.items_to_be_obtained) do
		if item.id == item_id then
			push(tpm.player.items_in_possession, item)
			if #tpm.player.items_in_possession > 1 then
				sort(tpm.player.items_in_possession, function(a, b)
					if not a or not b or not a.name or not b.name then
						return false
					end
					return a.name < b.name
				end)
			end

			table.remove(tpm.player.items_to_be_obtained, key)
			local viewObtained  = tpm.settings.scroll_box_views["items_to_be_obtained"]
			local viewPossession = tpm.settings.scroll_box_views["items_in_possession"]
			if viewObtained  then viewObtained:SetDataProvider(CreateDataProvider(tpm.player.items_to_be_obtained)) end
			if viewPossession then viewPossession:SetDataProvider(CreateDataProvider(tpm.player.items_in_possession)) end
			tpm:UpdateAvailableItemTeleports()
			tpm:ReloadFrames()
			break
		end
	end
end

--- @param item_id integer
function tpm:RemoveItemFromPossession(item_id)
	for key, item in pairs(tpm.player.items_in_possession) do
		if item.id == item_id then
			push(tpm.player.items_to_be_obtained, item)
			if #tpm.player.items_to_be_obtained > 1 then
				sort(tpm.player.items_to_be_obtained, function(a, b)
					if not a or not b or not a.name or not b.name then
						return false
					end
					return a.name < b.name
				end)
			end

			table.remove(tpm.player.items_in_possession, key)
			local viewObtained  = tpm.settings.scroll_box_views["items_to_be_obtained"]
			local viewPossession = tpm.settings.scroll_box_views["items_in_possession"]
			if viewObtained  then viewObtained:SetDataProvider(CreateDataProvider(tpm.player.items_to_be_obtained)) end
			if viewPossession then viewPossession:SetDataProvider(CreateDataProvider(tpm.player.items_in_possession)) end
			tpm:UpdateAvailableItemTeleports()
			tpm:ReloadFrames()
			break
		end
	end
end
