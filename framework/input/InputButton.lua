local InputActor = require("framework.input.InputActor")
local InputButton = InputActor:extend("InputButton")

function InputButton:constructor(x, y, radius, name)
	InputButton.super.constructor(self, x, y, radius, name)

	---
	--- @protected
	---
	self._color = Color.RED
	self._name = name
end

function InputButton:setColor(color)
	self._color = color
end

function InputButton:draw()
	local color = {love.graphics.getColor()}
	love.graphics.setColor(self._color.r, self._color.g, self._color.b, self._color.a)
		love.graphics.circle("fill",
			self:getX(),
			self:getY(),
			not self:isPressed() and self:getRadius() or self:getRadius()/2)
	love.graphics.setColor(color)
end

function InputButton:free()
	InputButton.super.free(self)
end

return InputButton