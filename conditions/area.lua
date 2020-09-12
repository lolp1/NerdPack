local _, NeP = ...

-- USAGE: UNIT.area(DISTANCE).enemies >= #
NeP.DSL:Register("area.enemies", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy', true)) do
    if NeP.DSL:Get('canattack')(Obj.key)
    and (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy) then
      if unit == 'player' then
        if Obj.range < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      else
        if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      end
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).enemies.infront >= #
NeP.DSL:Register("area.enemies.infront", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy', true)) do
    if NeP.DSL:Get('canattack')(Obj.key)
	  and (NeP.DSL:Get('combat')(Obj.key) or Obj.isdummy)
    and NeP.DSL:Get("infront")(Obj.key, nil, unit) then
      if unit == 'player' then
        if Obj.range < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      else
        if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      end
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly >= #
NeP.DSL:Register("area.friendly", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Friendly', true)) do
    if unit == 'player' then
      if Obj.range < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + 1
      end
    else
      if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + 1
      end
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.friendly.infront", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get('Friendly', true)) do
    if NeP.DSL:Get("infront")(Obj.key, nil, unit) then
      if unit == 'player' then
        if Obj.range < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      else
        if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
	and NeP.DSL:Get('los')(Obj.key) then
          total = total + 1
        end
      end
    end
  end
  return total
end)

-- USAGE: UNIT.area(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.incdmg", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Roster")) do
    if unit == 'player' then
      if Obj.range < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + NeP.DSL:Get("incdmg")(Obj.key)
      end
    else
      if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + NeP.DSL:Get("incdmg")(Obj.key)
      end
    end
  end
  return total
end)

-- USAGE: UNIT.dead(DISTANCE).friendly.infront >= #
NeP.DSL:Register("area.dead", function(unit, distance)
  if not NeP.DSL:Get('exists')(unit) then return 0 end
  local total = 0
  for _, Obj in pairs(NeP.OM:Get("Dead")) do
    if unit == 'player' then
      if Obj.range < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + 1
      end
    else
      if NeP.DSL:Get('range')(Obj.key, nil, unit) < tonumber(distance)
      and NeP.DSL:Get('los')(Obj.key) then
        total = total + 1
      end
    end
  end
  return total
end)
