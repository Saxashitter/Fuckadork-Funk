local SettingsState = require("src.scene.preset.MenuState"):extend("MainMenuState", ...)

function SettingsState:init()
	self.super.init(self)
end

function SettingsState:setup()
	self:addItem("Boop!", function()
		AudioPlayer.playSFX("assets/sounds/boop.ogg")
	end)
	-- there has to be a better way to do this LOL
	-- saxa: did it lol
end

function SettingsState:backPressed()
	Engine.switchScene(MainMenuState:new())
end

function SettingsState:selected(selection)
	selection()
end

return SettingsState