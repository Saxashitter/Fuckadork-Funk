local Background = Group:extend("Background", ...)

Background.path = "assets/stages/"
Background.metaData = {
	zoom = 1,
	rightSide = {0, 0},
	leftSide = {0, 0},
	speaker = {0, 0},
	sprites = {}
}
Background.metaData.__index = Background.metaData

function Background:constructor(folder)
	self.super.constructor(self)

	self:loadBackground(folder)
end

function Background:loadBackground(folder)
	if not love.filesystem.getInfo(self.path..folder.."/data.json", "file") then
		error(folder.." is not a valid background directory!")
		return
	end

	self:clear()

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
		local sprite = Sprite:new()

		sprite:setX(data.position[1])
		sprite:setY(data.position[2])
		sprite:makeSolid(data.dimensions[1], data.dimensions[2], data.color)
		sprite.scrollFactor = Point:new(0,0)
		sprite:setRotation(math.rad(data.rotation))

		self:add(sprite)
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

function Background:_draw()
	if self:isVisible() then
        self:draw()
        --print "draw"
	end

	for _, actor in ipairs(self._members) do
		drawObject(self, actor)
	end
end

return Background