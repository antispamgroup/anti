local function run(msg, matches)
	local chat = 'chat#id'..matches[1]
	local user = 'user#id'..matches[2]
	chat_del_user(chat, user, ok_cb, true)
	return 'فرد مورد نظر از گروه مورد نظر حذف شد'
end

return {
	description = "Add and Remove Robot in Group", 
	usagehtm = '<tr><td align="center">add لینک</td><td align="right">افزودن ربات به یک گروه</td></tr>',
	usage = {
		admin = {
			"&join (gp id) : ورود به گروه",
			"&link (gp id) : لینک گروه",
			"&link pv (gp id) : لینک در خصوصی",
			"&kick (gp id) (user id) : کیک در گروه",
			"&echo (gp id) (pm) : ارسال پیام در گروه",
			"&id all (gp id) : لیست اعضا",
			"&id all> (gp id) : تکست لیست اعضا",
			"&/id all> (gp id) : اچ تی ام ال لیست",
			"&stat gp (gp id) : کنتور اعضا",
			"&stat gp> (gp id) : تکست کنتور اعضا",
			"&/stat gp> (gp id) : اچ تی ام ال کنتور",
			},
		},
	patterns = {
		"^&kick (%d+)$",
	}, 
	run = run,
	privileged = true
}
