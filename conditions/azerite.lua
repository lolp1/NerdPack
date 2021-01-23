local NeP, g = NeP, NeP._G
local Azerite = {}

local empowered = g.C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem
local selected = g.C_AzeriteEmpoweredItem.IsPowerSelected
local tierInfo = g.C_AzeriteEmpoweredItem.GetAllTierInfo
local PowerInfo = g.C_AzeriteEmpoweredItem.GetPowerInfo

local EquipType = {
	[1] = "Head",
	[3] = "Shoulder",
	[5] = "Chest"
}

local function AzeriteScan()
	g.wipe(Azerite)
	if not g.IsEquippedItem(158075) then return end
	for i = 1, 5, 2 do
		if g.IsEquippedItemType(EquipType[i]) then
			local item = g.ItemLocation:CreateFromEquipmentSlot(i)
			if empowered(item) then
				local info = tierInfo(item)
				for _, v in pairs(info) do
					for j = 1, #v.azeritePowerIDs do
						if v.azeritePowerIDs[j] ~= 13
						and selected(item, v.azeritePowerIDs[j]) then
							local Name = g.GetSpellInfo(PowerInfo(v.azeritePowerIDs[j]).spellID):lower()
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

NeP.Listener:Add(n_name .. "_Azerite", "UNIT_INVENTORY_CHANGED", function()
	AzeriteScan()
end)

NeP.Listener:Add(n_name .. "_Azerite", "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED", function()
	AzeriteScan()
end)

AzeriteScan()
