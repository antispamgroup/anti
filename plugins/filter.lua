local function save_filter(msg, name, value)
	local hash = nil
	if msg.to.type == 'chat' then
		hash = 'chat:'..msg.to.id..':filters'
	end
	if msg.to.type == 'user' then
		return 'فقط در گروه'
	end
	if hash then
		redis:hset(hash, name, value)
		return "انجام شد"
	end
end

local function get_filter_hash(msg)
	if msg.to.type == 'chat' then
		return 'chat:'..msg.to.id..':filters'
	end
end 

local function list_filter(msg)
	if msg.to.type == 'user' then
		return 'فقط در گروه'
	end
	local hash = get_filter_hash(msg)
	if hash then
		local names = redis:hkeys(hash)
		local ekhtar = ""
		local sikout = ""
		k = 0
		v = 0
		for i=1, #names do
			local value = redis:hget(hash, names[i])
			if value == 'msg' then
				k = k+1
				ekhtar = ekhtar..k.."- "..names[i].."\n"
			elseif value == 'kick' then
				v = v+1
				sikout = sikout..v.."- "..names[i].."\n"
			end
		end
		return "لیست کلمات شامل اخطار:\n______________________________\n"..ekhtar.."\n\nلیست کلمات ممنوع:\n______________________________\n"..sikout
	end
end

local function pre_process(msg)
	data = load_data(_config.moderation.data)
	if not data[tostring(msg.to.id)] then
		chat_del_user('chat#id'..msg.to.id, 'user#id'..our_id, callback, false)
    end
	if is_sudo(msg) or is_admin(msg) or is_momod(msg) or tonumber(msg.from.id) == tonumber(our_id) then
		return
	end
	hash = get_filter_hash(msg)
	if hash then
		local names = redis:hkeys(hash)
		for i=1, #names do
			if msg.text:match(names[i]) then
				value = redis:hget(hash, names[i])
				if value == 'msg' then
					return send_large_msg('chat#id'..msg.to.id, 'کلمه ی "'..names[i]..'" ممنوع است، تکرار نکنید')
				elseif value == 'kick' then
					send_large_msg('chat#id'..msg.to.id, 'به علت بکار بردن کلمه ی "'..names[i]..'" از ادامه ی گفتوگو منع میشوید')
					return chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
				end
			end
		end
	end
end

local function run(msg, matches)
	if matches[1]:lower() == "filterlist" then
		return list_filter(msg)
	elseif matches[1]:lower() == "filter" and matches[2] == ">" then
		if not is_momod(msg) then
			return "شما مدير نيستيد"
		else
			return save_filter(msg, matches[3]:lower(), 'msg')
		end
	elseif matches[1]:lower() == "filter" and matches[2] == "+" then
		if not is_momod(msg) then
			return "شما مدير نيستيد"
		else
			return save_filter(msg, matches[3]:lower(), 'kick')
		end
	elseif matches[1]:lower() == "filter" and matches[2] == "-" then
		if not is_momod(msg) then
			return "شما مدير نيستيد"
		else
			return save_filter(msg, matches[3]:lower(), 'none')
		end
	else
		pre_process(msg)
	end
end

return {
	description = "Set and Get Variables", 
	usagehtm = '<tr><td align="center">filter > کلمه</td><td align="right">این دستور یک کلمه را ممنوع میکند و اگر توسط کاربری این کلمه استفاده شود، به او تذکر داده خواهد شد</td></tr>'
	..'<tr><td align="center">filter + کلمه</td><td align="right">این دستور کلمه ای را فیلتر میکند به طوری که اگر توسط کاربری استفاده شود، ایشان کیک میگردند</td></tr>'
	..'<tr><td align="center">filter - کلمه</td><td align="right">کلمه ای را از ممنوعیت یا فیلترینگ خارج میکند</td></tr>'
	..'<tr><td align="center">filterlist</td><td align="right">لیست کلمات فیلتر شده</td></tr>',
	usage = {
		user = {
			"filterlist : لیست فیلتر شده ها",
		},
		moderator = {
			"filter > (word) : اخطار کردن لغت",
			"filter + (word) : ممنوع کردن لغت",
			"filter - (word) : حذف از فیلتر",
		},
	},
	patterns = {
		"^([Ff]ilter) (.+) (.*)$",
		"^([Ff]ilterlist)$",
		"(.*)"
	},
	run = run,
} 
