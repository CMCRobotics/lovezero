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
            if type(lutro) == "table" then
                -- Lutro's graphics.clear does not take any arguments.
                -- We can set background color (if setBackgroundColor exists) and clear, or just call clear()
                if g.setBackgroundColor then
                    local r = color[1] or color.r or 0
                    local g_c = color[2] or color.g or 0
                    local b = color[3] or color.b or 0
                    local a = color[4] or color.a or 1
                    g.setBackgroundColor(r, g_c, b, a)
                end
                g.clear()
            else
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
            end
        else
            print("Warning: clear function not available in graphics module.")
        end
    end
end

local function get_scales()
    local g = get_graphics()
    if g and g.getWidth and g.getHeight then
        local w, h = g.getWidth(), g.getHeight()
        -- Default design/virtual resolution is 800x600.
        -- Use uniform scaling (minimum factor) to preserve the aspect ratio and prevent squashing/stretching.
        if w > 0 and h > 0 then
            local scale = math.min(w / 800, h / 600)
            return scale, scale
        end
    end
    return 1, 1
end

local default_font = nil

local function ensure_lutro_font()
    local g = get_graphics()
    if g and type(lutro) == "table" and not default_font then
        if g.newImageFont then
            -- Standard glyphs string
            local glyphs = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;=~_"
            local ok, font = pcall(g.newImageFont, "font.png", glyphs)
            if ok and font then
                default_font = font
                g.setFont(font)
            end
        end
    end
end

function screen.draw.text(text, pos)
    local g = get_graphics()
    if not g then
        print("Warning: Graphics module not available.")
        return
    end

    ensure_lutro_font()

    if g.print then
        local sx, sy = get_scales()
        local x = (pos[1] or pos.x or 0) * sx
        local y = (pos[2] or pos.y or 0) * sy
        -- In Lutro, g.print throws an error if no font has been explicitly set.
        -- We run g.print inside pcall to safely capture any font/printing errors.
        pcall(g.print, tostring(text), x, y)
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
        local sx, sy = get_scales()
        local x = (rect[1] or rect.x or 0) * sx
        local y = (rect[2] or rect.y or 0) * sy
        local w = (rect[3] or rect.w or 0) * sx
        local h = (rect[4] or rect.h or 0) * sy

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
