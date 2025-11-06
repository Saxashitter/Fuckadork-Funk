local Character = Sprite:extend("Character", ...)

local characterData = "assets/characters/%s/%s"
local AtlasFrames = crequire("animation.frames.AtlasFrames")

local function charFileExists(name, file)
	return love.filesystem.getInfo(characterData:format(name, file))
end

function Character.charExists(name)
	return charFileExists(name, "metadata.json")
end

Character.metaData = {
	displayName = "Example",
	shortDescription = "Example",
	longDescription = "Example",
	selectable = false,
	flip = false,
	origin = {0, 0},
	camera = {0, 0},
	animations = {
		funk = {
			idle = {prefix = "idle", fps = 24, loop = false, x = 0, y = 0}
		},
		taiko = {
			idle = {prefix = "idle", fps = 24, loop = false, x = 0, y = 0}
		},
		ddr = {
			idle = {prefix = "idle", fps = 24, loop = false, x = 0, y = 0}
		}
	}
}
Character.hitAnims = {
	"leftHit",
	"downHit",
	"upHit",
	"rightHit"
}
Character.flipHitAnims = {
	"rightHit",
	"downHit",
	"upHit",
	"leftHit"
}
Character.metaData.__index = Character.metaData

function Character.fileExists(name, file)
	if not Character.charExists(name) then
		return false
	end

	if not charFileExists(name, file) then
		return false
	end

	return true
end

function Character.getPath(name, file)
	return characterData:format(name, file)
end

function Character:constructor(name, mode, x, y)
	if not self.charExists(name) then
		error("Character not valid...")
		return
	end

	if not charFileExists(name, "images/"..mode..".png") then
		mode = "funk"
		if not charFileExists(name, "images/funk.png") then
			error("No sheet for "..mode.." mode.")
			return
		end
	end

	self.super.constructor(self)
	self.animTimer = Timer:new()

	self:load(name, mode)
	self:setX(x)
	self:setY(y)
end

function Character:load(name, mode)
	if not self.charExists(name) then
		error("Character not valid...")
		return
	end

	if not charFileExists(name, "images/"..mode..".png") then
		mode = "funk"
		if not charFileExists(name, "images/funk.png") then
			error("No sheet for "..mode.." mode.")
			return
		end
	end

	self.animTimer:stop()

	self.metaData = setmetatable(Json.decode(love.filesystem.read(self.getPath(name, "metadata.json"))), self.metaData)

	self.flipX = self.metaData.flip
	self:setFrames(
		AtlasFrames.fromSparrow(
			Character.getPath(name, "images/"..mode..".png"),
			Character.getPath(name, "images/"..mode..".xml")
		)
	)

	self.animation:reset()
	for animName, anim in pairs(self.metaData.animations[mode]) do
		self.animation:addByPrefix(animName, anim.prefix, anim.fps, anim.loop)
		self.animation:setOffset(animName, anim.x, anim.y)
	end
	self.origin = Point:new(self.metaData.origin[1], self.metaData.origin[2])
	self.camera = Point:new(self.metaData.camera[1], self.metaData.camera[2])
	self.scrollFactor = Point:new(1,1)

	self:play("idle")
end

function Character:getCamX()
	return self:getX() + self.camera.x
end

function Character:getCamY()
	return self:getY() + self.camera.y
end

function Character:setTimer(time)
	self.animTimer:start(time, function()
		self:play("idle")
	end)
end

function Character:play(name)
	self.animation:play(name, true)
	self.animTimer:stop()
end

function Character:playTimed(name, time)
	self:play(name)
	self:setTimer(time)
end

return Character