# Vignette MVP Scope

## Goal

Build a small Neo6502 demo that displays a static illustration for a room, shows title/description text, and accepts basic navigation input between a small set of rooms.

## Current MVP (skeleton)

The initial build in `src/` implements:

- Neo6502 Morpheus API helpers (`src/api.s`)
- Graphics initialization and full-screen drawing via Graphics group (Group 5)
- Simple room table with 6 Zork-like rooms (`src/rooms.s`)
- Primitive scene rendering (colored rectangles) per room
- Text rendering via `Graphics Draw Text` (Group 5, Fn 6)
- Blocking keyboard input via `Console Read Character` (Group 2, Fn 1)
- Navigation keys: `N`, `E`, `S`, `W`, `L` (look), `Q` (quit)

## Build

```sh
make
```

Outputs:

- `build/vignette.bin` - raw binary
- `dist/vignette.neo` - Neo6502 executable (load/exec `$1000`)

## Run

Copy `dist/vignette.neo` to Neo6502 storage and load it. On emulator/hardware with Morpheus firmware, load the `.neo` file through the normal Neo launcher flow.

> Note: This MVP has been compiled in CI/dev environment but not yet validated on Neo6502 emulator/hardware in this session.

## Next steps

1. Validate on Neo6502 emulator/hardware.
2. Confirm graphics/console text coexistence behavior on target firmware.
3. Replace primitive rectangle scenes with tilemap/graphics.gfx assets.
4. Add asset pipeline (`tools/build_gfx.py`, room data compiler).
5. Expand to 5-10 polished rooms.
