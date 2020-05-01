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
