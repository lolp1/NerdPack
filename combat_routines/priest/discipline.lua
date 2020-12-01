local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key = 'dps',
		name = 'DPS | HEAL (Smite and such)',
		text = 'Click this toggle for awesome things!',
		icon ='Interface\\Icons\\Ability_creature_cursed_05.png'
	})
	NeP.Interface:AddToggle({
		key = 'forceDps',
		name = 'Force DPS',
		text = 'Click this toggle for awesome things!',
		icon ='Interface\\Icons\\Ability_creature_cursed_04.png'
	})
end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(lalt)'},
	{'Angelic Feather', 'keybind(lcontrol)', 'cursor.ground'}
}

local Interrupts = {
	
}

local prio = {
	
}

local tank = {
	{'Power Word: Shield', '!debuff(Weakened Soul)&&health<100', 'tank'},
	{'Penance', 'health<85', 'tank'},
}

local lowest = {
	{'Power Word: Shield', '!debuff(Weakened Soul)&&health<95', 'lowest'},
	{'Penance', 'health<70', 'lowest'},
	{'Smite', 'toggle(dps)&&enemy', 'target'},
}

local solo = {
	{'Power Word: Shield', 'health<75', 'player'},
	{'Penance', 'health<60', 'player'},
	{'Penance', nil, 'target'},
	{'Shadow Word: Pain', '!debuff', 'target'},
	{'Smite', nil, 'target'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&infront&range<=8', 'target'},
	{solo, 'group.type==1||toggle(forceDps)'},
	{prio, 'lowest.health<100'},
	{'Power Word: Solance', 'toggle(dps)&&enemy&&player.mana<95', 'target'},
	{tank, 'health<100', 'tank'},
	{lowest, 'health<100', 'lowest'},
}

local outCombat = {
	{Keybinds},
	{'Power Word: Fortitude', '!buff', {'player', 'tank', 'lowest'}},
	{'Penance', 'health<75', 'lowest'},
}

NeP.CR:Add(256, {
	name = '[NeP] Priest | Discipline',
	wow_ver = "8.2",
	nep_ver = "1.12",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload
})
