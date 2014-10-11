require("class")

tilemap = love.graphics.newImage("tilemap.png")

stone = love.graphics.newQuad(0,0,100,100, tilemap:getDimensions())
grass = love.graphics.newQuad(100,0,100,100, tilemap:getDimensions())
dirt = love.graphics.newQuad(200,0,100,200, tilemap:getDimensions())


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