local _, tpm = ...
local SecureButton = {}
tpm.SecureButton = SecureButton

--------------------------------------
-- Libraries
--------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("TeleportMenu")
local MSQ = LibStub("Masque", true)
local MasqueGroup = MSQ and MSQ:Group(L["ADDON_NAME"])

--------------------------------------
-- Locales
--------------------------------------

local DEFAULT_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

local secureButtons = {}
local secureButtonsPool = {}

--------------------------------------
-- Texture Stuff
--------------------------------------

function SecureButton:SetTextureByItemId(frame, itemId)
	frame.icon:SetTexture(DEFAULT_ICON) -- Temp while loading
	local item = Item:CreateFromItemID(tonumber(itemId))
	frame.pendingIconItem = item
	item:ContinueOnItemLoad(function()
		if frame.pendingIconItem ~= item then
			return -- A newer texture was set while this item was loading
		end
		frame.pendingIconItem = nil
		local icon = item:GetItemIcon()
		frame.icon:SetTexture(icon)
	end)
end

--------------------------------------
-- Frames
--------------------------------------

local function createCooldownFrame(frame)
	if frame.cooldownFrame then
		return frame.cooldownFrame
	end
	local cooldownFrame = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	cooldownFrame:SetAllPoints()

	function cooldownFrame:CheckCooldown(id, type)
		if type ~= "housing" and not id then
			return
		end
		local start, duration, enabled
		if type == "toy" or type == "item" then
			start, duration, enabled = C_Item.GetItemCooldown(id)
		elseif type == "housing" then
			local cdInfo = C_Housing.GetVisitCooldownInfo()
			start = cdInfo.startTime
			duration = cdInfo.duration
			enabled = cdInfo.isEnabled
		else
			local cooldown = C_Spell.GetSpellCooldown(id)
			start = cooldown.startTime
			duration = cooldown.duration
			enabled = true
		end
		if enabled and not tpm:IsSecret(duration) and duration > 0 then
			self:SetCooldown(start, duration)
		else
			self:Clear()
		end
	end

	return cooldownFrame
end

---@param id ItemInfo
---@return boolean
local function IsItemEquipped(id)
	return C_Item.IsEquippableItem(id) and C_Item.IsEquippedItem(id)
end

function SecureButton:ClearAllInvalidHighlights()
	for _, button in pairs(secureButtons) do
		button:ClearHighlightTexture()

		if button:GetAttribute("item") ~= nil then
			local id = string.match(button:GetAttribute("item"), "%d+")
			if IsItemEquipped(id) then
				button:Highlight()
			end
		end
	end
end

---@param frame Frame
---@param buttonType string
---@param text string|nil
---@param id integer
---@param hearthstone? boolean
---@return Frame
function SecureButton:Create(frame, buttonType, text, id, hearthstone)
	local db = tpm:GetOptions()
	local globalWidth, globalHeight = tpm:GetButtonSize()
	local button

	if next(secureButtonsPool) then
		button = table.remove(secureButtonsPool)
	else
		button = CreateFrame("Button", nil, nil, "SecureActionButtonTemplate")

		function button:Recycle()
			self.buttonType = nil
			self.id = nil
			self.hearthstone = nil
			self.pendingIconItem = nil

			self:ClearHighlightTexture()
			self:SetParent(nil)
			self:ClearAllPoints()
			self:Hide()
			table.insert(secureButtonsPool, self)

			if MasqueGroup then
				MasqueGroup:RemoveButton(self)
			end
		end

		-- Icon
		button.icon = button:CreateTexture(nil, "BACKGROUND")
		button.icon:SetAllPoints()

		-- Cooldown Frame
		button.cooldownFrame = createCooldownFrame(button)

		function button:CheckCooldown()
			self.cooldownFrame:CheckCooldown(self.id, self.buttonType)
		end

		-- Text
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 5)
		button.text:SetTextColor(1, 1, 1, 1)

		-- Highlighting
		function button:Highlight()
			self:SetHighlightAtlas("talents-node-choiceflyout-square-green")
		end
		button:LockHighlight()

		-- Mouse Interaction
		button:EnableMouse(true)
		button:RegisterForClicks("AnyDown", "AnyUp")
		button:SetAttribute("useOnKeyDown", true)

		-- Scripts
		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		button:SetScript("PostClick", function(self)
			if self.buttonType == "item" and C_Item.IsEquippableItem(id) then
				C_Timer.After(0.25, function() -- Slight delay due to equipping the item not being instant.
					if IsItemEquipped(id) then
						SecureButton:ClearAllInvalidHighlights()
						self:Highlight()
					end
				end)
				if IsItemEquipped(id) then
					tpm:CloseMainMenu()
				end
			else
				tpm:CloseMainMenu()
			end
		end)

		button:SetScript("OnEnter", function(self)
			tpm.Tooltip:Set(self, self.buttonType, self.id, self.hearthstone)
		end)

		button:SetScript("OnShow", function(self)
			self:CheckCooldown()
		end)

		table.insert(secureButtons, button)
	end

	-- Properties
	button.buttonType = buttonType
	button.id = id
	button.hearthstone = hearthstone

	-- Text
	button.text:Hide()
	if db["Button:Text:Show"] == true and text then
		button.text:SetFont(STANDARD_TEXT_FONT, db["Button:Text:Size"], "OUTLINE")
		button.text:SetText(text)
		button.text:Show()
	end

	-- Cooldown
	button:CheckCooldown()

	-- Textures
	if buttonType == "spell" then
		local spellTexture = C_Spell.GetSpellTexture(id)
		button.icon:SetTexture(spellTexture)
	else -- item or toy
		self:SetTextureByItemId(button, id)
	end

	local zoomFactor = tpm.TEXTURE_SCALE
	local offset = zoomFactor / 2
	button.icon:SetTexCoord(offset, 1-offset, offset, 1-offset)

	-- Attributes
	button:SetAttribute("type", buttonType)
	if buttonType == "item" then
		button:SetAttribute(buttonType, "item:" .. id)
		if C_Item.IsEquippableItem(id) and IsItemEquipped(id) then
			button:Highlight()
		end
	else
		button:SetAttribute(buttonType, id)
	end

	-- Positioning/Size
	button:SetParent(frame)
	button:SetSize(globalWidth, globalHeight)
	button:SetFrameStrata("HIGH")
	button:SetFrameLevel(102) -- This needs to be lower than the flyout frame

	if MasqueGroup then
		MasqueGroup:AddButton(button, { Icon = button.icon })
	end

	button:Show()
	return button
end

function SecureButton:RecycleAll()
	for _, secureButton in ipairs(secureButtons) do
		secureButton:Recycle()
	end
end
