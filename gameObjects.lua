RectangleShape = class(function(r, x, y, width, height)
			r.x = x
			r.y = y
			r.width = width
			r.height = height

			end)

GameObject = class(RectangleShape, function(p, x, y, width, height, speed, input, physics)
			   RectangleShape.init(p, x, y, width, height)
			  
			   p.speed = speed
			   p.velocityX = 0
			   p.velocityY = 0

			   p.input = input
			   p.physics = PlayerPhysicsComponent()

			   end)

Enemy = class(GameObject, function(p,x,y,width,height,speed,input,physics)
			  GameObject.init(p,x,y,width,height,speed,input,physics)

			  
			  end)


Collectible = class(RectangleShape, function(c, x, y, width, height, info)
			   RectangleShape.init(c, x, y, width, height)
			  
			   c.info = info

			   end)

function GameObject:update(dt, map, world)
	self.input:update(self)
	self.physics:update(self, self.speed, map, world)
end

function GameObject:setDialogHandler(handler)
	self.dialog = handler
end

function Collectible:update()

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

NullInputComponent = class(InputComponent)

function NullInputComponent:update()
end

PhysicsComponent = class()
PlayerPhysicsComponent = class(PhysicsComponent)

function PlayerPhysicsComponent:update(object, speed, map, world)

	----------------------
	--Physical Collision--
	----------------------

	if object.velocityY ~= 0 then
        object.y = object.y+(speed*object.velocityY)
        handleVerticalCollision(object, map)

    end

	if object.velocityX ~= 0 then
        object.x = object.x+(speed*object.velocityX)
        handleHorizontalCollision(object, map)
    end

    -----------------------------
    --Player Object Interaction--
    -----------------------------

    for i=1, table.getn(world) do
    	--Check if it collides, and skip it if it collides with itself
    	if checkRectCollision(object, world[i]) and world[i] ~= object then
    		local collidedObject = world[i]

    		-- Player -> Collectible
    		--TODO: Most likely put an observer pattern here and send it to the rendering in order to render the mole fact
    		if instanceOf(collidedObject, Collectible) then
    			object.dialog:addText(collidedObject.info)
    			collidedObject.isDead = true
    		end

    	end
    end

end

function instanceOf (subject, super)
	super = tostring(super)
	local mt = getmetatable(subject)
 
	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
 
		mt = getmetatable(mt)
	end	
end


















-----------------------
--COLLISION DETECTION--
-----------------------

--IF SOMETHING BREAKS HERE YOU'RE SCREWEDh

function checkRectCollision(rectA, rectB)
	return rectA.x < rectB.x + rectB.width and
		   rectB.x < rectA.x + rectA.width and
		   rectA.y < rectB.y + rectB.height and
		   rectB.y < rectA.y + rectA.height 
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function handleHorizontalCollision(object, map)
	local leftTile = toGrid(object.x)
	local rightTile = toGrid(object.x+object.width)

	local topTile = toGrid(object.y)
	local botTile = toGrid(object.y+object.height)

	for y = topTile, botTile do
		for x = leftTile, rightTile do
			if map[y][x].collide then
				object.x = object.x + getHorizontalIntersectionDepth(object, map[y][x])
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
				object.y = object.y + getVerticalIntersectionDepth(object, map[y][x])
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
