do
local function run(msg, matches)
local data = load_data(_config.moderation.data)
if not is_chat_msg(msg) then
	return "اين گروه نيست"
else
if data[tostring(msg.to.id)] then
	local settings = data[tostring(msg.to.id)]['settings']
	if #matches == 2 then
		
		if matches[1] == 'ewlink' then
			local function link_callback (extra , success, result)
				local receiver = extra.receiver
				if success == 0 then
					return "چه گوهی می خوری!!!!"
				end
				data[tostring(msg.to.id)]['settings']['set_link'] = result
				save_data(_config.moderation.data, data)
				local group_link = data[tostring(msg.to.id)]['settings']['set_link']
				send_large_msg(receiver, "لینک جدیدت ساخته شد اگه بات شمارتو داشته یا ریپورت نپاشه میاد پی ویت لینک وگرنه هیچی نمیشه ")
				send_large_msg('user#id'..msg.from.id, "  گفتی لینک جدید بسازم؟؟  خو ساختم :\n______________________________\n"..group_link)
			end
			local receiver = 'chat#id'..msg.to.id
			return export_chat_link(receiver, link_callback, {receiver = receiver})

		elseif matches[1] == 'ink' then
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "اول لينک را بسازيد"
			end
			send_large_msg('chat#id'..msg.to.id, "لينک در چت خصوصي ارسال شد")
			send_large_msg('user#id'..msg.from.id, "لينک گروه:\n______________________________\n"..group_link)
			
		elseif matches[1] == '&link pv' and is_admin(msg) then
			local group_link = data[tostring(matches[2])]['settings']['set_link']
			if not group_link then
				return "گروه مورد نظر لینک ندارد"
			end
			send_large_msg('user#id'..msg.from.id, "لينک ورود به گروه:\n______________________________\n"..group_link)
			return 'لینک گروه مورد نظر در چت خصوصی ارسال شد'
			
		elseif matches[1] == '&link' and is_admin(msg) then
			local group_link = data[tostring(matches[2])]['settings']['set_link']
			if not group_link then
				return "گروه مورد نظر لینک ندارد"
			end
			return "لينک ورود به گروه:\n______________________________\n"..group_link
		end
		
	else
		
		if matches[1] == 'ewlink' then
			local function link_callback (extra , success, result)
				local receiver = extra.receiver
				if success == 0 then
					return "خطا در ساختن لينک"
				end
				data[tostring(msg.to.id)]['settings']['set_link'] = result
				save_data(_config.moderation.data, data)
				local group_link = data[tostring(msg.to.id)]['settings']['set_link']
				send_large_msg(receiver, "لينک جديد ساخته شد:\n______________________________\n"..group_link)
			end
			local receiver = 'chat#id'..msg.to.id
			return export_chat_link(receiver, link_callback, {receiver = receiver})
		
		elseif matches[1] == 'link' then
			local function link_callback (extra , success, result)
				local receiver = extra.receiver
				if success == 0 then
					return "خطا در بستن لينک"
				end
				data[tostring(msg.to.id)]['settings']['set_link'] = result
				save_data(_config.moderation.data, data)
				send_large_msg(receiver, "لينک بسته شد")
			end
			local receiver = 'chat#id'..msg.to.id
			return export_chat_link(receiver, link_callback, {receiver = receiver})

		elseif matches[1] == 'ink' then
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "اول لينک را بسازيد"
			end
			return "لينک ورود به گروه:\n______________________________\n"..group_link
		end
	end
end
end
end
 
return {
  description = "Link Manager System",
  usagehtm = '<tr><td align="center">link</td><td align="right">مشاهده ی لینک گروه</td></tr>'
  ..'<tr><td align="center">link pv</td><td align="right">دریافت لینک گروه در پی وی</td></tr>'
  ..'<tr><td align="center">newlink</td><td align="right">ساخت لینک جدید برای گروه</td></tr>'
  ..'<tr><td align="center">newlink pv</td><td align="right">ساخت لینک جدید برای گروه و دریافت آن در پی وی</td></tr>'
  ..'<tr><td align="center">clink</td><td align="right">بستن و منقضی کردن لینک گروه</td></tr>',
  usage = {
  moderator = {
	"link : مشاهده لينک",
	"link pv : ارسال لينک در خصوصي",
	"newlink : ساخت لينک جديد",
	"newlink pv : لينک جديد در خصوصي",
	"clink : بستن لينک",
    },
	},
  patterns = {
    "^[Nn](ewlink)$",
    "^[Ll](ink)$",
	"^[Nn](ewlink) (pv)$",
    "^[Ll](ink) (pv)$",
	"^[Cc](link)$",
	"^(&link pv) (%d+)$",
	"^(&link) (%d+)$",
  },
  run = run,
  moderated = true
}
end
