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
	{'Skull Bash', nil, 'target'}
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&.infront&range<=8', 'target'},
	{'Ferocious Bite', 'player.combopoints>=5', 'target'},
	{'Rake', '!debuff', 'target'},
	{'Shred', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(103, {
	name = '[NeP] Druid | Feral',
	wow_ver = "8.2",
	nep_ver = "1.12",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
