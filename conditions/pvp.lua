local NeP, g = NeP, NeP._G

NeP.DSL:Register("pvp", function(target)
  return g.UnitIsPVP(target, 'PLAYER')
end)
