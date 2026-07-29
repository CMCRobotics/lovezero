---@meta

---@class LoveZero
---@field engine string Current detected engine (love2d, lutro, lovepotion)
---@field screen LoveZero.Screen
---@field clock LoveZero.Clock
---@field Actor LoveZero.ActorClass
local lz = {}

---@class LoveZero.ScreenDraw
local ScreenDraw = {}
---@param text string|number
---@param pos {x?: number, y?: number, [1]?: number, [2]?: number}
function ScreenDraw.text(text, pos) end

---@param rect {x?: number, y?: number, w?: number, h?: number, [1]?: number, [2]?: number, [3]?: number, [4]?: number}
---@param color? {r?: number, g?: number, b?: number, a?: number, [1]?: number, [2]?: number, [3]?: number, [4]?: number}
function ScreenDraw.rect(rect, color) end

---@class LoveZero.Screen
---@field draw LoveZero.ScreenDraw
local Screen = {}
---@param color {r?: number, g?: number, b?: number, a?: number, [1]?: number, [2]?: number, [3]?: number, [4]?: number}
function Screen.fill(color) end

---@class LoveZero.Clock
local Clock = {}
---@param func function
---@param interval number
function Clock.schedule_interval(func, interval) end
---@param func function
---@param delay number
function Clock.schedule_unique(func, delay) end
---@param target table
---@param duration number
---@param properties table
function Clock.animate(target, duration, properties) end

---@class LoveZero.Actor
---@field x number
---@field y number
---@field width number
---@field height number
---@field image any
local Actor = {}
---@param dt number
function Actor:update(dt) end
function Actor:draw() end
---@param other LoveZero.Actor
---@return boolean
function Actor:colliderect(other) end

---@class LoveZero.ActorClass
local ActorClass = {}
---@param params {x?: number, y?: number, width?: number, height?: number, image?: string}
---@return LoveZero.Actor
function ActorClass:new(params) end

---@param actor LoveZero.Actor
function lz.add(actor) end

---@param callbacks? {update?: function, draw?: function}
function lz.start(callbacks) end

return lz
