local MenuState = Scene:extend("MenuState", ...)

function MenuState:init()
	MenuState.super.init(self)

	self.items = {}

	local folders = love.filesystem.getDirectoryItems("assets/songs/")

	self:setup()

	self:setSelection(1)

	if Engine.deviceType == "Mobile" then
		self.gamePad = GamePad:new()
		self.gamePad:setScheme(DPadABScheme)
		self:add(self.gamePad)
	end
end

function MenuState:setup() end

function MenuState:addItem(name, item)
	local size = 25
	local padding = 30
	local text = Text:new(0,
		0,
		0,
		name,
		size)

	text:setX(Engine.gameWidth/2)
	text.origin = Point:new(0.5, 0.5)

	self:add(text)
	table.insert(self.items, {item = item, text = text})

	local totalHeight = 0
	local y = 0

	for k, v in ipairs(self.items) do
		totalHeight = totalHeight + v.text:getHeight()
		if k < #self.items then
			totalHeight = totalHeight + padding
		end
	end
	for k, v in ipairs(self.items) do
		text:setY(Engine.gameHeight/2 - totalHeight/2 + y)
		y = y + v.text:getHeight() + padding
	end

	return text
end

function MenuState:setSelection(i)
	AudioPlayer.playSFX("assets/sounds/boop.ogg") --hell yeah
	self.selection = i

	for k, v in ipairs(self.items) do
		local color = {r=0.5, g=0.5, b=0.5, a=1}

		if k == i then
			color = {r=1,g=1,b=1,a=1}
		end

		v.text:setColor(color)
	end
end

function MenuState:selected(selection) end
function MenuState:set(selection, i) end
function MenuState:backPressed() end

function MenuState:input(event)
	if not event:is(InputEventKey) then
		return
	end

	if not event:isPressed() then
		return
	end

	if table.contains(KeyBinds.up, event:getScanCode()) then
		self:setSelection(((self.selection-2) % #self.items)+1)
	end

	if table.contains(KeyBinds.down, event:getScanCode()) then
		self:setSelection((self.selection % #self.items)+1)
	end

	if table.contains(KeyBinds.left, event:getScanCode()) then
		self:set(self.items[self.selection].item, -1)
	end

	if table.contains(KeyBinds.right, event:getScanCode()) then
		self:set(self.items[self.selection].item, 1)
	end

	if table.contains(KeyBinds.accept, event:getScanCode()) then
		AudioPlayer.playSFX("assets/sounds/boop.ogg")
		self:selected(self.items[self.selection].item)
	end

	if table.contains(KeyBinds.back, event:getScanCode()) then
		self:backPressed()
		AudioPlayer.playSFX("assets/sounds/boop.ogg")
	end
end

function MenuState:update(dt)
	MenuState.super.update(self, dt)
	if Engine.deviceType ~= "Mobile" then return end

	if self.gamePad:isPressed("up") then
		self:setSelection(((self.selection-2) % #self.items)+1)
	end

	if self.gamePad:isPressed("down") then
		self:setSelection((self.selection % #self.items)+1)
	end

	if self.gamePad:isPressed("left") then
		self:set(self.items[self.selection].item, -1)
	end

	if self.gamePad:isPressed("right") then
		self:set(self.items[self.selection].item, 1)
	end

	if self.gamePad:isPressed("a") then
		AudioPlayer.playSFX("assets/sounds/boop.ogg")
		self:selected(self.items[self.selection].item)
	end

	if self.gamePad:isPressed("b") then
		self:backPressed()
	end
end

return MenuState