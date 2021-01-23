local NeP, g = NeP, NeP._G

local talents = {}
local rows = 7
local cols = 3

local function UpdateTalents()
  g.wipe(talents) -- wipe the table specially for the pvp talents
  for i = 1, rows do
    for k = 1, cols do
      local talent_ID, talent_name, _, selected = g.GetTalentInfo(i, k, 1) -- ActiveSpecGroup is always 1
      if talent_ID then
        talents[talent_name] = selected
        talents[tostring(talent_ID)] = selected
        talents[tostring(i)..','..tostring(k)] = selected
      end
    end
  end
  for _, v in pairs(g.C_SpecializationInfo.GetAllSelectedPvpTalentIDs()) do
    local talent_ID, talent_name, _, selected = g.GetPvpTalentInfoByID(v, 1) -- ActiveSpecGroup is always 1
    talents[talent_name] = selected
    talents[tostring(talent_ID)] = selected
  end
end

NeP.Listener:Add('NeP_Talents', 'PLAYER_LOGIN', function()
  UpdateTalents()
  NeP.Listener:Add('NeP_Talents', 'ACTIVE_TALENT_GROUP_CHANGED', function()
    g.C_Timer.After(0.1, function() UpdateTalents() end)
  end)
end)

-- Usage: talent(ID/Name/Tier,Column)
-- /dump NeP.DSL.Parse("talent(23106)", "", "")
-- /dump NeP.DSL.Parse("talent(Eye of the Tiger)", "", "")
-- /dump NeP.DSL.Parse("talent(1,1)", "", "")
-- Note: PvP talents are no longer organized into a row/column so we check for ID/Name
NeP.DSL:Register("talent", function(_, args)
  return talents[args] ~= nil and talents[args]
end)
