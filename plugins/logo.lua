local function run(msg, matches)
	if matches[1]:lower() == "logo" then
		logo = "http://logo.clearbit.com/"..matches[2].."?size=500"
	else
		logo = "http://logo.clearbit.com/"..matches[2].."?size=500&greyscale=true"
	end
	local file_path = download_to_file(logo, "logo.png")
	if not file_path then
		return "خطا در بارگذاری لوگو"
	else
		print("File path: "..file_path)
		return _send_photo("chat#id"..msg.to.id, file_path, ok_cb, false)
	end
end

return {
	description = "Websites Logo Grabber",
	usagehtm = '<tr><td align="center">logo آدرس سایت</td><td align="right">آدرس سایت را ساده وارد کنید، درصورت وجود لوگو برای سایت آن را دریافت خواهید کرد. آدرس به صورت زیر وارد شود:<br>shayan-soft.ir</td></tr>'
	..'<tr><td align="center">logo> آدرس سایت</td><td align="right">دریافت لوگوی وبسایت به صورت سیاه سفید</td></tr>',
	usage = {
		"logo (website) : دریافت لوگوی وبسایت",
		"logo> (website) : دریافت لوگوی سیاه سفید",
		},
	patterns = {
		"^([Ll]ogo>) (.*)",
		"^([Ll]ogo) (.*)",
		},
	run = run
}
