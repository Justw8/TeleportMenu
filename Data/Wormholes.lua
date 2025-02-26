local _, tpm = ...
local push = table.insert

--- @type { [integer]: boolean }
tpm.Wormholes = {
	[30542] = true, -- Dimensional Ripper - Area 52
	[18984] = true, -- Dimensional Ripper - Everlook
	[18986] = true, -- Ultrasafe Transporter: Gadgetzan
	[30544] = true, -- Ultrasafe Transporter: Toshley's Station
	[48933] = true, -- Wormhole Generator: Northrend
	[87215] = true, -- Wormhole Generator: Pandaria
	[112059] = true, -- Wormhole Centrifuge (Dreanor) 6
	[151652] = true, -- Wormhole Generator: Argus
	[168807] = true, -- Wormhole Generator: Kul Tiras 5
	[168808] = true, -- Wormhole Generator: Zandalar
	[172924] = true, -- Wormhole Generator: Shadowlands 3
	[198156] = true, -- Wyrmhole Generator: Dragon Isles 4
	[221966] = true, -- Wormhole Generator: Khaz Algar
}

function tpm:UpdateAvailableWormholes()
	local availableWormholes = {}
	for id, _ in pairs(tpm.Wormholes) do
		if PlayerHasToy(id) then
			push(availableWormholes, id)
		end
	end

	tpm.AvailableWormholes = availableWormholes
	tpm.AvailableWormholes.GetUsable = function()
		if #tpm.AvailableWormholes == 0 then
			return 0
		end

		local usableWormholes = {}
		for _, wormholeId in ipairs(availableWormholes) do
			if C_ToyBox.IsToyUsable(wormholeId) then
				table.insert(usableWormholes, wormholeId)
			end
		end
		return usableWormholes
	end
end
