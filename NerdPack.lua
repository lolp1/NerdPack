local n_name, NeP = ...
NeP.Version = {
	major = 1,
	minor = 0013,
	branch = "RELEASE"
}
NeP.Media = 'Interface\\AddOns\\' .. n_name .. '\\Media\\'
NeP.Color = 'FFFFFF'
NeP.Paypal = 'https://www.paypal.me/JaimeMarques/25'
NeP.Patreon = 'https://www.patreon.com/mrthesoulz'
NeP.Discord = 'https://discord.gg/XtSZbjM'
NeP.Author = 'MrTheSoulz'

-- This exports stuff into global space
NeP.Globals = {}
_G.NeP = NeP.Globals
NeP._G = {}

NeP.Cache = {
	Conditions = {},
	Spells = {},
	Targets = {}
}

for name, func in pairs(_G) do
	NeP._G[name] = func
end

function NeP.Wipe_Cache()
	for _, v in pairs(NeP.Cache) do
		NeP._G.wipe(v)
	end
end

NeP.Timer = {
	timers = {},
	frame = _G.CreateFrame("Frame")
}

NeP.Timer.Add = function(name, func, seconds)
    NeP.Timer.timers[name] = {func = func, period = seconds, next = seconds}
end

NeP.Timer.Handle = function(_, elapsed)
	for name, struct in pairs(NeP.Timer.timers) do
		struct.next = struct.next - elapsed
		if (struct.next <= 0) then
			struct.func()
			struct.next = struct.period
        end
	end
end

NeP.Timer.UpdatePeriod = function(name, peroid)
    NeP.Timer.timers[name].period = (peroid / 1000)
end

NeP.Timer.frame:SetScript("OnUpdate", NeP.Timer.Handle)
