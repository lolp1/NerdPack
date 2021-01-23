local version = 1.5
local oauthToken;
local server_secret = 'SECRET_BY_SERVER';
local current_class = select(2,UnitClass('player')):lower();
local domain = "nerdpack.xyz"

local function load_code(code, name)
    local f = assert(loadstring(code, name))
    setfenv(f, _G)
    return f
end

local function setCrs(body)
	if not body then
		NeP.Core:Print('DONE no crs loaded');
		return;
	end
	local func = load_code(body,'NerdPack-Auth-crs');
	if not func then
		print('Error Loading crs')
	end
	local success, xerrorMessage = pcall(func);
	if not success then
		print('Error Loading crs')
		print(xerrorMessage)
	end
	NeP.Interface.ResetCRs();
    NeP.CR:Set();
	NeP.Core:Print('DONE loading crs!');
end

local function setPlugins(body)
	if not body then
		NeP.Core:Print('DONE no Plugins loaded');
		return;
	end
	local func = load_code(body,'NerdPack-Auth-Plugins');
	if not func then
		print('Error Loading Plugins')
	end
	local success, xerrorMessage = pcall(func);
	if not success then
		print('Error Loading Plugins')
		print(xerrorMessage)
	end
	NeP.Core:Print('DONE loading plugins!');
end

--REPLACE_WITH_UNLOCKER_FILE

local function login()
  if oauthToken then NeP.Core:Print('Already Logged in'); return; end
  local username = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'username');
  local password = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'password');
  if password and password:len() > 0 and username and username:len() > 0 then
		getToken(username, password)
  end
end

local config = {
	key = n_name .. '_ServerOAuth',
	title = n_name,
	subtitle = 'OAuth',
	width = 250,
	height = 100,
	config = {
		{ type = 'spacer' },
		{ type = 'input', text = 'Username', key = 'username', width = 150 },
		{ type = 'input', text = 'Password', key = 'password', width = 150 },
		{ type = 'spacer' },
		{ type = 'button', text = 'Login', width = 230, height = 20, callback = function(val) login() end},
	}
}

local GUI = NeP.Interface:BuildGUI(config)
NeP.Interface:Add('OAuth V:'..version, function() GUI.parent:Show() end)
GUI.parent:Hide();

-- try auto login
login();
