local lz = require("lovezero")

local game = {}

-- Create our moving actor using the character asset
local character = lz.Actor:new({
    x = 100,
    y = 150,
    image = "examples/assets/alien.png"
})

-- Create a second stationary actor to collide with
local stationary_block = lz.Actor:new({
    x = 300,
    y = 150,
    image = "examples/assets/character_green_idle.png"
})

local direction = 1

local is_colliding = false

function game.update(dt)
    -- Move the character back and forth
    character.x = character.x + (150 * dt * direction)
    if character.x > 500 or character.x < 100 then
        direction = direction * -1
    end

    -- Check for collision between character and block using LoveZero's AABB colliderect API
    is_colliding = character:colliderect(stationary_block)

    if is_colliding then
        stationary_block.image_path = "examples/assets/character_green_hit.png"
    else
        stationary_block.image_path = "examples/assets/character_green_idle.png"
    end

    -- Manually update actor states
    character:update(dt)
    stationary_block:update(dt)
end

function game.draw()
    
    -- Set background color based on collision state:
    -- Dark Red if colliding, Dark Blue otherwise
    local bg_color = is_colliding and {0.4, 0.1, 0.1} or {0.1, 0.1, 0.2}
    lz.screen.fill(bg_color)
    
    -- Draw background text
    lz.screen.draw.text("Welcome to LoveZero!", {50, 50})
    lz.screen.draw.text("The Actors are updated and drawn manually to control display ordering.", {50, 80})
    
    if is_colliding then
        lz.screen.draw.text("COLLISION STATUS: [ ACTIVE - RED BACKGROUND ]", {50, 110})
    else
        lz.screen.draw.text("COLLISION STATUS: [ INACTIVE - BLUE BACKGROUND ]", {50, 110})
    end
    
    -- Draw a white background highlight box behind the stationary block to outline/make it obvious
    lz.screen.draw.rect({
        stationary_block.x - 4,
        stationary_block.y - 4,
        stationary_block.width + 8,
        stationary_block.height + 8
    }, {1, 1, 1, 1})

    -- Manually draw both character actors to control rendering/layering
    stationary_block:draw()
    character:draw()
end

return game
