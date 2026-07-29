local LoveZero = {}

LoveZero._VERSION = "0.1.0"

-- Engine detection
if type(lutro) == "table" then
    LoveZero.engine = "lutro"
elseif _OS == "Nintendo Switch" or _OS == "Nintendo 3DS" or type(love) == "table" and (love._console_name or love._version == "11.4") then -- Simple check for common lovepotion variables
    LoveZero.engine = "lovepotion"
else
    LoveZero.engine = "love2d"
end

-- Submodules
LoveZero.screen = require("lovezero.screen")
LoveZero.clock = require("lovezero.clock")
LoveZero.Actor = require("lovezero.actor")

-- Active Actors
LoveZero.actors = {}

function LoveZero.add(actor)
    table.insert(LoveZero.actors, actor)
end

-- Game loop mechanism
LoveZero.callbacks = {
    update = function(dt) end,
    draw = function() end
}

function LoveZero.start(callbacks)
    if callbacks then
        if type(callbacks.update) == "function" then
            LoveZero.callbacks.update = callbacks.update
        end
        if type(callbacks.draw) == "function" then
            LoveZero.callbacks.draw = callbacks.draw
        end
    end

    -- Hook into the engine's update/draw loop
    if LoveZero.engine == "lutro" and type(lutro) == "table" then
        local old_update = lutro.update
        lutro.update = function(dt)
            if old_update then old_update(dt) end
            LoveZero.clock.update(dt)
            for _, actor in ipairs(LoveZero.actors) do
                if actor.update then actor:update(dt) end
            end
            LoveZero.callbacks.update(dt)
        end

        local old_draw = lutro.draw
        lutro.draw = function()
            if old_draw then old_draw() end
            for _, actor in ipairs(LoveZero.actors) do
                if actor.draw then actor:draw() end
            end
            LoveZero.callbacks.draw()
        end
    elseif type(love) == "table" then
        local old_update = love.update
        love.update = function(dt)
            if old_update then old_update(dt) end
            LoveZero.clock.update(dt)
            for _, actor in ipairs(LoveZero.actors) do
                if actor.update then actor:update(dt) end
            end
            LoveZero.callbacks.update(dt)
        end

        local old_draw = love.draw
        love.draw = function()
            if old_draw then old_draw() end
            for _, actor in ipairs(LoveZero.actors) do
                if actor.draw then actor:draw() end
            end
            LoveZero.callbacks.draw()
        end
    end
end

return LoveZero
