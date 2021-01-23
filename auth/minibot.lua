local function getCrs()
	print('Loading CRs...')
	wmbapi.SendHttpRequest({
		Url = "https://" .. domain .. "/api/user/crs/stream?class=" .. current_class,
		Method = "GET",
		Headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
		Callback = function(request, status)
			if (status ~= "SUCCESS") then
				return;
            end
            local _, response = wmbapi.ReceiveHttpResponse(request);
            if tonumber(response.Code) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
            end
			setCrs(response.Body)
		end
	});
end

local function getPlugins()
	print('Loading Plugins...')
	wmbapi.SendHttpRequest({
		Url = "https://" .. domain .. "/api/user/plugins/stream",
		Method = "GET",
		Headers = "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
		Callback = function(request, status)
			if (status ~= "SUCCESS") then
				return;
            end
            local _, response = wmbapi.ReceiveHttpResponse(request);
            if tonumber(response.Code) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
            end
			setPlugins(response.Body)
            getCrs()
		end
	});
end

local function getToken(username, password)
	print('Loging in...')
	wmbapi.SendHttpRequest({
		Url = "https://" .. domain .. "/api/auth/login",
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
				return;
            end
            local token = response.Headers:match("Authorization:%s*(.-)%s")
            if not token then
				print('Ooops, something went wrong. Are your credentials valid?');
				return;
            end
            oauthToken = token;
			getPlugins();
		end
	});
end