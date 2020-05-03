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
    {'Shadow Blades', nil, 'target'},
    {'Nightblade', '!debuff', 'target'},
    {'Symbols of Death', 'player.buff(Shadow Dance)', 'target'},
    {'Eviscerate', 'player.combopoints>=5', 'target'},
    {'Shadowstrike', 'player.buff(Shadow Dance)', 'target'},
    {'Backstab', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(261, {
	name = '[NeP] Rogue | Subtlety',
	wow_ver = "8.3",
	nep_ver = "1.13",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
