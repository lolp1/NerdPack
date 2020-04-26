local _, NeP = ...
local _G = _G

NeP.OM = {
	Enemy = {},
	Friendly = {},
	Dead = {},
	Objects = {},
	Roster = {},
	max_distance = 100
}

local function MergeTable_Insert(table, Obj, GUID)
	if not table[GUID]
	and NeP.DSL:Get('exists')(Obj.key)
	and NeP._G.UnitInPhase(Obj.key)
	and GUID == NeP.Protected.ObjectGUID(Obj.key) then
		table[GUID] = Obj
		Obj.range = NeP.DSL:Get('range')(Obj.key)
		Obj.distance = NeP.DSL:Get('distance')(Obj.key)
	end
end

local function MergeTable(ref)
	local temp = {}
	for GUID, Obj in pairs(NeP.OM[ref]) do
		MergeTable_Insert(temp, Obj, GUID)
	end
	for GUID, Obj in pairs(NeP.Protected.nPlates[ref]) do
		MergeTable_Insert(temp, Obj, GUID)
	end
	return temp
end

function NeP.OM.Get(_, ref, want_plates)
	if want_plates
	and NeP.Protected.nPlates
	and NeP.Protected.nPlates[ref] then
		return MergeTable(ref)
	end
	return NeP.OM[ref]
end

local forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

function NeP.OM.UpdateUnit(_, ref, GUID)
	local Obj = NeP.OM[ref][GUID]
	Obj.distance = NeP.DSL:Get('distance')(Obj.key)
	Obj.range = NeP.DSL:Get('range')(Obj.key)
	Obj.predicted = NeP.Healing.GetPredictedHealth_Percent(Obj.key)
	Obj.predicted_Raw = NeP.Healing.GetPredictedHealth(Obj.key)
	Obj.health = NeP.Healing.healthPercent(Obj.key)
	Obj.healthRaw = NeP._G.UnitHealth(Obj.key)
	Obj.healthMax = NeP._G.UnitHealthMax(Obj.key)
	Obj.role = forced_role[Obj.id] or NeP._G.UnitGroupRolesAssigned(Obj.key)
end

function NeP.OM.Insert(_, ref, Obj)
	local GUID = NeP.Protected.ObjectGUID(Obj)
	if GUID then
		local range = NeP.DSL:Get('range')(Obj) or 999
		if range > NeP.OM.max_distance then
			NeP.OM[ref][GUID] = nil
			return
		end
		if NeP.OM[ref][GUID] then
			NeP.OM:UpdateUnit(ref, GUID)
			return
		end
		local ObjID = select(6, NeP._G.strsplit('-', GUID))
		NeP.OM[ref][GUID] = {
			key = Obj,
			name = NeP.Protected.UnitName(Obj),
			distance = NeP.DSL:Get('distance')(Obj),
			range = range,
			id = tonumber(ObjID or 0),
			guid = GUID,
			isdummy = NeP.DSL:Get('isdummy')(Obj),
			--healing
			predicted = NeP.Healing.GetPredictedHealth_Percent(Obj),
			predicted_Raw = NeP.Healing.GetPredictedHealth(Obj),
			health = NeP.Healing.healthPercent(Obj),
			healthRaw = NeP._G.UnitHealth(Obj),
			healthMax = NeP._G.UnitHealthMax(Obj),
			role = forced_role[ObjID] or NeP._G.UnitGroupRolesAssigned(Obj),
			-- Damage Taken
			dmgTaken = 0,
			dmgTaken_P = 0,
			dmgTaken_M = 0,
			hits_taken = 0,
			lastHit_taken = 0,
			-- Damage Done
			dmgDone = 0,
			dmgDone_P = 0,
			dmgDone_M = 0,
			hits_done = 0,
			lastHit_done = 0,
			-- Healing taken
			heal_taken = 0,
			heal_hits_taken = 0,
			-- Healing Done
			heal_done = 0,
			heal_hits_done = 0,
			--shared
			combat_time = NeP._G.GetTime(),
			spell_value = {},
			--buffs
			buffs = {},
			debuffs = {},
		}
	end
end

function NeP.OM.Add(_, Obj, isObject)
	-- Objects
	if isObject then
		NeP.OM:Insert('Objects', Obj)
	-- Units
	elseif NeP.DSL:Get("exists")(Obj)
	and NeP._G.UnitInPhase(Obj)
	and NeP.DSL:Get('los')(Obj) then
		if NeP._G.UnitIsDeadOrGhost(Obj) then
			NeP.OM:Insert('Dead', Obj)
		elseif NeP._G.UnitIsFriend('player', Obj) then
			NeP.OM:Insert('Friendly', Obj)
		elseif NeP._G.UnitCanAttack('player', Obj) then
			NeP.OM:Insert('Enemy', Obj)
		end
	end
end

function cleanObjects()
	for GUID, Obj in pairs(NeP.OM["Objects"]) do
		if Obj.range > NeP.OM.max_distance
		or not NeP.DSL:Get('exists')(Obj.key)
		or GUID ~= NeP.Protected.ObjectGUID(Obj.key) then
			NeP.OM.Objects[GUID] = nil
		end
	end
end

function cleanOthers(ref)
	for GUID, Obj in pairs(NeP.OM[ref]) do
		-- remove invalid units
		if Obj.range > NeP.OM.max_distance
		or not NeP.DSL:Get('exists')(Obj.key)
		or not NeP._G.UnitInPhase(Obj.key)
		or GUID ~= NeP.Protected.ObjectGUID(Obj.key)
		or ref ~= "Dead" and NeP._G.UnitIsDeadOrGhost(Obj.key)
		or not NeP.DSL:Get('los')(Obj.key) then
			NeP.OM[ref][GUID] = nil
		end
	end
end

local function CleanStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		cleanObjects()
		cleanOthers("Dead")
		cleanOthers("Friendly")
		cleanOthers("Enemy")
	else
		NeP._G.wipe(NeP.OM['Objects'])
		NeP._G.wipe(NeP.OM['Dead'])
		NeP._G.wipe(NeP.OM['Friendly'])
		NeP._G.wipe(NeP.OM['Enemy'])
	end
end

local function MakerStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		NeP.Protected:OM_Maker()
	end
end

function NeP.OM.FindObjectByGuid(_, guid)
	return NeP.OM['Objects'][guid]
	or NeP.OM['Dead'][guid]
	or NeP.OM['Friendly'][guid]
	or NeP.OM['Enemy'][guid]
end

NeP.Debug:Add("OM_Clean", CleanStart, true)
NeP.Debug:Add("OM_Maker", MakerStart, true)

NeP._G.C_Timer.NewTicker(0.5, CleanStart)
NeP._G.C_Timer.NewTicker(1, MakerStart)
