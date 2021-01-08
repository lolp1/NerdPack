local InternetRequestAsync
InternetRequestAsync = function(verb, url, parameters, extraHeader, callback)
    if not NeP._G.InternetRequestAsyncInternal then
        C_Timer.After(0, function() InternetRequestAsync(verb, url, parameters, extraHeader, callback) end)
	return
    end
    local id = NeP._G.InternetRequestAsyncInternal(verb, url, parameters, extraHeader)
    local update
    update = function ()
       local response, status = NeP._G.TryInternetRequestInternal(id)
       if response then
          callback(response, status)
       else
          C_Timer.After(0, update)
       end
    end
    C_Timer.After(0, update)
end


local function getCrs()
	print('Loading CRs...')
    InternetRequestAsync(
        "GET",
        domain .. "/api/user/crs/stream?class=" .. current_class,
        '',
        "Content-Type: application/json & Accept: application/json & Authorization: bearer " .. oauthToken .. ' & CustomSecret: ' .. server_secret,
        function(response, status)
            if tonumber(status) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
			end
            pcall(setCrs, response)
        end
    )

end

local function getPlugins()
	print('Loading Plugins...')
    InternetRequestAsync(
        "GET",
        domain .. "/api/user/plugins/stream",
        '',
        "Content-Type: application/json & Accept: application/json & Authorization: bearer " .. oauthToken .. ' & CustomSecret: ' .. server_secret,
        function(response, status)
            if tonumber(status) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
            end
            pcall(setPlugins, response)
            pcall(getCrs);
        end
    )
end

local function getToken(username, password)
    print('Loging in... v5')
    InternetRequestAsync(
        "POST",
        domain .. "/api/auth/login",
        '{"email": "' .. username.. '", "password": "' .. password .. '"}',
        "Content-Type: application/json & Accept: application/json",
        function(response, status)
            if tonumber(status) ~= 200 then
		print('Ooops, something went wrong. Are your credentials valid?')
		pcall(print, status)
		return;
            end
            local token = response:match('"token":"(.-)"')
            if not token then
                print('Ooops, something went wrong. Are your credentials valid? (NO TOKEN)')
            end
            oauthToken = token;
            print('Logged in')
            pcall(getPlugins)
        end
    )
end
