-- Allow require to find 'lovezero' when running `love examples/trivial` from the repo root.
package.path = package.path .. ";./?.lua;./?/init.lua"

local lz = require("lovezero")
local game = require("examples.game")

lz.start(game)
