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

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&.infront&range<=8', 'target'},
    {'Fracture', nil, 'target'},
    {'Immolation Aura', nil, 'target'},
    {'Fel Devastation', nil, 'target'},
    {'Soul Cleave', 'pain>60', 'target'},
    {'Sigil of Flame', nil, 'target'},
    {'Infernal Strike', 'spell.charges>=2&&range<30', 'target.ground'},
    {'Shear', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(581, {
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
