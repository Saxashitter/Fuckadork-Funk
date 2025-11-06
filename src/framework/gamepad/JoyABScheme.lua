local JoyABScheme = {}

function JoyABScheme:new(gamePad)
	print("created")
	local hpad = 24
	local vpad = 80

	local lx = hpad
	local rx = Engine.gameWidth - hpad

	local y = Engine.gameHeight - vpad

	local joyRadius = 60
	local buttonRadius = 30

	local joystick = InputJoy:new(lx + joyRadius, y, joyRadius, "move")
	gamePad:add(joystick)

	local a = InputButton:new(rx - buttonRadius, y, buttonRadius, "a")
	gamePad:add(a)

	local b = InputButton:new(rx - (buttonRadius*3)-8, y, buttonRadius, "b")
	gamePad:add(b)
end

return JoyABScheme