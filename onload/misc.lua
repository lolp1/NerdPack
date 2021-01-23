local NeP, g = NeP, NeP._G

NeP.Listener:Add(n_name..'_misc', 'LFG_PROPOSAL_SHOW', function()
  if NeP.Interface:Fetch(n_name..'_Settings', 'LFG_acp', false) then
    g.C_Timer.After(math.random(3, 8), g.AcceptProposal)
  end
end)

local function ScanNewTalent(row)
  local active_talent, new_talent;
  -- scans
  for col=1, 3 do
    local talent_id, _,_, active = g.GetTalentInfo(row, col, 1)
    if active then
      active_talent = talent_id
    end
    if g.IsMouseButtonDown(1)
    and g.MouseIsOver(g["PlayerTalentFrameTalentsTalentRow"..row.."Talent"..col]) then
      new_talent = talent_id
    end
  end
  -- if we found a new talent, force learn
  if new_talent
  and active_talent
  and active_talent ~= new_talent then
    g.RemoveTalent(active_talent)
    g.RemoveTalent(active_talent)
    g.C_Timer.After(0.5, function()
      g.LearnTalent(new_talent)
    end)
  end
end

g.C_Timer.NewTicker(0.1, function()
  if g.PlayerTalentFrame
  and g.PlayerTalentFrame:IsVisible()
  and not g.IsResting()
  and NeP.Interface:Fetch(n_name..'_Settings', 'talents_exp', false) then
    for row=1, 7 do
      ScanNewTalent(row)
    end
  end
end)
