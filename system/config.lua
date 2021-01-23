

NeP.Config = {}
local Data = {}
local version = "0.2"
local confname = 'settings';
local function print(...) NeP.Core:Print(...) end

local function forceSave()
	local xData = _G.json.decode(Data)
	NeP.Protected.writeFile('settings.json', xData)
end

local function resetData()
	wipe(Data)
	Data["config_ver"] = version
	forceSave()
end

local function setData()
	local setingsFile = NeP.Protected.readFile('settings.json')
	-- lets try to import old settings
	local old_data = _G[local_stream_name .. 'DATA']
	if old_data and not setingsFile then
		Data = old_data
		forceSave()
		print('Importing old settings...')
		return
	end
	if not setingsFile then
		return
	end
	Data = _G.json.decode(setingsFile)
	-- do we need to wipe it?
	if Data["config_ver"] ~= version then
		resetData()
	end
end

C_Timer.After(.1, setData)

function NeP.Config.Read(_, a, b, default, profile)
	profile = profile or "default"
	if a == nil or b == nil then return end
	if Data[a] then
		if not Data[a][profile] then
			Data[a][profile] = {}
		end
		if Data[a][profile][b] == nil then
			Data[a][profile][b] = default
		end
	else
		Data[a] = {}
		Data[a][profile] = {}
		Data[a][profile][b] = default
	end
	return Data[a][profile][b]
end

function NeP.Config.Write(_, a, b, value, profile)
	profile = profile or "default"
	if not Data[a] then Data[a] = {} end
	if not Data[a][profile] then Data[a][profile] = {} end
	Data[a][profile][b] = value
	forceSave()
end

function NeP.Config.Reset(_, a, b, profile)
	if profile then
		Data[a][profile] = nil
	elseif b then
		if Data[a][profile] then
			Data[a][profile][b] = nil
		end
	elseif a then
		Data[a] = nil
	end
	forceSave()
end

function NeP.Config.Rest_all()
	resetData()
end
