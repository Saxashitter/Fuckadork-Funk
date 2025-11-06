local Shadow = Sprite:extend("Shadow", ...)

function Shadow:constructor(char, light)
	Shadow.super.constructor(self, char:getX(), char:getY())
	self.char = char
	self.light = light
	self:setTint(Color.BLACK)
	self.alpha = 0.4
end

function Shadow:draw()
	if not self.char or not self.light then return end

	local cx, cy = self.char:getX(), self.char:getY()
	local lx, ly = self.light:getX(), self.light:getY()

	-- direction from light to char
	local dx = cx - lx
	local dy = cy - ly

	-- parameters you can tweak
	local maxHeight = 300    -- distance at which shadow is flattest
	local minScale = 0    -- minimum y scale of the shadow
	local maxScale = 0.25     -- maximum y scale (when light is very low)

	-- map dy into a 0–1 range and invert it
	local t = dy / maxHeight
	local flattenFactor = maxScale - (maxScale - minScale) * t

	-- slight horizontal skew depending on light offset
	local skewAmount = dx * 0.0025

	self:setFrames(self.char:getFrames())
	self:setFrame(self.char:getFrame())
	self.origin = self.char.origin
	self.flipX = self.char.flipX

	self.scale = Point:new(
		self.char.scale.x,
		self.char.scale.y * flattenFactor
	)
	self.skew = Point:new(-skewAmount, self.char.skew.y)

	self:setX(cx)
	self:setY(cy)

	Shadow.super.draw(self)
end


return Shadow
