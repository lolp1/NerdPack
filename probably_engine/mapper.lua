local _, NeP = ...

NeP.PE.toggle = {}
NeP.PE.rotation = {}

--wrapper for toggles
NeP.PE.toggle.create = function(key, icon, name, tooltip)
	NeP.Interface:AddToggle({
		key = key,
		name = name,
		text = tooltip,
		icon = icon,
	})
end

--wrapper for CR Add
NeP.PE.rotation.register_custom = function(id, name, incombat, outcombat, callback)
	NeP.CR:Add(id, {
		name = name,
		ic = incombat,
		ooc = outcombat,
		load = callback
	})
end
