local Shadow = Sprite:extend("Shadow", ...)

function Shadow:constructor(char, light)
	Shadow.super.constructor(self, char:getX(), char:getY())
	self.char = char
	self.light = light
	self:setTint(Color.BLACK)
	self.alpha = 0.4
end

function Shadow:isOnScreen()
    return self.char:isOnScreen()
end

function Shadow:getRenderingInfo(trans)
    -- TODO: separate the transform updating into it's own function
    local frames, frame = self.char:getFrames(), self.char:getFrame()
    local frameWidth, frameHeight = self.char:getFrameWidth(), self.char:getFrameHeight()
    
    if not frames or not frame or not frame.texture then
        return nil, 0, 0, 0, 0, nil
    end
    local curAnim = self.char.animation:getCurrentAnimation()

    local ofx, ofy = math.abs(self.char.origin.x * frame.width), math.abs(self.char.origin.y * frame.height)
    local ofx2, ofy2 = math.abs(self.char.origin.x * frameWidth), math.abs(self.char.origin.y * frameHeight)
    
    if trans then
        trans:reset()
    
        local rx, ry = self._x - self.offset.x, self._y - self.offset.y
        
        local offx = ((curAnim and curAnim.offset.x or 0.0) - self.char.frameOffset.x) * (self.char.flipX and -1 or 1)
        local offy = ((curAnim and curAnim.offset.y or 0.0) -self.char.frameOffset.y) * (self.char.flipY and -1 or 1)

        local p = self.char._parent
    
        local canvases = {} --- @type table<chip.graphics.CanvasLayer>
    
        local canvasCount = 0
        local isOnCanvasLayer = false
    
        while p do
            if p:is(CanvasLayer) then
                if not p:is(Scene) then
                    isOnCanvasLayer = true
                end
                table.insert(canvases, p)
                canvasCount = canvasCount + 1
            end
            p = p._parent
        end
        local sx = self.scale.x
        local sy = self.scale.y
        local skx = self.skew.x
        local sky = self.skew.y
    
    	if sy < 0 then
    		skx = skx * -1
    	end
    
        if not isOnCanvasLayer then
            local cam = Camera.currentCamera
            --[[if cam then
                local w2 = Engine.gameWidth * 0.5
                local h2 = Engine.gameHeight * 0.5
                local zoom = cam:getZoom()
                
                trans:translate(
                    -(w2 * (zoom - 1)),
                    -(h2 * (zoom - 1))
                )
                trans:scale(zoom)
        
                trans:translate(w2, h2)
                trans:rotate(cam:getRotation())
                trans:translate(-w2, -h2)
            end]]
        end
        for i = 1, canvasCount do
            local canvas = canvases[canvasCount - i + 1] --- @type chip.graphics.CanvasLayer

            trans:translate(canvas:getX(), canvas:getY())
            trans:scale(canvas.scale.x, canvas.scale.y)
            trans:rotate(canvas.rotation)
        end
        -- TODO: resulting rect is slightly off
        -- when frame offset is more than 0 and the sprite is flipped
        trans:translate(rx, ry)

		local cam = Camera.currentCamera
		if not isOnCanvasLayer and cam then
			-- TODO: fix scrollfactor code
			local camX, camY = cam:getX(), cam:getY()
			trans:translate(camX * (1 - self.char.scrollFactor.x), camY * (1 - self.char.scrollFactor.y))
		end

        trans:scale(math.abs(sx), math.abs(sy))
        trans:rotate(self.char._rotation)
        trans:shear(skx, sky)
        trans:translate(-ofx2, -ofy2)
        trans:translate(
            -(frame.offset.x * (sx < 0.0 and -1 or 1) * (self.flipX and -1 or 1)),
            -(frame.offset.y * (sy < 0.0 and -1 or 1) * (self.flipY and -1 or 1))
        )
        trans:translate(-offx, -offy)
      
        --trans:translate(-ofx2, -ofy2)
    end
    local ot = trans
    if not trans then
        trans = self.char._transform
    end
    local v1, v2, _, rx, v5, v6, _, ry, v9, v10 = trans:getMatrix()
    
    local rw = frame.width * math.sqrt((v1 * v1) + (v5 * v5) + (v9 * v9))
    local rh = frame.height * math.sqrt((v2 * v2) + (v6 * v6) + (v10 * v10))
    local rotation = math.atan2(v5, v1) -- this is in radians
    
    local rect = self._rect:set(rx, ry, rw, rh) --- @type chip.math.Rect
    rect:getRotatedBounds(rotation, nil, rect)
   
    trans = ot
    if trans then
        if self.scale.x < 0.0 then
            trans:translate(ofx2, 0)
            trans:scale(-1, 1)
            trans:translate(-ofx2, 0)
        end
        if self.flipX then
            trans:translate(ofx2, 0)
            trans:scale(-1, 1)
            trans:translate(-ofx2, 0)
        end
        if self.scale.y < 0.0 then
            trans:translate(0, ofy2)
            trans:scale(1, -1)
            trans:translate(0, -ofy2)
        end
        if self.flipY then
            trans:translate(0, ofy2)
            trans:scale(1, -1)
            trans:translate(0, -ofy2)
        end
    end
    return trans, rx, ry, rw, rh, frame
end

function Shadow:draw()
	if not self.char or not self.light then return end

	local cx, cy = self.char:getX(), self.char:getY()
	local lx, ly = self.light:getX(), self.light:getY()

	-- direction from light to char
	local dx = cx - lx
	local dy = cy - ly

	-- parameters you can tweak
	local maxHeight = 300    -- distance at which shadow is flattest
	local minScale = 0    -- minimum y scale of the shadow
	local maxScale = 0.25     -- maximum y scale (when light is very low)

	-- map dy into a 0–1 range and invert it
	local t = (dy / maxHeight) * self.light.strength
	local flattenFactor = maxScale - (maxScale - minScale) * t

	-- slight horizontal skew depending on light offset
	local skewAmount = (dx * 0.0025) * self.light.strength

	self.origin = self.char.origin
	self.flipX = self.char.flipX

	self.scale = Point:new(
		self.char.scale.x,
		self.char.scale.y * flattenFactor
	)
	self.skew = Point:new(-skewAmount, self.char.skew.y)

	self:setX(cx)
	self:setY(cy)

	Shadow.super.draw(self)
end


return Shadow
