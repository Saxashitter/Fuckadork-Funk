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

local CanvasLayer = crequire("graphics.CanvasLayer") --- @type chip.graphics.CanvasLayer

---
--- @class chip.core.Scene : chip.graphics.CanvasLayer
---
--- A class which represents a scene.
--- 
--- This could be a main menu, a level, a game over screen,
--- anything you want it to be!
---
local Scene = CanvasLayer:extend("Scene", ...)

function Scene:constructor(...)
	Scene.super.constructor(self, ...)

	---
	--- Holds all cameras within the scene.
	---
	self.cameras = {}
end

function Scene:addCamera(camera)
	table.insert(self.cameras, camera)
end

function Scene:removeCamera(camera)
	table.removeItem(self.cameras, camera)
end
---
--- Override this function to initialize your scene.
---
function Scene:init()
	---
	--- Default camera for the state. All objects will be added into it's draw list.
	---
	self.camera = Camera:new()
	self:addCamera(self.camera)
end

function Scene:enter()
end

function Scene:physics()
end

local function drawObject(self, actor)
	if actor and actor:isExisting() and actor:isVisible() then
		if actor._draw then
			actor:_draw()
		else
			actor:draw()
		end
	end
end

function Scene:add(actor, camera)
	if not Scene.super.add(self, actor) then
		return
	end

	table.insert((camera or self.camera)._members, actor)
end

function Scene:remove(actor)
	if not Scene.super.remove(self, actor) then
		return
	end

	table.removeItem(self.camera._members, actor)
end

function Scene:resize()
end

function Scene:_draw()
	if self:isVisible() then
        self:draw()
        --print "draw"
	end

	for _, camera in ipairs(self.cameras) do
		camera:push()
    	for _, actor in ipairs(camera._members) do
    		drawObject(self, actor)
    	end
    	camera:pop()
    end
end

return Scene