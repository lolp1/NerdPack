local NeP, n_name = NeP, n_name

NeP.Timer = {
	timers = {},
	frame = _G.CreateFrame("Frame")
}
local timers = NeP.Timer.timers

NeP.Timer.Add = function(name, func, seconds)
    timers[#timers+1] = {func = func, period = seconds, next = seconds, name=name}
end

local function errorhandler(err)
	return _G.geterrorhandler()(err)
end

NeP.Timer.Handle = function(_, elapsed)
	NeP.current_moveover, NeP.current_focus = NeP._G.UnitGUID('mouseover'), NeP._G.UnitGUID('focus')
	for _, struct in pairs(timers) do
		struct.next = struct.next - elapsed
		if (struct.next <= 0) then
			xpcall(struct.func, errorhandler)
			struct.next = struct.period
        end
	end
end

--FIXME: find by name
NeP.Timer.UpdatePeriod = function(name, peroid)
    --timers[name].period = (peroid / 1000)
end

NeP.Timer.frame:SetScript("OnUpdate", NeP.Timer.Handle)

-- this should always be loader before OM and parser
local F = function(...) return NeP.Interface:Fetch(...) end
NeP.Core:WhenInGame(function()
	NeP.Timer.Add('nep_OM_Wipe_Cache', NeP.Wipe_Cache, tonumber(F(n_name..'_Settings', 'cache_clear_frequency', 0)))
end, 9997)
