local _, tpm = ...
local Housing = {}
tpm.Housing = Housing

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")
local MSQ = LibStub("Masque", true)
local MasqueGroup = MSQ and MSQ:Group(L["ADDON_NAME"])

--------------------------------------
-- Locales
--------------------------------------


local housingButtonsPool = {}
local activeHousingButtons = {}

--------------------------------------
-- Functions
--------------------------------------

function Housing:CanReturn()
	return C_HousingNeighborhood.CanReturnAfterVisitingHouse()
end

local function setToolTip(self)
	local db = tpm:GetOptions()
	local globalHeight = db["Button:Size"] or 40 -- default size
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	local yOffset = globalHeight / 2
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrameRight, "TOPRIGHT", 0, yOffset)

	local text = Housing:CanReturn() and _G.HOUSING_DASHBOARD_RETURN or _G.HOUSING_DASHBOARD_TELEPORT_TO_PLOT
	GameTooltip:SetText(text, 1, 1, 1)

	GameTooltip:Show()
end

local function createCooldownFrame(frame)
	if frame.cooldownFrame then
		return frame.cooldownFrame
	end
	local cooldownFrame = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	cooldownFrame:SetAllPoints()

	function cooldownFrame:CheckCooldown()
		if Housing:CanReturn() then
			self:Clear() -- this has no CD
			return
		end

		local cdInfo = C_Housing.GetVisitCooldownInfo()
		start = cdInfo.startTime
		duration = cdInfo.duration
		enabled = cdInfo.isEnabled
		if enabled and not tpm:IsSecret(duration) and duration > 0 then
			self:SetCooldown(start, duration)
		else
			self:Clear()
		end
	end

	return cooldownFrame
end

function Housing:CreateSecureHousingButton(tpInfo)
	local button, houseInfo = nil, nil

	if #houseData == 1 or tpInfo.faction == "alliance" then
		houseInfo = houseData[1]
	else -- horde if 2
		houseInfo = houseData[2]
	end

	if next(housingButtonsPool) then
		button = table.remove(housingButtonsPool)
	else
		button = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")

		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)
		button.cooldownFrame = createCooldownFrame(button)

		function button:Recycle()
			self:SetParent(nil)
			self:ClearAllPoints()
			self:Hide()
			table.insert(housingButtonsPool, self)

			if MasqueGroup then
				MasqueGroup:RemoveButton(self)
			end
		end

		button:EnableMouse(true)
		button:RegisterForClicks("AnyDown", "AnyUp")
		button:SetAttribute("useOnKeyDown", true)
		button:SetScript("PostClick", function()
			tpm:CloseMainMenu()
		end)

		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		button:SetScript("OnEnter", function(self)
			setToolTip(self)
		end)

		button:SetScript("OnShow", function(self)
			if not Housing:CanReturn() then
				self.cooldownFrame:CheckCooldown()
			end
		end)

		-- Icon
		button.icon = button:CreateTexture(nil, "BACKGROUND")
		button.icon:SetAllPoints()
	end

	-- Textures
	if self:CanReturn() then
		button.icon:SetAtlas("dashboard-panel-homestone-teleport-out-button")
	else
		local spellTexture =  C_Spell.GetSpellTexture(1263273)
		button.icon:SetTexture(spellTexture)
	end

	local zoomFactor = tpm.TEXTURE_SCALE
	local offset = zoomFactor / 2
	button.icon:SetTexCoord(offset, 1-offset, offset, 1-offset)

	-- Attributes
	if self:CanReturn() then
		button:SetAttribute("type", "returnhome")
	else
		button:SetAttribute("type", "teleporthome")
		button:SetAttribute("house-neighborhood-guid", houseInfo.neighborhoodGUID)
		button:SetAttribute("house-guid", houseInfo.houseGUID)
		button:SetAttribute("house-plot-id", houseInfo.plotID)
	end

	button.cooldownFrame:CheckCooldown()
	table.insert(activeHousingButtons, button)

	local db = tpm:GetOptions()
	local size = db["Button:Size"] or 40
	button:SetSize(size, size)
	button:Show()

	if MasqueGroup then
		MasqueGroup:AddButton(button, { Icon = button.icon })
	end
	return button
end

function Housing:RecycleHousingButtons()
	for _, secureButton in ipairs(activeHousingButtons) do
		secureButton:Recycle()
	end
	activeHousingButtons = {}
end

function Housing:GetActiveHousingButtons()
	return #activeHousingButtons
end

function Housing:HasAPlot()
	return #houseData > 0
end

--------------------------------------
-- Event Handlers
--------------------------------------

local events = {}
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	events[event](self, ...)
end)

function events:PLAYER_HOUSE_LIST_UPDATED(housingInfo)
	f:UnregisterEvent("PLAYER_HOUSE_LIST_UPDATED")
	houseData = housingInfo
end

function tpm:LoadHouses()
	f:RegisterEvent("PLAYER_HOUSE_LIST_UPDATED")
	C_Housing.GetPlayerOwnedHouses()
end
