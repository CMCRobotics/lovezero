-- Allow require to find 'lovezero' when running `retroarch -L lutro_libretro.so examples/lutro_trivial` from the repo root.
package.path = package.path .. ";./?.lua;./?/init.lua"

local lz = require("lovezero")
local game = require("examples.game")

-- In Lutro, games run inside the lutro global object.
-- We define lutro.load to start LoveZero, which hooks into lutro.update and lutro.draw.
function lutro.load()
    lz.start(game)
end
