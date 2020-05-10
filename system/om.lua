local _, NeP = ...

NeP.OM = {
	Memory = {},
	Enemy = {},
	Friendly = {},
	Dead = {},
	Objects = {},
	AreaTriggers = {},
	Critters = {},
	Roster = {},
	max_distance = 100
}

local function MergeTable(ref)
	local temp = {}
	for GUID, Obj in pairs(NeP.OM[ref] or {}) do
		if not temp[GUID] then
			temp[GUID] = Obj
		end
	end
	for GUID, Obj in pairs(NeP.Protected.nPlates[ref] or {}) do
		if not temp[GUID]
		and NeP.DSL:Get('exists')(Obj.key)
		and NeP.DSL:Get('inphase')(Obj.key)
		and GUID == NeP.DSL:Get('guid')(Obj.key) then
			temp[GUID] = Obj
		end
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

NeP.OM.forced_role = {
	[72218] = "TANK" -- Oto the Protector (Proving Grounds)
}

local function preLoadBuffs(Obj)
	local i, sName, count, type, duration, expiration, caster, isStealable, spellId, isBoss, sGUID, data = 1, true
	while sName do
		sName, _, count, type, duration, expiration, caster, isStealable,_,spellId,_, isBoss = NeP._G.UnitBuff(Obj.key, i)
		if sName then
			local found = Obj.buffs[sName] or Obj.buffs[spellId]
			sGUID = caster and NeP.DSL:Get('guid')(caster) or ''
			data = found or {}
			data.isCastByPlayer = sGUID == NeP.DSL:Get('guid')('player')
			data.SourceGUID = sGUID
			data.spellId = spellId
			data.spellName = sName
			data.auraType = 'BUFF'
			data.type = type
			data.count = count
			data.isStealable = isStealable
			data.isBoss = isBoss
			data.expiration = expiration
			data.duration = duration
			data.caster = caster
			Obj.buffs[sName] = data
			Obj.buffs[spellId] = data
			i=i+1
		end
	end
end

local function preLoadDebuffs(Obj)
	local i, sName, count, type, duration, expiration, caster, isStealable, spellId, isBoss, sGUID, data = 1, true
	while sName do
		sName, _, count, type, duration, expiration, caster, isStealable,_,spellId,_, isBoss = NeP._G.UnitDebuff(Obj.key, i)
		if sName then
			local found = Obj.debuffs[sName] or Obj.debuffs[spellId]
			sGUID = caster and NeP.DSL:Get('guid')(caster) or ''
			data = found or {}
			data.isCastByPlayer = sGUID == NeP.DSL:Get('guid')('player')
			data.SourceGUID = sGUID
			data.spellId = spellId
			data.spellName = sName
			data.auraType = 'DEBUFF'
			data.type = type
			data.count = count
			data.isStealable = isStealable
			data.isBoss = isBoss
			data.expiration = expiration
			data.duration = duration
			data.caster = caster
			Obj.debuffs[sName] = data
			Obj.debuffs[spellId] = data
			i=i+1
		end
	end
end

function NeP.OM.InsertObject(_, ref, Obj)
	Obj.tbl = ref
	if Obj.distance <= NeP.OM.max_distance then
		_G.C_Timer.After(5, function()
			Obj.name = NeP.DSL:Get('name')(Obj.key) or 'ERROR!_NO_NAME?'
		end)
		NeP.OM[ref][Obj.guid] = Obj
	end
end

-- they are the same for now, but i might need to change latter.
NeP.OM.InsertCritter = NeP.OM.InsertObject

function NeP.OM.Insert(_, ref, Obj)
	Obj.tbl = ref
	Obj.range = NeP.DSL:Get('range')(Obj.key) or 999
	if Obj.range <= NeP.OM.max_distance
	and NeP.DSL:Get('los')(Obj.key) then
		Obj.predicted = NeP.DSL:Get('health.predicted')(Obj.key)
		Obj.predicted_Raw = NeP.DSL:Get('health.predicted.actual')(Obj.key)
		Obj.health = NeP.DSL:Get('health')(Obj.key)
		Obj.healthRaw = NeP.DSL:Get('health.actual')(Obj.key)
		Obj.healthMax = NeP.DSL:Get('health.max')(Obj.key)
		Obj.role = NeP.OM.forced_role[Obj.id] or NeP.DSL:Get('role')(Obj.key)
		_G.C_Timer.After(5, function()
			Obj.name = NeP.DSL:Get('name')(Obj.key) or 'ERROR!_NO_NAME?'
		end)
		preLoadBuffs(Obj)
		preLoadDebuffs(Obj)
		NeP.OM[ref][Obj.guid] = Obj
	end
end

local critters = {
	["Non-combat Pet"] = true,
	["Wild Pet"] = true,
	["Critter"] = true,
	["Totem"] = true
  }

function NeP.OM.FitObject(_, Obj)
	-- stop if off
	if not NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		return
	end
	-- Objects
	if Obj.isObject then
		NeP.OM:InsertObject('Objects', Obj)
	elseif Obj.isAreaTrigger then
		NeP.OM:InsertObject('AreaTriggers', Obj)
	-- Units
	elseif NeP.DSL:Get('inphase')(Obj.key) then
		-- Critters
		if critters[NeP.DSL:Get('creatureType')(Obj.key)] then
			NeP.OM:InsertCritter('Critters', Obj)
		-- Units
		elseif NeP.DSL:Get('dead')(Obj.key) then
			NeP.OM:Insert('Dead', Obj)
		elseif NeP.DSL:Get('friend')(Obj.key) then
			NeP.OM:Insert('Friendly', Obj)
		elseif NeP.DSL:Get('canattack')(Obj.key) then
			NeP.OM:Insert('Enemy', Obj)
		end
	end
end

function NeP.OM.Add(_, Obj, isObject, isAreaTrigger)
	if not Obj then return end
	local GUID = NeP.DSL:Get('guid')(Obj)
	if not GUID then return end
	if NeP.OM.Memory[GUID] then
		return
	end
	local ObjID = select(6, NeP._G.strsplit('-', GUID))
	-- filter those with no id
	if not ObjID and not NeP.DSL:Get('is')(Obj, 'player') then return end
	local id = tonumber(ObjID or 0)
	local data = {
		key = Obj,
		name = '',
		distance = 999,
		range = 999,
		id = id,
		guid = GUID,
		isdummy = false,
		predicted = 0,
		predicted_Raw = 0,
		health = 0,
		healthRaw = 0,
		healthMax = 0,
		role = nil,
		combat_tack_enable = true,
		isObject = isObject,
		isAreaTrigger = isAreaTrigger,
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
		last_hit_taken_time = 0,
		last_hit_done_time = 0,
		combat_time = 0,
		spell_value = {},
		--buffs
		buffs = {},
		debuffs = {},
	}
	NeP.OM.Memory[GUID] = data
	NeP.OM:FitObject(data)
end

local function loadName(Obj)
	Obj.name = 'Loading'
	Obj.name = NeP.DSL:Get('name')(Obj.key)
	if Obj.name == '' then
		_G.C_Timer.After(1, function()
			Obj.name = NeP.DSL:Get('name')(Obj.key) or 'ERROR!_NO_NAME?'
			if Obj.name == '' then
				Obj.name = 'ERROR!_NO_NAME!'
			end
		end)
	end
end

local function cleanObject(Obj)
	Obj.distance = NeP.DSL:Get('distance')(Obj.key)
	-- remove invalid units
	if Obj.distance > NeP.OM.max_distance then
		NeP.OM[Obj.tbl][Obj.guid] = nil
		return
	end
	--update
	if Obj.name == 'Unknown'
	or Obj.name == '' then
		loadName(Obj)
	end
	-- restore
	if not NeP.OM[Obj.tbl][Obj.guid] then
		NeP.OM[Obj.tbl][Obj.guid] = Obj
	end
end

local function cleanUnit(Obj)
	local ctime = NeP._G.GetTime()
	Obj.range = NeP.DSL:Get('range')(Obj.key)
	-- remove invalid units
	if Obj.range > NeP.OM.max_distance
	or not NeP.DSL:Get('inphase')(Obj.key)
	or not NeP.DSL:Get('los')(Obj.key) then
		NeP.OM[Obj.tbl][Obj.guid] = nil
		NeP.OM.Roster[Obj.guid] = nil -- fail safe
		return
	end
	-- move Dead
	local dead = NeP.DSL:Get('dead')(Obj.key)
	if Obj.tbl ~= 'Dead' and dead then
		NeP.OM.Dead[Obj.guid] = Obj
		NeP.OM[Obj.tbl][Obj.guid] = nil
		Obj.tbl = 'Dead'
	elseif Obj.tbl == 'Dead' and not dead then
		local where = NeP.DSL:Get('friend')(Obj.key) and 'Friendly' or 'Enemy'
		NeP.OM[where][Obj.guid] = Obj
		NeP.OM.Dead[Obj.guid] = nil
		Obj.tbl = where
	end
	-- combat reset?
	if (ctime - Obj.last_hit_taken_time) > 15
	and (ctime - Obj.last_hit_done_time) > 15 then
		Obj.combat_time = 0
		Obj.dmgTaken = 0
		Obj.dmgTaken_P = 0
		Obj.dmgTaken_M = 0
		Obj.hits_taken = 0
		Obj.lastHit_taken = 0
		Obj.dmgDone = 0
		Obj.dmgDone_P = 0
		Obj.dmgDone_M = 0
		Obj.hits_done = 0
		Obj.lastHit_done = 0
		Obj.heal_taken = 0
		Obj.heal_hits_taken = 0
		Obj.heal_done = 0
		Obj.heal_hits_done = 0
		Obj.last_hit_taken_time = 0
		Obj.last_hit_done_time = 0
	end
	-- roster?
	if Obj.tbl == 'Friendly'
	and Obj.range < 40
	and (
		NeP.DSL:Get('ingroup')(Obj.key)
		or NeP.DSL:Get('is')('player', Obj.key)
	)
	and not NeP.DSL:Get('charmed')(Obj.key) then
		NeP.OM.Roster[Obj.guid] = Obj
	else
		NeP.OM.Roster[Obj.guid] = nil
	end
	-- update unit
	Obj.distance = NeP.DSL:Get('distance')(Obj.key)
	Obj.predicted = NeP.DSL:Get('health.predicted')(Obj.key)
	Obj.predicted_Raw = NeP.DSL:Get('health.predicted.actual')(Obj.key)
	Obj.health = NeP.DSL:Get('health')(Obj.key)
	Obj.healthRaw = NeP.DSL:Get('health.actual')(Obj.key)
	Obj.healthMax = NeP.DSL:Get('health.max')(Obj.key)
	Obj.role = NeP.OM.forced_role[Obj.id] or NeP.DSL:Get('role')(Obj.key)
	if Obj.name == 'Unknown'
	or Obj.name == '' then
		loadName(Obj)
	end
	-- restore
	if not NeP.OM[Obj.tbl][Obj.guid] then
		NeP.OM[Obj.tbl][Obj.guid] = Obj
	end
end

local function cleanUpdate()
	for GUID, Obj in pairs(NeP.OM.Memory) do
		-- should this be inserted now?
		if not Obj.tbl then
			NeP.OM:FitObject(Obj)
		-- completly invalid?
		elseif not NeP.DSL:Get('exists')(Obj.key) then
			NeP.OM.Memory[GUID] = nil
			if Obj.tbl then
				NeP.OM[Obj.tbl][Obj.guid] = nil
			end
			NeP.OM.Roster[Obj.guid] = nil -- fail safe
		--guid changed?(how? reset it...)
		elseif GUID ~= NeP.DSL:Get('guid')(Obj.key) then
			NeP.OM.Memory[GUID] = nil
			if Obj.tbl then
				NeP.OM[Obj.tbl][Obj.guid] = nil
			end
			NeP.OM.Roster[Obj.guid] = nil -- fail safe
			NeP.OM:Add(Obj.key)
		--clean
		elseif Obj.tbl == 'Objects' then
			cleanObject(Obj)
		elseif Obj.tbl == 'AreaTriggers' then
			cleanObject(Obj)
		elseif Obj.tbl == 'Critters' then
			cleanObject(Obj)
		elseif Obj.tbl == 'Enemy' then
			cleanUnit(Obj)
		elseif Obj.tbl == 'Friendly' then
			cleanUnit(Obj)
		elseif Obj.tbl == 'Dead' then
			cleanUnit(Obj)
		end
	end
end

function NeP.OM.CleanStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		cleanUpdate()
	else
		NeP._G.wipe(NeP.OM['Objects'])
		NeP._G.wipe(NeP.OM['AreaTriggers'])
		NeP._G.wipe(NeP.OM['Dead'])
		NeP._G.wipe(NeP.OM['Friendly'])
		NeP._G.wipe(NeP.OM['Enemy'])
		NeP._G.wipe(NeP.OM['Critters'])
	end
end

local function MakerStart()
	if NeP.DSL:Get("toggle")(nil, "mastertoggle") then
		NeP.Protected:OM_Maker()
	end
end

function NeP.OM.FindObjectByGuid(_, guid)
	if not guid then return end
	return NeP.OM.Memory[guid]
end

function NeP.OM.MoveObjectByGuid(_, guid, ref)
	if not guid then return end
	local Obj = NeP.OM:FindObjectByGuid(guid)
	if not (Obj and NeP.OM[ref]) then return end
	NeP.OM[ref][Obj.guid] = Obj
	if Obj.tbl then
		NeP.OM[Obj.tbl][Obj.guid] = nil
	end
	NeP.OM.Roster[Obj.guid] = nil -- fail safe
	Obj.tbl = ref
end

function NeP.OM.RemoveObjectByGuid(_, guid)
	if not guid then return end
	local Obj = NeP.OM:FindObjectByGuid(guid)
	if not Obj then return end
	NeP.OM.Memory[Obj.guid] = nil
	NeP.OM.Roster[Obj.guid] = nil -- fail safe
	if Obj.tbl then
		NeP.OM[Obj.tbl][Obj.guid] = nil
	end
end

NeP.Debug:Add("OM_Clean", NeP.OM.CleanStart, true)
NeP.Debug:Add("OM_Maker", MakerStart, true)
NeP.Timer.Add('OM_Maker', MakerStart, 1)