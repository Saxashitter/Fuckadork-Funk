local UIButton = Sprite:extend("UIButton", ...)

function UIButton:constructor(x, y, width, height, title)
	UIButton.super.constructor(self, x, y)

	self.title = title or ""
	self.pressed = false
	self:makeSolid(width, height, Color.WHITE)

	self.text = Text:new(x, y, width, self.title, height)
	self.text:setColor(Color.BLACK)
end

function UIButton:setCallback(func)
	self._callback = func
end

function UIButton:onPress()
	if self._callback then
		self._callback(self)
	end
end
function UIButton:onRelease() end

function UIButton:input(event)
	if not event:is(InputEventTouch) then
		return
	end

	if not event:isPressed() then
		if self.pressed then
			self.pressed = false
			self:onRelease()
		end

		return
	end

	-- check for collision
	if event:getX() < self:getX() then return end
	if event:getY() < self:getY() then return end
	if event:getX() > self:getX() + self:getWidth() then return end
	if event:getY() > self:getY() + self:getHeight() then return end

	self.pressed = true
	self:onPress()
end

function UIButton:draw()
	UIButton.super.draw(self)

	self.text:draw()
end

return UIButton