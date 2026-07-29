-- Allow require to find 'lovezero' and 'nest' when running `love examples/nest_trivial_switch` from the repo root.
package.path = package.path .. ";./?.lua;./?/init.lua;./nest/?.lua;./nest/?/init.lua"

-- Initialize nest for Switch testing
require("nest").init({console = "switch", scale=1})

local lz = require("lovezero")
local game = require("examples.game")

lz.start(game)
