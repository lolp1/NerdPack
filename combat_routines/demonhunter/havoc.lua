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
    Metamorphosis [on CD]
    Immolation Aura
    Blade Dance | Death Sweep
    Eye Beam
    Chaos Strike | Annihilation
    Demon's Bite [fury generator]
]]
local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&.infront&range<=8', 'target'},
    {'Immolation Aura', nil, 'player'},
    {'Blade Dance', nil, 'target'},
    {'Death Sweep', nil, 'target'},
    {'Eye Beam', 'infront&&range<19', 'target'},
    {'Chaos Strike', nil, 'target'},
    {'Annihilation', nil, 'target'},
    {'Demon\'s Bite', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(577, {
	name = '[NeP] Deamon Hunter | Vengeance',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
