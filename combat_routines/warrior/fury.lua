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
	{Keybinds},
	{Interrupts},
    {'Whirlwind', '!player.buff(Whirlwind)', 'target'},
    {'Recklessness', nil, 'target'},
    {'Siegebreaker', '!debuff', 'target'},
    {'Rampage', '!buff(Enrage)', 'target'},
    {'Bladestorm', nil, 'target'},
    {'Dragon Roar', '', 'target'},
}

local inCombat = {
	{Keybinds},
    {Interrupts},
	{AoE, 'toggle(aoe) && player.area(5).enemies >= 3'},
    {'Rampage', '!buff(Enrage) || player.rage >= 90', 'target'},
    {'Recklessness', nil, 'player'},
    {'Execute', 'player.buff(Sudden Death) || health <= 20', 'target'},
    {'Bloodthirst', '!buff(Enrage)', 'target'},
    {'Raging Blow', 'spell.charges >= 2', 'target'},
    {'Bloodthirst', nil, 'target'},
    {'Raging Blow', 'player.rage <= 30', 'target'},
    {'Whirlwind', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(72, {
	name = '[NeP] Warrior | Fury',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = {{inCombat, 'inmelee', 'target'}},
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
