local _, NeP = ...
local LibStub = LibStub
local LibDisp = LibStub('LibDispellable-1.0')
local GetSpellInfo = GetSpellInfo
local UnitThreatSituation = UnitThreatSituation
local UnitIsPlayer = UnitIsPlayer
local IsUsableItem = IsUsableItem
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitPlayerOrPetInParty = UnitPlayerOrPetInParty
local GetItemCooldown = GetItemCooldown
local GetItemSpell = GetItemSpell
local GetItemCount = GetItemCount
local CancelShapeshiftForm = CancelShapeshiftForm
local CancelUnitBuff = CancelUnitBuff
local GetSpellCooldown = GetSpellCooldown
local GetSpellBookItemInfo = GetSpellBookItemInfo
local IsUsableSpell = IsUsableSpell
local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemID = GetInventoryItemID
local GetItemInfo = GetItemInfo

local funcs = {
	noop = function() end,
	Cast = function(eva)
		NeP.Parser.LastCast = eva.spell
		NeP.Parser.LastGCD = not eva.nogcd and eva.spell or NeP.Parser.LastGCD
		NeP.Parser.LastTarget = eva.target
		NeP.Protected["Cast"](eva.spell, eva.target)
		return true
	end,
	UseItem = function(eva) NeP.Protected["UseItem"](eva.spell, eva.target); return true end,
	Macro = function(eva) NeP.Protected["Macro"]("/"..eva.spell, eva.target); return true end,
	Lib = function(eva) return NeP.Library:Parse(eva.spell, eva.target, eva[1].args) end,
	C_Buff = function(eva) CancelUnitBuff('player', GetSpellInfo(eva[1].args)) end
}

local function IsSpellReady(spell)
	local skillType = GetSpellBookItemInfo(spell)
	local isUsable, notEnoughMana = IsUsableSpell(spell)
	if skillType ~= 'FUTURESPELL' and isUsable and not notEnoughMana then
		return GetSpellCooldown(spell) <= NeP.DSL:Get('gcd')()
	end
end

-- Clip
NeP.Compiler:RegisterToken("!", function(_, ref)
		ref.interrupts = true
		ref.bypass = true
end)

-- No GCD
NeP.Compiler:RegisterToken("&", function(eval, ref)
		ref.bypass = true
		eval.nogcd = true
end)

-- Regular actions
NeP.Compiler:RegisterToken("%", function(eval, ref)
	eval.exe = funcs["noop"]
	ref.token = ref.spell
end)

local function FindDispell(eval, unit)
	for _, spellID, _,_,_,_,_, duration, expires in LibDisp:IterateDispellableAuras(unit) do
    local spell = GetSpellInfo(spellID)
    if IsSpellReady(spell) and (expires - eval.master.time) < (duration - math.random(1, 3)) then
      eval.spell = spell
      eval[3].target = unit
      eval.exe = funcs["Cast"]
      return true
    end
  end
end

-- DispelSelf
NeP.Actions:Add('dispelself', function(eval)
  return FindDispell(eval, 'player')
end)

-- Dispell all
NeP.Actions:Add('dispelall', function(eval)
  for _, Obj in pairs(NeP.Healing:GetRoster()) do
		if FindDispell(eval, Obj.key) then return true end
  end
end)

-- Executes a users macro
NeP.Compiler:RegisterToken("/", function(eval, ref)
	ref.token = 'macro'
	eval.nogcd = true
	eval.exe = funcs["Macro"]
end)

NeP.Actions:Add('macro', function()
  return true
end)

-- Executes a users macro
NeP.Actions:Add('function', function()
  return true
end)

-- Executes a users lib
NeP.Compiler:RegisterToken("@", function(eval, ref)
	ref.token = 'lib'
	eval.nogcd = true
	eval.exe = funcs["Lib"]
end)

NeP.Actions:Add('lib', function()
  return true
end)

-- Cancel buff
NeP.Actions:Add('cancelbuff', function(eval)
  eval.exe = funcs["C_Buff"]
  return true
end)

-- Cancel Shapeshift Form
NeP.Actions:Add('cancelform', function(eval)
  eval.exe = CancelShapeshiftForm
  return true
end)

-- Automated tauting
NeP.Actions:Add('taunt', function(eval)
	if not IsSpellReady(eval[1].args) then return end
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
    local Threat = UnitThreatSituation("player", Obj.key)
		if Threat and Threat >= 0
		and Threat < 3 and Obj.distance <= 30 then
      eval.spell = eval[1].args
      eval[3].target = Obj.key
      eval.exe = funcs["Cast"]
      return true
    end
  end
end)

-- Ress all dead
NeP.Actions:Add('ressdead', function(eval)
	if not IsSpellReady(eval[1].args) then return end
  for _, Obj in pairs(NeP.OM:Get('Friendly')) do
		if Obj.distance < 40 and UnitIsPlayer(Obj.Key)
    and UnitIsDeadOrGhost(Obj.key)
		and UnitPlayerOrPetInParty(Obj.key) then
      eval.spell = eval[1].args
      eval[3].target = Obj.key
      eval.exe = funcs["Cast"]
      return true
    end
  end
end)

-- Pause
NeP.Actions:Add('pause', function(eval)
  eval.exe = function() return true end
  return true
end)

-- Items
local invItems = {
	['head']		= 'HeadSlot',
	['helm']		= 'HeadSlot',
	['neck']		= 'NeckSlot',
	['shoulder']	= 'ShoulderSlot',
	['shirt']		= 'ShirtSlot',
	['chest']		= 'ChestSlot',
	['belt']		= 'WaistSlot',
	['waist']		= 'WaistSlot',
	['legs']		= 'LegsSlot',
	['pants']		= 'LegsSlot',
	['feet']		= 'FeetSlot',
	['boots']		= 'FeetSlot',
	['wrist']		= 'WristSlot',
	['bracers']		= 'WristSlot',
	['gloves']		= 'HandsSlot',
	['hands']		= 'HandsSlot',
	['finger1']		= 'Finger0Slot',
	['finger2']		= 'Finger1Slot',
	['trinket1']	= 'Trinket0Slot',
	['trinket2']	= 'Trinket1Slot',
	['back']		= 'BackSlot',
	['cloak']		= 'BackSlot',
	['mainhand']	= 'MainHandSlot',
	['offhand']		= 'SecondaryHandSlot',
	['weapon']		= 'MainHandSlot',
	['weapon1']		= 'MainHandSlot',
	['weapon2']		= 'SecondaryHandSlot',
	['ranged']		= 'RangedSlot'
}

NeP.Compiler:RegisterToken("#", function(eval, ref)
	local temp_spell, fake_id = ref.spell, 09324
	ref.token = 'item'
	eval.bypass = true
	if invItems[temp_spell] then
		local invItem = GetInventorySlotInfo(invItems[temp_spell])
		temp_spell = GetInventoryItemID("player", invItem) or ref.spell
	end
	ref.id = tonumber(temp_spell) or NeP.Core:GetItemID(temp_spell) or fake_id
	local itemName, itemLink, _,_,_,_,_,_,_, texture = GetItemInfo(ref.id)
	ref.spell = itemName or ref.spell
	ref.icon = texture or ""
	ref.link = itemLink or ""
	eval.exe = funcs["UseItem"]
end)

NeP.Actions:Add('item', function(eval)
  local item = eval[1]
  if item and item.id and GetItemSpell(item.spell) then
    if IsUsableItem(item.spell)
      and select(2,GetItemCooldown(item.id)) == 0
      and GetItemCount(item.spell) > 0 then
      return true
    end
  end
end)

-- regular spell
NeP.Compiler:RegisterToken("spell_cast", function(eval, ref)
	ref.spell = NeP.Spells:Convert(ref.spell, eval.master.name)
	ref.icon = select(3,GetSpellInfo(ref.spell))
	eval.exe = funcs["Cast"]
	ref.token = 'spell_cast'
end)

local C = NeP.Cache.Spells

NeP.Actions:Add('spell_cast', function(eval)
	-- cached
	if C[eval[1].spell] == nil then
		C[eval[1].spell] = IsSpellReady(eval[1].spell) or false
	end
	return C[eval[1].spell]
end)
