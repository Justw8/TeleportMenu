local _, tpm = ...

local push, sort = table.insert, sort

--- @alias Item { id: integer, name: string, icon: integer }
--- @class Player
--- @field items_in_possession Item[]
--- @field items_to_be_obtained Item[]
tpm.player = {
	items_in_possession = {},
	items_to_be_obtained = {},
}

local function sortByName(a, b)
	if not a or not b or not a.name or not b.name then
		return false
	end
	return a.name < b.name
end

-- Moves an item between the two filter lists.
--- @param from_key string
--- @param to_key string
--- @param item_id integer
local function moveItem(from_key, to_key, item_id)
	local from, to = tpm.player[from_key], tpm.player[to_key]
	for index, item in ipairs(from) do
		if item.id == item_id then
			table.remove(from, index)
			push(to, item)
			sort(to, sortByName)

			tpm.settings.scroll_box_views["items_to_be_obtained"]:SetDataProvider(CreateDataProvider(tpm.player.items_to_be_obtained))
			tpm.settings.scroll_box_views["items_in_possession"]:SetDataProvider(CreateDataProvider(tpm.player.items_in_possession))
			tpm:UpdateAvailableItemTeleports()
			tpm:ReloadFrames()
			return
		end
	end
end

--- @param item_id integer
function tpm:AddItemToPossession(item_id)
	moveItem("items_to_be_obtained", "items_in_possession", item_id)
end

--- @param item_id integer
function tpm:RemoveItemFromPossession(item_id)
	moveItem("items_in_possession", "items_to_be_obtained", item_id)
end

-- Moves items between the filter lists when they're gained or lost (bags or toy collection)
function tpm:SyncItemPossession()
	--- @type Item[]
	local items_in_possession = CopyTable(tpm.player.items_in_possession)

	--- @type Item[]
	local items_to_be_obtained = CopyTable(tpm.player.items_to_be_obtained)

	for _, item in ipairs(items_in_possession) do
		if not tpm:IsItemTeleportOwned(item.id) then
			tpm:RemoveItemFromPossession(item.id)
		end
	end

	for _, item in ipairs(items_to_be_obtained) do
		if tpm:IsItemTeleportOwned(item.id) then
			tpm:AddItemToPossession(item.id)
		end
	end
end
