--@@ -0,0 +1,66 @@
local PsychSongParser = Class:extend("PsychSongParser", ...)

function PsychSongParser.parse(data)
	local parsed = {
		rightSide = data.player1 or "bf",
		leftSide = data.player2 or "dad",
		speaker = data.gfVersion or "gf",
		speed = data.speed or 1,
		bpm = data.bpm or 120
	}

	-- custom note parsing and all, lol
	local crotchet = 60 / parsed.bpm * 1000
	local stepCrotchet = crotchet / 4

	parsed.notes = {}
	for i = 1, 2 do
		print("create player field "..i)
		parsed.notes[i] = {}
		for k = 1, 4 do
			print("create note field "..k)
			parsed.notes[i][k] = {}
		end
	end

	for num,section in ipairs(data.notes or {}) do
		print("parse sector #"..num)
		for num,note in ipairs(section.sectionNotes) do
			print("parse note #"..num)
			local absolutePos = note[1]
			local side = 3 - (math.floor(note[2] / 4) + 1)
			local field = (note[2] % 4)+1
			local holdTime = note[3]
		
			if holdTime < stepCrotchet then
				holdTime = 0
			end

			--[[if section.mustHitSection then -- flip the field
				side = 3 - side
			end]]

			local notes = parsed.notes[side]
			local notefield = notes[field]

			print("this note is at field #"..field)
			table.insert(notefield, {
				valid = true,
				position = absolutePos,
				holdTime = holdTime,
				field = field
			})
		end
	end

	return parsed.notes
end

function PsychSongParser.isPsych(data)
	return data and data.format == "psych_v1"
end

return PsychSongParser