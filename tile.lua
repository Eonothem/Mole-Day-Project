require("class")
TILE_WIDTH = 32
TILE_REAL_WIDTH = 34

tilemap = love.graphics.newImage("tilemap34.png")


function colToX(col)
	return (col*TILE_REAL_WIDTH)+1
end


stone = love.graphics.newQuad(colToX(0),0,TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
grass = love.graphics.newQuad(colToX(1),0,TILE_WIDTH, TILE_WIDTH, tilemap:getDimensions())
dirt = love.graphics.newQuad(colToX(2),0,TILE_WIDTH,TILE_WIDTH, tilemap:getDimensions())


Tile = class(function(t)
			t.isCollidedWith = false
		end)

function Tile:new(id)


	if id == 0 then
		self.image = grass
		self.collide = false
	elseif id == 1 then
		self.image = stone
		self.collide = true
	elseif id == 2 then
		self.image = dirt
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