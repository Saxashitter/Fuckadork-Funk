local TestState = Scene:extend("TestState", ...)

function TestState:init()
	self.super.init(self)

	self.tmr = 0

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, Color.GRAY)
	self:add(self.bg)

	local x = Engine.gameWidth/2
	local y = Engine.gameHeight/2

	self.judgement = Judgement:new(x, y, Notefield.range/8)
	--self.judgement.origin = Point:new(0.5, 0.5)
	--self.judgement:playAnim()
	self:add(self.judgement)

	Timer:new():start(1, function() self.judgement:playAnim() end)
end

function TestState:update(dt)
	self.super.update(self, dt)
end

return TestState