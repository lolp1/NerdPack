local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()

end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(alt)'}
}

local Interrupts = {

}

local inCombat = {
    {Interrupts, 'interruptAt(43)&.infront&range<=8', 'target'},
    {Keybinds},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(260, {
	name = '[NeP] Rogue | Outlaw',
	wow_ver = "8.3",
	nep_ver = "1.13",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
