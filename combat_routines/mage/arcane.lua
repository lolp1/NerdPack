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

local Conservation = {
	{'Charged Up', 'player.arcanecharges < 1', 'target'},
	{'Rune of Power', 'player.arcanecharges = 4', 'target'},
	{'Arcane Blast', 'player.buff(Rule of Threes)', 'target'},
	{'Arcane Missiles', 'player.buff(Clearcasting)', 'target'},
	{'Arcane Barrage', 'player.arcanecharges = 4 && player.mana < 60', 'target'},
	{'Arcane Blast', nil, 'target'},
}

--Enter the burn phase under the conditions that
--Arcane Power is ready, you have > 30% mana, 4 Arcane Charges,
--and at least one charge of Rune of Power.
local Burn = {
	{'Charged Up', nil, 'target'},
	{'Arcane Blast', 'player.buff(Rule of Threes)', 'target'},
	{'Rune of Power', nil, 'target'},
	{'Arcane Power', nil, 'target'},
	{'Arcane Missiles', 'player.buff(Clearcasting)', 'target'},
	{'Presence of Mind', nil, 'target'},
	{'Arcane Blast', nil, 'target'},
}

local inCombat = {
	{Keybinds},
	{Interrupts, 'interruptAt(43)&&infront&&range<=40', 'target'},
	{'Evocation', 'player.mana <= 30'},
	{Burn, 'player.mana > 30 && player.arcanecharges >= 4 && spell(Rune of Power).charges >= 1'},
	{Conservation}
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(62, {
	name = '[NeP] Mage | Arcane',
	wow_ver = "8.3",
	nep_ver = "1.3",
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad,
	unload = exeOnUnload,
	pooling = false,
})
