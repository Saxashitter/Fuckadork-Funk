g3d = require("lib.g3d")
Chip = require("lib.chip")
shove = require("lib.shove.shove")

KeyBinds = { --turns out this is for menus so these are not used in game
	left = {"a", "left"},
	down = {"s", "down"},
	up = {"w", "up"},
	right = {"d", "right"},
	accept = {"return", "z"},
	back = {"escape", "x"}
}

local function recursiveRequire(folder)
	-- Get all items (files and directories) within the specified folder
	local items = love.filesystem.getDirectoryItems(folder)
	
	for _, item in ipairs(items) do
		local path = folder .. "/" .. item
		
		if love.filesystem.getInfo(path, "directory") then
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
	gameWidth = 1280, --default 1280
	gameHeight = 720, -- default 720
	noBorders = false,
	targetFPS = 0,
	physicsPerFrame = 4,
	initialScene = TestState:new(),
	shove = {
		resizable = true,
		fullscreen = false -- this doesnt work, please fix this sax or atleast tell me how
		-- THATS THE THING IDFK
	}
}

Console.init()
print = Console.print