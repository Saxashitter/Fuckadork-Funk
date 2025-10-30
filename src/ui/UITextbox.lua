local UITextbox = require("src.ui.UIButton"):extend("UITextbox", ...)

UITextbox._openedKeyboard = false

function UITextbox:constructor(...)
	UITextbox.super.constructor(self, ...)
end

function UITextbox:onRelease()
	if UITextbox._openedKeyboard then
		UITextbox._openedKeyboard = false
		love.keyboard.setTextInput(false)
	end
end

function UITextbox:onPress()
	if not UITextbox._openedKeyboard then
		UITextbox._openedKeyboard = true
		love.keyboard.setTextInput(true)
	end
end

function UIButton:input(event)
	if event:is(InputEventTextInput)
	and self.pressed then
		self.title = self.title..event:getCharacter()
		self.text:setContents(self.title)
		return
	end

	if event:is(InputEventKey)
	and event:getKey() == "backspace"
	and self.pressed then
		self.title = self.title:sub(1, #self.title-1)
		self.text:setContents(self.title)
		return
	end

	if not event:is(InputEventTouch) then
		return
	end

	if not event:isPressed() then
		return
	end

	-- check for collision
	if event:getX() < self:getX()
	or event:getY() < self:getY()
	or event:getX() > self:getX() + self:getWidth()
	or event:getY() > self:getY() + self:getHeight() then
		if self.pressed then
			self.pressed = false
			self:onRelease()
		end

		return
	end

	self.pressed = true
	self:onPress()
end

function UITextbox:getContents()
	return self.title
end

return UITextbox