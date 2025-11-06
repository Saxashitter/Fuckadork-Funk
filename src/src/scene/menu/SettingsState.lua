local SettingsState = require("src.scene.preset.MenuState"):extend("MainMenuState", ...)

function SettingsState:init()
	self.super.init(self)
end

function SettingsState:setup()
	for k, setting in ipairs(Settings.addOrder) do
		self:addItem(setting.name..": "..tostring(setting.value), setting)
	end
	-- there has to be a better way to do this LOL
	-- saxa: did it lol
end

function SettingsState:backPressed()
	Engine.switchScene(MainMenuState:new())
end

function SettingsState:selected(selection)
end

function SettingsState:set(selection, i)
	selection:switch(i)
	self.items[self.selection].text:setContents(selection.name..": "..tostring(selection.value))
	AudioPlayer.playSFX("assets/sounds/boop.ogg")
end
return SettingsState