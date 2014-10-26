require("class")
TILE_WIDTH = 32
TILE_REAL_WIDTH = 34

tilemap = love.graphics.newImage("tileCor.png")


function colToX(col)
	return (col*TILE_REAL_WIDTH)+1
end

function rowToY(row)
	return (row*TILE_REAL_WIDTH)+1
end

stone = love.graphics.newQuad(colToX(0),0,TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
grass = love.graphics.newQuad(colToX(1),0,TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
dirt = love.graphics.newQuad(colToX(2),0,TILE_WIDTH,TILE_WIDTH, tilemap:getDimensions())

topLeftFloor = love.graphics.newQuad(colToX(0),rowToY(1),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
topCenterFloor = love.graphics.newQuad(colToX(1),rowToY(1),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
topRightFloor = love.graphics.newQuad(colToX(2),rowToY(1),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())

midLeftFloor = love.graphics.newQuad(colToX(0),rowToY(2),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
midCenterFloor = love.graphics.newQuad(colToX(1),rowToY(2),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
midRightFloor = love.graphics.newQuad(colToX(2),rowToY(2),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())

botLeftFloor = love.graphics.newQuad(colToX(0),rowToY(3),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
botCenterFloor = love.graphics.newQuad(colToX(1),rowToY(3),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
botRightFloor = love.graphics.newQuad(colToX(2),rowToY(3),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())

floorCornerTopLeft = love.graphics.newQuad(colToX(0),rowToY(4),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
floorCornerBotRight = love.graphics.newQuad(colToX(1),rowToY(4),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
floorCornerTopRight = love.graphics.newQuad(colToX(2),rowToY(4),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
floorCornerBotLeft = love.graphics.newQuad(colToX(3),rowToY(4),TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())


Tile = class(function(t)
			t.isCollidedWith = false
		end)

function Tile:new(id)
	self.id = id

	if id == 1 then
		self.image = stone
		self.collide = true
	elseif id == 2 then
		self.image = grass
		self.collide = false
	elseif id == 3 then
		self.image = dirt
		self.collide = false
	elseif id == 6 then
		self.image = topLeftFloor
		self.collide = false
	elseif id == 7 then
		self.image = topCenterFloor
		self.collide = false
	elseif id == 8 then
		self.image = topRightFloor
		self.collide = false
	elseif id == 11 then
		self.image = midLeftFloor
		self.collide = false
	elseif id == 12 then
		self.image = midCenterFloor
		self.collide = false
	elseif id == 13 then
		self.image = midRightFloor
		self.collide = false
	elseif id == 16 then
		self.image = botLeftFloor
		self.collide = false
	elseif id == 17 then
		self.image = botCenterFloor
		self.collide = false
	elseif id == 18 then
		self.image = botRightFloor
		self.collide = false
	elseif id == 21 then
		self.image = floorCornerTopLeft
		self.collide = false
	elseif id == 22 then
		self.image = floorCornerBotRight
		self.collide = false
	elseif id == 23 then
		self.image = floorCornerTopRight
		self.collide = false
	elseif id == 24 then
		self.image = floorCornerBotLeft
		self.collide = false
	end
	
	
	
end

function Tile:setGrid(row,col)
	self.row = row
	self.col = col
end

function Tile:setXY(tile_width)
	self.x = (self.col-1)*tile_width
	self.y = (self.row-1)*tile_width
	self.width = tile_width
	self.height = tile_width
end