local _, NeP 			= ...
NeP.Healing 			= {}
local Roster 			= NeP.OM.Roster
local maxDistance = 40

-- Local stuff for speed
local UnitExists = _G.ObjectExists or _G.UnitExists
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitGetTotalHealAbsorbs = _G.UnitGetTotalHealAbsorbs
local UnitGetIncomingHeals = _G.UnitGetIncomingHeals
local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned
local UnitInParty = _G.UnitInParty
local UnitIsUnit = _G.UnitIsUnit
local strsplit = _G.strsplit
local C_Timer = _G.C_Timer

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

local function GetPredictedHealth(unit)
	return UnitHealth(unit)+(UnitGetTotalHealAbsorbs(unit) or 0)+(UnitGetIncomingHeals(unit) or 0)
end

local function GetPredictedHealth_Percent(unit)
	return math.floor((GetPredictedHealth(unit)/UnitHealthMax(unit))*100)
end

local function healthPercent(unit)
	return math.floor((UnitHealth(unit)/UnitHealthMax(unit))*100)
end

-- This Add's more index to the Obj in the OM table
local function Add(Obj)
	local healthRaw = UnitHealth(Obj.key)
	local maxHealth = UnitHealthMax(Obj.key)
	Obj.predicted = GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = GetPredictedHealth(Obj.key)
	Obj.health = healthPercent(Obj.key)
	Obj.healthRaw = healthRaw
	Obj.healthMax = maxHealth
	Obj.role = forced_role[Obj.id] or UnitGroupRolesAssigned(Obj.key)
	Roster[Obj.guid] = Obj
end

local function Refresh(GUID, Obj)
	local temp = Roster[GUID]
	temp.health = healthPercent(Obj.key)
	temp.healthRaw = UnitHealth(temp.key)
	temp.predicted = GetPredictedHealth_Percent(Obj.key)
	temp.predicted_Raw = GetPredictedHealth(Obj.key)
	temp.role = forced_role[Obj.id] or UnitGroupRolesAssigned(Obj.key)
end

function NeP.Healing.GetRoster()
	return Roster
end

local function Iterate()
	for GUID, Obj in pairs(NeP.OM:Get('Friendly')) do
		if UnitInParty(Obj.key)
		or UnitIsUnit('player', Obj.key) then
			if Roster[GUID] then
				Refresh(GUID, Obj)
			elseif Obj.distance < maxDistance then
				Add(Obj)
			end
		end
	end
end

NeP.Debug:Add("Healing", Iterate, true)
C_Timer.NewTicker(0.1, Iterate)

NeP.DSL:Register("health", function(target)
	return healthPercent(target)
end)

NeP.DSL:Register("health.actual", function(target)
	return UnitHealth(target)
end)

NeP.DSL:Register("health.max", function(target)
	return UnitHealthMax(target)
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
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
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
	if not UnitExists(unit) then return total end
	local distance, health = strsplit(",", args, 2)
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
