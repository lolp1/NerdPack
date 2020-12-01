
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

}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&&infront&&range<=40', 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(270, {
	name = '[NeP] Monk | Mistweaver',
	wow_ver = "9.0",
	nep_ver = "1.4",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
