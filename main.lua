require("tile")
require("class")
require("gameObjects")
require("camera")
require("audio")

SCALE_FACTOR = 1
TILE_WIDTH = 32*SCALE_FACTOR



int_map = {{1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 }, 
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,2 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
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
	theme:play()
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
	return Collectible(x, y, 16, 16, info)
end
 
function createPlayer(x, y)
	return GameObject(x, y, 16, 16, 4, PlayerInputComponent)
end

function love.update(dt)
	------------------
	--Update Objects--
	------------------

	numObjects = table.getn(WORLD_OBJECTS)
	player:castRay(45)

	for i = 1, numObjects do
		local object = WORLD_OBJECTS[i]
		object:update(dt, map, WORLD_OBJECTS)


		if object.isDead then
			table.remove(WORLD_OBJECTS, i)
		end
	end
	
end

----------

function love.keypressed(key, isrepeat)
	if key == " " then
		dialogHandler:nextMessage()
		blip:play()
	end
end

----------


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
SCALE = .5



function love.draw()
	playerCamera:set()
	playerCamera:setScale(SCALE,SCALE)
	--



	--

	for row = 1, table.getn(map) do
		for col = 1, table.getn(map[row]) do
			love.graphics.draw(tilemap, map[row][col].image, map[row][col].col*TILE_WIDTH-TILE_WIDTH, map[row][col].row*TILE_WIDTH-TILE_WIDTH, 0)
		end
	end

	--

	love.graphics.setColor(225,225,225,255)
	love.graphics.line(player.x,player.y, player.aX, player.aY)
		print(player.aY)


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