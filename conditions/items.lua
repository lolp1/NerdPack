local _, NeP = ...
local GetAverageItemLevel = GetAverageItemLevel
local IsEquippedItem = IsEquippedItem
local GetItemCount = GetItemCount
local IsEquippedItemType = IsEquippedItemType

NeP.DSL:Register({'equipped', 'item'}, function(_, item)
  return IsEquippedItem(item)
end)

NeP.DSL:Register('item.cooldown', function(_, item)
	local start, duration = GetItemCooldown(item)
	if not start then return 0 end
  return start ~= 0 and (start + duration - GetTime()) or 0
end)

NeP.DSL:Register('item.usable', function(_, item)
	local isUsable, notEnoughMana = IsUsableItem(item)
  if not isUsable or notEnoughMana or NeP.DSL:Get('item.cooldown')(nil, item) ~= 0 then return false end
	return true
end)

NeP.DSL:Register('item.count', function(_, item)
  return GetItemCount(item, false, true)
end)

NeP.DSL:Register('twohand', function()
  return IsEquippedItemType("Two-Hand")
end)

NeP.DSL:Register('onehand', function()
  return IsEquippedItemType("One-Hand")
end)

NeP.DSL:Register("ilevel", function()
  return math.floor(select(1,GetAverageItemLevel()))
end)
