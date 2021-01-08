local function getCrs()
	print('Loading CRs...')
    __LB__.HttpAsyncGet(
		domain,
		 443,
		 true,
         "/api/user/crs/stream?class=" .. current_class,
		 function(content)
			pcall(setCrs, content)
		 end,
		 function(xerror)
			print('Error while loading...')
		 end,
         'Content-Type',
         'application/json',
         'Accept',
         'application/json',
         "Authorization",
         'bearer ' .. oauthToken,
		'CustomSecret',
		server_secret
	)
end

local function getPlugins()
	print('Loading Plugins...')
    __LB__.HttpAsyncGet(
		domain,
		 443,
		 true,
         "/api/user/plugins/stream",
		 function(content)
			print('test', content)
			pcall(setPlugins,content);
			pcall(getCrs);
		 end,
		 function(xerror)
			print('Error while loading...')
		 end,
         'Content-Type',
         'application/json',
         'Accept',
         'application/json',
         "Authorization",
         'bearer ' .. oauthToken,
		'CustomSecret',
		server_secret
	)
end

local function getToken(username, password)
	print('Loging in...')
	__LB__.HttpAsyncPost(
		domain,
		 443,
		 true,
         '/api/auth/login',
         '{"email": "' .. username.. '", "password": "' .. password .. '"}',
		 function(content)
			local token = content:match('"token":"(.-)"')
            if not token then
				print('Ooops, something went wrong. Are your credentials valid?')
				return;
            end
            oauthToken = token;
			getPlugins();
		 end,
		 function(xerror)
			print('Error while loading...')
		 end,
		 'Content-Type',
         'application/json',
         'Accept',
         'application/json'
	)
end
