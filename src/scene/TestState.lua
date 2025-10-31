local TestState = Scene:extend("TestState", ...)

function TestState:init()
	self.super.init(self)

	self.tmr = 0

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, Color.GRAY)
	self:add(self.bg)

	local x = Engine.gameWidth/2
	local y = Engine.gameHeight/2

	self.note = Note:new()
	self.note:setX(x)
	self.note:setY(y)
	self.note:setAlpha(0.1)
	self.note.length = 24
	self:add(self.note)
end

function TestState:update(dt)
	self.tmr = self.tmr + dt
	self.note.scale.x = 1 + math.abs(math.cos(self.tmr))*1.25
	self.note.scale.y = 1 + math.abs(math.cos(self.tmr))*1.25
	self.super.update(self, dt)
end

return TestState