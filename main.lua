require("tile")
require("class")

SCALE_FACTOR = .5
TILE_WIDTH = 100*SCALE_FACTOR

MAP_WIDTH = 4
MAP_HEIGHT = 4

int_map = {{1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 }, 
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1}}

Rectangle = class(function(p, x, y, width, height)
			p.x = x
			p.y = y
			p.width = width
			p.height = height
			end)

function love.load()

	------------
	--Load Map--
	------------
	map = {}
	for row = 1, table.getn(int_map) do
		map[row] = {}
		for col = 1, table.getn(int_map[row]) do
			newTile = Tile()
			newTile:new(int_map[row][col])
			newTile:setGrid(row, col)
			newTile:setXY(TILE_WIDTH)
			--io.write("["..newTile.row..", "..newTile.col.."]")
			map[row][col] = newTile
		end
	end
	
	player = Rectangle(150,150,32,32)

	
end


function love.update(dt)
	-------------------------------
	--Player Movement & Collision--
	-------------------------------
	prevX = player.x
	prevY = player.y

	MOVE_VEL_X = 0
	MOVE_VEL_Y = 0
	

	MOVE_SPEED = 5
	if love.keyboard.isDown("w") then
		MOVE_VEL_Y = -1
	elseif love.keyboard.isDown("s") then
		MOVE_VEL_Y = 1
	end

	if love.keyboard.isDown("a") then
		MOVE_VEL_X = -1
	elseif love.keyboard.isDown("d") then
		MOVE_VEL_X = 1
	end

	if MOVE_VEL_Y ~= 0 then
        player.y = player.y+(MOVE_SPEED*MOVE_VEL_Y)
        handleVerticalCollision(player)
    end

	if MOVE_VEL_X ~= 0 then
        player.x = player.x+(MOVE_SPEED*MOVE_VEL_X)
        handleHorizontalCollision(player)
    end

   

	
end

function handleHorizontalCollision(entity)
	local leftTile = toGrid(entity.x)
	local rightTile = toGrid(entity.x+entity.width)

	local topTile = toGrid(entity.y)
	local botTile = toGrid(entity.y+entity.height)

	for y = topTile, botTile do
		for x = leftTile, rightTile do
			if map[y][x].collide then
				player.x = player.x + getHorizontalIntersectionDepth(player, map[y][x])
			end
		end
	end
end

function handleVerticalCollision(entity)
	local leftTile = toGrid(entity.x)
	local rightTile = toGrid(entity.x+entity.width)

	local topTile = toGrid(entity.y)
	local botTile = toGrid(entity.y+entity.height)

	for y = topTile, botTile do
		for x = leftTile, rightTile do
			if map[y][x].collide then
				player.y = player.y + getVerticalIntersectionDepth(player, map[y][x])
			end
		end
	end
end

TOLERANCE = 4
function getVerticalIntersectionDepth(player, tile)

	local playerHalfHeight = player.height/2
	local tileHalfHeight = tile.height/2

	local playerCenter = player.y + playerHalfHeight
	local tileCenter = tile.y + tileHalfHeight

	local distanceY = playerCenter - tileCenter
	local minDistanceY = playerHalfHeight + tileHalfHeight

	if math.abs(distanceY) >= minDistanceY then
		return 0
	end

	if distanceY > 0 then
		return minDistanceY - distanceY + TOLERANCE
	else
		return -minDistanceY - distanceY - TOLERANCE
	end
end

function getHorizontalIntersectionDepth(player, tile)
	local playerHalfWidth = player.width/2
	local tileHalfWidth = tile.width/2

	local playerCenter = player.x+playerHalfWidth
	local tileCenter = tile.x+tileHalfWidth

	local distanceX = playerCenter - tileCenter
	local minDistanceX = playerHalfWidth + tileHalfWidth

	if math.abs(distanceX) >= minDistanceX then
		return 0
	end

	if distanceX > 0 then
		return minDistanceX - distanceX + TOLERANCE
	else
		return -minDistanceX - distanceX - TOLERANCE
	end

end


function toGrid(coord)
	return math.ceil(coord/TILE_WIDTH)
end

function love.draw()
	love.graphics.setColor(225,225,225,255)

	for row = 1, table.getn(map) do
		for col = 1, table.getn(map[row]) do

			--Check if collided with
			if map[row][col].isCollidedWith and map[row][col].collide then
				love.graphics.setColor(225,0,0,255)
			elseif map[row][col].isCollidedWith then
				love.graphics.setColor(0,255,0,255)
			else
				love.graphics.setColor(225,225,225,255)
			end

			love.graphics.draw(tilemap, map[row][col].image, map[row][col].col*TILE_WIDTH-TILE_WIDTH, map[row][col].row*TILE_WIDTH-TILE_WIDTH, 0, SCALE_FACTOR, SCALE_FACTOR)
			
			

			love.graphics.rectangle("line", map[row][col].col*TILE_WIDTH-TILE_WIDTH, map[row][col].row*TILE_WIDTH-TILE_WIDTH, TILE_WIDTH, TILE_WIDTH)
		end
	end


	love.graphics.setColor(0,0,225,255)
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

	love.graphics.setColor(0,0,0,255)

end