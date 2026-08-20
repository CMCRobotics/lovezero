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

### Nest Integration 3DS Example (`examples/nest_trivial_3ds/main.lua`)

Check out the `examples/nest_trivial_3ds` folder for a basic moving box example running with **Nest** configured to emulate/target a Nintendo 3DS screen.

You can run this example using Love2D from the repository root:
```bash
love examples/nest_trivial_3ds
```

### Nest Integration Switch Example (`examples/nest_trivial_switch/main.lua`)

Check out the `examples/nest_trivial_switch` folder for a basic moving box example running with **Nest** configured to emulate/target a Nintendo Switch screen.

You can run this example using Love2D from the repository root:
```bash
love examples/nest_trivial_switch
```

### Lutro Integration Example (`examples/lutro_trivial/main.lua`)

Check out the `examples/lutro_trivial` folder for a basic example running on **Lutro** (the LÖVE-like libretro core for RetroArch).

#### Setup on a Typical Linux Distribution (e.g., Ubuntu/Debian)

To run Lutro, you will need to install RetroArch and the Lutro libretro core. On typical Debian/Ubuntu-based distributions, install them via `apt`:

```bash
sudo apt update
sudo apt install -y retroarch libretro-lutro
```

#### Running the Lutro Example

We provide a convenient `./lutro` executable wrapper script in the repository root that automatically locates the installed Lutro core on your system and launches the target directory:

```bash
# Set execute permissions on the wrapper if needed
chmod +x ./lutro

# Run the trivial example with Lutro
./lutro examples/lutro_trivial
```

Alternatively, you can launch RetroArch manually and point it to the Lutro core and `main.lua` file:

```bash
retroarch -L /usr/lib/x86_64-linux-gnu/libretro/lutro_libretro.so examples/lutro_trivial/main.lua
```

*Note: Depending on your Linux distribution or installation source, the core might be located at `/usr/lib/libretro/lutro_libretro.so` or `~/.config/retroarch/cores/lutro_libretro.so`.*

#### Headless / CI Testing

For automated testing or headless environments, you can run the Lutro wrapper using virtual framebuffer (`xvfb-run`):

```bash
# Install xvfb if not already present
sudo apt install -y xvfb

# Run the example headlessly
xvfb-run -a ./lutro examples/lutro_trivial
```

## Running Tests
LoveZero includes a headless pure-Lua test suite to validate internal logic without needing a graphical environment.
```bash
# Ensure luajit is installed
chmod +x test.sh
./test.sh
```

## Credits
- Character assets provided by the amazing [Kenney Assets](https://kenney.nl/) from the [New Platformer Pack](https://kenney.nl/assets/new-platformer-pack).
- The sample Lutro font provided by the [Lutro project](https://lutro.libretro.com/).
