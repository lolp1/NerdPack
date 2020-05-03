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
	{'Berserking','target.enemy&energy<70','player'}, -- Troll Racial
	{"Tiger's Fury",'{buff(Incarnation: King of the Jungle)||buff(Berserk)||energy<40||combopoints==5}&!buff&target.range<10&target.enemy','player'},
}


local Interrupts = {
	{'Skull Bash', nil, 'target'}
}

local inCombat = {
	{Keybinds},
	{'Regrowth','talent(7,2)&combopoints>4&!buff(Bloodtalons)&buff(Predatory Swiftness)','player'},
	{Survival},
	{Cooldowns,'toggle(Cooldowns)'},
	{Interrupts, 'interruptAt(43)&infront&range<=8', 'target'},
	{'Rip', 'player.combopoints>=5&!debuff', 'target'},
	{'Ferocious Bite', 'player.combopoints>=5', 'target', custom_pool = function() return NeP.DSL:Get('energy')('player') < 50 end},
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
