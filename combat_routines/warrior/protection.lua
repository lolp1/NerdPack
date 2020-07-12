local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()

end

local exeOnUnload = function()

end

local Keybinds = {
    {'%pause', 'keybind(alt)'},
    {'Heroic Leap', 'keybind(control)', 'cursor.ground'}
}

local Interrupts = {
    {'Pummel', 'interruptat(40)', 'target'}
}

local AoE = {
    {'Thunder Clap', 'inmelee', 'target'},
    {'Revenge', nil, 'target'},
    {'Shield Slam', nil, 'target'},
    {'Devastate', nil, 'target'},
}

local inCombat = {
	{Keybinds},
    {Interrupts},
    {'&Last Stand', '!buff && health < 20', 'player'},
    {'&Shield Wall', '!buff && health < 60', 'player'},
    {'&Ignore Pain', '!buff && health < 90', 'player'},
    {'&Shield Block', '{spell.charges >= 2 || toggle(cooldowns)} && !buff && health < 100', 'player'},
    {'Avatar', 'toggle(cooldowns) && combat.time > 5', 'player'},
    {'Victory Rush', nil, 'target'},
    {AoE, 'toggle(aoe) && player.area(5).enemies >= 3'},
    {'Demoralizing Shout', 'talent(6,1)', 'target'},
    {'Shield Slam', nil, 'target'},
    {'Thunder Clap', 'inmelee', 'target'},
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
