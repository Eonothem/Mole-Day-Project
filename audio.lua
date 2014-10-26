discovery = love.audio.newSource("discovery.mp3")
discovery:setVolume(.1)

cavern = love.audio.newSource("cavern.mp3")
cavern:setVolume(.1)

pickup = love.audio.newSource("pickup.wav", "static")
pickup:setVolume(.3)

blip = love.audio.newSource("blip.wav", "static")
blip:setVolume(.5)

alert = love.audio.newSource("alert.wav", "static")

gameOver = love.audio.newSource("gameOver.mp3", "static")

codecRing = love.audio.newSource("codec.wav")
codecRing:setVolume(.4)