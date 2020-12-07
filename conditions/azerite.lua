local n_name, NeP = ...

local Azerite = {}

local empowered = NeP._G.C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem
local selected = NeP._G.C_AzeriteEmpoweredItem.IsPowerSelected
local tierInfo = NeP._G.C_AzeriteEmpoweredItem.GetAllTierInfo
local PowerInfo = NeP._G.C_AzeriteEmpoweredItem.GetPowerInfo

local EquipType = {
	[1] = "Head",
	[3] = "Shoulder",
	[5] = "Chest"
}

local function AzeriteScan()
	NeP._G.wipe(Azerite)
	if not NeP._G.IsEquippedItem(158075) then return end
	for i = 1, 5, 2 do
		if NeP._G.IsEquippedItemType(EquipType[i]) then
			local item = NeP._G.ItemLocation:CreateFromEquipmentSlot(i)
			if empowered(item) then
				local info = tierInfo(item)
				for _, v in pairs(info) do
					for j = 1, #v.azeritePowerIDs do
						if v.azeritePowerIDs[j] ~= 13
						and selected(item, v.azeritePowerIDs[j]) then
							local Name = NeP._G.GetSpellInfo(PowerInfo(v.azeritePowerIDs[j]).spellID):lower()
							Azerite[Name] = (Azerite[Name] or 0) + 1
						end
					end
				end
			end
		end
	end
end

-- /dump NeP.DSL.Parse("azerite(Font of Life).count", "", "")
NeP.DSL:Register("azerite.count", function(_, spell)
	return Azerite[spell:lower()] or 0
end)

-- /dump NeP.DSL.Parse("azerite(Overflowing Mists).active", "", "")
-- /dump NeP.DSL.Parse("azerite(Font of Life).active", "", "")
NeP.DSL:Register("azerite.active", function(_, spell)
	spell = spell:lower()
	return Azerite[spell] and Azerite[spell] > 0
end)

NeP.Listener:Add(n_name .. "_Azerite", "PLAYER_ENTERING_WORLD", function()
	AzeriteScan()
end)

NeP.Listener:Add(n_name .. "_Azerite", "UNIT_INVENTORY_CHANGED", function()
	AzeriteScan()
end)

NeP.Listener:Add(n_name .. "_Azerite", "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED", function()
	AzeriteScan()
end)
