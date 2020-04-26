local _, NeP = ...
local _G = _G

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }
NeP.DSL:Register("hashero", function()
  for i = 1, #heroismBuffs do
    local SpellName = NeP.Core:GetSpellName(heroismBuffs[i])
    if NeP.Core.UnitBuffL('player', SpellName) then return true end
  end
end)

------------------------------------------ BUFFS -----------------------------------------
------------------------------------------------------------------------------------------
NeP.DSL:Register("buff", function(target, spell)
  return NeP.Core.UnitBuffL(target, spell, 'PLAYER') ~= nil
end)

NeP.DSL:Register("buff.any", function(target, spell)
  local obj = NeP.OM:FindObjectByGuid(UnitGUID(target))
  return obj and obj.buffs[spell] ~= nil
end)

NeP.DSL:Register("buff.count", function(target, spell)
  local _, count = NeP.Core.UnitBuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.DSL:Register("buff.count.any", function(target, spell)
  local _, count = NeP.Core.UnitBuffL(target, spell)
  return count or 0
end)

NeP.DSL:Register("buff.duration", function(target, spell)
  local buff,_,expires = NeP.Core.UnitBuffL(target, spell, 'PLAYER')
  return buff and (expires - NeP._G.GetTime()) or 0
end)

NeP.DSL:Register("buff.duration.any", function(target, spell)
  local obj = NeP.OM:FindObjectByGuid(UnitGUID(target))
  return obj and obj.buffs[spell] 
  and ( obj.buffs[spell].expires - NeP._G.GetTime()) )
end)

NeP.DSL:Register("buff.many", function(target, spell)
  local i, name, count = 1, true, 0
  while name do
    name = NeP.Core.UnitBuffL(target, i, 'PLAYER')
    if name == spell then 
      count = count + 1 
    end
    i=i+1
  end
  return count
end)

NeP.DSL:Register("buff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if NeP.Core.UnitBuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

------------------------------------------ DEBUFFS ---------------------------------------
------------------------------------------------------------------------------------------

NeP.DSL:Register("debuff", function(target, spell)
  return  NeP.Core.UnitDebuffL(target, spell, 'PLAYER') ~= nil
end)

NeP.DSL:Register("debuff.any", function(target, spell)
  local obj = NeP.OM:FindObjectByGuid(UnitGUID(target))
  return obj and obj.debuffs[spell] ~= nil
end)

NeP.DSL:Register("debuff.count", function(target, spell)
  local _,count = NeP.Core.UnitDebuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.DSL:Register("debuff.count.any", function(target, spell)
  local _,count = NeP.Core.UnitDebuffL(target, spell)
  return count or 0
end)

NeP.DSL:Register("debuff.duration", function(target, spell)
  local debuff,_,expires = NeP.Core.UnitDebuffL(target, spell, 'PLAYER')
  return debuff and (expires - NeP._G.GetTime()) or 0
end)

NeP.DSL:Register("debuff.duration.any", function(target, spell)
  local obj = NeP.OM:FindObjectByGuid(UnitGUID(target))
  return obj and obj.debuffs[spell] 
  and (obj.debuffs[spell].expires - NeP._G.GetTime())
end)

NeP.DSL:Register("debuff.many", function(target, spell)
  local i, name, count = 1, true, 0
  while name do
    name = NeP.Core.UnitDebuffL(target, i, 'PLAYER')
    if name == spell then 
      count = count + 1 
    end
    i=i+1
  end
  return count
end)

NeP.DSL:Register("debuff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if NeP.Core.UnitDebuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

----------------------------------------------------------------------------------------------

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
NeP.DSL:Register("count.enemies.buffs", function(_,buff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
      if NeP.DSL:Get('buff')(Obj.key, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
NeP.DSL:Register("count.friendly.buffs", function(_,buff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Roster')) do
      if NeP.DSL:Get('buff')(Obj.key, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
NeP.DSL:Register("count.enemies.debuffs", function(_,debuff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
      if NeP.DSL:Get('debuff')(Obj.key, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count(DEBUFF).debuffs > = #
NeP.DSL:Register("count.friendly.debuffs", function(_,debuff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Roster')) do
      if NeP.DSL:Get('debuff')(Obj.key, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)
