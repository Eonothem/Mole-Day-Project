theme = love.audio.newSource("ninja.mp3")
theme:setVolume(.1)

pickup = love.audio.newSource("pickup.wav", "static")
pickup:setVolume(.3)

blip = love.audio.newSource("blip.wav", "static")
blip:setVolume(.5)