local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()

end

local exeOnUnload = function()

end

local Keybinds = {
    {'%pause', 'keybind(alt)'},
    {'Heroic Leap', 'keybind(control)', 'cursor.ground'},
    {'Focused Azerite Beam', 'keybind(shift)', 'target'}
}

local Interrupts = {
    {'Pummel', 'interruptat(40)', 'target'}
}

local AoE = {
    {'Whirlwind', '!player.buff(Whirlwind)', 'target'},
    {'Recklessness', 'toggle(cooldowns)', 'target'},
    {'Siegebreaker', '!debuff', 'target'},
    {'Rampage', '!buff(Enrage)', 'target'},
    {'Bladestorm', nil, 'target'},
    {'Dragon Roar', '', 'target'},
}

local inCombat = {
    {Interrupts},
    {'/startattack', '!isattacking', 'target'},
    {'Victory Rush', nil, 'target'},
	{AoE, 'toggle(aoe) && player.area(5).enemies >= 3'},
    {'Rampage', '!buff(Enrage) || player.rage >= 90', 'target'},
    {'Recklessness', 'toggle(cooldowns)', 'player'},
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
	ic = {
        {'%pause', 'channeling(Focused Azerite Beam)', 'player'},
        {Keybinds},
        {inCombat, 'inmelee', 'target'}
    },
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
