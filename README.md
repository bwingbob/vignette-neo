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

## Status

Project scaffolding created. Next step: M0 rendering spike on Neo6502.
