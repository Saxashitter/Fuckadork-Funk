local Model = Actor:extend("Model", ...)
-- a wrapper for g3d models

function Model:constructor(modelPathOrVertices, x, y, z, texture)
	self:setModel(modelPathOrVertices)
	self:setX(x)
	self:setY(y)
	self:setZ(z)
end

function Model:setModel(modelPathOrVertices)
	if not modelPathOrVertices then return end

	self._model = g3d.newModel(modelPathOrVertices)
end

function Model:setX(x)
	self._x = x or 0

	if self._model then
		self._model:setTranslation(
			self._x or 0,
			self._y or 0,
			self._z or 0)
	end
end

function Model:setY(y)
	self._y = y or 0

	if self._model then
		self._model:setTranslation(
			self._x or 0,
			self._y or 0,
			self._z or 0)
	end
end

function Model:setZ(z)
	self._z = z or 0

	if self._model then
		self._model:setTranslation(
			self._x or 0,
			self._y or 0,
			self._z or 0)
	end
end

function Model:setRotX(rx)
	self._rx = rx or 0

	if self._model then
		self._model:setRotation(
			self._rx or 0,
			self._ry or 0,
			self._rz or 0)
	end
end

function Model:setRotY(ry)
	self._ry = ry or 0

	if self._model then
		self._model:setRotation(
			self._rx or 0,
			self._ry or 0,
			self._rz or 0)
	end
end

function Model:setRotZ(rz)
	self._rz = rz or 0

	if self._model then
		self._model:setRotation(
			self._rx or 0,
			self._ry or 0,
			self._rz or 0)
	end
end

function Model:setScaleX(sx)
	self._sx = sx or 1

	if self._model then
		self._model:setScale(
			self._sx or 1,
			self._sy or 1,
			self._sz or 1)
	end
end

function Model:setScaleY(sy)
	self._sy = sy or 1

	if self._model then
		self._model:setScale(
			self._sx or 1,
			self._sy or 1,
			self._sz or 1)
	end
end

function Model:setScaleZ(sz)
	self._sz = sz or 1

	if self._model then
		self._model:setScale(
			self._sx or 1,
			self._sy or 1,
			self._sz or 1)
	end
end

function Model:getX()
	return self._x or 0
end
function Model:getY()
	return self._y or 0
end
function Model:getZ()
	return self._z or 0
end
function Model:getRotX()
	return self._rx or 0
end
function Model:getRotY()
	return self._ry or 0
end
function Model:getRotZ()
	return self._rz or 0
end
function Model:getScaleX()
	return self._sx or 1
end
function Model:getScaleY()
	return self._sy or 1
end
function Model:getScaleZ()
	return self._sz or 1
end

function Model:draw()
	self._model:draw()
end

return Model