local version = 1.4
local oauthToken;
-- would like this gone... i need to pass nep tho
local pointer = tostring(NeP);
_G[pointer] = NeP;
local server_secret = 'REPLACED_BY_SERVER';

local function getCrs()
	NeP.Core:Print('Loading CRs...')
	wmbapi.SendHttpRequest({
		Url = "http://127.0.0.1:8000/api/user/crs",
		Method = "GET",
		Headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
		Callback = function(request, status)
			local status, response = pcall(f, "a")
			if (status == "SUCCESS") then
				local _, response = wmbapi.ReceiveHttpResponse(request);
				local xstatus, xerror = pcall(RunScript, "local NeP = _G['" .. pointer .. "'];\n local n_name = '" .. n_name .. "';\n" .. response.Body);
				if not xstatus then print(xerror) end
				NeP.Interface.ResetCRs();
				NeP.CR:Set();
				NeP.Core:Print('DONE loading crs!');
			else
				print(status);
			end
		end
	});
end

local function getToken(username, password)
	NeP.Core:Print('Loging in...')
	wmbapi.SendHttpRequest({
		Url = "http://127.0.0.1:8000/api/auth/login",
		Method = "POST",
		Headers = "Content-Type: application/json\r\nAccept: application/json",
		Body = "{\"email\": \"" .. username.. "\", \"password\": \"" .. password .. "\"}",
		Callback = function(request, status)
			if (status == "SUCCESS") then
				local _, response = wmbapi.ReceiveHttpResponse(request);
				local token = response.Headers:match("Authorization:%s*(.-)%s")
				oauthToken = token;
				getCrs()
			end
		end
	});
end

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
