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
--- @class chip.math.Velocity
---
local Velocity = {}

---
--- @param  vx  number  Input X velocity
--- @param  vy  number  Input Y velocity
--- @param  ax  number  Input X acceleration
--- @param  ay  number  Input Y acceleration
--- @param  dx  number  Input X deceleration
--- @param  dy  number  Input Y deceleration
--- @param  dt  number  Delta time (in seconds, Engine.deltaTime is used if not provided)
---
--- @return number x
--- @return number y
---
function Velocity.computeVelocity(vx, vy, ax, ay, dx, dy, dt)
	local x, y = vx + (ax * dt), vy + (ay * dt)

	if x > 0 then
		x = math.max(0, x - (dx * dt))
	end
	if x < 0 then
		x = math.min(0, x + (dx * dt))
	end
	if y > 0 then
		y = math.max(0, y - (dy * dt))
	end
	if y < 0 then
		y = math.min(0, y + (dy * dt))
	end

	return x, y
end

---
--- @param  vx  number  Input X velocity
--- @param  vy  number  Input Y velocity
--- @param  ax  number  Input X acceleration
--- @param  ay  number  Input Y acceleration
--- @param  dx  number  Input X deceleration
--- @param  dy  number  Input Y deceleration
--- @param  dt  number  Delta time (in seconds, Engine.deltaTime is used if not provided)
---
--- @return number x
--- @return number y
---
function Velocity.getVelocityDelta(vx, vy, ax, ay, dx, dy, dt)
    local rvx, rvy = Velocity.computeVelocity(vx, vy, ax, ay, dx, dy, dt)
    return (rvx - vx) * 0.5, (rvy - vy) * 0.5
end

return Velocity