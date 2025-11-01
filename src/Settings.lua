local Settings = {
	addOrder = {}
}

local Setting = require("src.data.Setting")
local SettingNumber = require("src.data.SettingNumber")

function Settings.new(class)
	Settings[class.name] = class
	table.insert(Settings.addOrder, class)
end

function Settings.get(name)
	if not Settings[name] then
		return
	end

	return Settings[name]:get()
end

function Settings.set(name, value)
	if not Settings[name] then
		return
	end

	Settings[name]:set(value)
end

function Settings.switch(name, value)
	if not Settings[name] then
		return
	end

	Settings[name]:switch(value)
end

Settings.new(Setting:new(
	"Downscroll",
	true,
	"Changes the direction of scroll to be down instead of up."
))
Settings.new(Setting:new(
	"Middlescroll",
	true,
	"Pushes notes to the middle instead of which side you're on. As a bonus, opponent notes are scaled down and pushed more to the side."
))
Settings.new(SettingNumber:new(
	"Scroll Multiplier",
	1,
	0.1,
	10,
	0.1,
	"The higher it is, the faster your scroll speed is. Vice versa for lower."
))
Settings.new(SettingNumber:new(
	"Strumline Background",
	0,
	0,
	100,
	1,
	"Adds a black background behind your strumline to make the chart more readable. (0-100)"
))

return Settings