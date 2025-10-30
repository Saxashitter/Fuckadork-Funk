Chip = require("lib.chip")
shove = require("lib.shove.shove")
g3d = require("lib.g3d")

KeyBinds = {
	left = {"a", "left"},
	down = {"s", "down"},
	up = {"w", "up"},
	right = {"d", "right"},
	accept = {"space", "z"},
	back = {"escape", "x"}
}

local function recursiveRequire(folder)
	-- Get all items (files and directories) within the specified folder
	local items = love.filesystem.getDirectoryItems(folder)
	
	for _, item in ipairs(items) do
		local path = folder .. "/" .. item
		
		if love.filesystem.isDirectory(path) then
			recursiveRequire(path)
		elseif item:match("%.lua$") then
			_G[item:gsub("%.lua$", "")] = require(path:gsub("%.lua$", ""):gsub("/", "."))
		end
	end
end

recursiveRequire("framework")
recursiveRequire("src")

Chip.init {
	showSplashScreen = false,
	debugMode = false,
	gameWidth = 1280,
	gameHeight = 720,
	noBorders = false,
	targetFPS = 0,
	physicsPerFrame = 4,
	initialScene = MainMenuState:new(),
	shove = {
		resizable = true,
		fullscreen = false
	}
}

Console.init()
print = Console.print