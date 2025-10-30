local Receptor = Sprite:extend("Receptor")

local RECEPTOR_PATH = "assets/images/receptor.png"
local AtlasFrames = crequire("animation.frames.AtlasFrames")

Receptor.size = 50

function Receptor:constructor(x, y, rotation)
	Receptor.super.constructor(self, x, y)

	self:loadTexture(RECEPTOR_PATH)

	self.origin = Point:new(0.5, 0.5)
end

return Receptor