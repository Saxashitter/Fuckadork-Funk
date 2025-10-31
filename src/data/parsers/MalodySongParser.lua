local MalodySongParser = Class:extend("MalodySongParser", ...)

function MalodySongParser.parse(data, bpm)
	local notes = {}

	-- custom note parsing and all, lol
	local crotchet = 60 / bpm * 1000
	local stepCrotchet = crotchet / 4

	for k = 1, 4 do
		notes[k] = {}
	end

	for _,note in ipairs(data.note or {}) do
		if not note.column then
			goto continue
		end

		-- beat[1] is the beat num
		-- beat[2] is 0-(beat[3]-1)
		-- beat[3] is snap
		-- i could be wrong, can you research this?
		local position = note.beat[1] + (note.beat[2] / note.beat[3])
		position = (position * 60 / bpm) * 1000 / stepCrotchet 

		local absolutePos = math.floor(position)
		local offsetPos = position % 1

		local field = note.column+1
		local holdTime = 0

		if note.endbeat then
			holdTime = (note.endbeat[1] + (note.endbeat[2] / note.endbeat[3]))
				- (note.beat[1] + (note.beat[2] / note.beat[3]))
			holdTime = math.floor((holdTime * 60 / bpm) * 1000 / stepCrotchet)
		end

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

		::continue::
	end

	return notes
end

return MalodySongParser