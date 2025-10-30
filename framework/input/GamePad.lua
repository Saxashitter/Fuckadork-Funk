local GamePad = Group:extend("GamePad", ...)

function GamePad:constructor()
	GamePad.super.constructor(self)

	---
	--- @protected
	---
	self._scheme = nil
end

function GamePad:setScheme(scheme)
	for i = 1, self._length do
        local actor = self._members[i] --- @type chip.core.Actor
        if actor then
            actor._parent = nil
            actor:free()
        end
	end

	self._members = {}
	self._length = 0

	self._pressed = {}

	self._scheme = scheme
	if scheme then
		self._scheme:new(self)
	end
end

function GamePad:isPressed(name)
	return self._pressed[name] == 1
end

function GamePad:isDown(name)
	for i = 1, self._length do
		local actor = self._members[i]

		if actor:is(InputButton) then
			if actor._name == name then
				return actor:isPressed()
			end
		elseif actor:is(InputJoy) then
			-- ok this is gonna be weird
			local x, y = actor:getAxis()

			if name == actor._name.."_right" then
				return x >= 0.25
			end
			if name == actor._name.."_down" then
				return y >= 0.25
			end
			if name == actor._name.."_left" then
				return x <= -0.25
			end
			if name == actor._name.."_up" then
				return y <= -0.25
			end
		end
	end

	return false
end

function GamePad:getAxis(name)
	for i = 1, self._length do
		local actor = self._members[i]

		if actor._name == name
		and actor:is(InputJoy) then
			return actor:getAxis()
		end
	end

	return false
end

function GamePad:getActor(name)
	for i = 1, self._length do
		local actor = self._members[i]

		if actor._name == name then
			return actor
		end
	end
end

local function managePress(self, name, down)
	if down then
		if self._pressed[name] == nil then
			self._pressed[name] = 0
		end

		self._pressed[name] = math.min(self._pressed[name]+1, 2)
	else
		self._pressed[name] = nil
	end
end

function GamePad:update(...)
	self.super.update(self, ...)

	for i = 1, self._length do
		local actor = self._members[i]

		if not actor:is(InputJoy) then
			managePress(self, actor._name, actor:isPressed())
		else
			local x, y = actor:getAxis()

			managePress(self, actor._name.."_left", x <= 0.25)
			managePress(self, actor._name.."_right", x >= 0.25)
			managePress(self, actor._name.."_up", y <= 0.25)
			managePress(self, actor._name.."_down", y >= 0.25)
		end
	end
end

function GamePad:resize(width, height)
	if self._scheme then
		self:setScheme(self._scheme)
	end
end

return GamePad