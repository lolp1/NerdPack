local _, NeP = ...
local _G = _G

NeP.DSL:Register("pvp", function(target)
  return NeP._G.UnitIsPVP(target, 'PLAYER')
end)
