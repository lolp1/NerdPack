
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
    {'Spear Hand Srike', nil, 'target'},
}

local Cooldowns = {
    {'Invoke Xuen, the White Tiger', nil, 'target'},
}

local inCombat = {
	{Keybinds},
    {Interrupts, 'interruptAt(43)&infront&range<=40', 'target'},
    {Cooldowns, 'toggle(cooldowns)'},
    {'Touch of Death', nil, 'target'},
    {'Fist of the White Tiger', 'player.chi<3&&player.energy>70', 'target'},
    {'Tiger Palm', 'player.chi<4&&player.energy>70', 'target'},
    {'Whirling Dragon Punch', nil, 'target'},
    {'Fists of Fury', nil, 'target'},
    {'Rising Sun Kick', nil, 'target'},
    {'Chi Burst', nil, 'target'},
    {'Fist of the White Tiger', nil, 'target'},
    {'Spinning Crane Kick', 'player.buff(Dance of Chi-Ji)', 'target'},
    {'Blackout Kick', nil, 'target'},
    {'Tiger Palm', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(269, {
	name = '[NeP] Monk | Windwalker',
	wow_ver = "9.0",
	nep_ver = "1.4",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
