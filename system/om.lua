local _, NeP = ...
local _G = _G

NeP.OM = {
	Enemy    = {},
	Friendly = {},
	Dead     = {},
	Objects  = {},
	Roster   = {},
	max_distance = 100
}

local OM_c = {
	Enemy    = NeP.OM.Enemy,
	Friendly = NeP.OM.Friendly,
	Dead     = NeP.OM.Dead,
	Objects  = NeP.OM.Objects,
	Roster   = NeP.OM.Roster
}
local clean = {}

local function MergeTable_Insert(table, Obj, GUID)
	if not table[GUID]
	and NeP.DSL:Get('exists')(Obj.key)
	and NeP._G.UnitInPhase(Obj.key)
	and GUID == NeP.Protected.ObjectGUID(Obj.key) then
		table[GUID] = Obj
		Obj.distance = NeP.DSL:Get('distance')('player', nil, Obj.key)
	end
end

local function MergeTable(ref)
	local temp = {}
	for GUID, Obj in pairs(OM_c[ref]) do
		MergeTable_Insert(temp, Obj, GUID)
	end
	for GUID, Obj in pairs(NeP.Protected.nPlates[ref]) do
		MergeTable_Insert(temp, Obj, GUID)
	end
	return temp
end

function clean.Objects()
	for GUID, Obj in pairs(OM_c["Objects"]) do
		if Obj.distance > NeP.OM.max_distance
		or not NeP.DSL:Get('exists')(Obj.key)
		or GUID ~= NeP.Protected.ObjectGUID(Obj.key) then
			OM_c.Objects[GUID] = nil
		end
	end
end

function clean.Others(ref)
	for GUID, Obj in pairs(OM_c[ref]) do
		-- remove invalid units
		if Obj.distance > NeP.OM.max_distance
		or not NeP.DSL:Get('exists')(Obj.key)
		or not NeP._G.UnitInPhase(Obj.key)
		or GUID ~= NeP.Protected.ObjectGUID(Obj.key)
		or ref ~= "Dead" and NeP._G.UnitIsDeadOrGhost(Obj.key)
		or not NeP.DSL:Get('los')('player', Obj.key) then
			OM_c[ref][GUID] = nil
		end
	end
end

function NeP.OM.Get(_, ref, want_plates)
	if want_plates
	and NeP.Protected.nPlates
	and NeP.Protected.nPlates[ref] then
		return MergeTable(ref)
	end
	return OM_c[ref]
end

function NeP.OM.Insert(_, ref, Obj)
	local GUID = NeP.Protected.ObjectGUID(Obj)
	local distance = NeP.DSL:Get('distance')('player', nil, Obj) or 999
	if GUID and distance <= NeP.OM.max_distance then
		local ObjID = select(6, NeP._G.strsplit('-', GUID))
		OM_c[ref][GUID] = {
			key = Obj,
			name = NeP.Protected.UnitName(Obj),
			distance = distance,
			id = tonumber(ObjID or 0),
			guid = GUID,
			isdummy = NeP.DSL:Get('isdummy')(Obj)
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
	and NeP.DSL:Get('los')('player', Obj) then
		if NeP._G.UnitIsDeadOrGhost(Obj) then
			NeP.OM:Insert('Dead', Obj)
		elseif NeP._G.UnitIsFriend('player', Obj) then
			NeP.OM:Insert('Friendly', Obj)
		elseif NeP._G.UnitCanAttack('player', Obj) then
			NeP.OM:Insert('Enemy', Obj)
		end
	end
end

local function CleanStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		clean.Objects()
		clean.Others("Dead")
		clean.Others("Friendly")
		clean.Others("Enemy")
	else
		for _, v in pairs(OM_c) do
			NeP._G.wipe(v)
		end
	end
end

local function MakerStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		NeP.Protected:OM_Maker()
	end
end

NeP.Debug:Add("OM_Clean", CleanStart, true)
NeP.Debug:Add("OM_Maker", MakerStart, true)

NeP._G.C_Timer.NewTicker(0.5, CleanStart)
NeP._G.C_Timer.NewTicker(1, MakerStart)
