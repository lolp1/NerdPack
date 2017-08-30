local _, NeP = ...

if not DBM then return end

local Timers = {}
local fake_timer = 999

C_Timer.NewTicker(0.1, function()
  for bar in pairs(DBM.Bars.bars) do
      local id = GetSpellInfo(bar.id:match("%d+")) or bar.id:lower()
      Timers[id] = bar.timer > 0.1 and bar.timer or fake_timer
  end
end)

NeP.DSL:Register('dbm', function(_, event)
  return Timers[event:lower()] or fake_timer
end)

--Export to globals
NeP.Globals.DBM = NeP.DBM
