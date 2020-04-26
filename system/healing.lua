local _, NeP = ...
local _G = _G
NeP.Healing = {}
local Roster = NeP.OM.Roster
local maxDistance = 40

function NeP.Healing.GetPredictedHealth(unit)
	return NeP.DSL:Get('health.actual')(unit)+(NeP._G.UnitGetTotalHealAbsorbs(unit) or 0)+(NeP._G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/NeP.DSL:Get('health.max')(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((NeP.DSL:Get('health.actual')(unit)/NeP.DSL:Get('health.max')(unit))*100)
end

local function Iterate()
	for _, Obj in pairs(NeP.OM:Get('Friendly')) do
		if Obj.range < maxDistance
		and NeP.DSL:Get('exists')(Obj.key)
		and (NeP.DSL:Get('ingroup')(Obj.key) or NeP.DSL:Get('is')('player', Obj.key))
		and not NeP.DSL:Get('charmed')(Obj.key) then
			Roster[Obj.guid] = Obj
		else
			Roster[Obj.guid] = nil
		end
	end
end

NeP.Debug:Add("Healing", Iterate, true)
NeP._G.C_Timer.NewTicker(0.1, Iterate)
