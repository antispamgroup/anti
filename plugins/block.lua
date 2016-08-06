local function block_user_callback(cb_extra, success, result)
	local user = 'user#id'..result.id
	if success == 0 then
		return "نمی تونی بلاکش کنی 😂"
	end
	block_user(user, cb_ok, false)
end

local function unblock_user_callback(cb_extra, success, result)
	local user = 'user#id'..result.id
	unblock_user(user, cb_ok, false)
end

local function run(msg, matches)
	if matches[1] == '+' then
		local user = 'user#id'..matches[2]
		block_user(user, callback, false)
		return "بلاک شد😂"
	else
		local user = 'user#id'..matches[2]
		unblock_user(user, callback, false)
		return "بلاک شد😂"
	end
end

return {
	description = "User Blocker", 
	usagehtm = '<tr><td align="center">block + آی دی</td><td align="right">با این دستور میتوانید افراد را بلاک کنید</td></tr>'
	..'<tr><td align="center">block - آی دی</td><td align="right">با این دستور میتوانید افراد را از بلاک خارج کنید</td></tr>',
	usage = {
		admin = {
			"block (+|-) (id) : بلاک افراد",
		},
	},
	patterns = {
		"^[Bb]lock ([-+]) (%d+)$",
		"^(بلاک) ([-+]) (%d+)$",
	}, 
	run = run,
	privileged = true
}
