local _, NeP = ...

NeP.DSL:Register('ingroup', function(target)
  return NeP._G.UnitInParty(target) or NeP._G.UnitInRaid(target)
end)

NeP.DSL:Register('group.members', function()
  return (NeP._G.GetNumGroupMembers() or 0)
end)

-- USAGE: group.type==#
-- * 3 = RAID
-- * 2 = Party
-- * 1 = SOLO
NeP.DSL:Register('group.type', function()
  return NeP._G.IsInRaid() and 3 or NeP._G.IsInGroup() and 2 or 1
end)

local UnitClsf = {
  ['elite'] = 2,
  ['rareelite'] = 3,
  ['rare'] = 4,
  ['worldboss'] = 5
}

NeP.DSL:Register("boss", function (target)
  if NeP.DSL:Get("isdummy")(target) then return end
  local classification = NeP._G.UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 3 or NeP.BossID:Eval(target)
  end
end)

NeP.DSL:Register('elite', function (target)
  local classification = NeP._G.UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 2
  end
  return NeP.BossID:Eval(target)
end)

NeP.DSL:Register('id', function(target, id)
  local expectedID = tonumber(id)
  return expectedID and NeP.Core:UnitID(target) == expectedID
end)

NeP.DSL:Register('threat', function(target)
  if NeP.DSL:Get('aggro')(target) then
    return select(3, NeP._G.UnitDetailedThreatSituation('player', target))
  end
  return 0
end)

NeP.DSL:Register('aggro', function(target)
  local threat = NeP._G.UnitThreatSituation(target)
  return (threat and threat >= 2)
end)

NeP.DSL:Register('moving', function(target)
  local speed, _ = NeP._G.GetUnitSpeed(target)
  return speed ~= 0
end)

NeP.DSL:Register('classification', function (target, spell)
  if not spell then return false end
  local classification = NeP._G.UnitClassification(target)
  if string.find(spell, '[%s,]+') then
    for classificationExpected in string.gmatch(spell, '%a+') do
      if classification == string.lower(classificationExpected) then
        return true
      end
    end
    return false
  else
    return NeP._G.UnitClassification(target) == string.lower(spell)
  end
end)

NeP.DSL:Register('target', function(target, spell)
  return ( NeP.DSL:Get('guid')(target .. 'target') == NeP.DSL:Get('guid')(spell) )
end)

NeP.DSL:Register({'player', 'isplayer'}, function(target)
  return NeP._G.UnitIsPlayer(target)
end)

NeP.DSL:Register('inphase', function(unit)
  if not NeP.DSL:Get("exists")(unit) then
    return false
  end
  local reason = NeP._G.UnitPhaseReason(unit)
  if UnitIsPlayer(unit) then
    return reason == nil
  end
  return reason == nil or reason == 2 --warmode is 2
end)

NeP.DSL:Register('exists', function(target)
  return NeP.Protected.ObjectExists(target)
end)

NeP.DSL:Register('guid', function(target)
  return NeP.Protected.ObjectGUID(target)
end)

NeP.DSL:Register('visible', function(target)
  return NeP._G.UnitIsVisible(target)
end)

NeP.DSL:Register('dead', function (target)
  return NeP._G.UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('alive', function(target)
  return not NeP._G.UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('behind', function(target, _, target2)
  return not NeP.Protected.Infront(target2 or 'player', target)
end)

NeP.DSL:Register('infront', function(target, _, target2)
  return NeP.Protected.Infront(target2 or 'player', target)
end)

local movingCache = {}

NeP.DSL:Register('lastmoved', function(target)
  if NeP.DSL:Get('exists')(target) then
    local guid = NeP.DSL:Get('guid')(target)
    if movingCache[guid] then
      local moving = (NeP._G.GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving and moving then
        movingCache[guid].last = NeP._G.GetTime()
        movingCache[guid].moving = true
        return false
      elseif moving then
        return false
      elseif not moving then
        movingCache[guid].moving = false
        return NeP._G.GetTime() - movingCache[guid].last
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = NeP._G.GetTime()
      movingCache[guid].moving = (NeP._G.GetUnitSpeed(target) > 0)
      return false
    end
  end
  return false
end)

NeP.DSL:Register('movingfor', function(target)
  if NeP.DSL:Get('exists')(target) then
    local guid = NeP.DSL:Get('guid')(target)
    if movingCache[guid] then
      local moving = (NeP._G.GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving then
        movingCache[guid].last = NeP._G.GetTime()
        movingCache[guid].moving = (NeP._G.GetUnitSpeed(target) > 0)
        return 0
      elseif moving then
        return NeP._G.GetTime() - movingCache[guid].last
      elseif not moving then
        movingCache[guid].moving = false
        return 0
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = NeP._G.GetTime()
      movingCache[guid].moving = (NeP._G.GetUnitSpeed(target) > 0)
      return 0
    end
  end
  return 0
end)

NeP.DSL:Register('friend', function(unit, _, unit2)
  return NeP._G.UnitIsFriend(unit2 or 'player', unit)
end)

NeP.DSL:Register({'enemy', 'canattack'}, function(unit, _, unit2)
  return NeP._G.UnitCanAttack(unit2 or 'player', unit)
end)

NeP.DSL:Register({'range', 'rangefrom'}, function(unit, _, unit2)
  return NeP.Protected.UnitCombatRange(unit2 or 'player', unit) or 999
end)

NeP.DSL:Register({'distance', 'distancefrom'}, function(unit, _, unit2)
	if NeP._G.UnitExists('target') then
		local gt = NeP._G.UnitGUID('target')
			print('has target', gt)
		if (NeP._G.UnitGUID(unit) == gt) then
			print('a', unit2)
			print('NEP',NeP.Protected.Distance(unit2 or 'player', unit), unit, unit2)
		elseif (NeP._G.UnitGUID(unit2) == gt) then
			print('b', unit)
			print('NEP', NeP.Protected.Distance(unit2 or 'player', unit), unit, unit2)
		end
	end
  return NeP.Protected.Distance(unit2 or 'player', unit) or 999
end)

NeP.DSL:Register('level', function(target)
  return NeP._G.UnitLevel(target)
end)

NeP.DSL:Register('combat', function(target)
  return NeP._G.UnitAffectingCombat(target)
end)

-- Checks if the player has autoattack toggled currently
-- Use {'/startattack', '!isattacking'}, at the top of a CR to force autoattacks
NeP.DSL:Register('isattacking', function()
  return NeP._G.IsCurrentSpell(6603)
end)

NeP.DSL:Register('role', function(target)
  return NeP._G.UnitGroupRolesAssigned(target)
end)

NeP.DSL:Register('name', function (target)
  return target and NeP.Protected.UnitName(target)
end)

NeP.DSL:Register('hasRole', function(target, expectedName)
  return target and NeP.DSL:Get('role')(target):lower():find(expectedName:lower()) ~= nil
end)

NeP.DSL:Register('hasName', function (target, expectedName)
  return target and NeP.DSL:Get('name')(target):lower():find(expectedName:lower()) ~= nil
end)

NeP.DSL:Register('creatureType', function (target)
  return NeP._G.UnitCreatureType(target)
end)

NeP.DSL:Register('hascreatureType', function (target, expectedType)
  return NeP.DSL:Get('creatureType')(target) == expectedType
end)

NeP.DSL:Register('class', function (target, expectedClass)
  local class, _, classID = NeP._G.UnitClass(target)
  if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
  else
    return expectedClass == class
  end
end)

NeP.DSL:Register('melee', function()
  -- probably should add talents and other exeptions that mess with range here
  --[[
    since im lazy to figure out all of them you can overwrite this condition in your own code doing:
      NeP.DSL:Register('melee', function() ... end, true)
  ]]
  return 3
end)

NeP.DSL:Register('ranged', function()
  -- probably should add talents and other exeptions that mess with range here
  --[[
    since im lazy to figure out all of them you can overwrite this condition in your own code doing:
      NeP.DSL:Register('ranged', function() ... end, true)
  ]]
  return 40
end)

NeP.DSL:Register('inmelee', function(target, spell)
  if NeP.DSL:Get('spell.range')(target, spell) then
    return true
  end
  local range = NeP.DSL:Get('range')(target)
  return range <= NeP.DSL:Get('melee')(), range
end)

NeP.DSL:Register('inranged', function(target, spell)
  if NeP.DSL:Get('spell.range')(target, spell) then
    return true
  end
  local range = NeP.DSL:Get('range')(target)
  return range <= NeP.DSL:Get('ranged')(), range
end)

NeP.DSL:Register('incdmg', function(target, args)
  if args and NeP.DSL:Get('exists')(target) then
    local pDMG = NeP.CombatTracker:getDMG(target)
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.phys', function(target, args)
  if args and NeP.DSL:Get('exists')(target) then
    local pDMG = select(3, NeP.CombatTracker:getDMG(target))
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.magic', function(target, args)
  if args and NeP.DSL:Get('exists')(target) then
    local mDMG = select(4, NeP.CombatTracker:getDMG(target))
    return mDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('swimming', function ()
  return NeP._G.IsSwimming()
end)

--return if a unit is a unit
NeP.DSL:Register('is', function(a,b)
  return NeP._G.UnitIsUnit(a,b)
end)

NeP.DSL:Register("falling", function()
  return NeP._G.IsFalling()
end)

local last_fall = 0;
local falling_for = 0;

local function buildFallTime()
	-- if we´re not falling then reset the counter and return 0
  if not NeP._G.IsFalling() then
    last_fall = 0
		falling_for = 0
		return;
  end
  -- if we have a time set then return the difference
  local time = NeP._G.GetTime()
  if last_fall > 0 then
    falling_for = time - last_fall
		return;
  end
  -- otherwise set time and return 0
  last_fall = time
	falling_for = 0
end
NeP._G.C_Timer.NewTicker(0.1, buildFallTime)

NeP.DSL:Register({"falling.duration", "fall.duration"}, function()
  return falling_for
end)

NeP.DSL:Register({"deathin", "ttd", "timetodie"}, function(target)
  return NeP.CombatTracker:TimeToDie(target)
end)

NeP.DSL:Register("charmed", function(target)
  return NeP._G.UnitIsCharmed(target)
end)

local communName = NeP.Locale:TA('Dummies', 'Name')
local matchs = NeP.Locale:TA('Dummies', 'Pattern')

NeP.DSL:Register('isdummy', function(unit)
  if not NeP.DSL:Get('exists')(unit) then return end
  if NeP._G.UnitName(unit):lower():find(communName) then return true end
  return NeP.Tooltip:Unit(unit, matchs)
end)

NeP.DSL:Register('indoors', function()
    return NeP._G.IsIndoors()
end)

NeP.DSL:Register('haste', function(unit)
  return NeP._G.UnitSpellHaste(unit)
end)

NeP.DSL:Register("mounted", function()
  return NeP._G.IsMounted()
end)

NeP.DSL:Register('combat.time', function(target)
  return NeP.CombatTracker:CombatTime(target)
end)

NeP.DSL:Register('los', function(a, b)
  return NeP.DSL:Get('is')(a,b or 'player')
  or NeP.Protected.LineOfSight(a, b or 'player')
end)
