  
local n_name, NeP = ...

CH.Version = 1.4

local function login()
  local username = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'username');
  local password = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'password');
  print(username, password)
end

local config = {
	key = n_name .. '_ServerOAuth',
	title = n_name,
	subtitle = 'OAuth',
	width = 250,
	height = 200,
	config = {
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'input', text = 'Username', key = 'username' },
    { type = 'input', text = 'Password', key = 'password' },
    { type = 'button', text = 'Login', width = 230, height = 20, callback = function(val) login() end},
	}
}

local GUI = _G.NeP.Interface:BuildGUI(config)
_G.NeP.Interface:Add('OAuth V:'..CH.Version, function() GUI.parent:Show() end)
GUI.parent:Hide()
