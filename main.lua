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
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 },
	       {1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1}}

MOLE_FACT = "A mole is a unit of measurment that is pretty swag."

MOLE_CONVERSATION = {"Hello Solid Mole.", "I see you have collected a mole fact.", "A mole fact?", "Yes indeed a mole fact.", 
"Mole facts are used to get a passing grade in Dr. Heff's class", "Alright, I'll keep that in mind.", "Everybody get up, it's time to slam now We got a real jam goin' down Welcome to the Space Jam Here's your chance, do your dance at the Space Jam, alright"}

MAP_WIDTH = table.getn(int_map[1])*TILE_WIDTH
MAP_HEIGHT = table.getn(int_map)*TILE_WIDTH

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

WORLD_OBJECTS = {}

FONT_SIZE =48

------------------
--PRE GAME STUFF--
------------------

function love.load()
	------------
	--Set Font--
	------------
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
			map[row][col] = newTile
		end
	end

	--------------------
	--Init World Stuff--
	--------------------
	codec = Codec()
	--codec:activate()
	--codec:setText(MOLE_CONVERSATION)
	dialogHandler = TextBox()

	player = createPlayer(77,77)
	player.isSpotted = false
	player:setCodec(codec)

	table.insert(WORLD_OBJECTS, createBadGuy(100,100))
	table.insert(WORLD_OBJECTS, player)
	table.insert(WORLD_OBJECTS, createMoleFact(400,200, MOLE_FACT))
	
end

function createMoleFact(x, y, info)
	return Collectible(x, y, 16, 16, info)
end
 
function createPlayer(x, y)
	return GameObject(x, y, 16, 16, 4, PlayerInputComponent, PlayerPhysicsComponent)
end

function createBadGuy(x,y)
	return Enemy(x,y,16,16,2,PatrolLeftRight,EnemyPhysicsComponent,3)
end

-------------
--MAIN LOOP--
-------------

function love.keypressed(key, isrepeat)
	if key == " " and codec.isRinging then
		codecRing:stop()
		codec.isRinging = false
		codec:activate()
	end

	if key == " " and table.getn(codec.textToRead) > 0 and codec.active then
		--dialogHandler:nextMessage()
		codec:nextLine()
		blip:play()

		if table.getn(codec.textToRead) == 0 then
			codec:deactivate()
		end
	end
end

codecRingImage = love.graphics.newImage("getCall.png")

function love.update(dt)
	------------------
	--Update Objects--
	------------------

	if codec.isRinging then
		codecRing:play()
	end

	if not codec.active then
		numObjects = table.getn(WORLD_OBJECTS)

		for i = 1, numObjects do
			local object = WORLD_OBJECTS[i]
			object:update(dt, map, WORLD_OBJECTS)


			if object.isDead then
				table.remove(WORLD_OBJECTS, i)
			end
		end
	end
	
end

playerCamera = Camera(0,0,1,1,0)
guiCamera = Camera(0,0,1,1,0)
SCALE = .5

function love.draw()
	playerCamera:set()
	playerCamera:setScale(SCALE,SCALE)
	
	for row = 1, table.getn(map) do
		for col = 1, table.getn(map[row]) do
			love.graphics.draw(tilemap, map[row][col].image, map[row][col].col*TILE_WIDTH-TILE_WIDTH, map[row][col].row*TILE_WIDTH-TILE_WIDTH, 0)
		end
	end

	for i = 1, table.getn(WORLD_OBJECTS) do
		love.graphics.setColor(0,255,0,255)
		local object = WORLD_OBJECTS[i]

		if instanceOf(object, Enemy) then
			love.graphics.setColor(255,0,0,225)

			for i = 1, table.getn(object.viewTiles) do
				love.graphics.circle("fill", object.viewTiles[i].x+(TILE_WIDTH/2), object.viewTiles[i].y+(TILE_WIDTH/2), 10, 200)
			end
		elseif instanceOf(object, Collectible) then
			love.graphics.setColor(0,0,255,225)
		end

		love.graphics.rectangle("fill", object.x, object.y, object.width, object.height)


	end

	playerCamera:unset()
	--handleTextBox()
	guiCamera:set()

	if codec.active then
		handleCodec()
	end

	love.graphics.setColor(255,255,255,255)

	if codec.isRinging then
		love.graphics.draw(codecRingImage, (SCREEN_WIDTH/2)-codecRingImage:getWidth()/2, (SCREEN_HEIGHT/6)-codecRingImage:getHeight()/2,0,.8,.8)
	end

	guiCamera:unset()

end

function handleTextBox()
	love.graphics.setColor(255,255,255,255)

	if table.getn(dialogHandler.textQueue) > 0 then
		local string = dialogHandler.textQueue[1]

		if table.getn(dialogHandler.textQueue) > 1 then
			string = string.."..."
		end
		love.graphics.print(string, 0, SCREEN_HEIGHT-FONT_SIZE)
	end
end

codecImage = love.graphics.newImage("codec.png")

function handleCodec()
	love.graphics.setColor(255,255,255,255)
	guiCamera:set()

	love.graphics.draw(codecImage, 0, 0)


	if table.getn(codec.textToRead) > 0 then
		local string = codec.textToRead[1]

		if table.getn(codec.textToRead) > 1 then
			string = string.."..."
		end
		love.graphics.printf(string, 170, 470, 1050,"center")
	end

	guiCamera:unset()
end

--------------
--OTHER JUNK--
--------------

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

Codec = class(function(c)
		c.isRinging = false
		c.active = false
		c.textToRead = {}
		c.text = nil
		end)

function Codec:activate()
	self.active = true
end


function Codec:deactivate()
	self.active = false
end

function Codec:nextLine()
	table.remove(self.textToRead, 1)
end

function Codec:setText(text)
	self.textToRead = text
end
