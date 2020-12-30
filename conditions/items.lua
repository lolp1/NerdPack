local n_name, NeP = ...
local EquippedItems = {}
local AverageItemLevel = 0

local invSlots = {
    "HeadSlot",
    "NeckSlot",
    "BackSlot",
    "ShoulderSlot",
    "ChestSlot",
    "ShirtSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot"
}

local function ScanEquippedItems()
    NeP._G.wipe(EquippedItems)
    for _, slotName in pairs(invSlots) do
        local ItemID = NeP._G.GetInventoryItemID("player", NeP._G.GetInventorySlotInfo(slotName))
        if ItemID then
            local ItemName = NeP._G.GetItemInfo(ItemID):lower()
            EquippedItems[ItemID] = true
            EquippedItems[ItemName] = true
        end
    end
end

local EquipmentUpdateEvents = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LEVEL_UP",
    "PLAYER_EQUIPMENT_CHANGED",
    "UNIT_INVENTORY_CHANGED"
}

NeP.Listener:Add(n_name.."_EquippedItemsScaner", EquipmentUpdateEvents, function()
    NeP._G.C_Timer.After(2, function()
        ScanEquippedItems()
        AverageItemLevel = math.floor(select(2, NeP._G.GetAverageItemLevel()))
    end)
end)

NeP.DSL:Register({"equipped", "item"}, function(_, item)
    item = tonumber(item) or item:lower()
    return EquippedItems[item] or false
end)

NeP.DSL:Register('item.cooldown', function(_, item)
    local start, duration = NeP._G.GetItemCooldown(item)
    if not start then return 0 end
    return start ~= 0 and (start + duration - NeP._G.GetTime()) or 0
end)

NeP.DSL:Register('item.usable', function(_, item)
    local isUsable, notEnoughMana = NeP._G.IsUsableItem(item)
    if not isUsable or notEnoughMana or NeP.DSL:Get('item.cooldown')(nil, item) ~= 0 then return false end
    return true
end)

NeP.DSL:Register('item.count', function(_, item)
    return NeP._G.GetItemCount(item, false, true)
end)

NeP.DSL:Register('twohand', function()
    return NeP._G.IsEquippedItemType("Two-Hand")
end)

NeP.DSL:Register('onehand', function()
    return NeP._G.IsEquippedItemType("One-Hand")
end)

NeP.DSL:Register("ilevel", function()
    return AverageItemLevel
end)
