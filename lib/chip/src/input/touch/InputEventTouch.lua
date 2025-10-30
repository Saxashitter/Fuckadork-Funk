--[[
    chip.lua: a simple 2D game framework built off of Love2D
    Copyright (C) 2024  swordcube

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

---
--- @class chip.input.mouse.InputEventMouse : chip.input.InputEvent
--- 
--- A class which represents a mouse input event.
---
local InputEventTouch = InputEvent:extend("InputEventTouch", ...)

---
--- @param  x  number
--- @param  y  number
---
function InputEventTouch:constructor(id, x, y, pressed)
    InputEventTouch.super.constructor(self)

	self._id = id
	self._pressed = pressed
    self.__, self._x, self._y = shove.screenToViewport(x, y)
    self.__ = nil
end

function InputEventTouch:getX()
    return self._x
end

function InputEventTouch:getY()
    return self._y
end

function InputEventTouch:getID()
	return self._id
end

function InputEventTouch:isPressed()
	return self._pressed
end

return InputEventTouch