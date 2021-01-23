
local NeP, g = NeP, NeP._G
local EquippedItems = {}
local AverageItemLevel = 0

local EquipmentUpdateEvents = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LEVEL_UP",
    "PLAYER_EQUIPMENT_CHANGED",
    "UNIT_INVENTORY_CHANGED"
}

NeP.Listener:Add(n_name.."_ResetEquippedItems", EquipmentUpdateEvents, function()
    g.C_Timer.After(2, function()
        g.wipe(EquippedItems)
        AverageItemLevel = math.floor(select(2, g.GetAverageItemLevel()))
    end)
end)

NeP.DSL:Register({"equipped", "item"}, function(_, item)
    if EquippedItems[item] then
        return EquippedItems[item] == 1
    else
        EquippedItems[item] = g.IsEquippedItem(item) and 1 or 0
        return EquippedItems[item] == 1
    end
end)

NeP.DSL:Register('item.cooldown', function(_, item)
    local start, duration = g.GetItemCooldown(item)
    if not start then return 0 end
    return start ~= 0 and (start + duration - g.GetTime()) or 0
end)

NeP.DSL:Register('item.usable', function(_, item)
    local isUsable, notEnoughMana = g.IsUsableItem(item)
    if not isUsable or notEnoughMana or NeP.DSL:Get('item.cooldown')(nil, item) ~= 0 then return false end
    return true
end)

NeP.DSL:Register('item.count', function(_, item)
    return g.GetItemCount(item, false, true)
end)

NeP.DSL:Register('twohand', function()
    return g.IsEquippedItemType("Two-Hand")
end)

NeP.DSL:Register('onehand', function()
    return g.IsEquippedItemType("One-Hand")
end)

NeP.DSL:Register("ilevel", function()
    return AverageItemLevel
end)
