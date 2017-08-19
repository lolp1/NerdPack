local _, NeP = ...

NeP.Debug = {}
NeP.Debug.Profiles = {}
NeP.Debug.Profiles_dump = {}

SetCVar("scriptProfile", "1")

local GetFunctionCPUUsage = GetFunctionCPUUsage
local ResetCPUUsage = ResetCPUUsage
local C_Timer = C_Timer

function NeP.Debug:Add(name, func, subroutines)
	table.insert(self.Profiles, {
		name = name,
		func = func,
		sr = subroutines
	})
end

local tbl = NeP.Debug.Profiles
C_Timer.NewTicker(1, function()
	for i=1, #tbl do
		local usage, calls = GetFunctionCPUUsage(tbl[i].func, tbl[i].sr)
		NeP.Debug.Profiles_dump[tbl[i].name] = {
			cpu = usage,
			calls = calls
		}
	end
	ResetCPUUsage()
end, nil)

NeP.Globals.Debug = NeP.Debug
