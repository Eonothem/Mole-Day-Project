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

MOLE_CONVERSATION = {"Solid Mole, can you read me?", "Loud and clear Colonel Avagrado.", "Okay. As you know, Liquid Mole has been gathering various chemistry facts in order to work on his new war machine.", "Yeah, Metal Gear MOL.",
"Your mission is to infeltrate Liquid Mole's base and to retrive these chemistry facts so that Liquid Mole cannot finish his plans.", "Lethal or non-lethal?", "Non-lethal, we don't want any bodies laying around.", "Alright, so just retrive the mole facts and get out of there?",
"Yes. Make sure you are not seen by any of the guards, or it's game over.","The gaurd's line of sight should be visible due to your implanted nanomachines.","If you need more information, contact me on your Moldec.","My frequency is 6.0221","Got it.", "Good luck."}

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
	
	if key == " " and table.getn(codec.textToRead) > 0 and codec.active and not codec.isRinging then
		codec:nextLine()
		blip:play()

		if table.getn(codec.textToRead) == 0 then
			codec:deactivate()
		end
	end

	if key == " " and codec.isRinging then
		codecRing:stop()
		codec.isRinging = false
		codec:activate()
	end

end

time = 0
function love.update(dt)
	time = time+dt
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

-----

playerCamera = Camera(0,0,1,1,0)
guiCamera = Camera(0,0,1,1,0)
SCALE = .5

codecRingImage = love.graphics.newImage("getCall.png")

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

love.graphics.setColor(11,38,33,255)
love.graphics.setColor(102,163,150,255)



codecImage = love.graphics.newImage("moledec2.png")

function handleCodec()
	love.graphics.setColor(11,38,33,255)
	love.graphics.rectangle("fill",200,0,1000,500)
	love.graphics.setColor(102,163,150,255)

	love.graphics.rectangle("fill",200,(70*math.sin(3*time)+180),1000,500)
	love.graphics.setColor(255,255,255,255)
	guiCamera:set()

	love.graphics.draw(codecImage, 0, 0)


	if table.getn(codec.textToRead) > 0 then
		local string = codec.textToRead[1]

		if table.getn(codec.textToRead) > 1 then
			string = string
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
