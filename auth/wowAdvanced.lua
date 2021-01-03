local function InternetRequestAsync(verb, url, parameters, extraHeader, callback)
    local id = InternetRequestAsyncInternal(verb, url, parameters, extraHeader)
    local update
    update = function ()
       local response, status = TryInternetRequestInternal(id)
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
        domain .. "/download-stream/init/wowadvanced",
        '',
        "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
        function(response, status)
            if tonumber(status) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
			end
            pcall(setCrs, response.Body)
        end
    )

end

local function getPlugins()
	print('Loading Plugins...')
    InternetRequestAsync(
        "GET",
        domain .. "/download-stream/init/wowadvanced",
        '',
        "Content-Type: application/json\r\nAccept: application/json\r\nAuthorization: bearer " .. oauthToken .. '\r\nCustomSecret: ' .. server_secret,
        function(response, status)
            if tonumber(status) ~= 200 then
				print('Ooops, something is burning with the cr server. Try again later.');
				return;
			end
            pcall(setPlugins, response.Body)
            pcall(getCrs);
        end
    )
end

local function getToken(username, password)
	print('Loging in...')
    InternetRequestAsync(
        "POST",
        domain .. "/download-stream/init/wowadvanced",
        '{"email": "' .. username.. '", "password": "' .. password .. '"}',
        "Content-Type: application/json\r\nAccept: application/json",
        function(response, status)
            if tonumber(status) ~= 200 then
				print('Ooops, something went wrong. Are your credentials valid?')
				return;
            end
            local token = response:match('"token":"(.-)"')
			print(token, response)
            if not token then
                print('Ooops, something went wrong. Are your credentials valid?')
            end
            oauthToken = token;
            pcall(getPlugins)
        end
    )
end
