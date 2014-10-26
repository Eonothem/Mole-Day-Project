require("tile")
require("class")
require("gameObjects")
require("camera")
require("audio")

SCALE_FACTOR = 1
TILE_WIDTH = 32*SCALE_FACTOR

CURRENT_SONG = discovery



int_map = {{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,2,2,2},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2,2,2,2,2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,1,1,1,1,1,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,1,12,12,12,12,1,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,1,1,1,12,12,12,1,1,1,1,12,12,12,1,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,12,12,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,12,1,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,1,1,1,1,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,2,2,2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,1,12,12,12,1,2,2,2,2,2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,1,1,1,1,1,2,2,1,12,12,12,1,2,2,2,2,2,1,1,1,1,12,12,12,1,1,1,1,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,2,2,2,1,12,12,12,1,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,1,2,2,2,1,12,12,12,1,2,2,2},
{2,2,2,2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,1,2,1,1,1,12,12,12,1,1,1,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,1,1,1,12,12,12,12,12,12,12,1,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,12,12,12,1,1,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,2},
{2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,2,2,2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,1,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,2,2,2,1,12,12,12,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,1,2,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,2},
{2,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2,1,12,12,12,1,1,1,12,12,12,12,12,12,12,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,13,1,2},
{2,1,12,12,12,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,12,12,12,1,2,1,12,12,12,1,1,1,1,1,1,1,24,12,13,1,2},
{2,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,1,1,12,12,12,1,2,2,2,2,2,1,11,12,13,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,11,12,13,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,11,12,13,1,2},
{2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,2,2,2,2,1,11,12,13,1,2},
{2,1,1,1,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,12,1,2,2,2,2,2,1,11,12,13,1,2},
{2,2,2,2,2,2,2,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,2,2,2,2,2,2,1,1,12,12,12,1,1,1,1,1,1,1,11,12,13,1,2},
{2,2,2,2,2,2,2,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,1,12,12,12,1,2,2,2,2,2,2,2,1,12,12,12,12,7,7,7,7,7,7,21,12,13,1,2},
{2,2,2,2,2,2,2,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,2,2,2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,13,1,2},
{2,2,2,2,2,2,2,1,12,12,12,1,1,1,1,1,12,12,1,1,1,1,1,12,12,12,1,2,2,2,2,2,2,2,1,12,12,12,12,17,17,17,17,17,17,12,12,13,1,2},
{2,2,2,2,2,2,1,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,1,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,11,12,13,1,2},
{2,2,2,2,2,1,1,12,12,12,12,12,1,1,12,12,12,12,12,12,1,1,12,12,12,12,12,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,11,12,13,1,2},
{2,2,2,2,2,1,12,12,12,12,12,12,12,1,12,12,12,12,12,12,1,12,12,12,12,12,12,12,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,2},
{2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,7,7,7,7,7,7,7,7,7,7,7,7,7,11,12,12,12,1,2},
{2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2},
{2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,12,1,2},
{2,2,2,2,2,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2},
{2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}}


MOLE_FACT = "A mole is a unit of measurment that is pretty swag."

MOLE_CONVERSATION = {"Solid Mole, can you read me?", "Loud and clear Colonel Avagrado.", "As you know, Liquid Mole has been gathering various chemistry facts in order to work on his new war machine.", "Yeah, Metal Gear MOL.",
"Your mission is to infeltrate Liquid Mole's base and to retrive these chemistry facts so that Liquid Mole cannot finish his plans.", "Lethal or non-lethal?", "Non-lethal, we don't want any bodies laying around.", "Alright, so just retrive the mole facts and get out of there?",
"Yes. Make sure you are not seen by any of the guards, or it's game over.","The gaurd's line of sight should be visible due to your implanted nanomachines.","If you need more information, contact me on your Moldec.","My frequency is 6.0221","Got it.", "Good luck."}

MAP_WIDTH = table.getn(int_map[1])*TILE_WIDTH
MAP_HEIGHT = table.getn(int_map)*TILE_WIDTH

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

WORLD_OBJECTS = {}

FONT_SIZE =48

PLAY_INTRO = false
PLAY_INTRO_CODEC = false

------------------
--PRE GAME STUFF--
------------------

function love.load()
	if PLAY_INTRO then
		CURRENT_SONG = discovery
	else
		CURRENT_SONG = cavern
	end

	CURRENT_SONG:play()
	------------
	--Set Font--
	------------
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

	player = createPlayer(1030,1480)
	player.isSpotted = false
	player:setCodec(codec)

	

	table.insert(WORLD_OBJECTS, createBadGuy(280,1490,PatrolLeftRight))
	table.insert(WORLD_OBJECTS, createBadGuy(880,362,PatrolLeftRight))

	table.insert(WORLD_OBJECTS, createBadGuy(1065,561,PatrolUpDown))

	table.insert(WORLD_OBJECTS, createBadGuy(967,1123,PatrolSquare))

	table.insert(WORLD_OBJECTS, player)
	--table.insert(WORLD_OBJECTS, createMoleFact(400,200, MOLE_FACT))
	
end

function createMoleFact(x, y, info)
	return Collectible(x, y, 16, 16, info)
end
 
function createPlayer(x, y)
	return GameObject(x, y, 16, 16, 6, PlayerInputComponent, PlayerPhysicsComponent)
end

function createBadGuy(x,y,input)
	return Enemy(x,y,16,16,3,input,EnemyPhysicsComponent,3)
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

			if PLAY_INTRO_CODEC then
				CURRENT_SONG:stop()
				CURRENT_SONG = cavern
				CURRENT_SONG:play()
				PLAY_INTRO_CODEC = false
			end
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

	if not codec.active and not PLAY_INTRO_CODEC then
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
playerCamera:setBounds(0,0,(table.getn(int_map[1])*TILE_WIDTH-SCREEN_WIDTH/2),table.getn(int_map)*TILE_WIDTH-SCREEN_HEIGHT/2)

guiCamera = Camera(0,0,1,1,0)
SCALE = 2

codecRingImage = love.graphics.newImage("getCall.png")
codecRingScale = 1

titleOne = love.graphics.newImage("title1.png")
titleTwo = love.graphics.newImage("title2.png")
titleOneFade = 0
titleTwoFade = 1

fadingIn = true

function love.draw()
	love.graphics.setColor(255,255,255,255)

	playerCamera:set()
	--playerCamera:setPosition((player.x+player.width/2)-SCREEN_WIDTH/4 , (player.y+player.height/2)-SCREEN_HEIGHT/4)
	playerCamera:setScale(SCALE,SCALE)

	
	if not PLAY_INTRO_CODEC and not PLAY_INTRO then
		drawMap()
		drawObjects()
	end
	

	--GUI
	playerCamera:unset()

	guiCamera:set()

	if PLAY_INTRO then
		handleIntro()	
	end

	if codecTimer:getElpasedTime() > 1 then
		playIntroConversation()
		codecTimer:clear()
	end

	if codec.active then
		handleCodec()
	end

	love.graphics.print(player.x..","..player.y,0,0)

	if codec.isRinging then
		love.graphics.setColor(255,255,255, createSineWave(50,255,4,time) )
		love.graphics.draw(codecRingImage, (SCREEN_WIDTH/2)-codecRingImage:getWidth()*codecRingScale/2, (SCREEN_HEIGHT/2)-codecRingImage:getHeight()*codecRingScale/2,0,codecRingScale,codecRingScale)
	end
	guiCamera:unset()
	
end

fadeTime = 1

codecTimer = Timer()

function handleIntro()
	if fadingIn then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(255,255,255,0)
	end

	love.graphics.rectangle("fill",0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
		
	if fadingIn then
		love.graphics.setColor(255,255,255,titleOneFade)
		
		love.graphics.draw(titleOne)

		if fadeIn(titleOneFade) then 
			titleOneFade = titleOneFade + fadeTime
		end
	end

	-------------------------------------

	love.graphics.setColor(255,255,255,titleTwoFade)

	if fadingIn then
		if not fadeIn(titleOneFade) then
				
			if fadeIn(titleTwoFade) then 
				titleTwoFade = titleTwoFade + fadeTime
			else
				fadingIn = false
			end
		end
	else

		if fadeOut(titleTwoFade) then
			titleTwoFade = titleTwoFade - fadeTime
		end
	end

	love.graphics.draw(titleTwo)

	if not fadeOut(titleTwoFade) then
		PLAY_INTRO = false
		PLAY_INTRO_CODEC = true
		codecTimer:start()
	end

	
end




function playIntroConversation()
	codec:setText(MOLE_CONVERSATION)
	codec.isRinging = true
end

function fadeIn(fadeValue)
	return fadeValue < 255
end

function fadeOut(fadeValue)
	return fadeValue > 0
end

--------------------

function createSineWave(min, max, freq, time)
	return ((max-min)/2)*math.sin(time*freq)+(((min+max)/2))
end


function drawMap()
	for row = 1, table.getn(map) do
		for col = 1, table.getn(map[row]) do
			love.graphics.draw(tilemap, map[row][col].image, map[row][col].col*TILE_WIDTH-TILE_WIDTH, map[row][col].row*TILE_WIDTH-TILE_WIDTH, 0)
		end
	end
end

function drawObjects()
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
