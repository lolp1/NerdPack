local n_name, NeP = ...

NeP.Config = {}
local Data = {}

NeP.Listener:Add("NeP_Config", "ADDON_LOADED", function(addon)
	if addon:lower() == n_name:lower() then
		NePDATA = NePDATA or Data
		Data = NePDATA
	end
end)

function NeP.Config.Read(_, a, b, default)
	if Data[a] then
		if Data[a][b] == nil then
			Data[a][b] = default
		end
	else
		Data[a] = {}
		Data[a][b] = default
	end
	return Data[a][b]
end

function NeP.Config.Write(_, a, b, value)
	if not Data[a] then Data[a] = {} end
	Data[a][b] = value
end

function NeP.Config.Reset(_, a)
	Data[a] = nil
end

function NeP.Config.Rest_all()
	wipe(Data)
end
