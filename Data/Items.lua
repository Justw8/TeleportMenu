local _, tpm = ...

--- @type { [integer]: boolean }
tpm.ItemTeleports = {
	[202046] = true,      -- Lucky Tortollan Charm
	[63206] = UnitFactionGroup("player") == "Alliance",       -- Wrap of Unity: Stormwind
	[63207] = UnitFactionGroup("player") == "Horde",       -- Wrap of Unity: Orgrimmar
	[63352] = UnitFactionGroup("player") == "Alliance",       -- Shroud of Cooperation: Stormwind
	[63353] = UnitFactionGroup("player") == "Horde",       -- Shroud of Cooperation: Orgrimmar
	[65274] = UnitFactionGroup("player") == "Horde",       -- Cloak of Coordination: Orgrimmar
	[65360] = UnitFactionGroup("player") == "Alliance",       -- Cloak of Coordination: Stormwind
	[58487] = true,       -- Potion of Deepholm
	[61379] = true,       -- Gidwin's Hearthstone
	[63378] = true,       -- Hellscream's Reach Tabard
	[63379] = true,       -- Baradin's Wardens Tabard
	[64457] = true,       -- The Last Relic of Argus
	[68808] = true,       -- Hero's Hearthstone
	[68809] = true,       -- Veteran's Hearthstone
	[87548] = true,       -- Lorewalker's Lodestone
	[92510] = true,       -- Vol'jin's Hearthstone
	[95050] = UnitFactionGroup("player") == "Horde",       -- The Brassiest Knuckle (Brawl'gar Arena)
	[95051] = UnitFactionGroup("player") == "Alliance",       -- The Brassiest Knuckle (Bizmo's Brawlpub)
	[95567] = true,       -- Kirin Tor Beacon
	[95568] = true,       -- Sunreaver Beacon
	[103678] = true,      -- Time-Lost Artifact
	[117389] = true,      -- Draenor Archaeologist's Lodestone
	[118662] = true,      -- Bladespire Relic
	[118663] = true,      -- Relic of Karabor
	[118908] = UnitFactionGroup("player") == "Horde",         -- Pit Fighter's Punching Ring (Brawl'gar Arena)
	[118907] = UnitFactionGroup("player") == "Alliance",      -- Pit Fighter's Punching Ring (Bizmo's Brawlpub)
	[119183] = true,      -- Scroll of Risky Recall
	[128502] = true,      -- Hunter's Seeking Crystal
	[128503] = true,      -- Master Hunter's Seeking Crystal
	[128353] = true,      -- Admiral's Compass
	[129276] = true,      -- Beginner's Guide to Dimensional Rifting
	[132119] = UnitFactionGroup("player") == "Horde",      -- Orgrimmar Portal Stone
	[132120] = UnitFactionGroup("player") == "Alliance",      -- Stormwind Portal Stone
	[132517] = true,      -- Intra-Dalaran Wormhole Generator
	[132523] = true,      -- Reaves Battery
	[138448] = true,      -- Emblem of Margoss
	[139590] = true,      -- Scroll of Teleport: Ravenholdt
	[139599] = true,      -- Empowered Ring of the Kirin Tor
	[140493] = true,      -- Adept's Guide to Dimensional Rifting
	[141013] = true,      -- Scroll of Town Portal: Shala'nir
	[141014] = true,      -- Scroll of Town Portal: Sashj'tar
	[141015] = true,      -- Scroll of Town Portal: Kal'delar
	[141016] = true,      -- Scroll of Town Portal: Faronaar
	[141017] = true,      -- Scroll of Town Portal: Lian'tril
	[141324] = true,      -- Talisman of the Shal'dorei
	[141605] = true,      -- Flight Master's Whistle
	[142298] = true,      -- Astonishingly Scarlet Slippers
	[142469] = true,      -- Violet Seal of the Grand Magus
	[142543] = true,      -- Scroll of Town Portal (Diablo 3 event)
	[144341] = true,      -- Rechargeable Reaves Battery
	[144391] = UnitFactionGroup("player") == "Alliance",      -- Pugilist's Powerful Punching Ring (Alliance)
	[144392] = UnitFactionGroup("player") == "Horde",     -- Pugilist's Powerful Punching Ring (Horde)
	[150733] = true,      -- Scroll of Town Portal (Ar'gorok in Arathi)
	[159224] = true,      -- Zuldazar Hearthstone
	[160219] = true,      -- Scroll of Town Portal (Stromgarde in Arathi)
	[163694] = true,      -- Scroll of Luxurious Recall
	[166559] = true,      -- Commander's Signet of Battle
	[166560] = true,      -- Captain's Signet of Command
	[167075] = true,      -- Ultrasafe Transporter: Mechagon
	[168862] = true,      -- G.E.A.R. Tracking Beacon
	[169064] = true,      -- Montebank's Colorful Cloak
	[169297] = true,      -- Stormpike Insignia
	[172203] = true,      -- Cracked Hearthstone
	[173373] = true,      -- Faol's Hearthstone
	[173430] = true,      -- Nexus Teleport Scroll
	[173532] = true,      -- Tirisfal Camp Scroll
	[173528] = true,      -- Gilded Hearthstone
	[173537] = true,      -- Glowing Hearthstone
	[173716] = true,      -- Mossy Hearthstone
	[180817] = true,      -- Cypher of Relocation (Ve'nari's Refuge)
	[181163] = true,      -- Scroll of Teleport: Theater of Pain
	[184500] = true,      -- Attendant's Pocket Portal: Bastion
	[184501] = true,      -- Attendant's Pocket Portal: Revendreth
	[184502] = true,      -- Attendant's Pocket Portal: Maldraxxus
	[184503] = true,      -- Attendant's Pocket Portal: Ardenweald
	[184504] = true,      -- Attendant's Pocket Portal: Oribos
	[189827] = true,      -- Cartel Xy's Proof of Initiation
	[191029] = true,      -- Lilian's Hearthstone
	[201957] = true,      -- Thrall's Hearthstone
	[204481] = true,      -- Morqut Hearth Totem
	[205255] = true,      -- Niffen Diggin' Mitts
	[205456] = true,      -- Lost Dragonscale (1)
	[205458] = true,      -- Lost Dragonscale (2)
	[211788] = true,      -- Tess's Peacebloom
}

function tpm:GetAvailableItemTeleports()
	return tpm.AvailableItemTeleports
end

function tpm:UpdateAvailableItemTeleports()
	AvailableItemTeleports = {}
	for id, _ in pairs(tpm.ItemTeleports) do
		if C_Item.GetItemCount(id) > 0 and TeleportMenuDB[id] == true then
			table.insert(AvailableItemTeleports, id)
		end
	end
	tpm.AvailableItemTeleports = AvailableItemTeleports
end
