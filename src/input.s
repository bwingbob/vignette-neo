; Keyboard input helpers (Neo6502 console)

        .setcpu "65c02"
        .include "neo.inc"
        .import neo_call
        .export input_read_char_blocking

        .code

; input_read_char_blocking
; Returns ASCII key in A. Blocks until a key is available.
.proc input_read_char_blocking
loop:
        lda #NEO_GRP_CONSOLE
        ldx #NEO_FN_READ_CHAR
        jsr neo_call
        bcs loop
        lda NEO_PARAM0
        beq loop
        rts
.endproc
