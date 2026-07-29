-- Ensure lovezero is in package path for tests
package.path = package.path .. ";../?.lua;./?.lua"

local passed = 0
local failed = 0

local function assert_eq(a, b, msg)
    if a == b then
        passed = passed + 1
    else
        failed = failed + 1
        print("FAIL: " .. msg .. " (Expected " .. tostring(b) .. ", got " .. tostring(a) .. ")")
    end
end

-- Mock love2d globals
_G.love = {
    graphics = {}
}

local clear_called_with = nil
_G.love.graphics.clear = function(...)
    local args = {...}
    if type(args[1]) == "table" then
        clear_called_with = args[1]
        return true -- mimic success for newer love versions that accept table
    else
        clear_called_with = args
        return true
    end
end

local print_called_with = nil
_G.love.graphics.print = function(t, x, y)
    print_called_with = {t, x, y}
end

local rect_called_with = nil
_G.love.graphics.rectangle = function(mode, x, y, w, h)
    rect_called_with = {mode, x, y, w, h}
end

local original_color = {1, 1, 1, 1}
local current_color = {1, 1, 1, 1}
_G.love.graphics.setColor = function(r, g, b, a)
    current_color = {r, g, b, a}
end
_G.love.graphics.getColor = function()
    return current_color[1], current_color[2], current_color[3], current_color[4]
end

local screen = require("lovezero.screen")

print("Starting LoveZero Screen Tests...\n")

print("Testing screen.fill...")
screen.fill({1, 0.5, 0.2, 1})
assert_eq(clear_called_with[1], 1, "Clear r channel")
assert_eq(clear_called_with[2], 0.5, "Clear g channel")
assert_eq(clear_called_with[3], 0.2, "Clear b channel")

print("Testing screen.draw.text...")
screen.draw.text("Hello", {10, 20})
assert_eq(print_called_with[1], "Hello", "Print text")
assert_eq(print_called_with[2], 10, "Print x")
assert_eq(print_called_with[3], 20, "Print y")

print("Testing screen.draw.rect...")
_G.love.graphics.setColor(1, 1, 1, 1) -- Reset to white
screen.draw.rect({5, 10, 100, 200}, {0.5, 0.5, 0.5, 1})
assert_eq(rect_called_with[1], "fill", "Rect mode")
assert_eq(rect_called_with[2], 5, "Rect x")
assert_eq(rect_called_with[3], 10, "Rect y")
assert_eq(rect_called_with[4], 100, "Rect w")
assert_eq(rect_called_with[5], 200, "Rect h")
assert_eq(current_color[1], 1, "Color should be restored to original r")
assert_eq(current_color[2], 1, "Color should be restored to original g")

print(string.format("\nTests complete: %d passed, %d failed", passed, failed))
if failed > 0 then
    os.exit(1)
else
    os.exit(0)
end
