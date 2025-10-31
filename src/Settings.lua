local Settings = {}

function Settings.makeSetting(name, value, description)
	Settings[name] = {
		value = value,
		default = value,
		description = description or ""
	}
end

function Settings.getValue(name)
	if not Settings[name] then
		return
	end

	return Settings[name].value
end

function Settings.setValue(name, value)
	if not Settings[name] then
		return
	end

	if type(value) ~= type(Settings[name].default) then
		error("Attempt to set "..name.." to a different type.")
		return
	end

	Settings[name].value = value
end

Settings.makeSetting(
	"Downscroll",
	true,
	"Changes the direction of scroll to be down instead of up."
)
Settings.makeSetting(
	"Middlescroll",
	true,
	"Pushes notes to the middle instead of which side you're on. As a bonus, opponent notes are scaled down and pushed to the other side."
)
Settings.makeSetting(
	"Scroll Multiplier",
	1,
	"The higher it is, the faster your songs are. Vice versa for lower."
)
Settings.makeSetting(
	"Strumline Background",
	50,
	"Adds a black background behind your strumline to make the chart more readable. (0-100)"
)

return Settings