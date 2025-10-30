local SongsState = require("src.scene.preset.MenuState"):extend("SongsState", ...)

function SongsState:setup()
	local folders = love.filesystem.getDirectoryItems("assets/songs/")
	local info = love.filesystem.getInfo

	for i, folder in ipairs(folders) do
		local path = "assets/songs/" .. folder

		if (info(path .. "/data/funk/normal.json") or info(path .. "/data/funk/normal.mc"))
		and info(path .. "/audio/Inst.ogg") then
			self:addItem(folder, folder)
		end
	end
end

function SongsState:selected(selection)
	GameState.currentSong = selection

	Engine.switchScene(GameState:new())
end

function SongsState:backPressed()
	Engine.switchScene(MainMenuState:new())
end

return SongsState