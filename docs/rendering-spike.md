# M0 Rendering Spike Notes

## Questions to validate on real Neo6502/Morpheus firmware

1. **Graphics vs console layering**
   - Current MVP uses Graphics API for drawing and Graphics Draw Text for text. It avoids Console Clear Screen to reduce mode-mixing risk.
   - Validate whether Console Read Character works while graphics are displayed as expected.
   - Validate whether console output and graphics layer interfere.

2. **Draw Text behavior**
   - Confirm `Draw Text` (Group 5, Fn 6) uses length-prefixed strings at `Param4,5` and character-cell X/Y at `Param0..3` as documented.
   - Confirm font scale/color behavior with `Set Color`/defaults.

3. **Screen geometry**
   - MVP assumes 320x240 and 40x30 character cells. Confirm on target firmware.
   - Adjust `VIEWPORT_H`/text rows if actual geometry differs.

4. **Asset path**
   - For tile/sprite art, confirm `graphics.gfx` load via File I/O Load File (Group 3, Fn 2) with address `$FFFF`.
   - Evaluate 256-object limit for shared tileset + room scenes.
   - Evaluate Blitter (Group 12) for bitmap regions if needed.

5. **Input/quit behavior**
   - MVP quit currently clears screen and halts. Decide proper return-to-BASIC/reset behavior.

## Observed build status

- `make` builds successfully in dev environment.
- Produces `dist/vignette.neo` (single block, load/exec `$1000`).
- Not yet runtime-validated on Neo6502 emulator/hardware.
