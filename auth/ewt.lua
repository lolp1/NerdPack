local function getCrs()
	print('Loading CRs...')
    SendHTTPRequest("https:/".. domain .."/api/user/crs/stream?class=" .. current_class, 
        nil, 
        function(body, code, req, res, err)
            if tonumber(code) ~= 200 then
                print('Ooops, something is burning with the cr server. Try again later.');
                return;
            end
            pcall(setCrs, body)
        end,
        "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret .. '\r\n'
    )
end

local function getPlugins()
	print('Loading Plugins...')
    SendHTTPRequest("https:/".. domain .."/api/user/plugins/stream", 
        nil, 
        function(body, code, req, res, err)
            if tonumber(code) ~= 200 then
                print('Ooops, something is burning with the cr server. Try again later.');
                return;
            end
            pcall(setPlugins, body)
        end,
        "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret .. '\r\n'
    )
end

local function getToken(username, password)
	print('Loging in...')
    SendHTTPRequest('https:/".. domain .."/api/auth/login', 
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
			pcall(getPlugins);
		end,
		"Content-Type: application/json\r\nAccept: application/json"
	) 
end