local NeP =  NeP

NeP.Cache = {
	Conditions = {},
	Spells = {},
	Targets = {},
	Buffs = {},
	Debuffs = {}
}

function NeP.Wipe_Cache()
	for _, v in pairs(NeP.Cache) do
		NeP._G.wipe(v)
	end
end
