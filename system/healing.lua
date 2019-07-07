local _, NeP = ...
local _G = _G
NeP.Healing = {}
local Roster = NeP.OM.Roster
local maxDistance = 40

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

function NeP.Healing.GetPredictedHealth(unit)
	return NeP._G.UnitHealth(unit)+(NeP._G.UnitGetTotalHealAbsorbs(unit) or 0)+(NeP._G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/NeP._G.UnitHealthMax(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((NeP._G.UnitHealth(unit)/NeP._G.UnitHealthMax(unit))*100)
end

-- This Add's more index to the Obj in the OM table
local function Add(Obj)
	Obj.predicted = NeP.Healing.GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = NeP.Healing.GetPredictedHealth(Obj.key)
	Obj.health = NeP.Healing.healthPercent(Obj.key)
	Obj.healthRaw = NeP._G.UnitHealth(Obj.key)
	Obj.healthMax = NeP._G.UnitHealthMax(Obj.key)
	Obj.role = forced_role[Obj.id] or NeP._G.UnitGroupRolesAssigned(Obj.key)
	Roster[Obj.guid] = Obj
end

local function Iterate()
	NeP._G.wipe(Roster)
	for _, Obj in pairs(NeP.OM:Get('Friendly')) do
		if Obj.distance < maxDistance
		and NeP._G.UnitExists(Obj.key)
		and (NeP._G.UnitInParty(Obj.key) or NeP._G.UnitIsUnit('player', Obj.key))
		and not NeP._G.UnitIsCharmed(Obj.key) then
			Add(Obj)
		end
	end
end

NeP.Debug:Add("Healing", Iterate, true)
NeP._G.C_Timer.NewTicker(0.1, Iterate)
