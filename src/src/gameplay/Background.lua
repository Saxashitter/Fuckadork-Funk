local Background = Actor:extend("Background", ...)

Background.path = "assets/stages/"
Background.metaData = {
	zoom = 1,
	rightSide = {0, 0},
	leftSide = {0, 0},
	speaker = {0, 0},
	shadows = false,
	light = {x = 0, y = 0, strength = 0},
	sprites = {}
}
Background.metaData.__index = Background.metaData
Background.spriteMetaData = {
	key = "key",
	type = "solid",
	position = {0, 0},
	dimensions = {1, 1},
	image = "unknown",
	color = Color.WHITE,
	scale = {1, 1},
	origin = {1, 1},
	scrollFactor = {1, 1},
	rotation = 0
}
Background.spriteMetaData.__index = Background.spriteMetaData

function Background:constructor(folder)
	self.super.constructor(self)

	self._objects = {}

	self:loadBackground(folder)
end

function Background:addObjects()
	local parent = self:getParent()

	if not parent then
		error("Background must have parent!")
		return
	end

	for _, object in ipairs(self._objects) do
		parent:add(object)
	end
end

function Background:clearObjects()
	local parent = self:getParent()

	if not parent then
		return
	end

	for _, object in ipairs(self._objects) do
		self[object._key] = nil
		parent:remove(object)
	end

	self._objects = {}
end

function Background:loadBackground(folder)
	if not love.filesystem.getInfo(self.path..folder.."/data.json", "file") then
		error(folder.." is not a valid background directory!")
		return
	end

	self:clearObjects()

	local path = self.path..folder.."/"
	local meta = setmetatable(
		Json.decode(love.filesystem.read(path.."data.json")),
		self.metaData
	)

	self.zoom = meta.zoom
	self.leftSide = Point:new(meta.leftSide[1], meta.leftSide[2])
	self.rightSide = Point:new(meta.rightSide[1], meta.rightSide[2])
	self.speaker = Point:new(meta.speaker[1], meta.speaker[2])

	for _, data in ipairs(meta.sprites) do
		--local data = setmetatable(data, self.spriteMetaData)
		local sprite = Sprite:new()

		sprite:setX(data.position[1])
		sprite:setY(data.position[2])
		if data.type == "solid" then
			sprite:makeSolid(data.dimensions[1], data.dimensions[2], data.color)
		elseif data.type == "image" then
			sprite:loadTexture(path.."/images/"..data.image..".png")
		end
		--sprite.scale = Point:new(data.scale[1], data.scale[2])
		sprite.origin = Point:new(data.origin[1], data.origin[2])
		sprite.scrollFactor = Point:new(data.scrollFactor[1], data.scrollFactor[2])
		--sprite:setRotation(math.rad(data.rotation))
		sprite._key = data.key
		self[data.key] = sprite
		table.insert(self._objects, sprite)
		-- TODO: sparrow atlas, spritesheets, etc
	end
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

return Background