local Setting = Class:extend("Setting", ...)

Setting.name = "Blank"
Setting.value = false
Setting.desc = ""

function Setting:constructor(name, value, desc)
	self.name = name
	self.value = value
	self.desc = desc
end

function Setting:get()
	return self.value
end

-- return string for error
function Setting:switch(i)
	self.value = not self.value
	return true
end

-- return string for error
function Setting:set(i)
	if type(i) ~= "boolean" then
		return "Can't set bool setting to "..type(i)
	end

	self.value = i
end

return Setting