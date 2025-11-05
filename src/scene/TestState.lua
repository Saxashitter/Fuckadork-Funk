local TestState = Scene:extend("TestState", ...)

function TestState:init()
	self.super.init(self)

	self.tmr = 0

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, Color.GRAY)
	self:add(self.bg)

	local x = Engine.gameWidth/2
	local y = Engine.gameHeight/2

	self.right = Character:new("bf",
		"funk",
		x,
		y)
	self.right:setY(self.right:getY() + self.right:getHeight()/2)

	self.shadow = Shadow:new(self.right)

	self:add(self.shadow)
	self:add(self.right)
end

function TestState:update(dt)
	self.tmr = self.tmr + dt * 4.5
	self.right.skew.x = math.cos(self.tmr) * 0.4
	self.right.scale.y = 1 + math.sin(self.tmr*2) * 0.25
	self.super.update(self, dt)
end

return TestState