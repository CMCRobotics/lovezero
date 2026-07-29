local lz = require("lovezero")

local game = {}

-- Create our actor using the character asset
local character = lz.Actor:new({
    x = 50,
    y = 100,
    image = "examples/assets/alien.png"
})

local direction = 1

function game.update(dt)
    -- Move the character back and forth
    character.x = character.x + (150 * dt * direction)
    if character.x > 200 or character.x < 50 then
        direction = direction * -1
    end

    -- Manually update the actor state
    character:update(dt)
end

function game.draw()
    -- Fill the screen with a dark blue color (R, G, B)
    lz.screen.fill({0.1, 0.1, 0.2})
    
    -- Draw background text first
    lz.screen.draw.text("Welcome to LoveZero!", {30, 30})
    lz.screen.draw.text("The Actor is updated and drawn.", {30, 50})
    
    -- Manually draw the character actor to guarantee it renders on top of the text
    character:draw()
end

return game
