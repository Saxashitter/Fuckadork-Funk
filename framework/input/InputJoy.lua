local InputActor = require("framework.input.InputActor")
local InputJoy = InputActor:extend("InputJoy")

function InputJoy:constructor(x, y, radius, name)
	InputJoy.super.constructor(self, x, y, radius, name)

	---
	--- @protected
	---
	self._color = Color.RED
	self._name = name
end

function InputJoy:setColor(color)
	self._color = color
end

function InputJoy:getAxis()
	if not self:isPressed() then
		return 0, 0
	end

	local id = self._id
	local _, rx, ry = shove.screenToViewport(love.touch.getPosition(id))

	-- snap to edge of radius
	local distance = (Point:new(self:getX(), self:getY()) - Point:new(rx, ry)):length()
	if distance > self:getRadius() then
		local angle = math.atan2(ry-self:getY(), rx-self:getX())

		rx = math.cos(angle)
		ry = math.sin(angle)
		return rx, ry
	end

	local x, y = (rx-self:getX())/self:getRadius(), (ry-self:getY())/self:getRadius()
	return x, y
end

function InputJoy:update()
end

function InputJoy:draw()
	local color = {love.graphics.getColor()}

	love.graphics.setColor(0.25, 0.25, 0.25, 1)
		love.graphics.circle("fill", self:getX(), self:getY(), self:getRadius())

	love.graphics.setColor(self._color.r, self._color.g, self._color.b, self._color.a)
		local axisX, axisY = self:getAxis()

		love.graphics.circle("fill",
			self:getX() + axisX*self:getRadius(),
			self:getY() + axisY*self:getRadius(),
			self:getRadius()/2)

	love.graphics.setColor(color)
end

function InputJoy:free()
	InputButton.super.free(self)
end

return InputJoy