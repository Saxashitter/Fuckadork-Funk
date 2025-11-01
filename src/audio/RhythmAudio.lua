local RhythmAudio = Group:extend("RhythmAudio")

RhythmAudio.path = "assets/songs/%s/audio/%s.ogg"

function RhythmAudio:constructor()
	RhythmAudio.super.constructor(self)

	self._songs = {}
	--self._song = AudioPlayer:new()
	--self:add(self._song)

	self._playing = false
	self._bpm = 0
	self._crotchet = 0
	self._stepCrotchet = 0
	self._dt = 0
	self._correction = 0.15
end

function RhythmAudio:addSource(songName, file)
	local song = AudioPlayer:new()

	song:load(self.path:format(songName, file))
	table.insert(self._songs, song)
	self:add(song)
end

function RhythmAudio:setBeatCallback(func)
	self._beatCallback = func
end

function RhythmAudio:setStepCallback(func)
	self._stepCallback = func
end

function RhythmAudio:setSectionCallback(func)
	self._sectionCallback = func
end

function RhythmAudio:setFinishCallback(func)
	self._finishCallback = func
end

function RhythmAudio:setStartDelay(secs)
	self._dt = self._dt - secs
end

function RhythmAudio:resynchSong()
	for k, song in ipairs(self._songs) do
		song:seek(self._dt)
	end
end

function RhythmAudio:update(dt)
	RhythmAudio.super.update(self, dt)

	if not self._playing then
		return
	end

	local prevSec = self:getCurSection()
	local prevBeat = self:getCurBeat()
	local prevStep = self:getCurStep()

	local underZero = self._dt < 0

	self._dt = self._dt + dt

	if self._dt >= 0
	and underZero then
		self._dt = 0
	
		for k, song in ipairs(self._songs) do
			song:play()
		end
	end

	local curSec = self:getCurSection()
	local curBeat = self:getCurBeat()
	local curStep = self:getCurStep()

	if math.floor(curBeat) ~= math.floor(prevBeat)
	and self._beatCallback then
		self._beatCallback(curBeat)
	end

	if math.floor(curStep) ~= math.floor(prevStep)
	and self._stepCallback then
		self._stepCallback(curStep)
	end

	if math.floor(curSec) ~= math.floor(prevSec)
	and self._sectionCallback then
		self._sectionCallback(curSec)
	end

	local player = self._songs[1]

	if self._dt >= player:getStream():getDuration() then
		self._dt = player:getStream():getDuration()
		self:pause()

		if self._finishCallback then
			self._finishCallback(self)
		end

		return
	end

	local songOffset = self._songs[1]:getPlaybackTime() - self._dt

	if self._dt >= 0
	and math.abs(songOffset) >= self._correction then
		self:resynchSong()
	end
end

function RhythmAudio:setBPM(bpm)
	self._bpm = bpm
	self._crotchet = 60 / bpm * 1000
	self._stepCrotchet = self._crotchet / 4
end

function RhythmAudio:getBPM()
	return self._bpm
end

function RhythmAudio:getCrotchet()
	return self._crotchet
end

function RhythmAudio:getStepCrotchet()
	return self._stepCrotchet
end

function RhythmAudio:getCurStep()
	return self:getTime() * 1000 / self:getStepCrotchet()
end

function RhythmAudio:getCurBeat()
	return self:getTime() * 1000 / self:getCrotchet()
end

function RhythmAudio:getCurSection()
	return self:getTime() * 1000 / (self:getCrotchet()*4)
end

function RhythmAudio:getTime()
	return self._dt
end

function RhythmAudio:beatToTime(beat)
	return (beat / 1000) * self:getCrotchet()
end

function RhythmAudio:stepToTime(step)
	return (step / 1000) * self:getStepCrotchet()
end

function RhythmAudio:getTime()
	return self._dt
end

function RhythmAudio:pause()
	self._playing = false
	if self._dt >= 0 then
		for k, song in ipairs(self._songs) do
			song:pause()
		end
	end
end

function RhythmAudio:resume()
	self._playing = true
	if self._dt >= 0 then
		for k, song in ipairs(self._songs) do
			song:resume()
		end
	end
end

function RhythmAudio:play()
	self._playing = true

	if self._dt >= 0 then
		self:seek(0)
		for k, song in ipairs(self._songs) do
			song:play()
		end
	end
end

function RhythmAudio:seek(time)
	self._dt = time
	self:resynchSong()
end

return RhythmAudio