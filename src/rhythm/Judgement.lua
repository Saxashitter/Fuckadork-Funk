local Judgement = CanvasLayer:extend("Judgement", ...)

local Notefield = require("src.rhythm.Notefield")

Judgement.path = "assets/images/judgements/%s.png"
Judgement.textSize = 30
Judgement.judgements = {
	{
		time = 46,
		name = "Sick!!",
		score = 350,
		image = "sick"
	},
	{
		time = 79,
		name = "Good.",
		score = 200,
		image = "good"
	},
	{
		time = 109,
		name = "Bad...",
		score = 50,
		image = "bad"
	}
	-- 133 for shit
}

function Judgement:getJudgement(time)
	local judgement
	local jud_key

	time = math.abs(time)

	for i, jud in ipairs(self.judgements) do
		if not judgement then
			judgement = jud
			jud_key = i
			goto continue
		end

		if jud.time <= time then
			judgement = jud
			jud_key = i
			goto continue
		end

		::continue::
	end

	return judgement, jud_key
end

function Judgement:constructor(x, y, time)
	Judgement.super.constructor(self)

	local sprite = Sprite:new()
	sprite.origin = Point:new(0.5, 0.5)

	local text = Text:new()
	text.origin = Point:new(0.5, 0.5)
	text:setSize(self.textSize)
	text:setBorderSize(2)

	self.sprite = sprite
	self.text = text

	self:add(sprite)
	self:add(text)

	self:setX(x or 0)
	self:setY(y or 0)
	self:setJudgement(time or 0)
end

function Judgement:setDeadCallback(func)
	self._deadCallback = func
end

function Judgement:setJudgement(time)
	local judgement = self:getJudgement(time)

	self.sprite:loadTexture(self.path:format(judgement.image))
	self.text:setContents(("%0.2f ms"):format(time))
	self.text:setY(self.sprite:getHeight()/2 + self.textSize/2)
end

function Judgement:playFade()
	if not self.atwn then
		self.atwn = Tween:new()
	else
		self.atwn:stop()
	end

	if self.tmr then
		self.tmr:stop()
	end

	local twn = Tween:new()

	twn:tweenProperty(self.sprite, "_alpha", 0, 0.25, Ease.linear)
	twn:tweenProperty(self.text, "_alpha", 0, 0.25, Ease.linear)
	twn:setCompletionCallback(function()
		if self._deadCallback then
			self._deadCallback(self)
		end
	end)
end

function Judgement:playAnim()
	local twn = Tween:new()
	local atwn = Tween:new()
	local tmr = Timer:new()

	self.twn = twn
	self.atwn = atwn
	self.tmr = tmr

	local y = self:getY()
	local scale = Point:new(self.scale.x, self.scale.y)

	self.sprite:setAlpha(0)
	self:setY(y + 0*scale.y)
	self.scale = self.scale * 0.5

	local fadeTime = 0.1

	twn:tweenProperty(self, "_y", y, fadeTime, Ease.quadOut)
	atwn:tweenProperty(self.sprite, "_alpha", 1, fadeTime, Ease.linear)
	atwn:tweenProperty(self.text, "_alpha", 1, fadeTime, Ease.linear)
	twn:tweenProperty(self.scale, "x", scale.x, fadeTime, Ease.quadOut)
	twn:tweenProperty(self.scale, "y", scale.y, fadeTime, Ease.quadOut)
	tmr:start(1, function()
		self:playFade()
	end)
end

return Judgement