local _, NeP = ...
local _G = _G
NeP.Healing = {}
local Roster = NeP.OM.Roster
local maxDistance = 40

function NeP.Healing.GetPredictedHealth(unit)
	return NeP._G.UnitHealth(unit)+(NeP._G.UnitGetTotalHealAbsorbs(unit) or 0)+(NeP._G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/NeP._G.UnitHealthMax(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((NeP._G.UnitHealth(unit)/NeP._G.UnitHealthMax(unit))*100)
end

local function Iterate()
	for _, Obj in pairs(NeP.OM:Get('Friendly')) do
		if Obj.range < maxDistance
		and NeP._G.UnitExists(Obj.key)
		and (NeP._G.UnitInParty(Obj.key) or NeP._G.UnitIsUnit('player', Obj.key))
		and not NeP._G.UnitIsCharmed(Obj.key) then
			Roster[Obj.guid] = Obj
		else
			Roster[Obj.guid] = nil
		end
	end
end

NeP.Debug:Add("Healing", Iterate, true)
NeP._G.C_Timer.NewTicker(0.1, Iterate)
