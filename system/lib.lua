local _, NeP = ...
local strsplit = _G.strsplit

NeP.Library = {}
NeP.Library.Libs = {}

-- This needs to be global for loadstring :C
local libs = NeP.Library.Libs

function NeP.Library.Add(_, name, lib)
	if not libs[name] then
		libs[name] = lib
	end
end

function NeP.Library.Fetch(_, strg)
	local a, b = strsplit(".", strg, 2)
	return libs[a][b]
end

function NeP.Library:Parse(strg, ...)
	local lib = self:Fetch(strg)
	return lib(...)
end

NeP.Globals.Library = {
	Add = NeP.Library.Add,
	Fetch = NeP.Library.Fetch,
	Parse = NeP.Library.Parse
}
