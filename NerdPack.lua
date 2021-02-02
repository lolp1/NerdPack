local NeP, n_name, local_stream_name = NeP, n_name, local_stream_name
NeP.Version = {
	major = 2,
	minor = 0,
	branch = "",
	Core = {}
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
NeP._G = setmetatable({},{__index = _G})
