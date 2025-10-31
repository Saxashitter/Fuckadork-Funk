local SettingsState = require("src.scene.preset.MenuState"):extend("MainMenuState", ...)

function SettingsState:setup()
	self:addItem("Main Menu", function()
		Engine.switchScene(MainMenuState:new())
	end)
	self:addItem("Boop!", function()
		self.audio = AudioPlayer:new()
		self.audio:load("assets/sounds/boop.ogg")
		self:add(self.audio)
		self.audio:play()
	end) -- there has to be a better way to do this LOL
end

function SettingsState:selected(selection)
	selection()
end
return SettingsState