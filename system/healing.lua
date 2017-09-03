local _, NeP = ...
local _G = _G
NeP.Healing = {}
local Roster = NeP.OM.Roster
local maxDistance = 40

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

function NeP.Healing.GetPredictedHealth(unit)
	return _G.UnitHealth(unit)+(_G.UnitGetTotalHealAbsorbs(unit) or 0)+(_G.UnitGetIncomingHeals(unit) or 0)
end

function NeP.Healing.GetPredictedHealth_Percent(unit)
	return math.floor((NeP.Healing.GetPredictedHealth(unit)/_G.UnitHealthMax(unit))*100)
end

function NeP.Healing.healthPercent(unit)
	return math.floor((_G.UnitHealth(unit)/_G.UnitHealthMax(unit))*100)
end

-- This Add's more index to the Obj in the OM table
local function Add(Obj)
	local healthRaw = _G.UnitHealth(Obj.key)
	local maxHealth = _G.UnitHealthMax(Obj.key)
	Obj.predicted = NeP.Healing.GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = NeP.Healing.GetPredictedHealth(Obj.key)
	Obj.health = NeP.Healing.healthPercent(Obj.key)
	Obj.healthRaw = healthRaw
	Obj.healthMax = maxHealth
	Obj.role = forced_role[Obj.id] or _G.UnitGroupRolesAssigned(Obj.key)
	Roster[Obj.guid] = Obj
end

local function Refresh(GUID, Obj)
	local temp = Roster[GUID]
	temp.health = NeP.Healing.healthPercent(Obj.key)
	temp.healthRaw = _G.UnitHealth(temp.key)
	temp.predicted = NeP.Healing.GetPredictedHealth_Percent(Obj.key)
	temp.predicted_Raw = NeP.Healing.GetPredictedHealth(Obj.key)
	temp.role = forced_role[Obj.id] or _G.UnitGroupRolesAssigned(Obj.key)
end

local function clean()
	for GUID, Obj in pairs(Roster) do
		-- remove invalid units
		if Obj.distance > maxDistance
		or not _G.UnitExists(Obj.key)
		or not _G.UnitInPhase(Obj.key)
		or GUID ~= _G.UnitGUID(Obj.key)
		or _G.UnitIsDeadOrGhost(Obj.key)
		or not NeP.Protected.LineOfSight('player', Obj.key) then
			Roster[GUID] = nil
		else
			Refresh(GUID, Obj)
		end
	end
end

local function Iterate()
	clean()
	for GUID, Obj in pairs(NeP.OM:Get('Friendly')) do
		if (_G.UnitInParty(Obj.key)
		or _G.UnitIsUnit('player', Obj.key))
		and Obj.distance < maxDistance
		and not Roster[GUID] then
			Add(Obj)
		end
	end
end

NeP.Debug:Add("Healing", Iterate, true)
_G.C_Timer.NewTicker(0.1, Iterate)
