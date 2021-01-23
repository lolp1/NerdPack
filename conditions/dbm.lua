local NeP, g = NeP, NeP._G
NeP.DBM = {}

--dont load if DBM is not installed
function NeP.DBM.BuildTimers() end
if not g.DBM then return end

local DBM_Timers = {}
local fake_timer = 999

function NeP.DBM.BuildTimers()
  g.wipe(DBM_Timers)
  for bar in pairs(g.DBM.Bars.bars) do
    local id = g.GetSpellInfo(bar.id:match("%d+")) or bar.id:lower():gsub("%%s%c", "")
    DBM_Timers[id] = bar.timer and bar.timer
  end
end

-- Usage: dbm(Bar name) <= #
-- /dump NeP.DSL.Parse("dbm(pull in)<=10", "", "")
-- /dump NeP.DSL:Get('dbm')(_, 'pull in')
NeP.DSL:Register('dbm', function(_, event)
  return DBM_Timers[event:lower()] or fake_timer
end)
