# LoveZero

LoveZero is a cross-engine framework inspired by Pygame Zero, designed to run seamlessly on [Love2D](https://love2d.org/), [Lutro](https://libretro.com/index.php/api/lutro/), and [Love Potion](https://github.com/lovebrew/lovepotion). It abstracts away boilerplate and engine-specific quirks so you can focus on making games!

## Features
- **Cross-Engine Compatibility:** Automatically detects the underlying engine and hooks into the correct game loop safely.
- **Screen Module:** Pygame Zero-style drawing primitives (`lz.screen.fill`, `lz.screen.draw.rect`, `lz.screen.draw.text`).
- **Clock Module:** Easy timers (`schedule_interval`, `schedule_unique`) and smooth tweening animations (`animate`).
- **Actor Model:** Simple entity management (`lz.Actor`) with automatic image loading and AABB collision.
- **IDE Support:** Fully typed via Sumneko LuaLS (`lovezero.lua` and `.vscode` settings) for robust autocomplete and intellisense.

## Getting Started

Drop the `lovezero/` folder into your project directory. 

### Trivial Example (`main.lua`)

```lua
local lz = require("lovezero")

local x, y = 100, 100

lz.start({
    update = function(dt)
        x = x + (100 * dt)
    end,
    
    draw = function()
        lz.screen.fill({0.1, 0.1, 0.2})
        lz.screen.draw.rect({x, y, 50, 50}, {1, 0.5, 0})
        lz.screen.draw.text("LoveZero Example", {50, 50})
    end
})
```

You can run this project just like any Love2D project:
```bash
love .
```

## Running Tests
LoveZero includes a headless pure-Lua test suite to validate internal logic without needing a graphical environment.
```bash
# Ensure luajit is installed
chmod +x test.sh
./test.sh
```
