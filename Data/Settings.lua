local _, tpm = ...
local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

local GetItemCount, GetItemNameByID, GetItemIconByID, sort, push = C_Item.GetItemCount, C_Item.GetItemNameByID, C_Item.GetItemIconByID, sort, table.insert

--- @type { [string|integer]: boolean|string|integer }
tpm.SettingsBase = {
	["Enabled"] = true,
	["Teleports:Seasonal:Only"] = false,
	["Teleports:Mage:Reverse"] = false,
	["Teleports:Hearthstone"] = "none",
	["Button:Size"] = 40,
	["Button:Text:Size"] = 14,
	["Button:Text:Show"] = true,
	["Flyout:Max_Per_Row"] = 5,
}

tpm.settings = {
	scroll_box_views = {
		items_in_possession_view = nil,
		items_to_be_obtained = nil,
	},
	current_season = 1,
}

local function pack(...)
	local num = select("#", ...)
	return setmetatable({ ... }, {
		__len = function()
			return num
		end,
	})
end

local function merge(...)
	local all_teleports = {}
	local arg = pack(...)
	for i = 1, #arg do
		for k, v in pairs(arg[i]) do
			if all_teleports[k] then
				error("\n\n" .. L["AddonNamePrint"] .. "Duplicate key found\n\124cFF34B7EBKey:\124r " .. k .. "\n")
			end
			all_teleports[k] = v
		end
	end
	return all_teleports
end

function tpm:SourceItemTeleportScrollBoxes(onSourceComplete)
	local ContinuableContainer = ContinuableContainer:Create()
	local items_in_possession, items_to_be_obtained = tpm.player.items_in_possession, tpm.player.items_to_be_obtained
	for id, _ in pairs(tpm.ItemTeleports) do
		local item = Item:CreateFromItemID(id)
		ContinuableContainer:AddContinuable(item)
	end

	ContinuableContainer:ContinueOnLoad(function()
		for id, _ in pairs(tpm.ItemTeleports) do
			local items = (GetItemCount(id) > 0 and items_in_possession) or items_to_be_obtained
			push(items, {
				id = id,
				name = GetItemNameByID(id),
				icon = GetItemIconByID(id),
			})

			if #items > 1 then
				sort(items, function(a, b)
					return a.name < b.name
				end)
			end
		end
	end)

	if onSourceComplete then
		onSourceComplete()
	end
end

tpm.SettingsBase = setmetatable(tpm.SettingsBase, {
	__index = merge(tpm.ItemTeleports, tpm.Wormholes, tpm.Hearthstones),
})
