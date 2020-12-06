local _, NeP = ...

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

local ConduitTable = {}

local function ConduitScan()
    NeP._G.wipe(ConduitTable)
    if not NeP._G.C_Soulbinds then return end -- don't error with previous expansion
    local soulbindID = NeP._G.C_Soulbinds.GetActiveSoulbindID()
    local nodes = NeP._G.C_Soulbinds.GetSoulbindData(soulbindID).tree.nodes
    for i = 1, #nodes do
        local node = nodes[i]
        if node.conduitID > 0 and node.state > 2 then
            local spellID = NeP._G.C_Soulbinds.GetConduitSpellID(node.conduitID, node.conduitRank)
            local spellName = NeP._G.GetSpellInfo(spellID):lower()
            ConduitTable[spellID] = node.conduitRank
            ConduitTable[spellName] = node.conduitRank
        end
    end
end

-- /dump NeP.DSL.Parse("conduit(harm denial).rank") -- works with spellID also
NeP.DSL:Register("conduit.rank", function(_, spellName)
    spellName = tonumber(spellName) or spellName:lower()
    return ConduitTable[spellName] or 0
end)

-- /dump NeP.DSL.Parse("conduit(harm denial).active") -- works with spellID also
NeP.DSL:Register("conduit.active", function(_, spellName)
    return NeP.DSL:Get("conduit.rank")(nil, spellName) > 0
end)

local ConduitUpdateEvents = {
    "PLAYER_ENTERING_WORLD",
    "PLAYER_LEVEL_UP",
    "PLAYER_TALENT_UPDATE",
    "PLAYER_SPECIALIZATION_CHANGED",
    "COVENANT_CHOSEN",
    "SOULBIND_ACTIVATED",
    "SOULBIND_PATH_CHANGED",
    "SOULBIND_CONDUIT_COLLECTION_UPDATED",
    "SOULBIND_NODE_UPDATED",
    "SOULBIND_FORGE_INTERACTION_ENDED"
}

NeP.Listener:Add("NeP_ConduitScaner", ConduitUpdateEvents, function()
    NeP._G.C_Timer.After(1, ConduitScan)
end)

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
