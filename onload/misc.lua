local n_name, NeP = ...

NeP.Listener:Add(n_name..'_misc', 'LFG_PROPOSAL_SHOW', function()
  if NeP.Interface:Fetch(n_name..'_Settings', 'LFG_acp', false) then
    NeP._G.C_Timer.After(math.random(3, 8), NeP._G.AcceptProposal)
  end
end)

local function ScanNewTalent(row)
  local active_talent, new_talent;
  -- scans
  for col=1, 3 do
    local talent_id, _,_, active = NeP._G.GetTalentInfo(row, col, 1)
    if active then
      active_talent = talent_id
    end
    if NeP._G.IsMouseButtonDown(1)
    and NeP._G.MouseIsOver(_G["PlayerTalentFrameTalentsTalentRow"..row.."Talent"..col]) then
      new_talent = talent_id
    end
  end
  -- if we found a new talent, force learn
  if new_talent
  and active_talent
  and active_talent ~= new_talent then
    NeP._G.RemoveTalent(active_talent)
    NeP._G.RemoveTalent(active_talent)
    NeP._G.C_Timer.After(0.5, function()
      NeP._G.LearnTalent(new_talent)
    end)
  end
end

NeP._G.C_Timer.NewTicker(0.1, function()
  if NeP._G.PlayerTalentFrame
  and NeP._G.PlayerTalentFrame:IsVisible()
  and not NeP._G.IsResting()
  and NeP.Interface:Fetch(n_name..'_Settings', 'talents_exp', false) then
    for row=1, 7 do
      ScanNewTalent(row)
    end
  end
end)
