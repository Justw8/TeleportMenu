local _, tpm = ...
local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

tpm.SettingsBase = {
	["Enabled"] = false,
	["Teleports:Seasonal:Only"] = false,
	["Teleports:Mage:Reverse"] = false,
	["Teleports:Hearthstone"] = "none",
	["Button:Size"] = 40,
	["Button:Text:Size"] = 14,
	["Button:Text:Show"] = true,
	["Flyout:Max_Per_Row"] = 5,
}

local function pack(...)
	local num = select("#", ...)
	return setmetatable({ ... }, { __len = function() return num end })
end

local function merge(...)
	local all_teleports = {}
	local arg = pack(...)
	for i = 1, #arg do
		for k, v in pairs(arg[i]) do
			if all_teleports[k] then error("\n\n" .. L["AddonNamePrint"] .. "Duplicate key found\n\124cFF34B7EBKey:\124r " .. k .. "\n") end
			all_teleports[k] = v
		end
	end
	return all_teleports
end


tpm.SettingsBase = setmetatable(tpm.SettingsBase, {
	__index = merge(
		tpm.ItemTeleports,
		tpm.Wormholes,
		tpm.Hearthstones
	)
})
