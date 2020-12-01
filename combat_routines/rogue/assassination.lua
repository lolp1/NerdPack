local _, NeP = ...

local GUI = {
	{type = 'text', text = 'nothing here yet...'},
}

local exeOnLoad = function()
     NeP.Core:Print('Hello User!\nThanks for using [NeP]\nRemember this is just a basic routine.')
end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(alt)'}
}

local Interrupts = {
	{'Kick', nil, 'target'}
}

local inCombat = {
    {Interrupts, 'interruptAt(43)&&infront&&range<=8', 'target'},
	{Keybinds},
	{'Rupture', '!debuff&&player.combopoints>=5', 'target'},
	{'Envenom', 'player.combopoints>=5', 'target'},
	{'Garrote', '!debuff', 'target'},
	{'Mutilate'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(259, {
	name = '[NeP] Rogue | Assassination',
	wow_ver = "8.3",
	nep_ver = "1.13",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
