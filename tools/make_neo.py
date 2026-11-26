#!/usr/bin/env python3
"""Pack a raw binary into a Neo6502 .NEO file.

Format (as used by Ozmoo/neo6502 tooling):
  Header: 03 4E 45 4F 00 00 <exec lo> <exec hi>
  Block:  <cont> <load lo> <load hi> <size lo> <size hi> <comment...> 00 <data...>
          cont has bit 7 set if another block follows.
"""
from __future__ import annotations

import argparse
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("input", type=Path, help="Raw binary input")
    ap.add_argument("output", type=Path, help=".NEO output")
    ap.add_argument("--load", type=lambda x: int(x, 0), default=0x1000, help="Load address")
    ap.add_argument("--exec", type=lambda x: int(x, 0), default=0x1000, help="Exec address")
    ap.add_argument("--comment", default="Vignette MVP", help="Block comment")
    args = ap.parse_args()

    data = args.input.read_bytes()
    load = args.load & 0xFFFF
    exec_addr = args.exec & 0xFFFF
    size = len(data) & 0xFFFF

    header = bytes([0x03, ord("N"), ord("E"), ord("O"), 0x00, 0x00, exec_addr & 0xFF, (exec_addr >> 8) & 0xFF])
    block = bytes([
        0x00,  # last block
        load & 0xFF, (load >> 8) & 0xFF,
        size & 0xFF, (size >> 8) & 0xFF,
    ]) + args.comment.encode("ascii", errors="replace") + b"\x00" + data

    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(header + block)
    print(f"Wrote {args.output} ({len(data)} bytes, load=${load:04X}, exec=${exec_addr:04X})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
