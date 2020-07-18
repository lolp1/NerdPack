local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()

end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(alt)'},
	{'Focused Azerite Beam', 'keybind(shift)', 'target'}
}

local Interrupts = {
	{'Skull Bash', nil, 'target'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&.infront&range<=8', 'target'},
	{'/startattack', '!isattacking', 'target'},
    {'Moonfire', '!debuff||player.proc(Galactic Guardian)', 'target'},
    {'Thrash', 'debuff.count<3', 'target'},
    {'Pulverize', 'debuff(Thrash).count>=3', 'target'},
    {'Mangle', nil, 'target'},
    {'Thrash', nil, 'target'},
    {'Swipe', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(104, {
	name = '[NeP] Druid | Guardian',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
