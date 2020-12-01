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
	{'Pummel', 'interruptat(40)', 'target'}
}

local Execute = {
	{'Bladestorm', 'player.rage < 30', 'target'},
	{'Overpower', 'player.rage <= 10', 'target'},
	{'Execute', nil, 'target'},
}

local inCombat = {
	{Keybinds},
	{Interrupts},
	{'Avatar', 'spell(Colossus Smash).cooldown == 0', 'target'},
	{'Colossus Smash', nil, 'target'},
	{Execute, 'health <= 20', 'target'},
	{'Execute', 'player.buff(Sudden Death)', 'target'},
	{'Overpower', '!player.buff && spell(Mortal Strike).cooldown == 0', 'target'},
	{'Mortal Strike', 'debuff(Deep Wounds).duration <= 2', 'target'},
	{'Bladestorm', 'debuff(Colossus Smash)', 'target'},
	{'Slam', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(71, {
	name = '[NeP] Warrior | Arms',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
