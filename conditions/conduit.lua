local NeP, g = NeP, NeP._G

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

local ConduitTable = {}

local function ConduitScan()
    g.wipe(ConduitTable)
    if not g.C_Soulbinds then return end -- don't error with previous expansion
    local soulbindID = g.C_Soulbinds.GetActiveSoulbindID()
    local nodes = g.C_Soulbinds.GetSoulbindData(soulbindID).tree.nodes
    for i = 1, #nodes do
        local node = nodes[i]
        if node.conduitID > 0 and node.state > 2 then
            local spellID = g.C_Soulbinds.GetConduitSpellID(node.conduitID, node.conduitRank)
            local spellName = g.GetSpellInfo(spellID):lower()
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
    g.C_Timer.After(1, ConduitScan)
end)

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
