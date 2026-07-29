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

### Trivial Example (`examples/trivial/main.lua`)

Check out the `examples/trivial` folder for a basic moving box example. 

You can run this example using Love2D from the repository root:
```bash
love examples/trivial
```

### Nest Integration Example (`examples/nest_trivial/main.lua`)

Check out the `examples/nest_trivial` folder for a basic moving box example running with **Nest** (useful for console emulators/hardware targeting Nintendo 3DS).

You can run this example using Love2D from the repository root:
```bash
love examples/nest_trivial
```

## Running Tests
LoveZero includes a headless pure-Lua test suite to validate internal logic without needing a graphical environment.
```bash
# Ensure luajit is installed
chmod +x test.sh
./test.sh
```
