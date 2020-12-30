local version = 1.4
local oauthToken;
-- would like this gone... i need to pass nep tho
local pointer = tostring(NeP);
_G[pointer] = NeP;
local server_secret = 'REPLACED_BY_SERVER';
local current_class = select(1,UnitClass('player')):lower();

local function getCrs(body)
    local xstatus, xerror = pcall(RunScript, "local NeP = _G['" .. pointer .. "'];\n local n_name = '" .. n_name .. "';\n" .. body);
    if not xstatus then print(xerror) end
    NeP.Interface.ResetCRs();
    NeP.CR:Set();
    NeP.Core:Print('DONE loading crs!');
end

local function getCrsLB()
    __LB__.HttpAsyncGet(
		'nerdpack.xyz',
		 443, 
		 true, 
         "/api/user/crs/stream?class=" .. current_class,
		 function(content)
			getCrs(content)
		 end, 
		 function(xerror)
			print('Error while loading...')
		 end, 
		 'Content-Type: application/json', 
		 'Accept: application/json',
         "Authorization: bearer " .. oauthToken
	)
end

local function getTokenLB(username, password)
	__LB__.HttpAsyncPost(
		'nerdpack.xyz',
		 443, 
		 true, 
         '/download-stream/init', 
         '{"email": "' .. username.. '", "password": "' .. password .. '"}',
		 function(content)
			local token = content:match("Authorization:%s*(.-)%s")
            if not token then
                print('Ooops, something went wrong. Are your credentials valid?')
            end
            oauthToken = token;
			getCrsLB()
		 end, 
		 function(xerror)
			print('Error while loading...')
		 end, 
		 'Content-Type: application/json', 
         'Accept: application/json'
	)
end

local function getCrsEWT()
    SendHTTPRequest("https://nerdpack.xyz/api/user/crs/stream?class=" .. current_class, 
        nil, 
        function(body, code, req, res, err)
			print(res)
            if tonumber(code) ~= 200 then
                print('Ooops, something is burning with the cr server. Try again later.');
                return;
            end
            getCrs(body)
        end,
        "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret
    )
end

local function getTokenEWT(username, password)
    SendHTTPRequest('https://nerdpack.xyz/api/auth/login', 
        '{"email": "' .. username.. '", "password": "' .. password .. '"}',
		function(body, code, req, res, err)
			if tonumber(code) ~= 200 then
                print('Ooops, something is burning with the auth server. Try again later.');
				return;
            end
            local token = res:match("Authorization:%s*(.-)%s")
            if not token then
                print('Ooops, something went wrong. Are your credentials valid?')
            end
            oauthToken = token;
			getCrsEWT()
		end,
		"Content-Type: application/json\r\nAccept: application/json"
	) 
end

local function getCrsMB()
	NeP.Core:Print('Loading CRs...')
	wmbapi.SendHttpRequest({
		Url = "https://nerdpack.xyz/api/user/crs/stream?class=" .. current_class,
		Method = "GET",
		Headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
		Callback = function(request, status)
			if (status ~= "SUCCESS") then
				return;
            end
            local _, response = wmbapi.ReceiveHttpResponse(request);
            if tonumber(response.Code) ~= 200 then
                print('Ooops, something is burning with the cr server. Try again later.');
            end
			getCrs(response.Body)
		end
	});
end

local function getTokenMB(username, password)
	NeP.Core:Print('Loging in...')
	wmbapi.SendHttpRequest({
		Url = "https://nerdpack.xyz/api/auth/login",
		Method = "POST",
		Headers = "Content-Type: application/json\r\nAccept: application/json",
		Body = '{"email": "' .. username.. '", "password": "' .. password .. '"}',
		Callback = function(request, status)
			if (status ~= "SUCCESS") then
                return;
            end
            local _, response = wmbapi.ReceiveHttpResponse(request);
            if tonumber(response.Code) ~= 200 then
                print('Ooops, something is burning with the auth server. Try again later.');
            end
            local token = response.Headers:match("Authorization:%s*(.-)%s")
            if not token then
                print('Ooops, something went wrong. Are your credentials valid?')
            end
            oauthToken = token;
			getCrsMB();
		end
	});
end

local function getToken(...)
    if wmbapi then
		getTokenMB(...)
	elseif EWT then
		getTokenEWT(...)
	elseif __LB__ then
		getTokenLB(...)
	else
		print('No supported unlocker found, try again after launching one.')
	end
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
