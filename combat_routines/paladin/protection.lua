local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key = 'smart_taunt',
		name = 'Use Crowd Controls',
		text = 'Click this toggle for awesome things!',
		icon ='Interface\\Icons\\Ability_creature_cursed_05.png'
	})
end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(alt)'}
}

local Interrupts = {
	{'Rebuke', nil , 'target'},
}

local cooldowns = {
	{'Avenging Wrath', nil , 'player'},
	{'Ardent Defender', 'health<60' , 'player'},
	{'Guardian of Ancient Kings', 'health<40' , 'player'},
}

local heals = {
	{'Lay on Hands', 'health<15', 'player'},
	{'Word of Glory', 'health<80', 'player'},
}

local inCombat = {
	{Keybinds},
	{heals},
	{Interrupts, 'interruptAt(43)&.infront&range<=40', 'target'},
	{cooldowns, 'toggle(cooldowns)'},
	{'Hand of Reckoning', '!aggro&&combat&&toggle(smart_taunt)', 'enemies'},
	{'Consecration', nil, 'target'},
	{'Judgment', nil, 'target'},
	{'Divine Toll', 'area(40).enemies>=3', 'target'},
	{'Hammer of Wrath', nil, 'target'},
	{'Avenger\'s Shield', nil, 'target'},
	{'Hammer of the Righteous', nil, 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(66, {
	name = '[NeP] Paladin | Protection',
	wow_ver = "9.0",
	nep_ver = "1.4",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
