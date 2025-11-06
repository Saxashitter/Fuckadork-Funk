local InputActor = Actor2D:extend("InputActor")

function InputActor:constructor(x, y, radius)
	InputActor.super.constructor(self, x, y)

	---
	--- @protected
	---
	self._radius = radius or 1.0

	---
	--- @protected
	---
	self._id = nil
end

function InputActor:setRadius(radius)
	self._radius = radius or self._radius
end

function InputActor:getRadius()
	return self._radius
end

function InputActor:input(event)
	if not event:is(InputEventTouch) then
		return
	end

	local x = event:getX()
	local y = event:getY()

	if event:isPressed() then
		if not self:isPressed() then
			local dist = (Point:new(self:getX(), self:getY()) - Point:new(x, y)):length()
	
			if dist < self:getRadius() then
				self._id = event:getID()
				self:onPressCallback(self._id, x, y)
			end
		end

		return
	end

	if self._id == event:getID() then
		self._id = nil
		self:onReleaseCallback(event:getID(), x, y)
	end
end

function InputActor:onPressCallback(id, x, y)
end

function InputActor:onReleaseCallback(id, x, y)
end

function InputActor:isPressed()
	return self._id ~= nil
end

return InputActor