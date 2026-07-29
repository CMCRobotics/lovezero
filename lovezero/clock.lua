local clock = {}

local timers = {}
local animations = {}

-- Schedule a function to be called repeatedly every `interval` seconds
function clock.schedule_interval(func, interval)
    table.insert(timers, {
        func = func,
        interval = interval,
        timer = interval,
        repeatable = true
    })
end

-- Schedule a function to be called once after `delay` seconds
function clock.schedule_unique(func, delay)
    table.insert(timers, {
        func = func,
        interval = delay,
        timer = delay,
        repeatable = false
    })
end

-- Tween numeric properties on a target table over `duration` seconds
function clock.animate(target, duration, properties)
    local anim = {
        target = target,
        duration = duration,
        timer = 0,
        props = {}
    }
    
    for k, v in pairs(properties) do
        if type(target[k]) == "number" and type(v) == "number" then
            anim.props[k] = {
                start = target[k],
                target = v,
                delta = v - target[k]
            }
        end
    end
    
    table.insert(animations, anim)
end

-- Process timers and animations
function clock.update(dt)
    -- Update timers
    for i = #timers, 1, -1 do
        local t = timers[i]
        t.timer = t.timer - dt
        if t.timer <= 0 then
            t.func()
            if t.repeatable then
                t.timer = t.timer + t.interval
            else
                table.remove(timers, i)
            end
        end
    end

    -- Update animations
    for i = #animations, 1, -1 do
        local anim = animations[i]
        anim.timer = anim.timer + dt
        
        local progress = anim.timer / anim.duration
        if progress >= 1 then
            progress = 1
        end
        
        for k, prop in pairs(anim.props) do
            -- Linear interpolation
            anim.target[k] = prop.start + (prop.delta * progress)
        end
        
        if progress >= 1 then
            table.remove(animations, i)
        end
    end
end

return clock
