local _, tpm = ...

--- @type { [integer]: boolean }
tpm.ItemTeleports = {
	-- Kirin Tor rings
	-- Slight note on these, it is technically possible to have ALL of them, but that'd cost too much inventory space if you ask me.
	[32757] = true, -- Blessed Medallion of Karabor
	[37863] = true, -- Direbrew's Remote
	[40586] = true, -- Band of the Kirin Tor
	[44935] = true, -- Ring of the Kirin Tor
	[40585] = true, -- Signet of the Kirin Tor
	[44934] = true, -- Loop of the Kirin Tor
	[45688] = true, -- Inscribed Band of the Kirin Tor
	[45690] = true, -- Inscribed Ring of the Kirin Tor
	[45691] = true, -- Inscibed Signet of the Kirin Tor
	[45689] = true, -- Inscribed Loop of the Kirin Tor
	[48954] = true, -- Etched Band of the Kirin Tor
	[48955] = true, -- Etched Loop of the Kirin Tor
	[48956] = true, -- Etched Ring of the Kirin Tor
	[48957] = true, -- Etched Signet of the Kirin Tor
	[51557] = true, -- Runed Signet of the Kirin Tor
	[51558] = true, -- Runed Loop of the Kirin Tor
	[51559] = true, -- Runed Ring of the Kirin Tor
	[51560] = true, -- Runed Band of the Kirin Tor
	[52251] = true, -- Jaina's Locket
	-- Faction Cloaks
	[63206] = UnitFactionGroup("player") == "Alliance", -- Wrap of Unity: Stormwind
	[63207] = UnitFactionGroup("player") == "Horde", -- Wrap of Unity: Orgrimmar
	[63352] = UnitFactionGroup("player") == "Alliance", -- Shroud of Cooperation: Stormwind
	[63353] = UnitFactionGroup("player") == "Horde", -- Shroud of Cooperation: Orgrimmar
	[65274] = UnitFactionGroup("player") == "Horde", -- Cloak of Coordination: Orgrimmar
	[65360] = UnitFactionGroup("player") == "Alliance", -- Cloak of Coordination: Stormwind
	-- Other items
	[43824] = true, -- The Schools of Arcane Magic - Mastery
	[46874] = true, -- Argent Crusader's Tabard
	[50287] = true, -- Boots of the Bay
	[58487] = true, -- Potion of Deepholm
	[61379] = true, -- Gidwin's Hearthstone
	[63378] = true, -- Hellscream's Reach Tabard
	[63379] = true, -- Baradin's Wardens Tabard
	[64457] = true, -- The Last Relic of Argus
	[68808] = true, -- Hero's Hearthstone
	[68809] = true, -- Veteran's Hearthstone
	[87548] = true, -- Lorewalker's Lodestone
	[92510] = true, -- Vol'jin's Hearthstone
	[95050] = UnitFactionGroup("player") == "Horde", -- The Brassiest Knuckle (Brawl'gar Arena)
	[95051] = UnitFactionGroup("player") == "Alliance", -- The Brassiest Knuckle (Bizmo's Brawlpub)
	[95567] = UnitFactionGroup("player") == "Alliance", -- Kirin Tor Beacon
	[95568] = UnitFactionGroup("player") == "Horde", -- Sunreaver Beacon
	[103678] = true, -- Time-Lost Artifact
	[104110] = true, -- Curious Bronze Timepiece - Timeless Isle QuestItem
}
