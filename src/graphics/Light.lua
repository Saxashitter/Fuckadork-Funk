local Light = Actor2D:extend("Light", ...)

-- tbh idfk how light works i just wanna cast semi accurate shadows

function Light:constructor(x, y, strength)
	Light.super.constructor(self, x, y)
	self.strength = strength or 0
end

return Light