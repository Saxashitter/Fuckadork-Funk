local Notefield = Group:extend("Notefield")
Notefield.range = 133
Notefield.missRange = 170

Notefield.rotations = {
	math.rad(-90),
	math.rad(180),
	math.rad(0),
	math.rad(90),
}
Notefield._padding = 16

function Notefield:constructor(x, y, meta, song, chart, bot)
	Notefield.super.constructor(self)

	self._x = x or 0
	self._y = y or 0
	self._width = 0
	self._height = 0
	self._scale = 1
	self._bot = bot or false

	self._meta = meta
	self._song = song
	self._chart = chart
	self._receptors = {}
	self._heldNotes = {}

	self._noteAnims = {}

	for i = 1, #chart do
		local receptor = Receptor:new(0, 0)

		self:add(receptor)

		table.insert(self._receptors, receptor)
	end

	self:positionReceptors()
end

function Notefield:setHitCallback(func)
	self._hitCallback = func
end

function Notefield:setHoldCallback(func)
	self._holdCallback = func
end

function Notefield:setMissCallback(func)
	self._missCallback = func
end

function Notefield:update(dt)
	Notefield.super.update(dt)

	local noteHeightLimit = math.ceil((Engine.gameHeight - self:getY()) / Receptor.size)
	local step = self._song:getCurStep()

	self:forEachExisting(function(note)
		if not note:is(Note) then return end
		if self._noteAnims[note.receptor] == note then return end

		if not note.metadata.heldDown then
			local y = self:getWorldNotePosition(note.receptor, note.metadata)
			note:setY(y)

			return
		end

		local receptor = self._receptors[note.receptor]
		local meta = note.metadata

		-- (meta.position - time) * (Receptor.size * self:getScale() * self._meta.speed) / 1000

		local time = self._song:getTime() * 1000

		note:setX(receptor:getX())
		note:setY(receptor:getY())
		note.scale = Point:new(receptor.scale.x, receptor.scale.y)
		note.length = math.max(
			--(((meta.position + meta.holdTime - time) * (Receptor.size * self:getScale() * self._meta.speed) / 1000)),
			self:getScrollPosition(meta.position + meta.holdTime, true),
			0
		)
	end)

	-- TODO: cut down the amount of lines used here
	-- iterate through receptors
	for r = 1, #self._receptors do
		-- iterate through every possible step within chart lane
		for note = #self._chart[r], 1, -1 do
			self:manageChartStep(r, note)
		end
	end
end

function Notefield:onPress(r)
	local latestNote
	local noteStep

	local chart = self._chart[r]
	local receptor = self._receptors[r]
	local step = self._song:getCurStep()
	local rangeStep = self.range * 1000 / self._song:getStepCrotchet()
	local stepBeforeInput = step - rangeStep
	local flooredStepBeforeInput = math.floor(stepBeforeInput)
	local startOfLoop = math.floor(step - rangeStep*2)
	local animTime = self._song:beatToTime(4)
	local note = chart[1]

	if not note then
		self:positionReceptors()
		return false
	end

	local timing = self:getNoteMillisecondTiming(note) 

	if timing <= self.range then
		if note.holdTime > 0 then
			if self._char then
				local hitAnims = self._char.flipX and self._char.flipHitAnims or self._char.hitAnims
				self._char:play(hitAnims[r])
			end
			self:setReceptorHoldNote(r, 1)

			if self._holdCallback then
				self._holdCallback(self, timing)
			end
		else
			local anyHeld = false

			for k, v in pairs(self._heldNotes) do
				if v then
					anyHeld = true
					break
				end
			end

			if self._char
			and not anyHeld then
				local hitAnims = self._char.flipX and self._char.flipHitAnims or self._char.hitAnims
				self._char:playTimed(hitAnims[r], animTime)
			end
			self:hitNote(r, 1)
		end
		self:positionReceptors()
		return true
	end

	self:positionReceptors()
	return false
end

function Notefield:onRelease(r)
	local receptor = self._receptors[r]
	local animTime = self._song:beatToTime(4)

	-- unplay note anim and manage hold note
	if self._heldNotes[r] then
		self:hitNote(r, 1)

		local anyHeld = false

		for k, v in pairs(self._heldNotes) do
			if v then
				anyHeld = true
				break
			end
		end

		if self._char
		and not anyHeld then
			self._char:setTimer(animTime)
		end
	end

	self:positionReceptors()
end

function Notefield:setCharacter(char)
	self._char = char
end

function Notefield:getX()
	return self._x
end

function Notefield:setX(val)
	self._x = val
	self:positionReceptors()
end

function Notefield:getY()
	return self._y
end

function Notefield:setY(val)
	self._y = val
	self:positionReceptors()
end

function Notefield:getScale()
	return self._scale
end

function Notefield:setScale(scale)
	self._scale = scale
	self:positionReceptors()
end

function Notefield:getPadding()
	return self._padding
end

function Notefield:setPadding(val)
	self._padding = val
	self:positionReceptors()
end

function Notefield:getWidth()
	return self._width
end

function Notefield:getHeight()
	return self._height
end

function Notefield:makeNote(i, meta)
	local receptors = self._receptors
	local receptor = receptors[i]
	local note = self:recycle(Note, nil, true)
	local time = self._song:getTime() * 1000

	note:setDisplay(i)
	note.receptor = i
	note.metadata = meta
	note.scale = Point:new(self:getScale(), self:getScale())
	note:setAlpha(1)
	note.length = math.max(
		self:getScrollPosition(meta.holdTime),
		0
	)
	note:setX(self._receptors[i]:getX())
	note:setY(self:getWorldNotePosition(i, meta))
	note:setRotation(receptor:getRotation())
	note:setAlpha(receptor:getAlpha())

	meta.rendered = note
	return note
end

function Notefield:positionReceptors()
	for i = 1, #self._receptors do
		local receptor = self._receptors[i]

		receptor.scale = Point:new(self:getScale(), self:getScale())
		receptor:setX(self:getX()
			+ (receptor.size * self:getScale()
			+ self:getPadding()) * (i-1)
			+ receptor:getWidth()/2)
		receptor:setY(self:getY())
		receptor:setRotation(self.rotations[i])

		self._width = math.max(self._width, (receptor:getX() + receptor.size) - self:getX())
		self._height = math.max(self._height, (receptor:getY() + receptor:getHeight()/2) - self:getY())
	end
end

function Notefield:hitNote(r, noteStep)
	local noteData = self._chart[r][noteStep]
	local receptor = self._receptors[r]
	local timing = self:getNoteMillisecondTiming(noteData)

	if noteData.holdTime > 0 then
		timing = timing + noteData.holdTime
	end

	if noteData.rendered then
		if self._noteAnims[r] then
			self._noteAnims[r]:kill()
			self._noteAnims[r] = nil
		end

		local note = noteData.rendered

		note:setAlpha(1)
		if noteData.heldDown then
			note.length = 0
			self._heldNotes[r] = nil
		end

		note:setX(receptor:getX())
		note:setY(receptor:getY())

		note:playHit(function()
			self._noteAnims[r] = nil
		end)
		if self._hitCallback then
			self._hitCallback(self, timing)
		end

		self._noteAnims[r] = note
	end

	self:removeNoteFromChart(r, noteStep, false)
end

function Notefield:manageChartStep(r, step)
	local noteData = self._chart[r][step]

	-- if the note isnt valid... return
	if not (noteData and noteData.valid) then
		return
	end

	-- iterate through each note backwards (in case of removal)
	-- and then handle stuff like misses and spawning
	local y = self:getWorldNotePosition(r, noteData)
	local timing = self:getNoteMillisecondTiming(noteData)
	local held = false

	if self._heldNotes[r]
	and step == self._heldNotes[r].step then
		held = true
		timing = timing + noteData.holdTime
	end

	if self._bot
	and timing <= 0 then
		if not held then
			self:onPress(r)
			if noteData.holdTime <= 0 then
				self:onRelease(r)
			end
		else
			self:onRelease(r)
		end

		return
	elseif timing <= -self.missRange then
		-- whoops, you missed
		if self._char then
			self._char.animTimer:stop()
			self._char:play("idle")
		end
		if held then
			self._heldNotes[r] = nil
		end
		self:removeNoteFromChart(r, step)
		if self._missCallback then
			self._missCallback(self, timing)
		end
		return
	end

	if y < Engine.gameHeight + Receptor.size * self:getScale() / 2
	and y > -Receptor.size * self:getScale() / 2
	and not noteData.rendered then
		self:makeNote(r, noteData)
	end
end

function Notefield:getScrollPosition(timing, subtract)
	local songTime = self._song:getTime() * 1000
	if not subtract then
		songTime = 0
	end
	local msDiff = timing - songTime
	local secPerBeat = 60000 / self._song:getBPM()
	local beatDiff = msDiff / secPerBeat

	-- Make each beat = receptor size * scale * speed
	return beatDiff * (Receptor.size * self:getScale() * self._meta.speed)
end

function Notefield:getWorldNotePosition(r, meta)
	local receptor = self._receptors[r]

	if Settings.getValue("Downscroll") then
		return self:getY() - self:getScrollPosition(meta.position, true)
	end

	return self:getY() + self:getScrollPosition(meta.position, true)
end

function Notefield:getNoteTiming(meta)
	local time = self._song:getTime() * 1000
	return (meta.position - time)
end

function Notefield:getNoteMillisecondTiming(meta)
	return self:getNoteTiming(meta)
end

function Notefield:removeNoteFromChart(r, step, killRender)
	if killRender == nil then killRender = true end
	local noteData = self._chart[r][step]

	if noteData.rendered then
		if killRender then
			noteData.rendered:kill()
		end
	end

	table.remove(self._chart[r], step)
end

function Notefield:setReceptorHoldNote(r, step, timing)
	self._chart[r][step].heldDown = true
	self._heldNotes[r] = {step = step}

	local noteData = self._chart[r][step]

	if noteData.rendered then
		noteData.rendered:setAlpha(0)
	end
end


return Notefield