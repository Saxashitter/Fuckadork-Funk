local DPadABScheme = {}

function DPadABScheme:new(gamePad)
	local hpad = 40
	local vpad = 80

	local sr = 55
	local br = 30

	local lx = hpad
	local dpx = lx + sr
	local rx = Engine.gameWidth - hpad

	local y = Engine.gameHeight - vpad

	local left = InputButton:new(dpx - sr, y - sr, br, "left")
	gamePad:add(left)

	local right = InputButton:new(dpx + sr, y - sr, br, "right")
	gamePad:add(right)

	local down = InputButton:new(dpx, y, br, "down")
	gamePad:add(down)

	local up = InputButton:new(dpx, y - sr*2, br, "up")
	gamePad:add(up)

	local a = InputButton:new(rx - br, y, br, "a")
	gamePad:add(a)

	local b = InputButton:new(rx - (br*3)-8, y, br, "b")
	gamePad:add(b)
end

return DPadABScheme