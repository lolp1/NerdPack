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

}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&&infront&&range<=40', 'target'},
	{'Icy Veins', nil, 'player'},
	{'Flurry', 'player.buff(Brain Freeze) && player.buff(Icicles).count < 3', 'target'},
	{'Ebonbolt', nil, 'target'},
	{'Frozen Orb', nil, 'player'},
	{'Comet Storm', nil, 'player'},
	{'Glacial Spike', 'player.buff(Brain Freeze)', 'player'},
	{'Frostbolt', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(64, {
	name = '[NeP] Mage | Forst',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
