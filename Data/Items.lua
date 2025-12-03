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
	[117389] = true, -- Draenor Archaeologist's Lodestone
	[118662] = true, -- Bladespire Relic
	[118663] = true, -- Relic of Karabor
	[118907] = UnitFactionGroup("player") == "Alliance", -- Pit Fighter's Punching Ring (Bizmo's Brawlpub)
	[118908] = UnitFactionGroup("player") == "Horde", -- Pit Fighter's Punching Ring (Brawl'gar Arena)
	[119183] = true, -- Scroll of Risky Recall
	[128353] = true, -- Admiral's Compass
	[128502] = true, -- Hunter's Seeking Crystal
	[128503] = true, -- Master Hunter's Seeking Crystal
	[129276] = true, -- Beginner's Guide to Dimensional Rifting
	[132119] = UnitFactionGroup("player") == "Horde", -- Orgrimmar Portal Stone
	[132120] = UnitFactionGroup("player") == "Alliance", -- Stormwind Portal Stone
	[132517] = true, -- Intra-Dalaran Wormhole Generator
	[132523] = true, -- Reaves Battery
	[138448] = true, -- Emblem of Margoss
	[139590] = true, -- Scroll of Teleport: Ravenholdt
	[139599] = true, -- Empowered Ring of the Kirin Tor
	[140493] = true, -- Adept's Guide to Dimensional Rifting
	[141013] = true, -- Scroll of Town Portal: Shala'nir
	[141014] = true, -- Scroll of Town Portal: Sashj'tar
	[141015] = true, -- Scroll of Town Portal: Kal'delar
	[141016] = true, -- Scroll of Town Portal: Faronaar
	[141017] = true, -- Scroll of Town Portal: Lian'tril
	[141324] = true, -- Talisman of the Shal'dorei
	[141605] = true, -- Flight Master's Whistle
	[142298] = true, -- Astonishingly Scarlet Slippers
	[142469] = true, -- Violet Seal of the Grand Magus
	[142543] = true, -- Scroll of Town Portal (Diablo 3 event)
	[144341] = true, -- Rechargeable Reaves Battery
	[144391] = UnitFactionGroup("player") == "Alliance", -- Pugilist's Powerful Punching Ring (Alliance)
	[144392] = UnitFactionGroup("player") == "Horde", -- Pugilist's Powerful Punching Ring (Horde)
	[150733] = true, -- Scroll of Town Portal (Ar'gorok in Arathi)
	[151016] = true, -- Fractured Necrolyte Skull
	[159224] = true, -- Zuldazar Hearthstone
	[160219] = true, -- Scroll of Town Portal (Stromgarde in Arathi)
	[163694] = true, -- Scroll of Luxurious Recall
	[166559] = true, -- Commander's Signet of Battle
	[166560] = true, -- Captain's Signet of Command
	[167075] = true, -- Ultrasafe Transporter: Mechagon
	[168862] = true, -- G.E.A.R. Tracking Beacon
	[169064] = true, -- Montebank's Colorful Cloak
	[169297] = UnitFactionGroup("player") == "Alliance", -- Stormpike Insignia
	[172203] = true, -- Cracked Hearthstone
	[173373] = true, -- Faol's Hearthstone
	[173430] = true, -- Nexus Teleport Scroll
	[173528] = true, -- Gilded Hearthstone
	[173532] = true, -- Tirisfal Camp Scroll
	[173537] = true, -- Glowing Hearthstone
	[173716] = true, -- Mossy Hearthstone
	[180817] = true, -- Cypher of Relocation (Ve'nari's Refuge)
	[181163] = true, -- Scroll of Teleport: Theater of Pain
	[184500] = true, -- Attendant's Pocket Portal: Bastion
	[184501] = true, -- Attendant's Pocket Portal: Revendreth
	[184502] = true, -- Attendant's Pocket Portal: Maldraxxus
	[184503] = true, -- Attendant's Pocket Portal: Ardenweald
	[184504] = true, -- Attendant's Pocket Portal: Oribos
	[189827] = true, -- Cartel Xy's Proof of Initiation
	[191029] = true, -- Lilian's Hearthstone
	[193000] = true, -- Ring-Bound Hourglass
	[200613] = true, -- Aylaag Windstone Fragment
	[201957] = true, -- Thrall's Hearthstone
	[202046] = true, -- Lucky Tortollan Charm
	[204481] = true, -- Morqut Hearth Totem
	[205255] = true, -- Niffen Diggin' Mitts
	[205456] = true, -- Lost Dragonscale (1)
	[205458] = true, -- Lost Dragonscale (2)
	[211788] = UnitRace("player") == "Worgen", -- Tess's Peacebloom
	[230850] = true, -- Delve-O-Bot 7001
	[234389] = true, -- Gallagio Loyalty Rewards Card: Silver
	[234390] = true, -- Gallagio Loyalty Rewards Card: Gold
	[234391] = true, -- Gallagio Loyalty Rewards Card: Platinum
	[234392] = true, -- Gallagio Loyalty Rewards Card: Black
	[234393] = true, -- Gallagio Loyalty Rewards Card: Diamond
	[234394] = true, -- Gallagio Loyalty Rewards Card: Legendary
	[238727] = true, -- Nostwin's Voucher
	[243056] = true, -- Delver's Mana-Bound Ethergate	
	[249699] = true, -- Shadowguard Translocator
}

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
