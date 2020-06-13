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

local AoE = {
    {'Thunder Clap', nil, 'target'},
    {'Revenge', nil, 'target'},
    {'Shield Slam', nil, 'target'},
    {'Devastate', nil, 'target'},
}

local inCombat = {
	{Keybinds},
    {Interrupts},
    {AoE, 'toggle(aoe) && player.area(5).enemies >= 3'},
    {'Avatar', nil, 'player'},
    {'Demoralizing Shout', 'talent(6,1)', 'target'},
    {'Shield Slam', nil, 'target'},
    {'Thunder Clap', nil, 'target'},
    {'Revenge', 'spell.proc', 'target'},
    {'Devastate', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(73, {
	name = '[NeP] Warrior | Protection',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
