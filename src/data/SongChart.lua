local SongChart = Class:extend("SongChart")

local chartPath = "assets/songs/%s/data/%s-%s.mc"
local metaPath = "assets/songs/%s"
local metaDataPath = "assets/songs/%s/metadata.json"

SongChart.metadata = {
	bpm = 120,
	speed = 1,
	vocals = true,
	adaptiveVocals = false,
	stage = "test",
	rightSide = "bf",
	leftSide = "bf",
	speaker = "gf-radio"
}
SongChart.metadata.__index = SongChart.metadata

function SongChart:constructor(name, mode)
	if mode == nil then
		mode = "funk"
	end

	if love.filesystem.getInfo(metaDataPath:format(name)) then
		self.metadata = setmetatable(Json.decode(love.filesystem.read(metaDataPath:format(name))), self.metadata)
	end
	self.path = metaPath:format(name)

	local json = "{}"
	local path = chartPath:format(name, style, difficulty)
	local parsed = {}

	-- now this is where it gets fun
	self.rightSide = self.metadata.rightSide
	self.leftSide = self.metadata.leftSide
	self.speaker = self.metadata.speaker
	self.vocals = self.metadata.vocals
	self.adaptiveVocals = self.metadata.adaptiveVocals
	self.bpm = self.metadata.bpm
	self.speed = self.metadata.speed
	self.notes = {
		MalodySongParser.parse(Json.decode(love.filesystem.read(chartPath:format(name, "left", mode))), self.bpm),
		MalodySongParser.parse(Json.decode(love.filesystem.read(chartPath:format(name, "right", mode))), self.bpm)
	}
end

function SongChart:stepToTime(step)
	local crotchet = 60 / self.bpm * 1000
	local stepCrotchet = crotchet / 4

	return step / stepCrotchet
end

function SongChart:timeToStep(time)
	local crotchet = 60 / self.bpm * 1000
	local stepCrotchet = crotchet / 4

	return time / stepCrotchet
end

return SongChart