std = "lua51"
max_line_length = false
exclude_files = {
	".luacheckrc",
}

files["**/Hearthstones.lua"].ignore = {
	"AvailableHearthstones",
}
ignore = {
	"212/self",
}
globals = {
	-- wow std api
	"sort",

	-- Addon Globals
	"TeleportMenuDB",
	"TeleportMeButtonsFrame",
	"SLASH_TPMENU1",
	"SLASH_TPMENU2",
	"SlashCmdList",

	-- Other
	"LibStub",
	"C_Covenants",
	"C_ToyBox",
	"C_Spell",
	"C_Timer",
	"C_CVar",
	"CopyTable",
	"GetFlyoutSlotInfo",
	"InCombatLockdown",
	"STANDARD_TEXT_FONT",
	"C_TradeSkillUI",
	"MYTHIC_DUNGEON_SEASON",
	"C_QuestLog",
	"IsSpellKnown",
	"C_ChallengeMode",
	"GameMenuFrame",
	"CreateFrame",
	"ContinuableContainer",
	"C_Item",
	"hooksecurefunc",
	"GetAchievementCriteriaInfo",
	"UnitRace",
	"PlayerHasToy",
	"UnitFactionGroup",
	"CreateDataProvider",
	"Item",
	"InterfaceOptionsFramePanelContainer",
	"Settings",
	"MinimalSliderWithSteppersMixin",
	"GameTooltip",
	"ScrollUtil",
	"GetBindLocation",
	"GetFlyoutInfo",
	"GetExpansionLevel",
	"GameFontHighlight",
	"CreateScrollBoxListLinearView",
}
