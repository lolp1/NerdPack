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

local Survival = {
	{'Renewal','health<49',"player"},
}

local Cooldowns = {
	{'Berserk','!buff&target.range<10&target.enemy','player'},
	{'Incarnation: King of the Jungle','!buff&target.range<10target.enemy','player'},
	{'Berserking','enemy&player.energy<70','target'}, -- Troll Racial
}


local Interrupts = {
	{'Skull Bash', nil, 'target'}
}

local inCombat = {
	{Keybinds},
	{Survival},
	{Cooldowns,'toggle(Cooldowns)'},
	{Interrupts, 'interruptAt(43)&infront&range<=8', 'target'},
	{'Regrowth','talent(7,2)&player.combopoints>4&!buff(Bloodtalons)&buff(Predatory Swiftness)','player'},
	{'Rip', 'player.combopoints>=5&!debuff', 'target'},
	{'Ferocious Bite', 'player.combopoints>=5&player.energy>=50', 'target'},
	{'Ferocious Bite', '{player.buff(Incarnation: King of the Jungle)||player.buff(Berserk)}&player.combopoints>=5&player.energy>=24', 'target'},
	{'Rake', '!debuff&player.combopoints<5', 'target'},
	{'Rake', 'debuff&debuff.duration<7&player.combopoints<5', 'target'},
	{'Shred', 'player.combopoints<5', 'target'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(103, {
	name = '[NeP] Druid | Feral',
	wow_ver = "8.2",
	nep_ver = "1.12",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = true,
})
