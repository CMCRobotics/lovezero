local Actor = {}
Actor.__index = Actor

local function get_graphics()
    if type(lutro) == "table" and type(lutro.graphics) == "table" then
        return lutro.graphics
    elseif type(love) == "table" and type(love.graphics) == "table" then
        return love.graphics
    end
    return nil
end

local image_cache = {}

function Actor:new(params)
    local obj = {
        x = params.x or 0,
        y = params.y or 0,
        width = params.width or 0,
        height = params.height or 0,
        image_path = params.image,
        image = nil
    }

    if obj.image_path then
        local g = get_graphics()
        if g and g.newImage then
            if not image_cache[obj.image_path] then
                local loaded_img = nil

                -- 1. Try to load the image out-of-sandbox using standard io.open (useful for subdirectories/examples)
                local file = io.open(obj.image_path, "rb")
                if file then
                    local contents = file:read("*a")
                    file:close()
                    if type(love) == "table" and love.filesystem and love.image then
                        local ok1, fileData = pcall(love.filesystem.newFileData, contents, obj.image_path)
                        if ok1 and fileData then
                            local ok2, imageData = pcall(love.image.newImageData, fileData)
                            if ok2 and imageData then
                                local ok3, img = pcall(g.newImage, imageData)
                                if ok3 and img then
                                    loaded_img = img
                                end
                            end
                        end
                    end
                end

                -- 2. Fall back to standard newImage (for in-sandbox / non-Love2D engines)
                if not loaded_img then
                    local success, img = pcall(g.newImage, obj.image_path)
                    if success and img then
                        loaded_img = img
                    end
                end

                if loaded_img then
                    image_cache[obj.image_path] = loaded_img
                end
            end

            obj.image = image_cache[obj.image_path]
            if obj.image then
                if type(obj.image.getWidth) == "function" then
                    obj.width = obj.image:getWidth()
                    obj.height = obj.image:getHeight()
                end
            end
        end
    end

    setmetatable(obj, Actor)
    return obj
end

function Actor:update(dt)
    -- Default empty update
end

function Actor:draw()
    local g = get_graphics()
    if not g then return end
    
    if self.image and g.draw then
        g.draw(self.image, self.x, self.y)
    elseif g.rectangle then
        -- fallback block
        local prev_r, prev_g, prev_b, prev_a
        if g.getColor then
            prev_r, prev_g, prev_b, prev_a = g.getColor()
        end
        if g.setColor then
            g.setColor(1, 0, 1, 1) -- magenta for missing texture
        end
        
        g.rectangle("fill", self.x, self.y, self.width > 0 and self.width or 32, self.height > 0 and self.height or 32)
        
        if prev_r and g.setColor then
            g.setColor(prev_r, prev_g, prev_b, prev_a)
        end
    end
end

function Actor:colliderect(other)
    local w1 = self.width > 0 and self.width or 32
    local h1 = self.height > 0 and self.height or 32
    local w2 = other.width > 0 and other.width or 32
    local h2 = other.height > 0 and other.height or 32
    
    return self.x < other.x + w2 and
           self.x + w1 > other.x and
           self.y < other.y + h2 and
           self.y + h1 > other.y
end

return Actor
