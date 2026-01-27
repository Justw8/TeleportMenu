local _, tpm = ...

local Housing = {}
tpm.Housing = Housing

local housingButtonsPool = {}
local activeHousingButtons = {}

local function setToolTip(self)
	local IsInsideHouseOrPlot = C_Housing.IsInsideHouseOrPlot()
	local db = tpm:GetOptions()
	local globalHeight = db["Button:Size"] or 40 -- default size
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	local yOffset = globalHeight / 2
	GameTooltip:SetPoint("BOTTOMLEFT", TeleportMeButtonsFrameRight, "TOPRIGHT", 0, yOffset)

	local text = IsInsideHouseOrPlot and "Return to Previous Location" or "Teleport Home"
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
		local cdInfo = C_Housing.GetVisitCooldownInfo()
		start = cdInfo.startTime
		duration = cdInfo.duration
		enabled = cdInfo.isEnabled
		if enabled and not tpm:isSecret(duration) and duration > 0 then
			self:SetCooldown(start, duration)
		else
			self:Clear()
		end
	end

	return cooldownFrame
end

function Housing:CreateSecureHousingButton(tpInfo)
	local button, houseInfo = nil, nil
	local IsInsideHouseOrPlot = C_Housing.IsInsideHouseOrPlot()

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
	end

	function button:Recycle()
		self:SetParent(nil)
		self:ClearAllPoints()
		self:Hide()
		table.insert(housingButtonsPool, self)
	end

	-- Interaction
	button:EnableMouse(true)
	button:RegisterForClicks("AnyDown", "AnyUp")
	button:SetAttribute("useOnKeyDown", true)
	button:SetScript("PostClick", function()
		tpm:CloseMainMenu()
	end)

	-- Scripts
	button:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	button:SetScript("OnEnter", function(self)
		setToolTip(self)
	end)
	button:SetScript("OnShow", function(self)
		self.cooldownFrame:CheckCooldown()
	end)
	button.cooldownFrame:CheckCooldown()

	-- Textures
	if IsInsideHouseOrPlot then
		button:SetNormalAtlas("dashboard-panel-homestone-teleport-out-button")
	else
		local spellTexture =  C_Spell.GetSpellTexture(1263273)
		button:SetNormalTexture(spellTexture)
	end

	-- Attributes
	if IsInsideHouseOrPlot then
		button:SetAttribute("type", "returnhome")
		button.cooldownFrame:Hide()
	else
		button:SetAttribute("type", "teleporthome")
		button:SetAttribute("house-neighborhood-guid", houseInfo.neighborhoodGUID)
		button:SetAttribute("house-guid", houseInfo.houseGUID)
		button:SetAttribute("house-plot-id", houseInfo.plotID)
		button.cooldownFrame:Show()
	end

	table.insert(activeHousingButtons, button)
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
