local _, NeP = ...
local _G = _G

-- USAGE: UNIT.area(DISTANCE).enemies >= #
NeP.DSL:Register("area.enemies", function(unit, distance)
  if not NeP._G.UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy', true)) do
    if NeP._G.UnitCanAttack(Obj.key, "player")
	  and (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy)
    and NeP.DSL:Get("distancefrom")(unit, Obj.key) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).enemies.infront >= #
NeP.DSL:Register("area.enemies.infront", function(unit, distance)
  if not NeP._G.UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy', true)) do
    if NeP._G.UnitCanAttack(Obj.key, "player")
	  and (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy)
    and NeP.DSL:Get("distancefrom")(unit, Obj.key) < tonumber(distance)
    and NeP.DSL:Get("infront")(Obj.key, unit) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly >= #
NeP.DSL:Register("area.friendly", function(unit, distance)
  if not NeP._G.UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Friendly', true)) do
    if NeP.DSL:Get("distancefrom")(unit, Obj.key) < tonumber(distance) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.friendly.infront", function(unit, distance)
  if not NeP._G.UnitExists(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Friendly', true)) do
    if NeP.DSL:Get("distancefrom")(unit, Obj.key) < tonumber(distance)
    and NeP.DSL:Get("infront")(Obj.key, unit) then
      total = total +1
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.incdmg", function(target, max_dist)
  if not NeP._G.UnitExists(target) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Roster")) do
    if NeP.DSL:Get("range")(target, Obj.key) < tonumber(max_dist) then
      total = total + NeP.DSL:Get("incdmg")(Obj.key)
    end
  end
  return total
end)

-- USAGE: UNIT.dead(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.dead", function(target, max_dist)
  if not NeP._G.UnitExists(target) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Dead")) do
    if NeP.DSL:Get("range")(target, Obj.key) < tonumber(max_dist) then
      total = total + 1
    end
  end
  return total
end)
