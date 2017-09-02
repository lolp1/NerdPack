local n_name, NeP = ...
local SetCVar = SetCVar
local wipe = wipe

NeP.Version = 1.8
NeP.Branch  = 'Beta10'
NeP.Media   = 'Interface\\AddOns\\' .. n_name .. '\\Media\\'
NeP.Color   = 'FFFFFF'

-- This exports stuff into global space
NeP.Globals = {}
_G.NeP = NeP.Globals

NeP.Cache = {
	Conditions = {},
	Spells = {},
	Targets = {}
}

function NeP.Wipe_Cache()
	for _, v in pairs(NeP.Cache) do
		wipe(v)
	end
end

-- Force lua erros on
SetCVar("scriptErrors", "1")
