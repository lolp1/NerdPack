local _, NeP = ...

local Essence = {}

local function ScanEssenceFunc()
    NeP._G.wipe(Essence)
	local milestones = NeP._G.C_AzeriteEssence.GetMilestones() or {}
	for i = 1, #milestones do
		if milestones[i].slot ~= nil then
			local ID = NeP._G.C_AzeriteEssence.GetMilestoneEssence(milestones[i].ID)
			if ID ~= nil then
				local info = NeP._G.C_AzeriteEssence.GetEssenceInfo(ID)
				local name = info.name:lower()
				Essence[name] = {}
				Essence[name].rank = info.rank
				Essence[name].slot = milestones[i].slot
			end
		end
	end
end

local ESslots = {
  ["main"] = {0},
  ["passive"] = {1, 2, 3}
}

-- USAGE: essence(Essence of the Focusing Iris,main).rank >= 3 (slots : main, passive)
-- /dump NeP.DSL.Parse("essence(Essence of the Focusing Iris,passive).rank", "", "")
NeP.DSL:Register("essence.rank", function(_, args)
	local name, slotName = NeP._G.strsplit(',', args, 2)
	name = name:lower()
	if ESslots[slotName] == nil then return end
	for i = 1, #ESslots[slotName] do
		if Essence[name] and Essence[name].slot == ESslots[slotName][i] then
			return Essence[name].rank
		end
	end
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_CHANGED", function()
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_ACTIVATED", function()
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_UPDATE", function()
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "PLAYER_ENTERING_WORLD", function()
    ScanEssenceFunc()
end)
