local NeP = NeP
NeP.Version = {
	major = 2,
	minor = 0,
	branch = ""
}
NeP.Media = 'Interface\\AddOns\\' .. (local_stream_name or n_name) .. '\\media\\'
NeP.Color = 'FFFFFF'
NeP.Paypal = 'https://www.paypal.me/JaimeMarques/25'
NeP.Patreon = 'https://www.patreon.com/mrthesoulz'
NeP.Discord = 'https://discord.gg/XtSZbjM'
NeP.Author = 'MrTheSoulz'

-- This exports stuff into global space
NeP.Globals = {}
_G.NeP = NeP.Globals
--NeP._G = setmetatable({},{__index = _G})
NeP._G = _G -- testing

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

NeP.Timer = {
	timers = {},
	frame = _G.CreateFrame("Frame")
}
local timers = NeP.Timer.timers

NeP.Timer.Add = function(name, func, seconds)
    timers[#timers+1] = {func = func, period = seconds, next = seconds, name=name}
end

local function errorhandler(err)
	return geterrorhandler()(err)
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

-- this should always be the 1st
NeP.Timer.Add('nep_OM_Wipe_Cache', NeP.Wipe_Cache, 0) -- every frame
