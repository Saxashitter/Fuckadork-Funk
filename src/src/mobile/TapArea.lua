local TapArea = Actor2D:extend("TapArea", ...)

function TapArea:constructor(x, y, width, height)
	self.super.constructor(self, x, y)

	self._width = width or 0
	self._height = height or 0

	self._pressed = false
	self._touch = nil

	self._callback = nil
end

function TapArea:setWidth(width)
	self._width = width or 0
end

function TapArea:setHeight(height)
	self._height = height or 0
end

function TapArea:getWidth()
	return self._width
end

function TapArea:getHeight()
	return self._height
end

function TapArea:isPressed()
	return self._pressed
end

function TapArea:setCallback(func)
	self._callback = func
end

function TapArea:getCallback()
	return self._callback
end

function TapArea:input(event)
	self.super.input(self, event)

	if not event:is(InputEventTouch) then
		return
	end

	if event:isPressed()
	and not self:isPressed()
	and self:isInside(event:getX(), event:getY()) then
		self._pressed = true
		self._touch = event:getID()

		if self._callback then
			self:_callback(true)
		end

		return
	end 

	if not event:isPressed()
	and self:isPressed()
	and self._touch == event:getID() then
		self._pressed = false
		self._touch = nil

		if self._callback then
			self:_callback(false)
		end

		return
	end
end

function TapArea:isInside(x, y)
	return x >= self._x
	and y >= self._y
	and x <= self._x + self._width
	and y <= self._y + self._height
end

return TapArea