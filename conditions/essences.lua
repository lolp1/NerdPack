local _, NeP = ...

local Essence = {}

local function ScanEssenceFunc()
	local milestones = NeP._G.C_AzeriteEssence.GetMilestones()
	for i = 1, #milestones do
		if milestones[i].slot ~= nil then
			local ID = NeP._G.C_AzeriteEssence.GetMilestoneEssence(milestones[i].ID)
			if ID ~= nil then
				local info = NeP._G.C_AzeriteEssence.GetEssenceInfo(ID)
				Essence[info.name] = {}
				Essence[info.name].rank = info.rank
				Essence[info.name].slot = milestones[i].slot
			end
		end
	end
	return Essence
end

local ESslots = {
  ["main"] = {0},
  ["passive"] = {1, 2, 3}
}

-- USAGE: essence(Essence of the Focusing Iris,main).rank >= 3 (slots : main, passive)
-- /dump NeP.DSL.Parse("essence(Essence of the Focusing Iris,passive).rank", "", "")
NeP.DSL:Register("essence.rank", function(_, args)
	local name, slotName = _G.strsplit(',', args, 2)
	if ESslots[slotName] == nil then return end
	for i = 1, #ESslots[slotName] do
		if Essence[name] and Essence[name].slot == ESslots[slotName][i] then
			return Essence[name].rank
		end
	end
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_CHANGED", function()
    _G.wipe(Essence)
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_ACTIVATED", function()
    _G.wipe(Essence)
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "AZERITE_ESSENCE_UPDATE", function()
    _G.wipe(Essence)
    ScanEssenceFunc()
end)

NeP.Listener:Add("NeP_Essences", "PLAYER_ENTERING_WORLD", function()
    _G.wipe(Essence)
    ScanEssenceFunc()
end)

--NeP._G.C_AzeriteEssence.GetMilestones()
--NeP._G.C_AzeriteEssence.GetMilestoneEssence(milestoneID)
--NeP._G.C_AzeriteEssence.GetEssenceInfo(ID)