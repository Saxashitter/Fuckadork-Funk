local ModelTestState = Scene:extend("ModelTestState", ...)

function ModelTestState:init()
	self.super.init(self)

	self.tmr = 0

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth/self.camera:getZoom(), Engine.gameHeight/self.camera:getZoom(), Color.GRAY)
	self.bg.origin = Point:new(0.5, 0.5)
	self.bg:screenCenter("xy")
	self.bg:setAlpha(0.25)
	self:add(self.bg)

	--self.area = g3d.newModel("assets/models/cube.obj")
	--self.area:setTranslation(1, 0, -1)

	local texture = Assets.getTexture("assets/images/note.png")

	local sd = math.max(1/texture.width, 1/texture.height)
	local xs = texture.width*sd
	local ys = texture.height*sd

	local a = {-xs, 0, -ys, 0, 0}
	local b = {xs, 0, -ys, 1, 0}
	local c = {xs, 0, ys, 1, 1}
	local d = {-xs, 0, ys, 0, 1}

	self.billboard = g3d.newModel({
		a, b, c,
		a, c, d
	}, texture:getImage())
	self.billboard:setTranslation(1, 1, 0)
end

function ModelTestState:update(dt)
	ModelTestState.super.update(self, dt)

	self.tmr = self.tmr + dt
end

function ModelTestState:draw()
	ModelTestState.super.draw(self)

	--self.area:draw()
	self.billboard:draw()
end

function ModelTestState:input(event)
	if not event:is(InputEventMouseMotion) then
		return
	end

	g3d.camera.firstPersonLook(event:getDeltaX(), event:getDeltaY())
end

return ModelTestState