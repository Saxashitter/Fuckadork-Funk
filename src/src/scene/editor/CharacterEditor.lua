local CharacterEditor = Scene:extend("CharacterEditor", ...)

function CharacterEditor:init()
	CharacterEditor.super.init(self)

	local characterX = Engine.gameWidth*0.5
	local characterY = Engine.gameHeight*0.8

	local characterOriginWidth = 16
	local characterOriginHeight = 16
	local characterOriginAlpha = 0.5
	local characterOriginColor = Color.BLUE

	local camLocationWidth = 16
	local camLocationHeight = 16
	local camLocationAlpha = 1
	local camLocationColor = Color.WHITE

	local textSize = 24
	local leftUIPos = 4

	self.characterName = UITextbox:new(4, leftUIPos, textSize*16, textSize, "bf")
	leftUIPos = leftUIPos + 4 + textSize/4 + textSize

	self.characterMode = UITextbox:new(4, leftUIPos, textSize*16, textSize, "funk")
	leftUIPos = leftUIPos + 4 + textSize/4 + textSize

	self.animationName = UITextbox:new(4, leftUIPos, textSize*16, textSize, "idle")
	leftUIPos = leftUIPos + 4 + textSize/4 + textSize

	self.bg = Sprite:new()
	self.bg:makeSolid(Engine.gameWidth, Engine.gameHeight, Color.GRAY)
	self:add(self.bg)

	self.ghostCharacter = Character:new(self.characterName:getContents(), self.characterMode:getContents(), characterX, characterY)
	self.ghostCharacter:setAlpha(0.25)
	self:add(self.ghostCharacter)

	self.character = Character:new(self.characterName:getContents(), self.characterMode:getContents(), characterX, characterY)
	self.character:play(self.animationName:getContents())
	self:add(self.character)

	self.originUI = Sprite:new()
	self.originUI:setX(characterX)
	self.originUI:setY(characterY)
	self.originUI.origin = Point:new(0.5, 0.5)
	self.originUI:setAlpha(characterOriginAlpha)
	self.originUI:makeSolid(characterOriginWidth, characterOriginHeight, characterOriginColor)
	self:add(self.originUI)

	self.camUI = Sprite:new()
	self.camUI:setX(self.character:getCamX())
	self.camUI:setY(self.character:getCamY())
	self.camUI.origin = Point:new(0.5, 0.5)
	self.camUI:setAlpha(camLocationAlpha)
	self.camUI:makeSolid(camLocationWidth, camLocationHeight, camLocationColor)
	self:add(self.camUI)

	self.information = Text:new(4,Engine.gameHeight - textSize - 4,0, "hey so im kinda lazy, just edit the json then reload it constantly", textSize)
	self:add(self.information)

	self.reload = UIButton:new(4, leftUIPos, textSize*4, textSize, "reload")
	self.reload:setCallback(function()
		self.character:load(self.characterName:getContents(), self.characterMode:getContents())
		self.ghostCharacter:load(self.characterName:getContents(), self.characterMode:getContents())
		self.camUI:setX(self.character:getCamX())
		self.camUI:setY(self.character:getCamY())
		self.character:play(self.animationName:getContents())
	end)
	leftUIPos = leftUIPos + 4 + textSize/4 + textSize, textSize*4

	self:add(self.characterName)
	self:add(self.characterMode)
	self:add(self.animationName)
	self:add(self.reload)
end

return CharacterEditor