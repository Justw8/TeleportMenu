local _, tpm = ...

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

tpm.SettingsBase = setmetatable(tpm.SettingsBase, {
	__index = setmetatable(tpm.ItemTeleports, {
		__index = setmetatable(tpm.Hearthstones, {
			__index = setmetatable(tpm.Wormholes, {})
		})
	})
})
