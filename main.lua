local lz = require("lovezero")

-- A trivial example showing LoveZero's screen operations

local box_x = 100
local box_y = 100
local direction = 1

-- We pass our update and draw loops to LoveZero, 
-- and it handles hooking them into the active engine (Love2D, Lutro, etc).
lz.start({
    update = function(dt)
        -- Move the box back and forth
        box_x = box_x + (150 * dt * direction)
        if box_x > 600 or box_x < 100 then
            direction = direction * -1
        end
    end,
    
    draw = function()
        -- Fill the screen with a dark blue color (R, G, B)
        lz.screen.fill({0.1, 0.1, 0.2})
        
        -- Draw text at x=50, y=50
        lz.screen.draw.text("Welcome to LoveZero!", {50, 50})
        
        -- Draw an orange rectangle
        lz.screen.draw.rect({box_x, box_y, 100, 100}, {1, 0.5, 0})
    end
})
