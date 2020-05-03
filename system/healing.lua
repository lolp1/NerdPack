local _, NeP = ...
NeP.Healing = {}

function NeP.Healing.GetPredictedHealth(unit)
	return NeP.DSL:Get('health.actual')(unit)
	+ (NeP._G.UnitGetTotalHealAbsorbs(unit) or 0)
	+ (NeP._G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/NeP.DSL:Get('health.max')(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((NeP.DSL:Get('health.actual')(unit)/NeP.DSL:Get('health.max')(unit))*100)
end