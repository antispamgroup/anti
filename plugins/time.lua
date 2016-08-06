local api_key  = nil
local base_api = "https://maps.googleapis.com/maps/api"
local dateFormat = "%A %d %B \nساعت: %H:%M:%S"

local function utctime()
	return os.time(os.date("!*t"))
end

function get_latlong(area)
	local api = base_api.."/geocode/json?"
	local parameters = "address="..(URL.escape(area) or "")
	if api_key ~= nil then
		parameters = parameters.."&key="..api_key
	end
	local res, code = https.request(api..parameters)
	if code ~=200 then return nil  end
		local data = json:decode(res) 
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		lat  = data.results[1].geometry.location.lat
		lng  = data.results[1].geometry.location.lng
		acc  = data.results[1].geometry.location_type
		types= data.results[1].types
	return lat,lng,acc,types
	end
end

local function get_time(lat,lng)
	local api  = base_api .. "/timezone/json?"
	local timestamp = utctime()
	local parameters = "location=" ..
		URL.escape(lat) .. "," ..
		URL.escape(lng) .. 
		"&timestamp="..URL.escape(timestamp)
	if api_key ~=nil then
		parameters = parameters .. "&key="..api_key
	end
	local res,code = https.request(api..parameters)
	if code ~= 200 then return nil end
		local data = json:decode(res)
	if (data.status == "ZERO_RESULTS") then
		return nil
	end
	if (data.status == "OK") then
		local localTime = timestamp + data.rawOffset + data.dstOffset
		return localTime, data.timeZoneId
	end
	return localTime
end

local function getformattedLocalTime(area)
	if area == nil then
		return "در اين منطقه زمان وجود ندارد"
	end
	lat,lng,acc = get_latlong(area)
	if lat == nil and lng == nil then
		return 'در اين منطقه زمان وجود ندارد'
	end
	local localTime, timeZoneId = get_time(lat,lng)
	return "منطقه: "..timeZoneId.."\nتاريخ: ".. os.date(dateFormat,localTime) 
end

local function run(msg, matches)
	return getformattedLocalTime(matches[1])
end

return {
	description = "Get Time Give by Local Name", 
	usagehtm = '<tr><td align="center">time نام شهر یا کشور</td><td align="right">با این قابلیت میتوانید تاریخ و ساعت پایتخت هر کشور را بیابید. دقت کنید که اگر نام کشور وارد شود، ربات به صورت هوشمند پایتخت آن را یافته و ارائه میکند و اگر شهر دیگر از یک کشور را نیز وارد کنید به همین ترتیب است. مثلا اگر وارد کنید <br>time shiraz<br> ربات تشخیص میدهد که شیراز در ایران است و بعد زمان پایتخت ایران را در اختیارتان قرار میدهد. نام کشور یا شهر را به زبان فارسی و انگلیسی میتوانید وارد کنید</td></tr>',
	usage = "time (country) : ساعت کشورها",
	patterns = {"^[Tt]ime (.*)$"}, 
	run = run
}
