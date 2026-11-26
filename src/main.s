; Vignette - Neo6502 illustrated text adventure MVP
; ca65 / ld65

        .setcpu "65c02"
        .include "neo.inc"

        .import neo_call
        .import rooms_init
        .import rooms_draw_current
        .import rooms_handle_key
        .import input_read_char_blocking

        .exportzp ptr0

        .zeropage
ptr0:   .res 2

        .segment "CODE"

        .export start
start:
        cld
        ldx #$FF
        txs

        jsr gfx_init
        jsr rooms_init
        jsr rooms_draw_current

main_loop:
        jsr input_read_char_blocking
        jsr rooms_handle_key
        jmp main_loop

; gfx_init - set defaults and clear screen via graphics
gfx_init:
        ; Graphics defaults: And=0, Or=0, Fill=1, Extent=0, Flip=0
        lda #0
        sta NEO_PARAM0      ; and
        sta NEO_PARAM1      ; or
        lda #1
        sta NEO_PARAM2      ; fill
        lda #0
        sta NEO_PARAM3      ; extent
        sta NEO_PARAM4      ; flip
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_DEFAULTS
        jsr neo_call

        ; Set draw size/solid for text/images
        lda #1
        sta NEO_PARAM0
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_SET_SIZE
        jsr neo_call
        lda #1
        sta NEO_PARAM0
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_SET_SOLID
        jsr neo_call

        ; Clear full screen to black
        lda #COLOR_BLACK
        sta NEO_PARAM0
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_SET_COLOR
        jsr neo_call

        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        sta NEO_PARAM2
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<239
        sta NEO_PARAM6
        lda #>239
        sta NEO_PARAM7
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_RECT
        jsr neo_call
        rts
