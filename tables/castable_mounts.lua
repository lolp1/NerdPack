local _, NeP = ...
NeP.ByPassMounts = {}
NeP.ByPassMounts.table = {}

function NeP.ByPassMounts:Eval(ID)
	for i=1, #self.table do
		if tonumber(ID) == self.table[i] then
			return true
		end
	end
end

function NeP.ByPassMounts:Add(ID)
	if type(ID) == 'table' then
		for i=1, #ID do
			self:Add(ID[i])
		end
	else
		table.insert(self.table, ID)
	end
end

NeP.ByPassMounts:Add({
	165803, --telaari-talbuk
	164222, --frostwolf-war-wolf
	221883, --divine-steed
	221887, --divine-steed
	221673, --storms-reach-worg
	221595, --storms-reach-cliffwalker
	221672, --storms-reach-greatstag
	221671, --storms-reach-warbear
	221886 -- Divine Steed
})

--Export to global
NeP.Globals.Tables = NeP.Globals.Tables or {}
NeP.Globals.Tables.ByPassMounts = NeP.ByPassMounts
