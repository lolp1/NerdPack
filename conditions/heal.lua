local _, NeP = ...

NeP.DSL:Register("health", function(target)
	return NeP.Healing.healthPercent(target)
end)

NeP.DSL:Register("health.actual", function(target)
	return NeP._G.UnitHealth(target) or 0
end)

NeP.DSL:Register("health.max", function(target)
	return NeP._G.UnitHealthMax(target) or 0
end)

NeP.DSL:Register("health.predicted", function(target)
	return NeP.Healing.GetPredictedHealth_Percent(target)
end)

NeP.DSL:Register("health.predicted.actual", function(target)
	return NeP.Healing.GetPredictedHealth(target)
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal >= #
NeP.DSL:Register("area.heal", function(unit, args)
	local total = 0
	if not NeP.DSL:Get('exists')(unit) then return total end
	local distance, health = NeP._G.strsplit(",", args, 2)
	for _,Obj in pairs(NeP.OM:Get('Roster')) do
		local unit_dist = NeP.Protected.Distance(unit, Obj.key)
		if unit_dist < (tonumber(distance) or 20)
		and Obj.health < (tonumber(health) or 100) then
			total = total + 1
		end
	end
	return total
end)

-- USAGE: UNIT.area(DISTANCE, HEALTH).heal.infront >= #
NeP.DSL:Register("area.heal.infront", function(unit, args)
	local total = 0
	if not NeP.DSL:Get('exists')(unit) then return total end
	local distance, health = NeP._G.strsplit(",", args, 2)
	for _,Obj in pairs(NeP.OM:Get('Roster')) do
		local unit_dist = NeP.Protected.Distance(unit, Obj.key)
		if unit_dist < (tonumber(distance) or 20)
		and Obj.health < (tonumber(health) or 100)
		and NeP.Protected.Infront(unit, Obj.key)
		and NeP.DSL:Get('los')(Obj.key) then
			total = total + 1
		end
	end
	return total
end)
