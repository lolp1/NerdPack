local _, NeP = ...
local _G = _G

local talents = {}
local rows = 7
local cols = 3

local function UpdateTalents()
  -- wipe the table specially for the pvp talents
  _G.wipe(talents)
  -- this is always 1, dont know why bother but oh well...
  local spec = NeP._G.GetActiveSpecGroup()
  local pvp = NeP._G.C_SpecializationInfo.GetAllSelectedPvpTalentIDs() -- get a table with all selected pvp talents
  for i = 1, rows do
    for k = 1, cols do
      local talent_ID, talent_name, _, selected = NeP._G.GetTalentInfo(i, k, spec)
      talents[talent_name] = selected
      talents[tostring(talent_ID)] = selected
      talents[tostring(i)..','..tostring(k)] = selected
    end
  end
  for _, v in pairs(pvp) do
    local talent_ID, talent_name, _, selected = NeP._G.GetPvpTalentInfoByID(v, spec)
    talents[talent_name] = selected
    talents[tostring(talent_ID)] = selected
  end
end

NeP.Listener:Add('NeP_Talents', 'PLAYER_LOGIN', function()
  UpdateTalents()
  NeP.Listener:Add('NeP_Talents', 'ACTIVE_TALENT_GROUP_CHANGED', function()
    UpdateTalents()
  end)
end)

-- Usage: talent(ID/Name/Tier,Column)
-- /dump NeP.DSL.Parse("talent(23106)", "", "")
-- /dump NeP.DSL.Parse("talent(Eye of the Tiger)", "", "")
-- /dump NeP.DSL.Parse("talent(1,1)", "", "")
-- Note: PvP talents are no longer organized into a row/column so we check for ID/Name
NeP.DSL:Register("talent", function(_, args)
  return talents[args]
end)
