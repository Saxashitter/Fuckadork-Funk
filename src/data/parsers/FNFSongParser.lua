local FNFSongParser = Class:extend("FNFSongParser", ...)

function FNFSongParser.parse(data)
	local parsed = {
		rightSide = data.song.player1 or "bf",
		leftSide = data.song.player2 or "dad",
		speaker = data.song.gfVersion or data.song.player3 or "gf",
		speed = data.song.speed or 1,
		bpm = data.song.bpm or 120,
	}

	-- custom note parsing and all, lol
	local crotchet = 60 / parsed.bpm * 1000
	local stepCrotchet = crotchet / 4

	parsed.notes = {}
	for i = 1, 2 do
		parsed.notes[i] = {}
		for k = 1, 4 do
			parsed.notes[i][k] = {}
		end
	end

	for _,section in ipairs(data.song.notes or {}) do
		for _,note in ipairs(section.sectionNotes) do
			local absolutePos = math.floor(note[1] / stepCrotchet)
			local offsetPos = (note[1] % stepCrotchet) / stepCrotchet
			local side = math.floor(note[2] / 4) + 1
			local field = (note[2] % 4)+1
			local holdTime = note[3] / stepCrotchet
		
			if holdTime < 1 then
				holdTime = 0
			end

			if section.mustHitSection then -- flip the field
				side = 3 - side
			end

			local notes = parsed.notes[side]
			local notefield = notes[field]

			if #notefield < absolutePos then -- lets even things out
				for k = #notefield+1, absolutePos-1 do
					notefield[k] = notefield[k] or {valid = false}
				end
			end
	
			notefield[absolutePos] = {
				valid = true,
				step = absolutePos,
				offset = offsetPos,
				holdTime = holdTime,
				field = field
			}
		end
	end

	return parsed
end

function FNFSongParser.isFNF(data)
	return data and data.song and type(data.song) == "table"
end

return FNFSongParser