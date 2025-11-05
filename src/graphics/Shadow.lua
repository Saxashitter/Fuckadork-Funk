local Shadow = Sprite:extend("Shadow", ...)

-- acts as a shadow to sprites, allows to attach one light source cus im a fucking dumbass
function Shadow:constructor(char)
	Shadow.super.constructor(self, x, y)
	self.char = char
	self:setTint(Color.BLACK)
end

function Shadow:draw()
	if not self.char then return end

	self.origin = Point:new(self.char.origin.x, self.char.origin.y)
	self.scale = Point:new(self.char.scale.x, self.char.scale.y)
	self.skew = Point:new(self.char.skew.x, self.char.skew.y)
	self.flipX = self.char.flipX

	self:setFrames(self.char:getFrames())
	self:setFrame(self.char:getFrame())
	self:setX(self.char:getX())
	self:setY(self.char:getY())

	-- now actually make the shadow
	self.skew.x = 1 + (self.skew.x * 0.5)
	self.scale.y = 0.25 * self.scale.y

	Shadow.super.draw(self)
end
return Shadow