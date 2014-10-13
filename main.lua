require("tile")
require("class")
require("gameObjects")

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
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1}}



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
	
	player = createPlayer(150,150)
	block = GameObject(60, 200, 128, 32, 0, NullInputComponent)

	
end

function createPlayer(x, y)
	return GameObject(x, y, 32, 32, 5, PlayerInputComponent)
end


function love.update(dt)
	-------------------------------
	--Player Movement & Collision--
	-------------------------------

	
	player:update(dt, map)

	
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
			
		end
	end


	love.graphics.setColor(0,0,225,255)
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", block.x, block.y, block.width, block.height)

	love.graphics.setColor(0,0,0,255)

end