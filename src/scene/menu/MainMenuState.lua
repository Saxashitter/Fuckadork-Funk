local MainMenuState = require("src.scene.preset.MenuState"):extend("MainMenuState", ...)

function MainMenuState:setup()
	self:addItem("Songs", function()
		Engine.switchScene(SongsState:new())
	end)
	self:addItem("Editors", function()
		Engine.switchScene(CharacterEditor:new())
	end)
	self:addItem("Settings", function() end)
end

function MainMenuState:selected(selection)
	selection()
end

return MainMenuState