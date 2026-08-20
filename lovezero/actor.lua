local Actor = {}

local function get_graphics()
    if type(lutro) == "table" and type(lutro.graphics) == "table" then
        return lutro.graphics
    elseif type(love) == "table" and type(love.graphics) == "table" then
        return love.graphics
    end
    return nil
end

local image_cache = {}

local function load_image(image_path)
    if not image_path then return nil end
    local g = get_graphics()
    if not (g and g.newImage) then return nil end

    if not image_cache[image_path] then
        local loaded_img = nil

        -- 1. Try to load the image out-of-sandbox using standard io.open (useful for subdirectories/examples)
        local file = io.open(image_path, "rb")
        if file then
            local contents = file:read("*a")
            file:close()
            if type(love) == "table" and love.filesystem and love.image then
                local ok1, fileData = pcall(love.filesystem.newFileData, contents, image_path)
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
            local success, img = pcall(g.newImage, image_path)
            if success and img then
                loaded_img = img
            end
        end

        if loaded_img then
            image_cache[image_path] = loaded_img
        end
    end

    return image_cache[image_path]
end

function Actor:new(params)
    local properties = {
        x = params.x or 0,
        y = params.y or 0,
        width = params.width or 0,
        height = params.height or 0,
        image_path = nil,
        image = nil
    }

    local obj = {
        _props = properties
    }

    setmetatable(obj, Actor)

    if params.image then
        obj.image = params.image -- Triggers __newindex to load the image
    end

    return obj
end

function Actor:__index(key)
    -- First check if it's a method in the Actor class
    local class_val = Actor[key]
    if class_val ~= nil then
        return class_val
    end
    -- Otherwise read from properties
    if self._props then
        return self._props[key]
    end
    return nil
end

function Actor:__newindex(key, value)
    if key == "image" or key == "image_path" then
        if type(value) == "string" then
            self._props.image_path = value
            local img = load_image(value)
            self._props.image = img
            if img then
                if type(img.getWidth) == "function" then
                    self._props.width = img:getWidth()
                    self._props.height = img:getHeight()
                end
            end
            return
        end
    end

    if self._props and self._props[key] ~= nil then
        self._props[key] = value
    else
        rawset(self, key, value)
    end
end

function Actor:update(dt)
    -- Default empty update
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

function Actor:draw()
    local g = get_graphics()
    if not g then return end
    
    local sx, sy = get_scales()
    if self.image and g.draw then
        -- Standard LÖVE and Lutro support scale factors (sx, sy) as the 5th and 6th arguments in g.draw.
        g.draw(self.image, self.x * sx, self.y * sy, 0, sx, sy)
    elseif g.rectangle then
        -- fallback block
        local prev_r, prev_g, prev_b, prev_a
        if g.getColor then
            prev_r, prev_g, prev_b, prev_a = g.getColor()
        end
        if g.setColor then
            g.setColor(1, 0, 1, 1) -- magenta for missing texture
        end
        
        local w = (self.width > 0 and self.width or 32) * sx
        local h = (self.height > 0 and self.height or 32) * sy
        g.rectangle("fill", self.x * sx, self.y * sy, w, h)
        
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
