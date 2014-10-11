RectangleShape = class(function(r, x, y, width, height)
			r.x = x
			r.y = y
			r.width = width
			r.height = height

			end)

GameObject = class(RectangleShape, function(p, x, y, width, height, speed, input)
			   RectangleShape.init(p, x, y, width, height)
			  
			   p.speed = speed
			   p.velocityX = 0
			   p.velocityY = 0

			   p.input = input
			   p.physics = GameObjectPhysicsComponent()

			   end)

function GameObject:update(dt, map)
	self.input:update(self)
	self.physics:update(self, self.speed, map)
end

--------------
--COMPONENTS--
--------------

InputComponent = class(function(i, speed)
						i.speed = speed
						end)

PlayerInputComponent = class(InputComponent)

function PlayerInputComponent:update(object)
	object.velocityY = 0
	object.velocityX = 0

	if love.keyboard.isDown("w") then
		object.velocityY = -1
	elseif love.keyboard.isDown("s") then
		object.velocityY = 1
	end

	if love.keyboard.isDown("a") then
		object.velocityX = -1
	elseif love.keyboard.isDown("d") then
		object.velocityX = 1
	end

	
end

PhysicsComponent = class()
GameObjectPhysicsComponent = class(PhysicsComponent)

function GameObjectPhysicsComponent:update(object, speed, map)
	if object.velocityY ~= 0 then
        object.y = object.y+(speed*object.velocityY)
        handleVerticalCollision(player, map)
    end

	if object.velocityX ~= 0 then
        object.x = object.x+(speed*object.velocityX)
        handleHorizontalCollision(player, map)
    end
end

function handleHorizontalCollision(object, map)
	local leftTile = toGrid(object.x)
	local rightTile = toGrid(object.x+object.width)

	local topTile = toGrid(object.y)
	local botTile = toGrid(object.y+object.height)

	for y = topTile, botTile do
		for x = leftTile, rightTile do
			if map[y][x].collide then
				player.x = player.x + getHorizontalIntersectionDepth(player, map[y][x])
			end
		end
	end
end

function handleVerticalCollision(object, map)
	local leftTile = toGrid(object.x)
	local rightTile = toGrid(object.x+object.width)

	local topTile = toGrid(object.y)
	local botTile = toGrid(object.y+object.height)

	for y = topTile, botTile do
		for x = leftTile, rightTile do
			if map[y][x].collide then
				player.y = player.y + getVerticalIntersectionDepth(player, map[y][x])
			end
		end
	end
end

TOLERANCE = 4
function getVerticalIntersectionDepth(rectA, rectB)

	local rectAHalfHeight = rectA.height/2
	local rectBHalfHeight = rectB.height/2

	local rectACenter = rectA.y + rectAHalfHeight
	local rectBCenter = rectB.y + rectBHalfHeight

	local distanceY = rectACenter - rectBCenter
	local minDistanceY = rectAHalfHeight + rectBHalfHeight

	if math.abs(distanceY) >= minDistanceY then
		return 0
	end

	if distanceY > 0 then
		return minDistanceY - distanceY + TOLERANCE
	else
		return -minDistanceY - distanceY - TOLERANCE
	end
end

function getHorizontalIntersectionDepth(rectA, rectB)
	local rectAHalfWidth = rectA.width/2
	local rectBHalfWidth = rectB.width/2

	local rectACenter = rectA.x+rectAHalfWidth
	local rectBCenter = rectB.x+rectBHalfWidth

	local distanceX = rectACenter - rectBCenter
	local minDistanceX = rectAHalfWidth + rectBHalfWidth

	if math.abs(distanceX) >= minDistanceX then
		return 0
	end

	if distanceX > 0 then
		return minDistanceX - distanceX + TOLERANCE
	else
		return -minDistanceX - distanceX - TOLERANCE
	end

end
