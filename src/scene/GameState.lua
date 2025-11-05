local GameState = Scene:extend("GameState", ...)

local NOTES = 4
local NOTE_WIDTH = 32
local NOTE_PADDING = 4
local FIELD_WIDTH = (NOTE_WIDTH * NOTES) + (NOTE_PADDING * (NOTES-1))
local FIELDS = 1

GameState.currentSong = "Dadbattle"
GameState.currentMode = "funk"
GameState.keyBinds = {"d", "f", "j", "k"}

function GameState:constructor(...)
	self.super.constructor(self, ...)

	self.background = Background:new("test")

	self.left = Character:new("bf",
		self.currentMode,
		self.background.leftSide.x,
		self.background.leftSide.y)
	self.right = Character:new("bf",
		self.currentMode,
		self.background.rightSide.x,
		self.background.rightSide.y)
	--self.left.flipX = not self.left.flipX
	self.right.flipX = not self.right.flipX

	self.HUDcamera = Camera:new()

	self.chart = SongChart:new(self.currentSong, self.currentMode,  "normal")
	self.song = RhythmAudio:new()

	local xOffset = 20
	local yOffset = 70
	local height = 8
	local scale = 1.75

	if Settings.get("Downscroll") then
		yOffset = Engine.gameHeight - yOffset
	end

	local function getNotesInSection(self, i)
		local notes = 0
		local time = self.song:beatToTime(4)
		local curTime = self.song:getTime()

		for r = 1,4 do
			for _, note in ipairs(self.chart.notes[i][r]) do
				if note.position > (curTime+time)*1000 then
					return notes
				end
	
				notes = notes + 1
			end
		end
	
		return notes
	end

	self.song:addSource(self.currentSong, "Inst")
	if self.chart.vocals then
		self.song:addSource(self.currentSong, "funkin/Voices")
	end

	self.song:setBPM(self.chart.bpm)
	self.song:setFinishCallback(function()
		Engine.switchScene(SongsState:new())
	end)

	self.song:setBeatCallback(function(beat)
		if beat % 2 > 1 then return end

		if self.right.animation:getCurrentAnimation().name == "idle" then
			self.right:play("idle")
		end
		if self.left.animation:getCurrentAnimation().name == "idle" then
			self.left:play("idle")
		end
	end)

	self.song:setSectionCallback(function()
		local step = math.floor(self.song:getCurStep())

		local leftNotes = getNotesInSection(self, 1)
		local rightNotes = getNotesInSection(self, 2)

		local t = Tween:new()
		-- TODO: make chart "editor" to make events and camera switches

		if rightNotes > leftNotes then
			t:tweenProperty(self.camera, "_x", self.right:getCamX(), 0.6, Ease.quintInOut)
			t:tweenProperty(self.camera, "_y", self.right:getCamY(), 0.6, Ease.quintInOut)
			return
		end
		if leftNotes > rightNotes then
			t:tweenProperty(self.camera, "_x", self.left:getCamX(), 0.6, Ease.quintInOut)
			t:tweenProperty(self.camera, "_y", self.left:getCamY(), 0.6, Ease.quintInOut)
			return
		end

		local minCamX = math.min(self.left:getCamX(), self.right:getCamX())
		local minCamY = math.min(self.left:getCamY(), self.right:getCamY())
		local maxCamX = math.max(self.left:getCamX(), self.right:getCamX())
		local maxCamY = math.max(self.left:getCamY(), self.right:getCamY())

		local camX = minCamX + (maxCamX - minCamX)/2
		local camY = minCamY + (maxCamY - minCamY)/2

		t:tweenProperty(self.camera, "_x", camX, 0.6, Ease.quintInOut)
		t:tweenProperty(self.camera, "_y", camY, 0.6, Ease.quintInOut)
	end)
	self.song:setStartDelay(3)

	self.botField = Notefield:new(xOffset, yOffset, self.chart, self.song, self.chart.notes[1], true)
	self.botField:setScale(scale)
	self.botField:setCharacter(self.left)

	self.playerField = Notefield:new(Engine.gameWidth, yOffset, self.chart, self.song, self.chart.notes[2])
	self.playerField:setScale(scale)
	self.playerField:setX(Engine.gameWidth - self.playerField:getWidth() - xOffset)
	self.playerField:setCharacter(self.right)

	if Settings.get("Middlescroll") then
		self.playerField:setX(Engine.gameWidth/2 - self.playerField:getWidth()/2)
		self.botField:setX(xOffset)
		self.botField:setScale(self.botField:getScale()*0.75)
	end

	local strumBGOffset = 48

	self.strumlineBG = Sprite:new() --couldnt figure this out today, sax if u wanna you can try and do it urself
	-- penny sucks at coding.wav
	-- i dont blame you at all tbh LOL
	self.strumlineBG:setX(self.playerField:getX() - strumBGOffset)
	self.strumlineBG:makeSolid(self.playerField:getWidth() + strumBGOffset*2, Engine.gameHeight, Color.BLACK) -- set the alpha based off of the settings lua valuo for it
	self.strumlineBG:setAlpha(Settings.get("Strumline Background") / 100)

	self.judgementGroup = CanvasLayer:new()
	self.judgementGroup:setX(self.playerField:getX()
		+ self.playerField:getWidth()/2)
	self.judgementGroup:setY(self.playerField:getY()
		+ self.playerField:getHeight()
		+ Receptor.size*self.playerField:getScale())

	if Settings.get("Downscroll") then
		self.judgementGroup:setY(self.playerField:getY()
			- self.playerField:getHeight()
			- Receptor.size*self.playerField:getScale() - 150)
	end

	self.playerField:setHitCallback(function(_, timing)
		local judgement = self.judgementGroup:recycle(Judgement, nil, true)

		if self.curJudgement then
			self.curJudgement:playFade()
		end

		judgement:setJudgement(timing)
		judgement.scale = Point:new(0.5, 0.5)
		judgement:playAnim()
		judgement:setDeadCallback(function()
			if judgement == self.curJudgement then
				self.curJudgement = nil
			end
			judgement:kill()
		end)

		self.curJudgement = judgement
	end)
end

function GameState:init(songName)
	GameState.super.init(self)

	self.camera:setX(self.right:getCamX())
	self.camera:setY(self.right:getCamY())
	self.camera:setZoom(self.background.zoom)

	if Engine.deviceType == "Mobile" then
		self.hitbox = Hitbox:new(0, 0, Engine.gameWidth, Engine.gameHeight, 4)
		self.hitbox:setCallback(function(_, key, pressed)
			local playerField = self.playerField

			if pressed then
				playerField:onPress(key)
			else
				playerField:onRelease(key)
			end
		end)

		self:add(self.hitbox)
	end

	self:addCamera(self.HUDcamera)

	self:add(self.song)

	self:add(self.background)
	self:add(self.left)
	self:add(self.right)

	self:add(self.line, self.HUDcamera)
	self:add(self.strumlineBG, self.HUDcamera)
	self:add(self.playerField, self.HUDcamera)
	self:add(self.botField, self.HUDcamera)
	self:add(self.judgementGroup, self.HUDcamera)

	self.song:play()
end

function GameState:physics(dt)
end

function GameState:resize(width, height)
	self.super.resize(self, width, height)

	self.hitbox:setWidth(width)
	self.hitbox:setHeight(width)
	--self.HUDcamera:setX(width/2, height/2)
end

function GameState:input(event)
	self.super.input(self, event)

	--[[if event:is(InputEventTouch)
	and event:isPressed()
	and self.song:getTime() < 70 * 60 / self.song:getBPM() then
		self.song:seek(70 * 60 / self.song:getBPM())
	end]]

	if not event:is(InputEventKey) then return end
	if event:isRepeating() then return end

	local contains, key = table.contains(self.keyBinds, event:getScanCode())

	if not contains then return end

	if event:isPressed() then
		self.playerField:onPress(key)
		return
	end

	self.playerField:onRelease(key)
end

return GameState