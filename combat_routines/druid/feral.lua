local _, NeP = ...

local GUI = {

}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key = 'tFury',
		name = 'Use Tiger\'s Fury',
		text = 'Click this toggle for awesome things!',
		icon ='Interface\\Icons\\Ability_creature_cursed_05.png'
	})
end

local exeOnUnload = function()

end

local Keybinds = {
	{'%pause', 'keybind(alt)'},
	{'Focused Azerite Beam', 'keybind(shift)', 'target'},
}

local Survival = {
	{'Renewal','health<49',"player"},
}

local aoe = {
	{'Thrash','!debuff',"target"},
	{'Brutal Slash', nil, 'target'},
	{'Rake', '!debuff&&inmelee', 'enemies'},
}

local Cooldowns = {
	{'Berserk','!buff&target.range<10&target.enemy','player'},
	{'Incarnation: King of the Jungle','!buff&target.range<10target.enemy','player'},
	{'Berserking','target.enemy&energy<70','player'}, -- Troll Racial
	{"Tiger's Fury",'{buff(Incarnation: King of the Jungle)||buff(Berserk)||energy<40||combopoints==5}&!buff&target.range<10&target.enemy','player'},
}


local Interrupts = {
	{'Skull Bash', nil, 'target'},
}

local inCombat = {
	{Keybinds},
	{'Regrowth','talent(7,2)&combopoints>4&!buff(Bloodtalons)&buff(Predatory Swiftness)','player'},
	{"Tiger's Fury",'toggle(tFury)&energy<40','player'},
	{Survival},
	{Cooldowns,'toggle(Cooldowns)'},
	{Interrupts, 'interruptAt(43)&infront&range<=8', 'target'},
	{'/startattack', '!isattacking', 'target'},
	{aoe, 'toggle(aoe)&&player.area(6).enemies >= 3'},
	{'Rip', 'player.combopoints>=5&!debuff', 'target'},
	{'Ferocious Bite', 'player.combopoints>=5', 'target', custom_pool = "player.energy<50"},
	{'Ferocious Bite', '{player.buff(Incarnation: King of the Jungle)||player.buff(Berserk)}&player.combopoints>=5', 'target' , custom_pool = "player.energy<24"},
	{'Rake', '!debuff', 'target'},
	{'Rake', 'debuff&debuff.duration<7', 'target'},
	{'Shred', nil, 'target'},
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
