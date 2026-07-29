local screen = {}
screen.draw = {}

-- Safely get the graphics module (love.graphics or lutro.graphics)
local function get_graphics()
    if type(lutro) == "table" and type(lutro.graphics) == "table" then
        return lutro.graphics
    elseif type(love) == "table" and type(love.graphics) == "table" then
        return love.graphics
    end
    return nil
end

function screen.fill(color)
    local g = get_graphics()
    if not g then
        print("Warning: Graphics module not available.")
        return
    end

    if type(color) == "table" then
        if g.clear then
            -- Love2D typically uses love.graphics.clear(r, g, b, a)
            if g.clear(color) then
                -- if love.graphics.clear can take a table (newer Love2D versions)
            else
                -- unpack color up to 4 values
                local r = color[1] or color.r or 0
                local g_c = color[2] or color.g or 0
                local b = color[3] or color.b or 0
                local a = color[4] or color.a or 1
                g.clear(r, g_c, b, a)
            end
        else
            print("Warning: clear function not available in graphics module.")
        end
    end
end

function screen.draw.text(text, pos)
    local g = get_graphics()
    if not g then
        print("Warning: Graphics module not available.")
        return
    end

    if g.print then
        local x = pos[1] or pos.x or 0
        local y = pos[2] or pos.y or 0
        g.print(tostring(text), x, y)
    else
        print("Warning: print function not available in graphics module.")
    end
end

function screen.draw.rect(rect, color)
    local g = get_graphics()
    if not g then
        print("Warning: Graphics module not available.")
        return
    end

    if g.rectangle then
        local mode = "fill"
        local x = rect[1] or rect.x or 0
        local y = rect[2] or rect.y or 0
        local w = rect[3] or rect.w or 0
        local h = rect[4] or rect.h or 0

        -- Set color first if provided
        local prev_r, prev_g, prev_b, prev_a
        if color and g.setColor and g.getColor then
            prev_r, prev_g, prev_b, prev_a = g.getColor()
            local r = color[1] or color.r or 1
            local c_g = color[2] or color.g or 1
            local b = color[3] or color.b or 1
            local a = color[4] or color.a or 1
            g.setColor(r, c_g, b, a)
        elseif color and g.setColor then
            local r = color[1] or color.r or 1
            local c_g = color[2] or color.g or 1
            local b = color[3] or color.b or 1
            local a = color[4] or color.a or 1
            g.setColor(r, c_g, b, a)
        end

        g.rectangle(mode, x, y, w, h)

        -- Restore color
        if prev_r and g.setColor then
            g.setColor(prev_r, prev_g, prev_b, prev_a)
        end
    else
        print("Warning: rectangle function not available in graphics module.")
    end
end

return screen
