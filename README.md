# Vignette

A Neo6502-first illustrated text adventure experiment.

Vignette explores a simple idea: keep the feel of classic parser adventures, but add a small illustration for each location. The initial MVP targets the **Neo6502** as a standalone project.

## MVP Goal

Build a small Neo6502 demo that:

- displays a static illustration for a room/location
- displays room title and description text
- accepts basic navigation/input between a small set of rooms
- loads art from a Neo6502-friendly asset format

**Demo content:** 5-10 hand-picked Zork-like rooms (for example: West of House, North of House, Behind House, Kitchen, Living Room, Cellar).

## Non-goals

- Full Zork I/II/III or a full Z-machine parser
- All 110 locations, puzzles, scoring, inventory, combat, or save/restore
- Stateful/animated room art
- C64/Atari 800XL implementations in the MVP (asset portability only)
- Sound/music, mouse, or sprite-heavy effects
- Integration with Ozmoo

## Planned Direction

- **Rendering strategy:** start with tilemap-based scenes composed from shared 16x16 tiles, using the Neo6502/Morpheus graphics model.
- **Layout spike:** confirm whether graphics and readable room text can coexist cleanly on the same screen.
- **Asset pipeline:** build reproducible tooling to convert master art into Neo graphics assets and room data.

## Build

Requires `ca65`/`ld65` (cc65) and `python3`.

```sh
make
```

Outputs:

- `build/vignette.bin`
- `dist/vignette.neo`

## Status

MVP skeleton built and compiling.

- [x] Project scaffolding
- [x] Neo6502 API helpers
- [x] Room data + primitive scene renderer
- [x] Keyboard navigation loop
- [x] `.neo` packer and Makefile
- [ ] Runtime validation on Neo6502 emulator/hardware
- [ ] Replace primitive scenes with tile/graphics assets
- [ ] Asset pipeline and content pass

See [docs/mvp.md](docs/mvp.md) and [docs/rendering-spike.md](docs/rendering-spike.md).
