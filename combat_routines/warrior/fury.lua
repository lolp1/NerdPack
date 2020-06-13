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

--[[
Cast Whirlwind for two stacks of its buff.
Cast Recklessness if able.
Cast Siegebreaker to debuff multiple targets.
Cast Rampage for Enrage.
Cast Bladestorm or Dragon Roar as appropriate.
Cast Whirlwind to refresh its buff.
]]
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
    {'Rampage', '!buff(Enrage)', 'target'},
    {'Recklessness', nil, 'player'},
    {'Execute', '!player.buff(Sudden Death) || health <= 20', 'target'},
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
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
