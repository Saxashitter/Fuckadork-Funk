local StartScreen = Scene:extend("StartScreen", ...)

local function endCutscene(self)
	local t = Tween:new()
	t:tweenProperty(self.bg, "_alpha", 0, 1, Ease.linear)

	Timer:new():start(1, function()
		Engine.switchScene(SelectState:new())
	end)
end

local function dropLogo(self)
	local height = self.saxashitter:getFrameHeight()
	local targetY = (Engine.gameHeight-height)/2
	local dropTime = 0.45
	local bounceTime = 1.25
	local bounceOffset = Engine.gameHeight/7
	
	local t = Tween:new()
	t:tweenProperty(self.saxashitter, "y", targetY, dropTime, Ease.linear)
	t:setCompletionCallback(function()
		local t = Tween:new()
		t:tweenProperty(self.saxashitter, "y", targetY - bounceOffset, bounceTime/2, Ease.sineOut)
		t:setCompletionCallback(function()
			local t = Tween:new()
			t:tweenProperty(self.saxashitter, "y", targetY, bounceTime/2, Ease.sineIn)
		end)
	end)

	Timer:new():start(5, function()
		endCutscene(self)
	end)

	self.audio:play()
end

local function fadeBackground(self)
	local t = Tween:new()
	t:tweenProperty(self.bg, "_alpha", 1, 1, Ease.linear)

	Timer:new():start(0.75, function()
		dropLogo(self)
	end)
end

function StartScreen:init()
	StartScreen.super.init(self)

	self.audio = AudioPlayer:new()
	self.audio:load("assets/sounds/naomi.ogg")
	self:add(self.audio)

	self.bg = Sprite:new() --- @type chip.graphics.Sprite
	self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, Color.WHITE)
	self.bg:screenCenter("xy")
	self.bg:setAlpha(0)
	self:add(self.bg)

	self.saxashitter = Text:new() --- @type chip.graphics.Text
    self.saxashitter:setSize(24)
    self.saxashitter:setContents("Saxashitter")
    self.saxashitter:screenCenter("x")
    self.saxashitter:setY(-self.saxashitter:getFrameHeight())
    self.saxashitter:setColor(Color.BLACK)
    self:add(self.saxashitter)

	print(self.camera.x, self.camera.y)

	local t = Timer:new()
 	t:start(1, function()
		fadeBackground(self)
	end)
end

function StartScreen:resize(width, height)
	self.camera:setX(width/2)
	self.camera:setY(height/2)

	self.bg:makeSolid(width, height, Color.WHITE)
	self.bg:screenCenter("xy")
	self.saxashitter:screenCenter("x")
end

return StartScreen