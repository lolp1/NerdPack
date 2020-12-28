  
local n_name, NeP = ...

local version = 1.4
local oauthToken;

local function getCrs()
	print('Loading CRs...', oauthToken)
	wmbapi.SendHttpRequest({
		Url = "http://127.0.0.1:8000/api/user/crs",
		Method = "GET",
		Headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken,
		Callback = function(request, status)
			if (status == "SUCCESS") then
				local _, response = wmbapi.ReceiveHttpResponse(request);
				RunScript("local NeP = " .. NeP .. ";\n local n_name = " .. n_name .. "\n" .. response.Body)
			else
				print('ERROR', status)
			end
		end
	});
end

local function getToken(username, password)
	print('Loging in...')
	wmbapi.SendHttpRequest({
		Url = "http://127.0.0.1:8000/api/auth/login",
		Method = "POST",
		Headers = "Content-Type: application/json\r\nAccept: application/json",
		Body = "{\"email\": \"" .. username.. "\", \"password\": \"" .. password .. "\"}",
		Callback = function(request, status)
			if (status == "SUCCESS") then
				local _, response = wmbapi.ReceiveHttpResponse(request);
				local token = response.Headers:match("Authorization: (.*)$")
				oauthToken = token;
				getUser()
			else
				print('ERROR', status)
			end
		end
	});
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

local function login()
  local username = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'username');
  local password = NeP.Interface:Fetch(n_name .. '_ServerOAuth', 'password');
  print(username, password)
  getToken(username, password)
end

local GUI = NeP.Interface:BuildGUI(config)
NeP.Interface:Add('OAuth V:'..version, function() GUI.parent:Show() end)
GUI.parent:Hide()
