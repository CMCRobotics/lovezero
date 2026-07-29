local lz = require("lovezero")

local game = {}

local box_x = 100
local box_y = 100
local direction = 1

function game.update(dt)
    -- Move the box back and forth
    box_x = box_x + (150 * dt * direction)
    if box_x > 600 or box_x < 100 then
        direction = direction * -1
    end
end

function game.draw()
    -- Fill the screen with a dark blue color (R, G, B)
    lz.screen.fill({0.1, 0.1, 0.2})
    
    -- Draw text at x=50, y=50
    lz.screen.draw.text("Welcome to LoveZero!", {50, 50})
    
    -- Draw an orange rectangle
    lz.screen.draw.rect({box_x, box_y, 100, 100}, {1, 0.5, 0})
end

return game
