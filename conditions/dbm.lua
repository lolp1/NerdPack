local _, NeP = ...
NeP.DBM = {}

--dont load if DBM is not installed
function NeP.DBM.BuildTimers() end
if not NeP._G.DBM then return end

local DBM_Timers = {}
local fake_timer = 999

function NeP.DBM.BuildTimers()
  _G.wipe(DBM_Timers)
  for bar in pairs(NeP._G.DBM.Bars.bars) do
    local id = NeP._G.GetSpellInfo(bar.id:match("%d+")) or bar.id:lower():gsub("%%s%c", "")
    DBM_Timers[id] = bar.timer and bar.timer
  end
end

-- Usage: dbm(Bar name) <= #
-- /dump NeP.DSL.Parse("dbm(pull in)<=10", "", "")
-- /dump NeP.DSL:Get('dbm')(_, 'pull in')
NeP.DSL:Register('dbm', function(_, event)
  return DBM_Timers[event:lower()] or fake_timer
end)
