; Minimal Neo6502 Morpheus API helpers (ca65)

        .include "neo.inc"
        .export neo_call
        .export neo_wait_cmd
        .export neo_last_error

        .bss
neo_last_error: .res 1

        .code

; neo_call
;   A = group, X = function
;   Params must already be written to NEO_PARAM0..NEO_PARAM7.
;   On return: C clear on success, C set on error; A = error code.
.proc neo_call
        stx NEO_FUNCTION
        sta NEO_COMMAND
        jmp neo_wait_cmd
.endproc

; neo_wait_cmd
;   Polls until NEO_COMMAND == 0.
;   On return: C clear on success, C set on error; A = error code.
.proc neo_wait_cmd
        ldx #$00
        ldy #$00
wait:   lda NEO_COMMAND
        beq done
        dex
        bne wait
        dey
        bne wait
        ; timeout
        lda #$FF
        sta neo_last_error
        sec
        rts
done:   lda NEO_ERROR
        sta neo_last_error
        cmp #NEO_ERR_NONE
        beq ok
        sec
        rts
ok:     clc
        rts
.endproc
