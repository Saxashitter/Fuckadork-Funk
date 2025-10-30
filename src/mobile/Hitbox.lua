local Hitbox = Actor2D:extend("Hitbox", ...)

function Hitbox:constructor(x, y, width, height, keys)
	self.super.constructor(self, x, y)

	self._width = width or 0
	self._height = height or 0

	self._areas = {}

	if type(keys) == "number" then
		local keyTable = {}

		for i = 0, keys-1 do
			table.insert(keyTable, {
				x = (1/keys)*i,
				y = 0,
				width = 1/keys,
				height = 1
			})
		end

		keys = keyTable
	end

	self._keys = keys
	self._callback = nil

	for i = 1, #keys do
		local area = TapArea:new(0,0,1,1)

		area:setCallback(function(key, pressed)
			if not self:getCallback() then return end

			self._callback(self, i, pressed, key)
		end)

		table.insert(self._areas, area)
	end

	self:positionTapAreas()
end

function Hitbox:setCallback(func)
	self._callback = func
end

function Hitbox:getCallback()
	return self._callback
end

function Hitbox:positionTapAreas()
	for i = 1, #self._keys do
		local area = self._areas[i]
		local key = self._keys[i]

		area:setX(self._x + (self._width*key.x))
		area:setY(self._y + (self._height*key.y))
		area:setWidth(self._width * key.width)
		area:setHeight(self._height * key.height)
	end
end

function Hitbox:setX(x)
	self._x = x or 0
	self:positionTapAreas()
end

function Hitbox:setY(x)
	self._y = y or 0
	self:positionTapAreas()
end

function Hitbox:setWidth(width)
	self._width = width or 0
	self:positionTapAreas()
end

function Hitbox:setHeight(height)
	self._height = height or 0
	self:positionTapAreas()
end

function Hitbox:getWidth()
	return self._width
end

function Hitbox:getHeight()
	return self._height
end

function Hitbox:input(event)
	if not event:is(InputEventTouch) then
		return
	end

	for _, area in ipairs(self._areas) do
		area:input(event)
	end
end

return Hitbox