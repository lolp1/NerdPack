local _, NeP = ...
local _G = _G

NeP.Queuer = {}
local Queue = {}

function NeP.Queuer.Add(_, spell, target)
  spell = NeP.Spells:Convert(spell)
  if not spell then return end
  Queue[spell] = {
    time = NeP._G.GetTime(),
    target = target or NeP.DSL:Get('exists')('target') and 'target' or 'player'
  }
end

function NeP.Queuer.Spell(_, spell)
  local skillType = NeP._G.GetSpellBookItemInfo(spell)
  local isUsable, notEnoughMana = NeP._G.IsUsableSpell(spell)
  if skillType ~= 'FUTURESPELL' and isUsable and not notEnoughMana then
    local GCD = NeP.DSL:Get('gcd')()
    if NeP._G.GetSpellCooldown(spell) <= GCD then
      return true
    end
  end
end

function NeP.Queuer:Execute()
  for spell, v in pairs(Queue) do
    if (NeP._G.GetTime() - v.time) > 5 then
      Queue[spell] = nil
    elseif self:Spell(spell) then
      NeP.Protected.Cast(spell, v.target)
      Queue[spell] = nil
      return true
    end
  end
end
