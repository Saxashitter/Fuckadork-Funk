--[[
    chip.lua: a simple 2D game framework built off of Love2D
    Copyright (C) 2024  swordcube

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

local path = Chip.classPath:gsub("%.", "/")

local function getImagePath(name)
    return path .. "/assets/images/" .. name
end

local function getFontPath(name)
    return path .. "/assets/fonts/" .. name
end

local loveStripColors = {0xFFe74a99, 0xFF27aae1}

---
--- @class chip.SplashScene : chip.core.Scene
---
local SplashScene = Scene:extend("SplashScene", ...)

---
--- @param  initialScene  chip.core.Scene
---
function SplashScene:constructor(initialScene)
    SplashScene.super.constructor(self)
    self.initialScene = initialScene --- @type chip.core.Scene
end

function SplashScene:init()
    MouseCursor.setVisibility(false)

	SplashScene.super.init(self)

    self.bg = Sprite:new() --- @type chip.graphics.Sprite
    self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, 0xFF17171a)
    self.bg:screenCenter("xy")
    self:add(self.bg)

    self.backdrop = Backdrop:new(0, 0, math.floor(Engine.gameWidth / 64), math.floor(Engine.gameHeight / 64)) --- @type chip.graphics.Backdrop
    self.backdrop:loadTexture(getImagePath("love_logo_heart_small.png"))
    self.backdrop.spacing:set(20, 20)
    self.backdrop.velocity:set(-60, -60)
    self.backdrop:setAntialiasing(true)
    self.backdrop:setAlpha(0.05)
    --self.backdrop:kill()
    self:add(self.backdrop)

    self.strips = Sprite:new() --- @type chip.graphics.Sprite
    self.strips:loadTexture(getImagePath("love_strips.png"))
    self.strips:setGraphicSize(0.0001, Engine.gameHeight * 3)
    self.strips:screenCenter("xy")
    self:add(self.strips)

    self.logoBG = Sprite:new() --- @type chip.graphics.Sprite
    self.logoBG:loadTexture(getImagePath("love_logo_bg.png"))
    self.logoBG.scale:set(4, 4)
    self.logoBG:screenCenter("xy")
    self.logoBG:setAntialiasing(true)
    self.logoBG:setVisibility(false)
    self.logoBG:setRotationDegrees(45)
    self:add(self.logoBG)

    self.heart = Sprite:new() --- @type chip.graphics.Sprite
    self.heart:loadTexture(getImagePath("love_logo_heart.png"))
    self.heart:screenCenter("xy")
    self.heart:setAntialiasing(true)
    self.heart:setVisibility(false)
    self.heart.origin = Point:new(0.5, 0.5)
    self.heart.offset.y = -5
    self:add(self.heart)

    self.madeWith = Text:new() --- @type chip.graphics.Text
    self.madeWith:setSize(24)
    self.madeWith:setFont(getFontPath("handy-andy.otf"))
    self.madeWith:setContents("made with")
    self.madeWith:screenCenter("xy")
    self.madeWith:setY(self.madeWith:getY() + 130)
    self.madeWith:setAntialiasing(true)
    self.madeWith:setVisibility(false)
    self.madeWith.origin = Point:new(0.5, 0.5)
    self:add(self.madeWith)

    self.logo = Sprite:new() --- @type chip.graphics.Sprite
    self.logo:loadTexture(getImagePath("love_logo.png"))
    self.logo.scale:set(0.3, 0.3)
    self.logo:screenCenter("xy")
    self.logo:setY(self.logo:getY() + 170)
    self.logo:setAntialiasing(true)
    self.logo:setVisibility(false)
    self.logo.origin = Point:new(0.5, 0.5)
    self:add(self.logo)
end

return SplashScene