-- Ensure lovezero is in package path for tests
package.path = package.path .. ";../?.lua;./?.lua"

local clock = require("lovezero.clock")
local Actor = require("lovezero.actor")

print("Starting LoveZero Tests...\n")
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

local function assert_true(a, msg)
    if a then
        passed = passed + 1
    else
        failed = failed + 1
        print("FAIL: " .. msg)
    end
end

local function assert_false(a, msg)
    if not a then
        passed = passed + 1
    else
        failed = failed + 1
        print("FAIL: " .. msg)
    end
end

-- 1. Test Clock Interval Triggers
print("Testing Clock Intervals...")
local trigger_count = 0
clock.schedule_interval(function() trigger_count = trigger_count + 1 end, 1.0)
clock.update(0.5)
assert_eq(trigger_count, 0, "Timer should not trigger at 0.5s")
clock.update(0.6)
assert_eq(trigger_count, 1, "Timer should trigger after passing 1.0s (total 1.1s)")
clock.update(1.0)
assert_eq(trigger_count, 2, "Timer should trigger again after passing another 1.0s")

-- 2. Test Clock Unique Triggers
print("Testing Clock Unique Delay...")
local unique_triggered = false
clock.schedule_unique(function() unique_triggered = true end, 2.0)
clock.update(1.0)
assert_false(unique_triggered, "Unique timer should not trigger yet")
clock.update(1.1)
assert_true(unique_triggered, "Unique timer should trigger after 2.0s")
clock.update(2.0)
-- Just checking it doesn't crash on further updates

-- 3. Test Clock Animations / Tweens
print("Testing Clock Animations...")
local target = { x = 0, y = 10 }
clock.animate(target, 2.0, { x = 100, y = 50 })
clock.update(1.0) -- Halfway
assert_eq(target.x, 50, "Tween x should be 50 at halfway")
assert_eq(target.y, 30, "Tween y should be 30 at halfway")
clock.update(1.5) -- Over duration (total 2.5s)
assert_eq(target.x, 100, "Tween x should cap at 100")
assert_eq(target.y, 50, "Tween y should cap at 50")

-- 4. Test Actor Collisions
print("Testing Actor Collisions...")
local a1 = Actor:new({ x = 10, y = 10, width = 20, height = 20 })
local a2 = Actor:new({ x = 15, y = 15, width = 20, height = 20 })
local a3 = Actor:new({ x = 50, y = 50, width = 20, height = 20 })

assert_true(a1:colliderect(a2), "A1 should collide with A2")
assert_true(a2:colliderect(a1), "A2 should collide with A1")
assert_false(a1:colliderect(a3), "A1 should NOT collide with A3")

print(string.format("\nTests complete: %d passed, %d failed", passed, failed))
if failed > 0 then
    os.exit(1)
else
    os.exit(0)
end
