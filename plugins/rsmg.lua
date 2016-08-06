local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, '"'..#result..'" پیام های  که شما گفتید منفجر شدند ok_cb, false)
  else
    send_msg(extra.chatid, 'تعداد پیام مورد نظر شما منفجر شدند ok_cb, false)
  end
end
local function run(msg, matches)
  if matches[1] == 'clean' and is_owner(msg) then
    if msg.to.type == 'channel' then
      if tonumber(matches[2]) > 10000 or tonumber(matches[2]) < 1 then
        return "لطفا انقد گشاد نباش یکی رو من پاک نمی کنم"
      end
      get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
    else
      return "فقط در سوپرگروه ممکن است"
    end
  else
    return "چه گوهی می خوری!!!!"
  end
end

return {
    patterns = {
        '^[!/#](rsmg) (%d*)$'
        '^(حذف) (%d*)$'
    },
    run = run
}
