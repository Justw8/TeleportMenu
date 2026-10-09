local _, tpm = ...
local Tooltip = {}
tpm.Tooltip = Tooltip

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")

--------------------------------------
-- Functions
--------------------------------------

local function anchorTooltip(owner)
	local _, globalHeight = tpm:GetButtonSize()
	GameTooltip:SetOwner(owner, "ANCHOR_NONE")
	local yOffset = globalHeight / 2
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrameRight, "TOPRIGHT", 0, yOffset)
end

function Tooltip:SetCombat(owner)
	anchorTooltip(owner)
	GameTooltip:SetText(L["Not In Combat Tooltip"], 1, 1, 1)
	GameTooltip:Show()
end

function Tooltip:Set(owner, tpType, id, hs)
	local db = tpm:GetOptions()
	anchorTooltip(owner)
	if hs and db["Teleports:Hearthstone"] and db["Teleports:Hearthstone"] == "rng" then
		local bindLocation = GetBindLocation()
		GameTooltip:SetText(L["Random Hearthstone"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Tooltip"], 1, 1, 1)
		GameTooltip:AddLine(L["Random Hearthstone Location"]:format(bindLocation), 1, 1, 1, true) -- `false` is supposed to disable text wrapping, but somehow `true` works that way in action
	elseif tpType == "item" then
		GameTooltip:SetItemByID(id)
	elseif tpType == "item_teleports" then
		GameTooltip:SetText(L["Item Teleports"] .. "\n" .. L["Item Teleports Tooltip"], 1, 1, 1)
	elseif tpType == "toy" then
		GameTooltip:SetToyByItemID(id)
	elseif tpType == "spell" then
		GameTooltip:SetSpellByID(id)
	elseif tpType == "flyout" then
		local name = GetFlyoutInfo(id)
		GameTooltip:SetText(name, 1, 1, 1)
	elseif tpType == "profession" then
		local professionInfo = C_TradeSkillUI.GetProfessionInfoBySkillLineID(id)
		if professionInfo then
			GameTooltip:SetText(professionInfo.professionName, 1, 1, 1)
		end
	elseif tpType == "seasonalteleport" then
		local currExpID = GetExpansionLevel()
		local expName = _G["EXPANSION_NAME" .. currExpID]
		local title = MYTHIC_DUNGEON_SEASON:format(expName, tpm.settings.current_season)
		GameTooltip:SetText(title, 1, 1, 1)
		GameTooltip:AddLine(L["Seasonal Teleports Tooltip"], 1, 1, 1)
	end
	GameTooltip:Show()
end
