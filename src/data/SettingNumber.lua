local SettingNumber = require("src.data.Setting"):extend("SettingNumber", ...)

SettingNumber.value = 0
SettingNumber.min = 0
SettingNumber.max = 1

function SettingNumber:constructor(name, value, min, max, mult, desc)
	self.name = name
	self.value = value
	self.min = min
	self.max = max
	self.mult = mult
	self.desc = desc
end

function SettingNumber:switch(i)
	self.value = math.max(self.min, math.min(self.max, self.value+(i*self.mult)))
	return true
end

-- return string for error
function SettingNumber:set(i)
	if type(i) ~= "number" then
		return "Can't set number setting to "..type(i)
	end

	self.value = i
end

return SettingNumber