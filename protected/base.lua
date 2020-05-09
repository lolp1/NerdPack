local _, NeP = ...
local strsplit = NeP._G.strsplit
local IsInGroup = NeP._G.IsInGroup
local IsInRaid = NeP._G.IsInRaid
local GetNumGroupMembers = NeP._G.GetNumGroupMembers

NeP.Protected = {}
NeP.Protected.callbacks = {}

local rangeCheck = NeP._G.LibStub("LibRangeCheck-2.0")
local noop = function() end

function NeP.Protected:AddCallBack(func)
    if not func() then table.insert(self.callbacks, func) end
end

NeP.Protected.Cast = function(...) NeP.Faceroll:Set(...) end

NeP.Protected.CastGround = function(...) NeP.Faceroll:Set(...) end

NeP.Protected.Macro = noop
NeP.Protected.UseItem = noop
NeP.Protected.UseInvItem = noop
NeP.Protected.TargetUnit = noop
NeP.Protected.SpellStopCasting = noop
NeP.Protected.ObjectExists = NeP._G.UnitExists
NeP.Protected.ObjectCreator = noop
NeP.Protected.GameObjectIsAnimating = noop
NeP.Protected.UnitName = NeP._G.UnitName
NeP.Protected.ObjectGUID = NeP._G.UnitGUID

NeP.Protected.Distance = function(_, b)
    local minRange, maxRange = rangeCheck:GetRange(b)
    return maxRange or minRange or 0
end

NeP.Protected.Infront = function(_, b)
	return NeP.Helpers:Infront(b) or false
end

NeP.Protected.UnitCombatRange = function(_, b)
	return rangeCheck:GetRange(b) or 0
end

NeP.Protected.LineOfSight = function(_, b)
	return NeP.Helpers:Infront(b) or false
end

local ValidUnits = {'player', 'mouseover', 'target', 'focus', 'pet'}
local ValidUnitsN = {'boss', 'arena', 'arenapet'}

NeP.Protected.nPlates = {Friendly = {}, Enemy = {}}

function NeP.Protected.nPlates:Insert(ref, Obj, GUID)
    local range = NeP.DSL:Get('range')(Obj)
    if range <= NeP.OM.max_distance then
        local ObjID = select(6, strsplit('-', GUID))
        self[ref][GUID] = {
            key = Obj,
            name = NeP.DSL:Get('name')(Obj),
            distance = NeP.DSL:Get('distance')(Obj),
            range = range,
            id = tonumber(ObjID or 0),
            guid = GUID,
			isdummy = NeP.DSL:Get('isdummy')(Obj),
			--healing
			predicted = NeP.DSL:Get('health.predicted')(Obj),
			predicted_Raw = NeP.DSL:Get('health.predicted.actual')(Obj),
			health = NeP.DSL:Get('health')(Obj),
			healthRaw = NeP.DSL:Get('health.actual')(Obj),
			healthMax = NeP.DSL:Get('health.max')(Obj),
			role = NeP.OM.forced_role[ObjID] or NeP.DSL:Get('role')(Obj),
			combat_tack_enable = false,
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
    end
end

NeP.Protected.OM_Maker = function()
    -- If in Group scan frames...
    if IsInGroup() or IsInRaid() then
        local prefix = (IsInRaid() and 'raid') or 'party'
        for i = 1, GetNumGroupMembers() do
            local unit = prefix .. i
            local pet = prefix .. 'pet' .. i
            NeP.OM:Add(unit)
            NeP.OM:Add(pet)
            NeP.OM:Add(unit .. 'target')
            NeP.OM:Add(pet .. 'target')
        end
    end
    -- Valid Units
    for i = 1, #ValidUnits do
        local object = ValidUnits[i]
        NeP.OM:Add(object)
        NeP.OM:Add(object .. 'target')
    end
    -- Valid Units with numb (5)
    for i = 1, #ValidUnitsN do
        for k = 1, 5 do
            local object = ValidUnitsN[i] .. k
            NeP.OM:Add(object)
            NeP.OM:Add(object .. 'target')
        end
    end
    -- nameplates
    for i = 1, 40 do
        local Obj = 'nameplate' .. i
        if NeP.DSL:Get('exists')(Obj) then
            local GUID = NeP.DSL:Get('guid')(Obj) or '0'
            if NeP._G.UnitIsFriend('player', Obj) then
                NeP.Protected.nPlates:Insert('Friendly', Obj, GUID)
            else
                NeP.Protected.nPlates:Insert('Enemy', Obj, GUID)
            end
        end
    end
end
