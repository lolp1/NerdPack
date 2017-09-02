local _, NeP = ...

if not _G.DBM then return end

local Timers = {}
local fake_timer = 999

_G.C_Timer.NewTicker(0.1, function()
  for bar in pairs(_G.DBM.Bars.bars) do
      local id = _G.GetSpellInfo(bar.id:match("%d+")) or bar.id:lower()
      Timers[id] = bar.timer > 0.1 and bar.timer or fake_timer
  end
end)

NeP.DSL:Register('dbm', function(_, event)
  return Timers[event:lower()] or fake_timer
end)

--Export to globals
NeP.Globals.DBM = NeP.DBM
