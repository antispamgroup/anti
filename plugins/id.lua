local function run(msg,matches)
if matches[1] == "id" and is_sudo(msg) then
local text ="👑Name :"..msg.from.first_name.."\n🍀Group Name :"..msg.to.print_name.."\n❤️Your ID:"..msg.from.id.."\n♥️Group ID:"..nsg.to.id.."\nYour Username :"..msg.from.username.."\n★Your Phone :"..msg.from.phone.."\n💻Your link : https://telegram.me/"..msg.from.username
local ch ="channel : @kaiser900"
local cr ="creator : @programer_iran"
return text.."\n"..ch.."\n"..cr
else
return "You Are Not sudo"
end
end

return {
patterns = {
"^(ایدی)$"
},
run = run
}
