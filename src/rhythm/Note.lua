local Note = Sprite:extend("Note", ...)

local NOTE_PATH = "assets/images/note.png"
local HOLDNOTE_PATH = "assets/images/noteHold.png"
local HOLDNOTEEND_PATH = "assets/images/noteHoldTail.png"
local AtlasFrames = crequire("animation.frames.AtlasFrames")
local TileFrames = crequire("animation.frames.TileFrames")

Note._noteStep = 0
Note._noteOffset = 0
Note._noteHold = 0
Note._noteField = 0
Note.special = nil
Note.anims = {
	{"noteLeft", 1, 2},
	{"noteDown", 3, 4},
	{"noteUp", 5, 6},
	{"noteRight", 7, 8}
}

function Note.getJudgement(time)
	local judgement
	local jud_key

	for i, jud in ipairs(Note.judgements) do
		if not judgement then
			judgement = jud
			jud_key = i
			goto continue
		end

		if jud.time <= time then
			judgement = jud
			jud_key = i
		end

		::continue::
	end

	return judgement, jud_key
end
	

function Note:constructor()
	Note.super.constructor(self)

	self:loadTexture(NOTE_PATH)

	self.origin = Point:new(0.5, 0.5)
	self.length = 0

	self._holdSprite = Sprite:new()
	self._holdSprite:loadTexture(HOLDNOTE_PATH)
	self._holdSprite.origin = Point:new(0.5, 0)

	self._holdSpriteEnd = Sprite:new()
	self._holdSpriteEnd:loadTexture(HOLDNOTEEND_PATH)
	self._holdSpriteEnd.origin = Point:new(0.5, 0)
end

function Note:setDisplay(val)
end

function Note:getNoteField(val)
	return self._noteField
end

function Note:playHit(callback)
	self._hitTween = Tween:new()
	self._hitDelayTween = Tween:new()

	local twn = self._hitTween
	local atwn = self._hitDelayTween

	atwn:setStartDelay(0.25)
	atwn:setCompletionCallback(function()
		self:kill()
		if callback then
			callback(self)
		end
	end)

	local sx = self.scale.x
	local sy = self.scale.x

	self.scale.x = sx * 1.75
	self.scale.y = sy * 0.25

	twn:tweenProperty(self.scale, "x", sx, 0.25, Ease.backOut)
	twn:tweenProperty(self.scale, "y", sy, 0.25, Ease.backOut)
	atwn:tweenProperty(self, "_alpha", 0, 0.1, Ease.linear)
end

function Note:kill()
	if self._hitTween then
		self._hitTween:stop()
		self._hitDelayTween:stop()

		self._hitTween = nil
		self._hitDelayTween = nil
	end

	self.super.kill(self)
end
function Note:free()
	if self._hitTween then
		self._hitTween:stop()
		self._hitDelay:stop()
	end

	self.super.free(self)
end

function Note:draw()
	if self.length > 0 then
		local hold = self._holdSprite
		local tail = self._holdSpriteEnd

		tail.scale = Point:new(self.scale.x, self.scale.y)

		if Settings.getValue("Downscroll") then
			tail.flipY = true
		end

		if self.length > tail:getHeight() then
			hold.scale = Point:new(self.scale.x, self.length - tail:getHeight())
			hold:setX(self:getX())
			hold:setY(self:getY())
			if Settings.getValue("Downscroll") then
				hold:setY(self:getY() - hold:getHeight())
			end
			hold:draw()
		end

		tail:setX(self:getX())
		if not Settings.getValue("Downscroll") then
			tail:setY(self:getY() + self.length - tail:getHeight())
			tail:setClipRect(
				Rect:new(0,
					math.max(0, (tail:getHeight() - self.length) / tail.scale.y),
					tail:getFrameWidth(),
					tail:getFrameHeight()
				)
			)
		else
			local crop = math.max(0, math.min(1, self.length / tail:getHeight()))

			tail:setY(self:getY() - self.length + tail:getHeight())
			tail:setClipRect(Rect:new(
				0,
				tail:getFrameHeight() * (1-crop),
				tail:getFrameWidth(),
				tail:getFrameHeight()
			))
		end
		tail:draw()
	end

	self.super.draw(self)
end

return Note