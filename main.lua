require("tile")
require("class")
require("gameObjects")
require("camera")
require("audio")

SCALE_FACTOR = 1
TILE_WIDTH = 32*SCALE_FACTOR

CURRENT_SONG = discovery



int_map = {{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29},
{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,29,29,29,29,29,29,1,1,1,1,1,29,29,29},
{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29,29,29,29,29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,1,1,1,1,1,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,1,12,12,12,12,1,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,1,1,1,12,12,12,1,1,1,1,12,12,12,1,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,12,12,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,12,1,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,1,1,1,1,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,29,29,29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,1,12,12,12,1,29,29,29,29,29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,1,1,1,1,1,29,29,1,12,12,12,1,29,29,29,29,29,1,1,1,1,12,12,12,1,1,1,1,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,29,29,29,1,12,12,12,1,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,1,29,29,29,1,12,12,12,1,29,29,29},
{29,29,29,29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,1,29,1,1,1,12,12,12,1,1,1,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,1,1,1,12,12,12,12,12,12,12,1,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,1,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,29,29,29,29,29,1,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,1,12,12,12,1,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,1,29,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,29},
{29,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29,1,12,12,12,1,1,1,12,12,12,12,12,12,12,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,1,12,12,12,1,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,1,29,1,12,12,12,1,1,1,1,1,1,1,12,12,12,1,29},
{29,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,1,1,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29},
{29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29},
{29,1,1,1,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,1,1,1,1,1,1,1,12,12,12,12,1,29,29,29,29,29,1,12,12,12,1,29},
{29,29,29,29,29,29,29,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,29,29,29,29,29,29,1,1,12,12,12,1,1,1,1,1,1,1,12,12,12,1,29},
{29,29,29,29,29,29,29,1,12,12,12,1,1,12,12,12,12,12,12,12,12,1,1,12,12,12,1,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,29,29,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,29,29,1,12,12,12,1,1,1,1,1,12,12,1,1,1,1,1,12,12,12,1,29,29,29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,29,1,1,12,12,12,1,1,1,12,12,12,12,12,12,1,1,1,12,12,12,1,1,29,29,29,29,29,29,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29},
{29,29,29,29,29,1,1,12,12,12,12,12,1,1,12,12,12,12,12,12,1,1,12,12,12,12,12,1,1,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,1,12,12,12,1,29},
{29,29,29,29,29,1,12,12,12,12,12,12,12,1,12,12,12,12,12,12,1,12,12,12,12,12,12,12,1,29,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,12,12,1,29},
{29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29},
{29,29,29,29,29,1,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,1,29,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,29},
{29,29,29,29,29,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29}}



INTRO_CODEC = {"Solid Mole, can you read me?", "Loud and clear Colonel Avogadro.", "As you know, Liquid Mole has been gathering various chemistry facts in order to work on his new war machine.", "Yeah, Metal Gear MOL.",
"Your mission is to infiltrate Liquid Mole's base and to retrieve these chemistry facts so that Liquid Mole cannot finish his plans.", "Lethal or non-lethal?", "Non-lethal, we don't want any bodies lying around.", "Alright, so just retrieve the mole facts and get out of there?",
"Yes. Make sure you are not seen by any of the guards, or it's game over.","The guards'line of sight should be visible due to your implanted nanomachines.","I have no idea why they're snakes though.","If you need more information, contact me on your Moldec.","My frequency is 6.0221","Got it.", "Good luck."}

TNT_FACT = {"Would you look at this… Metal Gear MOL is armed with more nuclear weapons then imaginable.", "Look, it even says here that it has weapons 50 times more powerful than the bomb dropped on Nagasaki.", "That exploded with the power of 20 kilotons of TNT! I don’t want to think about how destructive those will be."
,"According to my calculations, a mole of TNT would be about 227.15 grams.","That gives off as much as 1,102,400 joules! Who knows how much power all those nuclear weapons will produce?”"} 

MISSLE_FACT = {"This seems to be the blueprints for Metal Gear MOL’s AGM-129 cruise missiles.","AGMs are usually attached with a W80 warhead, if I’m not mistaken.","You are correct. Combined with Metal Gear MOL’s bipedal movement, the effect would be devastating."
,"Solid Mole, did you know that it only takes only 35 pounds of uranium-235 to make a nuclear weapon?", "Huh, that would be about 68 moles of uranium-235.", "You did that in your head just now?", "I'm a quick thinker."}

PLUTONIUM_FACT = {"According to these documents, it seems that Metal Gear MOL is powered by plutonium-239.", "Nothing special there Avogadro, most nuclear power comes from plutonium or uranium.", "Solid Mole, did you know that the molar mass of plutonium-239 is 239 grams?"
, "...", "You don't say?", "Uh..."}

URANIUM_FACT = {"Huh. This one is full of details about uranium-235 in Metal Gear MOL…", "Did you know that uranium-235 has a half-life of 713 million years?", "That’s about 2.25 x 10^16 seconds!", "Let me use my mole calculator real quick… that comes out to be about...",
"2.74 x 10^-8 moles of seconds!", "Geez. That’s… quite small"}

ROBOT_FACT = {"Why are there so many briefcases full of facts about uranium?", "I dunno, maybe since everything here is nuclear powered? That could explain it.", "Well then, here’s another fact about uranium. Pure isolated uranium was isolated in 1841, which was the same time I was working on the concept of the mole!"
, "Wait, that means that you’re almost 200 years old!", "Yes, I just secretly cryogenically froze my brain and put it into a robot’s body.", "What!?", "Don't question it."}

END_WORDS = {"Congratulations Solid Mole! You did it!", "Really? That wasn't a fun game. Too short for my tastes.", "Shut up. Its 10:13 right now and I've been working on this for a month.", "Geez, calm down.",
"I'm too tired to put in a proper ending right now, so just click that little X on the window, and don't press space", "What did I just say to you.", "Great now I have to infect your computer with a virus.", "Goodbye"}

MAP_WIDTH = table.getn(int_map[1])*TILE_WIDTH
MAP_HEIGHT = table.getn(int_map)*TILE_WIDTH

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

WORLD_OBJECTS = {}

FONT_SIZE =48

PLAY_INTRO = true
PLAY_INTRO_CODEC = false
GAME_OVER = false

COLLECTED_MOLE_FACTS = 0

COLLECTED_ALL = false
PLAY_OUTRO = false
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
	love.window.setMode(SCREEN_WIDTH,SCREEN_HEIGHT, {vsync = false})

	love.graphics.setNewFont("novem.ttf", FONT_SIZE)

	love.window.setTitle("Molar Gear Solid")
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
	
	resetGame()

		

	
	--table.insert(WORLD_OBJECTS, createMoleFact(400,200, MOLE_FACT))
	
end

function createMoleFact(x, y, info)
	return Collectible(x, y, 16, 16, info)
end
 
function createPlayer(x, y)
	return GameObject(x, y, 16, 16, 32*4, PlayerInputComponent, PlayerPhysicsComponent)
end

function createBadGuy(x,y,input)
	return Enemy(x,y,16,16,32*4,input,EnemyPhysicsComponent,3)
end

function resetGame()
	GAME_OVER = false
	gameOverFade = 0

	WORLD_OBJECTS = {}

	player = createPlayer(1030,1480)
	player:setCodec(codec)

	COLLECTED_MOLE_FACTS = 0


	table.insert(WORLD_OBJECTS, player)
	
	table.insert(WORLD_OBJECTS, createBadGuy(280,1490,PatrolLeftRight))
	table.insert(WORLD_OBJECTS, createBadGuy(880,362,PatrolLeftRight))

	table.insert(WORLD_OBJECTS, createBadGuy(1065,561,PatrolUpDown))
	table.insert(WORLD_OBJECTS, createBadGuy(967,633,PatrolUpDown))
	table.insert(WORLD_OBJECTS, createBadGuy(1423,800,PatrolUpDown))
	table.insert(WORLD_OBJECTS, createBadGuy(1165,1165,PatrolUpDown))
	table.insert(WORLD_OBJECTS, createBadGuy(647,137,PatrolUpDown))
	table.insert(WORLD_OBJECTS, createBadGuy(1483,1087,PatrolUpDown))

	table.insert(WORLD_OBJECTS, createBadGuy(900,933,PatrolSquare))
	table.insert(WORLD_OBJECTS, createBadGuy(100,933,PatrolSquare))
	table.insert(WORLD_OBJECTS, createBadGuy(423,263,PatrolSquare))

	table.insert(WORLD_OBJECTS, createMoleFact(1246,774, TNT_FACT))
	table.insert(WORLD_OBJECTS, createMoleFact(1419,200, MISSLE_FACT))
	table.insert(WORLD_OBJECTS, createMoleFact(884,370, PLUTONIUM_FACT))
	table.insert(WORLD_OBJECTS, createMoleFact(532,1276, URANIUM_FACT))
	table.insert(WORLD_OBJECTS, createMoleFact(439,534, ROBOT_FACT))



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

	if key == " " and GAME_OVER then
		CURRENT_SONG:play()
		resetGame()
	end

end

time = 0

publicDT = 0

function love.update(dt)
	publicDT = dt
	time = time+dt
	------------------
	--Update Objects--
	------------------

	if codec.isRinging then
		codecRing:play()
	end

	if not codec.active and not PLAY_INTRO_CODEC and not GAME_OVER then
		numObjects = table.getn(WORLD_OBJECTS)

		for i = 1, numObjects do
			local object = WORLD_OBJECTS[i]
			object:update(dt, map, WORLD_OBJECTS)


			if object.isDead then
				table.remove(WORLD_OBJECTS, i)
				break
			end
		end


	end
	
	if COLLECTED_MOLE_FACTS == 5 then
		COLLECTED_ALL = true
	end


	if COLLECTED_ALL and (not codec.active and not codec.isRinging) then
		codec:setText(END_WORDS)
		codec.isRinging = true
	end
end

-----

playerCamera = Camera(0,0,1,1,0)
playerCamera:setBounds(0,0,(table.getn(int_map[1])*TILE_WIDTH-SCREEN_WIDTH/2),table.getn(int_map)*TILE_WIDTH-SCREEN_HEIGHT/2)

guiCamera = Camera(0,0,1,1,0)
SCALE =.5

codecRingImage = love.graphics.newImage("getCall.png")
codecRingScale = 1

titleOne = love.graphics.newImage("title1.png")
titleTwo = love.graphics.newImage("title2.png")
titleOneFade = 0
titleTwoFade = 1

fadingIn = true

gameOverScreen = love.graphics.newImage("gameOver.png")
gameOverFade = 0

function love.draw()
	love.graphics.setColor(255,255,255,255)

	playerCamera:set()
	playerCamera:setPosition((player.x+player.width/2)-SCREEN_WIDTH/4 , (player.y+player.height/2)-SCREEN_HEIGHT/4)
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


	if codec.isRinging then
		love.graphics.setColor(255,255,255, createSineWave(50,255,4,time) )
		love.graphics.draw(codecRingImage, (SCREEN_WIDTH/2)-codecRingImage:getWidth()*codecRingScale/2, (SCREEN_HEIGHT/2)-codecRingImage:getHeight()*codecRingScale/2,0,codecRingScale,codecRingScale)
	end

	if GAME_OVER then
		love.graphics.setColor(225,255,255,gameOverFade)

		love.graphics.draw(gameOverScreen)
		if fadeIn(gameOverFade) then
			gameOverFade = gameOverFade + 100*publicDT
		end
	end

	guiCamera:unset()
	
end

fadeTime = 100

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
			titleOneFade = titleOneFade + fadeTime*publicDT
		end
	end

	-------------------------------------

	love.graphics.setColor(255,255,255,titleTwoFade)

	if fadingIn then
		if not fadeIn(titleOneFade) then
				
			if fadeIn(titleTwoFade) then 
				titleTwoFade = titleTwoFade + fadeTime*publicDT
			else
				fadingIn = false
			end
		end
	else

		if fadeOut(titleTwoFade) then
			titleTwoFade = titleTwoFade - fadeTime*publicDT
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
	codec:setText(INTRO_CODEC)
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

spottedImage = love.graphics.newImage("!.png")
cone = love.graphics.newImage("vision.png")

case = love.graphics.newImage("intel.png")
playerGraphic = love.graphics.newImage("moleFlip.png")
snake = love.graphics.newImage("snake.png")
caseRotation = 0

function drawObjects()
	caseRotation = caseRotation+math.pi*publicDT
	for i = 1, table.getn(WORLD_OBJECTS) do
		love.graphics.setColor(0,255,0,255)
		local object = WORLD_OBJECTS[i]

		if instanceOf(object, Enemy) then
			
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(snake, object.x+object.width/2,object.y+object.height/2, 0,.8,.8,snake:getWidth()/2,snake:getHeight()/2)
			if object.spottedPlayer then
				spotScale = .05
				love.graphics.draw(spottedImage, object.x+object.width/2-(spottedImage:getWidth()*spotScale)/2,object.y+object.height/2-(spottedImage:getHeight()*spotScale)/2-30,0,spotScale,spotScale)
			end

			love.graphics.setColor(255,255,255,115)
			love.graphics.draw(cone, (object.x+(object.width/2)), (object.y+(object.height/2)),math.rad(object.angle-90),1,1,cone:getWidth()/2,cone:getHeight())
			love.graphics.setColor(255,0,0,225)

			for i = 1, table.getn(object.viewTiles) do
				--love.graphics.circle("fill", object.viewTiles[i].x+(TILE_WIDTH/2), object.viewTiles[i].y+(TILE_WIDTH/2), 10, 200)

				
			end
		elseif instanceOf(object, Collectible) then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(case, object.x+object.width/2,object.y+object.height/2, caseRotation,1,1,case:getWidth()/2,case:getHeight()/2)
		end

		if object == player then
			love.graphics.setColor(255,255,255,255)
			love.graphics.draw(playerGraphic, object.x+object.width/2, object.y+object.height/2, 0,.5,.5,playerGraphic:getWidth()/2, playerGraphic:getHeight()/2)
		end

		--love.graphics.rectangle("fill", object.x, object.y, object.width, object.height)


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
