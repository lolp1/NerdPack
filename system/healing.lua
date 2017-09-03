local _, NeP = ...
local _G = _G
NeP.Healing = {}
local Roster = NeP.OM.Roster
local maxDistance = 40

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

local function GetPredictedHealth(unit)
	return _G.UnitHealth(unit)+(_G.UnitGetTotalHealAbsorbs(unit) or 0)+(_G.UnitGetIncomingHeals(unit) or 0)
end

local function GetPredictedHealth_Percent(unit)
	return math.floor((GetPredictedHealth(unit)/_G.UnitHealthMax(unit))*100)
end

local function healthPercent(unit)
	return math.floor((_G.UnitHealth(unit)/_G.UnitHealthMax(unit))*100)
end

-- This Add's more index to the Obj in the OM table
local function Add(Obj)
	local healthRaw = _G.UnitHealth(Obj.key)
	local maxHealth = _G.UnitHealthMax(Obj.key)
	Obj.predicted = GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = GetPredictedHealth(Obj.key)
	Obj.health = healthPercent(Obj.key)
	Obj.healthRaw = healthRaw
	Obj.healthMax = maxHealth
	Obj.role = forced_role[Obj.id] or _G.UnitGroupRolesAssigned(Obj.key)
	Roster[Obj.guid] = Obj
end

local function Refresh(GUID, Obj)
	local temp = Roster[GUID]
	temp.health = healthPercent(Obj.key)
	temp.healthRaw = _G.UnitHealth(temp.key)
	temp.predicted = GetPredictedHealth_Percent(Obj.key)
	temp.predicted_Raw = GetPredictedHealth(Obj.key)
	temp.role = forced_role[Obj.id] or _G.UnitGroupRolesAssigned(Obj.key)
end

function NeP.Healing.GetRoster()
	return Roster
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

NeP.DSL:Register("health", function(target)
	return healthPercent(target)
end)

NeP.DSL:Register("health.actual", function(target)
	return _G.UnitHealth(target)
end)

NeP.DSL:Register("health.max", function(target)
	return _G.UnitHealthMax(target)
end)

NeP.DSL:Register("health.predicted", function(target)
	return GetPredictedHealth_Percent(target)
end)

NeP.DSL:Register("health.predicted.actual", function(target)
	return GetPredictedHealth(target)
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal >= #
NeP.DSL:Register("area.heal", function(unit, args)
	local total = 0
	if not _G.UnitExists(unit) then return total end
	local distance, health = _G.strsplit(",", args, 2)
	for _,Obj in pairs(NeP.Healing:GetRoster()) do
		local unit_dist = NeP.Protected.Distance(unit, Obj.key)
		if unit_dist < (tonumber(distance) or 20)
		and Obj.health < (tonumber(health) or 100) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal.infront >= #
NeP.DSL:Register("area.heal.infront", function(unit, args)
	local total = 0
	if not _G.UnitExists(unit) then return total end
	local distance, health = _G.strsplit(",", args, 2)
	for _,Obj in pairs(NeP.Healing:GetRoster()) do
		local unit_dist = NeP.Protected.Distance(unit, Obj.key)
		if unit_dist < (tonumber(distance) or 20)
		and Obj.health < (tonumber(health) or 100)
		and NeP.Protected.Infront(unit, Obj.key) then
			total = total + 1
		end
	end
	return total
end)

NeP.Globals.OM.GetRoster = NeP.Healing.GetRoster
