local ShadowTestState = Scene:extend("ShadowTestState", ...)

local anims = {
	"leftHit",
}
local curAnim = 1
local char

local function timeLoop()
	char:play(anims[curAnim])
	curAnim = curAnim + 1
	if curAnim > #anims then
		curAnim = 1
	end
	Timer:new():start(1, timeLoop)
end

function ShadowTestState:init()
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
	self.shadow.__special = true

	self:add(self.shadow)
	self:add(self.light)
	self:add(self.lightGraphic)
	self:add(self.right)

	char = self.right
	timeLoop()
end

function ShadowTestState:update(dt)
	self.tmr = self.tmr + dt

	--self.light:setX(Engine.gameWidth/2 + (self.right:getWidth()*1.25) * math.cos(self.tmr))
	--self.light:setY(Engine.gameHeight/2 + (self.right:getHeight()*1.25) * math.sin(self.tmr))
	-- self.light:setX(love.mouse.getX() - 350)
	-- self.light:setY(love.mouse.getY() - 350)
	-- there isnt a good way to do this for some reason, or maybe there is i just dont know how LOL
	-- actually there IS stupid

	self.super.update(self, dt)
end

function ShadowTestState:input(event)
	if not event:is(InputEventMouseMotion) then
		return
	end

	local x, y = self.camera:screenToCamera(event:getX(), event:getY())

	self.light:setX(x)
	self.light:setY(y)

	self.lightGraphic:setX(self.light:getX())
	self.lightGraphic:setY(self.light:getY())
end

return ShadowTestState