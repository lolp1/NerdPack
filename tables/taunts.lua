local _, NeP = ...
NeP.Taunts = {}

function NeP.Taunts:Add(id, stacks)
  if type(id) == 'table' then
    for i=1, #id do
      local tmp = id[i]
      self:Add(tmp.id, tmp.stacks)
    end
  else
    table.insert(self.table, {id=id, stacks=stacks})
  end
end

function NeP.Taunts:Add(unit)
  for i=1, #self.table do
    local debuff = _G.etSpellInfo(self.table[i].id)
    if not _G.UnitDebuff('player', debuff)
    and (select(4, _G.UnitDebuff(unit..'target', debuff)) or 0) > self.table[i].stacks then
      return true
    end
  end
end

NeP.Taunts:Add({
  { id = 143436, stacks = 1 },--143436 - Corrosive Blast (Immerseus/71543)
  { id = 146124, stacks = 3 },--146124 - Self Doubt (Norushen/72276)
  { id = 144358, stacks = 1 },--144358 - Wounded Pride (Sha of Pride/71734)
  { id = 147029, stacks = 3 },--147029 - Flames of Galakrond (Galakras/72249)
  { id = 144467, stacks = 2 },--144467 - Ignite Armor (Iron Juggernaut/71466)
  { id = 144215, stacks = 6 },--144215 - Froststorm Strike (Earthbreaker Haromm) (Kor'Kron Dark Shaman/71859)
  { id = 143494, stacks = 3 },--143494 - Sundering Blow (General Nazgrim/71515)
  { id = 142990, stacks = 12 },--142990 - Fatal Strike (Malkorok/71454)
  { id = 143426, stacks = 2 },--143426 - Fearsome Roar (Thok the Bloodthirsty/71529)
  { id = 143780, stacks = 2 },--143780 - Acid Breath (Thok (Saurok eaten))
  { id = 143773, stacks = 3 },--143773 - Freezing Breath (Thok (Jinyu eaten))
  { id = 143767, stacks = 2 },--143767 - Scorching Breath (Thok (Yaungol eaten))
  { id = 145183, stacks = 3 } --145183 - Gripping Despair (Garrosh/71865)
})
