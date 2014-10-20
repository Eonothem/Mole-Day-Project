require("audio")

RectangleShape = class(function(r, x, y, width, height)
			r.x = x
			r.y = y
			r.width = width
			r.height = height

			end)

GameObject = class(RectangleShape, function(p, x, y, width, height, speed, input, physics)
			   RectangleShape.init(p, x, y, width, height)
			   
			   p.angle = 0
			   p.speed = speed
			   p.velocityX = 0
			   p.velocityY = 0

			   p.input = input
			   p.physics = physics

			   end)

Enemy = class(GameObject, function(e,x,y,width,height,speed,input,physics,viewRange)
			  GameObject.init(e,x,y,width,height,speed,input,physics)

			  e.viewRange = viewRange
			  e.viewTiles = {}
			  e.walkingLeft = false
			  e.walkingDown = false
			  e.spottedPlayer = false
			  end)


Collectible = class(RectangleShape, function(c, x, y, width, height, info)
			   RectangleShape.init(c, x, y, width, height)
			  
			   c.info = info

			   end)

InputComponent = class(function(i, speed)
						i.speed = speed
						end)

PhysicsComponent = class()


----------------------------------
----------------------------------
----------------------------------

function Enemy:update(dt, map, world)
	self.input:update(self)
	self.physics:update(self,map)
	self:getVision(map)

end

function Enemy:getVision(map)
	self.viewTiles = {}
	if self.angle == 0 then
		
		for i = 1, self.viewRange do
			if map[toGrid(self.y)][toGrid(self.x)+i].collide then break end
			table.insert(self.viewTiles, map[toGrid(self.y)][toGrid(self.x)+i])
		end

	elseif self.angle == 180 then

		for i = 1, self.viewRange do
			if map[toGrid(self.y)][toGrid(self.x)-i].collide then break end
			table.insert(self.viewTiles, map[toGrid(self.y)][toGrid(self.x)-i])
		end

	end
end

function Enemy:setAngle(angle)
	self.angle = angle
end

EnemyPhysicsComponent = class(PhysicsComponent)

function EnemyPhysicsComponent:update(object, map)
	local centerX = object.x + (object.width/2)
	local centerY = object.y + (object.height/2)

	object.y = object.y + (object.speed*object.velocityY)
	object.x = object.x + (object.speed*object.velocityX)

	if not object.walkingLeft and map[toGrid(centerY)][toGrid(centerX)+1].collide then
		object.walkingLeft = true
		object:setAngle(180)
	elseif object.walkingLeft and map[toGrid(centerY)][toGrid(centerX)-1].collide then
		object.walkingLeft = false
		object:setAngle(0)
	end
		
end

PatrolLeftRight = class(InputComponent)

function PatrolLeftRight:update(object)
	if not object.spottedPlayer then	
		if not object.walkingLeft then
			object.velocityX = 1
		else
			object.velocityX = -1
		end
	else
		object.velocityX = 0
	end
end

PatrolUpDown = class(InputComponent)

function PatrolUpDown:update(object)
	if not object.spottedPlayer then	
		if not object.walkingDown then
			object.velocityY = -1
		else
			object.velocityY = 1
		end
	else
		object.velocityY = 0
	end
end

----------------------------------
----------------------------------
----------------------------------

function GameObject:update(dt, map, world)
	self.input:update(self)
	self.physics:update(self, self.speed, map, world)
end

function GameObject:setCodec(codec)
	self.codec = codec
end

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
stime = 0
PlayerPhysicsComponent = class(PhysicsComponent)

Timer = class(function(t)
			t.startTime = -1
			end)

function Timer:start()
	self.startTime = love.timer.getTime()
end

function Timer:getElpasedTime()
	if self.startTime ~= -1 then
		return love.timer.getTime()-self.startTime
	else
		return 0
	end
end

function Timer:clear()
	self.startTime = -1
end

function PlayerPhysicsComponent:update(object, speed, map, world)
	object.currentTile = map[toGrid(object.y+(object.height/2))][toGrid(object.x+(object.width/2))]

	----------------------
	--Physical Collision--
	----------------------

	if not object.isSpotted then
		if object.velocityY ~= 0 then
        	object.y = object.y+(speed*object.velocityY)
        	handleVerticalCollision(object, map)

   	 	end

		if object.velocityX ~= 0 then
        	object.x = object.x+(speed*object.velocityX)
        	handleHorizontalCollision(object, map)
    	end
    end

    -----------------------------
    --Player Object Interaction--
    -----------------------------

    for i=1, table.getn(world) do
    	local compareObject = world[i]

    	if instanceOf(compareObject, Enemy) then
    		--SPOTTED by Patrol
    		for j=1, table.getn(compareObject.viewTiles) do
    			if compareObject.viewTiles[j] == object.currentTile then
    				if not object.isSpotted then
    					alert:play()
    					theme:pause()
    					alertTimer = Timer()
    					alertTimer:start()
    				end

    				--Wait
    				if object.isSpotted and alertTimer:getElpasedTime() > .5 then
    					gameOver:play()
    					alertTimer:clear()
    				end
    				compareObject.spottedPlayer = true
    				object.isSpotted = true
    			end
    		end
    	end

    	--Check if it collides, and skip it if it collides with itself
    	if checkRectCollision(object, world[i]) and world[i] ~= object then
    		local collidedObject = compareObject

    		-- Player -> Collectible
    		if instanceOf(collidedObject, Collectible) then
    			pickup:play()
    			object.codec:setText(MOLE_CONVERSATION)
    			codec.isRinging = true
    			collidedObject.isDead = true
    		end

    	end

    end

end

----------------------------------
----------------------------------
----------------------------------

function Collectible:update()

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

TOLERANCE = 2
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

function instanceOf (subject, super)
	super = tostring(super)
	local mt = getmetatable(subject)
 
	while true do
		if mt == nil then return false end
		if tostring(mt) == super then return true end
 
		mt = getmetatable(mt)
	end	
end