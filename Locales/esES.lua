local L = LibStub("AceLocale-3.0"):NewLocale("TeleportMenu", "esES")
if not L then return end

--L["AddonNamePrint"] = "\124cFFFF0000TeleportMenu:\124r " -- 1 space after the :
--L["Not In Combat Tooltip"] = "\124cFFFF0000<Not available in combat>\124r"
--L["Random Hearthstone"] = "Random Hearthstone"
--L["Random Hearthstone Tooltip"] = "\124cFF34B7EBClick to cast a random hearthstone.\nIt will pick a new hearthstone when you re-open the menu.\124r"
--L["Random Hearthstone Location"] = "\n\124cFF34B7EBHearthstone Location:\124r \124cFF1EFF0C%s\124r"
--L["Bonus Hearthstones"] = "Bonus Hearthstones"
--L["Bonus Hearthstones Tooltip"] = "\124cFF34B7EBThese Hearthstones do not share cooldown with the other toys.\124r"
--L["Seasonal Teleports"] = "Seasonal Teleports"
--L["Seasonal Teleports Tooltip"] = "\124cFF34B7EBThese Teleports are for the current Mythic Keystone Season.\124r"
--L["Seasonal Teleports Toggle Tooltip"] = "Enable/Disable to only show the Seasonal Teleports.\n\n\124cFF34B7EBRequires a reload to take effect.\124r"
--L["Missing Texture"] = "a texture is missing for itemID: %s, please report this to the author."
--L["No Hearthtone In Bags"] = "You don't have a hearthstone in your bags or set a custom one. Please use /tpm for the commands to set one."
--L["No Alternative Hearthstone"] = "No alternative Hearthstone set."
--L["Current Hearthstone"] = "Current Hearthstone is set to: %s"
--L["Hearthstone Reset"] = "Hearthstone reset to default!"
--L["Hearthone Reset Error"] = "We reset your heartstone to default because the toy with itemID: %s is not in your collection."
--L["Not In Combat Print"] = "You can't do that in combat."
--L["Available Hearthstones Print"] = "Available Hearthstone toys: [id - name]"
--L["No Hearthone Toys"] = "You don't have any valid Hearthstone toys to randomize in your collection."
--L["Hearthstone Random Set"] = "Hearthstone set to be random!"
--L["New Hearthstone Set"] = "New Hearthstone set to: %s!"
--L["Available Commands"] = "Available Commands:"
--L["List Command"] = "/tpm list - List all valid Hearthstone toys in your collection."
--L["Current Command"] = "/tpm current - Show the currently set alternative Hearthstone."
--L["Clear Command"] = "/tpm clear - Reset back to the default hearthstone."
--L["ItemId Command"] = "/tpm [itemId] - Set a valid Hearthstone toy as your alternative Hearthstone."
--L["Rng Command"] = "/tpm rng - Randomize a Hearthstone toy from your collection every time you open the game menu."

-- dungeons abreviated Text
--L["The Vortex Pinnacle"] = "VP"
--L["Throne of the Tides"] = "ToTT"
--L["Grim Batol"] = "GB"
--L["Temple of the Jade Serpentl"] = "TJS"
--L["Stormstout Brewery"] = "SB"
--L["Shado-Pan Monastery"] = "SPM"
--L["Mogu'shan Palace"] = "MP"
--L["Gate of the Setting Sun"] = "GATE"
--L["Siege of Niuzao Temple"] = "SoN"
--L["Scarlet Monastery"] = "SM"
--L["Scarlet Halls"] = "SH"
--L["Scholomance"] = "SCHL"
--L["The Everblooml"] = "EB"
--L["Shadowmoon Burial Grounds"] = "SBG"
--L["Grimrail Depot"] = "GD"
--L["Iron Docks"] = "ID"
--L["Bloodmaul Slag Mines"] = "BSM"
--L["Auchindoun"] = "AUCH"
--L["Skyreach"] = "SKY"
--L["Upper Blackrock Spire"] = "UBRS"
--L["Halls of Valor"] = "HoV"
--L["Neltharion's Lair"] = "NL"
--L["Court of Stars"] = "CoS"
--L["Karazhan"] = "KARA"
--L["Black Rook Hold"] = "BRH"
--L["Darkheart Thicket"] = "DHT"
--L["Freehold"] = "FH"
--L["The Underrot"] = "UR"
--L["Mechagon"] = "MECH"
--L["Waycrest Manor"] = "WM"
--L["Atal'Dazar"] = "AD"
--L["Siege of Boralus"] = "SoB"
--L["The Necrotic Wake"] = "NW"
--L["Plaguefall"] = "PF"
--L["Mists of Tirna Scithe"] = "MoTS"
--L["Halls of Atonement"] = "HoA"
--L["Bastion"] = "SoA"
--L["Theater of Pain"] = "ToP"
--L["De Other Side"] = "DOS"
--L["Sanguine Depths"] = "SD"
--L["Tazavesh, the Veiled Market"] = "TAZ"
--L["Castle Nathria"] = "CN"
--L["Sanctum of Domination"] = "SoD"
--L["Sepulcher of the First Ones"] = "SoFO"
--L["Ruby Life Pools"] = "RLP"
--L["The Nokhud Offensive"] = "NO"
--L["Brackenhide Hollow"] = "BH"
--L["Algeth'ar Academy"] = "AA"
--L["Neltharus"] = "NELT"
--L["The Azure Vault"] = "AV"
--L["Halls of Infusion"] = "HoI"
--L["Uldaman"] = "ULD"
--L["Dawn of the Infinite"] = "DotI"
--L["Vault of the Incarnates"] = "VotI"
--L["Aberrus, the Shadowed Crucible"] = "Abb"
--L["Amirdrassil, the Dream's Hope"] = "Amir"
--L["City of Threads"] = "CoT"
--L["The Dawnbreaker"] = "DB"
--L["The Stonevault"] = "SV"
--L["The Rookery"] = "ROOK"
--L["Cinderbrew Meadery"] = "CBM"
--L["Priory of the Sacred Flame"] = "PoSF"
--L["Ara-Kara, City of Echoes"] = "AK"
--L["Darkflame Cleft"] = "DFC"

-- expansion abreviated Text
--L["Cataclysm"] = "CATA"
--L["Mists of Pandaria"] = "MoP"
--L["Warlords of Draenor"] = "WoD"
--L["Legion"] = "LEGN"
--L["Battle for Azeroth"] = "BFA"
--L["Shadowlands"] = "SL"
--L["Shadowlands Raids"] = "SL R"
--L["Dragonflight"] = "DF"
--L["Dragonflight Raids"] = "DF R"
--L["The War Within"] = "TWW"
--L["Season 1"] = "S1"

-- Options
--L["Enabled"] = "Enabled"
--L["Enable Tooltip"] = "Enable/Disable the Teleport Menu."
--L["Hearthstone Toy"] = "Hearthstone Toy"
--L["Hearthstone Toy Tooltip"] = "Sets the preferred hearthstone toy to use.\n\nIf set to Random, a random hearthstone toy will be choosen every time you open the game menu."
--L["None"] = "None"
--L["Random"] = "Random"
--L["ButtonText"] = "Show Teleport Icon Text"
--L["ButtonText Tooltip"] = "When enabled, an abbreviated name of the dungeon will be added to dungeon teleports.\n\n\124cFF34B7EBRequires a reload to take effect.\124r"
--L["Reverse Mage Flyouts"] = "Reverse Mage Flyouts"
--L["Reverse Mage Flyouts Tooltip"] = "Reverse order of flyouts for mage abilities to make most recent expansion teleports appear first"
