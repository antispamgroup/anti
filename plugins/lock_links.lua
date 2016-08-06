local function run(msg, matches)
 local data = load_data(_config.moderation.data)
 local lock_link = data[tostring(msg.to.id)]['settings']['lock_link']
 
 if matches[1]:lower() == "+" and matches[2] == "link" and is_momod(msg) then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'yes'
  save_data(_config.moderation.data, data)
  return 'ارسال لینک غیر مجاز'
 elseif matches[1]:lower() == "-" and matches[2] == "link" and is_momod(msg) then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'no'
  save_data(_config.moderation.data, data)
  return 'ارسال لینک مجاز'
 end
 
 if not lock_link then
  data[tostring(msg.to.id)]['settings']['lock_link'] = 'yes'
  save_data(_config.moderation.data, data)
  if not is_chat_msg(msg) then
   return nil
  end
  if is_sudo(msg) then
   return nil
  elseif is_admin(msg) then
   return nil
  elseif is_momod(msg) then
   return nil
  else
   send_large_msg('chat#id'..msg.to.id, "تبلیغ ممنوع")
   chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
  end
 elseif lock_link == 'yes' then
  if not is_chat_msg(msg) then
   return nil
  end
  if is_sudo(msg) then
   return nil
  elseif is_admin(msg) then
   return nil
  elseif is_momod(msg) then
   return nil
  else
   send_large_msg('chat#id'..msg.to.id, "تبلیغ ممنوع")
   chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
  end
 end
end

return {
 description = "Anti Link",
 --usagehtm = '<tr><td align="center">(Anti Link)</td><td align="right">این افزونه جهت کیک کردن افرادی است که در گروه تبلیغ میکنند. حساسیت این افزونه فقط به لینک گروه ها و کانالها میباشد. مدیران گروه مجاز به ارسال هرگونه لینک میباشند</td></tr>',
 patterns = {
  "[Ll][Oo][Cc][Kk][ ][Ll][Ii][Nn][Kk][Ss]",
  "^[Ll](ock links)$",
  "^[Ll](ock links)$",
 },
 run = run,
}
