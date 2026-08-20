-- Allow require to find 'lovezero' when running `retroarch -L lutro_libretro.so examples/lutro_trivial` from the repo root.
package.path = package.path .. ";./?.lua;./?/init.lua"

local lz = require("lovezero")
local game = require("examples.game")

-- In Lutro, games run inside the lutro global object.
-- We define lutro.load to start LoveZero, which hooks into lutro.update and lutro.draw.
function lutro.load()
    print("--- DIAGNOSTICS ---")
    local g = lutro.graphics
    if g then
        print("graphics width:", g.getWidth and g.getWidth() or "nil")
        print("graphics height:", g.getHeight and g.getHeight() or "nil")
        print("graphics.scale:", type(g.scale))
        print("graphics.push:", type(g.push))
        print("graphics.pop:", type(g.pop))
    else
        print("graphics module is nil")
    end
    print("-------------------")
    lz.start(game)
end
