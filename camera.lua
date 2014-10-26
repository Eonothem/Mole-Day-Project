Camera = class(function(c, x, y, scaleX, scaleY, rotation)
              c.x = x
              c.y = y
              c.scaleX = scaleX
              c.scaleY = scaleY
              c.rotation = rotation
              end)

function Camera:set()
love.graphics.push()
love.graphics.rotate(-self.rotation)
love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
love.graphics.translate(-self.x, -self.y)
end
 
function Camera:unset()
love.graphics.pop()
end
 
function Camera:move(dx, dy)
self.x = self.x + (dx or 0)
self.y = self.y + (dy or 0)
end
 
function Camera:rotate(dr)
self.rotation = self.rotation + dr
end
 
function Camera:scale(sx, sy)
sx = sx or 1
self.scaleX = self.scaleX * sx
self.scaleY = self.scaleY * (sy or sx)
end
 
function Camera:setX(value)
  if self.bounds then
    self.x = math.clamp(value, self.bounds.x1, self.bounds.x2)
  else
  self.x = value
end
end
 
function Camera:setY(value)
if self.bounds then
self.y = math.clamp(value, self.bounds.y1, self.bounds.y2)
else
self.y = value
end
end
 
function Camera:setPosition(x, y)
if x then self:setX(x) end
if y then self:setY(y) end
end
 
function Camera:setScale(sx, sy)
self.scaleX = sx or self.scaleX
self.scaleY = sy or self.scaleY
end
 
function Camera:getBounds()
  return unpack(self.bounds)
end
 
function Camera:setBounds(x1, y1, x2, y2)
self.bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function math.clamp(x, min, max)
  if x < min then
    return min
  elseif x > max then
    return max
  else
    return x
  end
end



