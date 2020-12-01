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
    {Interrupts, 'interruptAt(43)&&infront&&range<=8', 'target'},
    {Keybinds},
    {'Roll the Bones', '!player.buff(Ruthless Precision)&&!player.buff(Grand Melee)', 'target'},
    {'Blade Rush', 'player.energy<30', 'target'},
    {'Adrenaline Rush', nil, 'target'},
    {'Between the Eyes', 'player.combotpoints>=4&&{player.buff(Ruthless Precision)||player.buff(Deadshot)||player.buff(Ace Up Your Sleeve)}', 'target'},
    {'Dispatch', 'player.combopoints>=4', 'target'},
    {'Pistol Shot', 'player.buff(Opportunity)&&player.combotpoints<=3', 'target'},
    {'Sinister Strike', nil, 'target'},
}

local outCombat = {
    {Keybinds},
}

NeP.CR:Add(260, {
	name = '[NeP] Rogue | Outlaw',
	wow_ver = "8.3",
	nep_ver = "1.13",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
