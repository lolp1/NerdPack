local NeP = NeP
local CreateFrame = NeP._G.CreateFrame
NeP.Listener = {}
local listeners = {}

local onEvent = function(_, event, ...)
	if not listeners[event] then return end
	for k in pairs(listeners[event]) do
		listeners[event][k](...)
	end
end

local frame = CreateFrame('Frame', 'NeP_Events')
frame:SetScript('OnEvent', onEvent)

function NeP.Listener.Add(_, name, event, callback, overwrite)
	if type(event) == "table" then
		for i=1, #event do
			 NeP.Listener:Add(name .. i, event[i], callback)
		end
		return
	end
	if not listeners[event] then
		frame:RegisterEvent(event)
		listeners[event] = {}
	end
	if listeners[event][name] and not overwrite then
		NeP.Core:Print(name..' for '..event..' already exists')
		return
	end
	listeners[event][name] = callback
end

function NeP.Listener.Remove(_, name, event)
	if listeners[event] then
		listeners[event][name] = nil
	end
end

function NeP.Listener.Trigger(_, event, ...)
	onEvent(nil, event, ...)
end
