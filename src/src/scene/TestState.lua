local TestState = Scene:extend("TestState", ...)

function TestState:init()
	self.super.init(self)

	self.tmr = 0

	self.camera:setZoom(0.6)

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth/self.camera:getZoom(), Engine.gameHeight/self.camera:getZoom(), Color.GRAY)
	self.bg.origin = Point:new(0.5, 0.5)
	self.bg:screenCenter("xy")
	self:add(self.bg)

	local x = Engine.gameWidth/2
	local y = Engine.gameHeight/2

	self.light = Light:new(x+100, 0, 1)

	self.lightGraphic = Sprite:new(self.light:getX(), self.light:getY())
	self.lightGraphic:makeSolid(32, 32, Color.YELLOW)
	self.lightGraphic.origin = Point:new(0.5, 0.5)

	self.right = Character:new("poyo", "funk", x, y)
	self.right:setY(self.right:getY() + self.right:getHeight()/2)

	self.shadow = Shadow:new(self.right, self.light)

	self:add(self.shadow)
	self:add(self.light)
	self:add(self.lightGraphic)
	self:add(self.right)

end

function TestState:update(dt)
	self.tmr = self.tmr + dt

	--self.light:setX(Engine.gameWidth/2 + (self.right:getWidth()*1.25) * math.cos(self.tmr))
	--self.light:setY(Engine.gameHeight/2 + (self.right:getHeight()*1.25) * math.sin(self.tmr))
	self.light:setX(love.mouse.getX() - 350)
	self.light:setY(love.mouse.getY() - 350)
	-- there isnt a good way to do this for some reason, or maybe there is i just dont know how LOL

	self.lightGraphic:setX(self.light:getX())
	self.lightGraphic:setY(self.light:getY())

	--self.right.skew.x = math.cos(self.tmr) * 0.4
	--self.right.scale.y = 1 + math.sin(self.tmr*2) * 0.25
	self.super.update(self, dt)
end

return TestState