do
local function parsed_url(link)
local parsed_link = URL.parse(link)
local parsed_path = URL.parse_path(parsed_link.path)
return parsed_path[2]
end

local function run(msg, matches)
local bot_id = our_id
if matches[1] == 'dd' then
local hash = parsed_url(matches[1])
join = import_chat_link(hash, ok_cb, false)
elseif matches[1] == 'eeekh' then
send_large_msg("chat#id"..msg.to.id, 'يا ابرفض', ok_cb, false)
chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
end
end

return{
	description = "Add and Remove Robot in Group",
	--usagehtm = '<tr><td align="center">add لینک</td><td align="right">افزودن ربات به یک گروه</td></tr>',
	--usage = {
		--admin = {
			--"add (link) : افزودن ربات به گروه",
			-- },
			-- },
			patterns = {
				"^[Aa]ddbot (.*)$",
				"^[Pp](eeekh)$",
			},
			run = run,
			privileged = true
}
end
