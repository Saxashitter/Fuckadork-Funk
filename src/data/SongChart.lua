local SongChart = Class:extend("SongChart")

local chartPath = "assets/songs/%s/data/%s/%s"
local metaPath = "assets/songs/%s"
local metaDataPath = "assets/songs/%s/metadata.json"

SongChart.metadata = {
	vocals = true,
	adaptiveVocals = false,
	stage = "test",
	rightSide = "bf",
	leftSide = "bf",
	speaker = "gf-radio"
}
SongChart.metadata.__index = SongChart.metadata

function SongChart:constructor(name, style, difficulty)
	if style == nil then
		style = "funk"
	end
	if difficulty == nil then
		difficulty = "normal"
	end

	self.path = metaPath:format(name)
	if love.filesystem.getInfo(metaDataPath:format(name)) then
		self.metadata = setmetatable(Json.decode(love.filesystem.read(metaDataPath:format(name))), self.metadata)
	end

	local json = "{}"
	local path = chartPath:format(name, style, difficulty)
	local parsed = {}

	if love.filesystem.getInfo(path..".json") then
		json = love.filesystem.read(path..".json")
		json = Json.decode(json)

		if FNFSongParser.isFNF(json) then
			parsed = FNFSongParser.parse(json)
			print("fnf song parse")
		elseif PsychSongParser.isPsych(json) then
			parsed = PsychSongParser.parse(json)
			print("psych song parse")
		else
			error("Invalid .json song format.")
		end
	elseif love.filesystem.getInfo(path..".mc") then
		json = love.filesystem.read(path..".mc")
		json = Json.decode(json)

		parsed = MalodySongParser.parse(json)
		print("malody song parse")
	end


	-- now this is where it gets fun
	self.rightSide = self.metadata.rightSide
	self.leftSide = self.metadata.leftSide
	self.speaker = self.metadata.speaker
	self.vocals = self.metadata.vocals
	self.adaptiveVocals = self.metadata.adaptiveVocals
	self.bpm = parsed.bpm
	self.speed = parsed.speed
	self.notes = parsed.notes
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