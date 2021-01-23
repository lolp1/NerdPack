local NeP = NeP

NeP.DSL = {}
NeP.DSL.Conditions = {}
local conditions = NeP.DSL.Conditions
local noop = function() end

function NeP.DSL.Get(_, Strg)
	return conditions[Strg:lower()] or noop
end

function NeP.DSL.Exists(_, Strg)
	return conditions[Strg:lower()] ~= nil
end

local C = NeP.Cache.Conditions

local function _add(name, condition)
	name = name:lower()
	if not conditions[name] then
		conditions[name] = function(target, spell, spell2, ...)
			spell = spell or spell2
			local key = name .. (target or '') .. (spell or '') .. (spell2 or '')
			if C[key] == nil then
				C[key] = {condition(target, spell, spell2, ...)}
			end
			return NeP._G.unpack(C[key])
		end
		--NeP.Debug:Add(name, condition, true)
	end
end

function NeP.DSL.Register(_, name, condition)
	if type(name) == 'table' then
		for i=1, #name do
			_add(name[i], condition)
		end
	elseif type(name) == 'string' then
		_add(name, condition)
	else
		NeP.Core:Print("ERROR! tried to add an invalid condition")
	end
end
