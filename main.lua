require("tile")
require("class")
require("gameObjects")
require("camera")

SCALE_FACTOR = .5
TILE_WIDTH = 100*SCALE_FACTOR



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

MOLE_FACT = "A mole is a unit of measurment that is pretty swag."

MAP_WIDTH = table.getn(int_map[1])*TILE_WIDTH
MAP_HEIGHT = table.getn(int_map)*TILE_WIDTH

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

WORLD_OBJECTS = {}

FONT_SIZE =25

function love.load()
	love.window.setMode(SCREEN_WIDTH,SCREEN_HEIGHT)

	love.graphics.setNewFont("novem.ttf", FONT_SIZE)


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

	dialogHandler = TextBox()
	dialogHandler:addText("Hello world!")
	dialogHandler:addText("Disregard!")

	


	player = createPlayer(150,150)
	player:setDialogHandler(dialogHandler)


	table.insert(WORLD_OBJECTS, player)
	table.insert(WORLD_OBJECTS, createMoleFact(400,200, MOLE_FACT))
	
end

function createMoleFact(x, y, info)
	return Collectible(x, y, 32, 32, info)
end
 
function createPlayer(x, y)
	return GameObject(x, y, 32, 32, 5, PlayerInputComponent)
end

function love.update(dt)

	------------------
	--Update Objects--
	------------------

	numObjects = table.getn(WORLD_OBJECTS)

	for i = 1, numObjects do
		local object = WORLD_OBJECTS[i]
		object:update(dt, map, WORLD_OBJECTS)

		if object.isDead then
			table.remove(WORLD_OBJECTS, i)
		end
	end
	
end

function love.keypressed(key, isrepeat)
	if key == " " then
		dialogHandler:nextMessage()
	end
end

TextBox = class(function(t)
		  t.textQueue = {}
		  t.text = nil
		  end)


function TextBox:addText(text)
	table.insert(self.textQueue, text)
end

function TextBox:nextMessage()
	table.remove(self.textQueue, 1)
end



function toGrid(coord)
	return math.ceil(coord/TILE_WIDTH)
end

playerCamera = Camera(0,0,1,1,0)
guiCamera = Camera(0,0,1,1,0)

function love.draw()
	playerCamera:set()
	playerCamera:setPosition((player.x-SCREEN_WIDTH/2)+(player.width/2), (player.y-SCREEN_HEIGHT/2)+(player.height/2))
	playerCamera:setScale()
	--

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

	love.graphics.setColor(0,255,0,255)

	for i = 1, table.getn(WORLD_OBJECTS) do
		local object = WORLD_OBJECTS[i]
		love.graphics.rectangle("fill", object.x, object.y, object.width, object.height)
	end

	playerCamera:unset()

	love.graphics.setColor(255,255,255,255)
	handleTextBox()

	

	---

	--love.graphics.setColor(0,0,0,255)

end

function handleTextBox()
	guiCamera:set()
	if table.getn(dialogHandler.textQueue) > 0 then
		local string = dialogHandler.textQueue[1]

		if table.getn(dialogHandler.textQueue) > 1 then
			string = string.."..."
		end
		love.graphics.print(string, 0, SCREEN_HEIGHT-FONT_SIZE)
	end
	guiCamera:unset()
end