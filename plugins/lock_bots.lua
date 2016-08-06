local function run(msg, matches)
	local data = load_data(_config.moderation.data)
	local lock_bot = data[tostring(msg.to.id)]['settings']['lock_bot']
	if matches[1]:lower() == "+" and matches[2] == "bot" then
		data[tostring(msg.to.id)]['settings']['lock_bot'] = 'yes'
		save_data(_config.moderation.data, data)
		return 'عضوگیری ربات غیر مجاز شد'
	elseif matches[1]:lower() == "-" and matches[2] == "bot" then
		data[tostring(msg.to.id)]['settings']['lock_bot'] = 'no'
		save_data(_config.moderation.data, data)
		return 'عضوگیری ربات مجاز شد'
	end
	if not lock_bot then
		data[tostring(msg.to.id)]['settings']['lock_bot'] = 'yes'
		save_data(_config.moderation.data, data)
		if msg.action.user.username ~= nil then
			if is_sudo(msg) then
				return nil
			elseif is_admin(msg) then
				return nil
			else
				if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
					local antibotchat = 'chat#id'..msg.to.id
					local antibotuser = 'user#id'..msg.action.user.id
					chat_del_user(antibotchat, antibotuser, ok_cb, true)
					return 'افزودن ربات ممنوع است'
				end
			end
		end
	elseif lock_bot == 'yes' then
		if msg.action.user.username ~= nil then
			if is_sudo(msg) then
				return nil
			elseif is_admin(msg) then
				return nil
			else
				if string.sub(msg.action.user.username:lower(), -3) == 'bot' then
					local antibotchat = 'chat#id'..msg.to.id
					local antibotuser = 'user#id'..msg.action.user.id
					chat_del_user(antibotchat, antibotuser, ok_cb, true)
					return 'افزودن ربات ممنوع است'
				end
			end
		end
	end
end

return {
	description = "Anti Bot", 
	--usagehtm = '<tr><td align="center">(Anti Robot)</td><td align="right">این افزونه باعث میشود کسی نتواند ربات به گروه اضافه کند ولی مدیران جایز اند</td></tr>',
	patterns = {
		"^[Ll](ock bots)$",
		"^[Ll](ock bots)$",
		"^!!tgservice (chat_add_user)$",
	}, 
	run = run,
}
