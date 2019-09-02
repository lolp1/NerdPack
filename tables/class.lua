local _, NeP = ...
NeP.ClassTable = {}

local rangex = {
	["melee"] = 1.5,
	["ranged"] = 40,
}

local Warrior = {
	class = 'Warrior',
	hex = 'c79c6e',
	rgb = {0.78,0.61,0.43},
}

local Paladin = {
	class = 'Paladin',
	hex = 'f58cba',
	rgb = {0.96,0.55,0.73},
}

local Hunter = {
	class = 'Hunter',
	hex = 'abd473',
	rgb = {0.67,0.83,0.45},
}

local Rogue = {
	class = 'Rogue',
	hex = 'fff569',
	rgb = {1,0.96,0.41},
}

local Priest = {
	class = 'Priest',
	hex = 'ffffff',
	rgb = {1,1,1},
}

local DeathKnight = {
	class = 'DeathKnight',
	hex = 'c41f3b',
	rgb = {0.77,0.12,0.23},
}

local Shaman = {
	class = 'Shaman',
	hex = '0070de',
	rgb = {0,0.44,0.87},
}

local Mage = {
	class = 'Mage',
	hex = '69ccf0',
	rgb = {0.41,0.8,0.94},
}

local Warlock = {
	class = 'Warlock',
	hex = '9482c9',
	rgb = {0.58,0.51,0.79},
}

local Monk = {
	class = 'Monk',
	hex = '00ff96',
	rgb = {0,1,0.59},
}

local Druid = {
	class = 'Druid',
	hex = 'ff7d0a',
	rgb = {1,0.49,0.04},
}

local Demon_Hunter = {
	class = 'Demon Hunter',
	hex = 'A330C9',
	rgb = {0.64,0.19,0.79},
}

local ShortByIndex = {
	[1] = Warrior,
	[2] = Paladin,
	[3] = Hunter,
	[4] = Rogue,
	[5] = Priest,
	[6] = DeathKnight,
	[7] = Shaman,
	[8] = Mage,
	[9] = Warlock,
	[10] = Monk,
	[11] = Druid,
	[12] = Demon_Hunter
}

function NeP.ClassTable.GetClass(_, classid)
	return ShortByIndex[classid]
end

function NeP.ClassTable:GetClassColor(classid, type)
	local class = self:GetClass(classid)
	return class[type or "hex"]
end
