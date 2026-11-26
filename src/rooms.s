; Room data and rendering for Vignette MVP

        .setcpu "65c02"
        .include "neo.inc"

        .import neo_call
        .importzp ptr0
        .export rooms_init
        .export rooms_draw_current
        .export rooms_handle_key

        .zeropage
current_room: .res 1
text_ptr:     .res 2

        .segment "RODATA"

; Room IDs
ROOM_WEST   = 0
ROOM_NORTH  = 1
ROOM_EAST   = 2
ROOM_BEHIND = 3
ROOM_KITCHEN = 4
ROOM_LIVING = 5
ROOM_COUNT  = 6
NO_EXIT     = $FF

; Room table: each entry is 8 bytes
;  name_lo, name_hi, desc_lo, desc_hi, scene, north, east, south, west
; (9 bytes per room for clarity)
room_table:
        ; 0: West of House
        .byte <name_west, >name_west, <desc_west, >desc_west
        .byte SCENE_WEST, ROOM_NORTH, ROOM_NORTH, ROOM_EAST, NO_EXIT
        ; 1: North of House
        .byte <name_north, >name_north, <desc_north, >desc_north
        .byte SCENE_NORTH, NO_EXIT, ROOM_BEHIND, ROOM_WEST, ROOM_WEST
        ; 2: East of House
        .byte <name_east, >name_east, <desc_east, >desc_east
        .byte SCENE_EAST, ROOM_NORTH, NO_EXIT, NO_EXIT, ROOM_WEST
        ; 3: Behind House
        .byte <name_behind, >name_behind, <desc_behind, >desc_behind
        .byte SCENE_BEHIND, NO_EXIT, NO_EXIT, ROOM_EAST, ROOM_NORTH
        ; 4: Kitchen
        .byte <name_kitchen, >name_kitchen, <desc_kitchen, >desc_kitchen
        .byte SCENE_KITCHEN, NO_EXIT, ROOM_LIVING, NO_EXIT, ROOM_BEHIND
        ; 5: Living Room
        .byte <name_living, >name_living, <desc_living, >desc_living
        .byte SCENE_LIVING, NO_EXIT, NO_EXIT, NO_EXIT, ROOM_KITCHEN

SCENE_WEST   = 0
SCENE_NORTH  = 1
SCENE_EAST   = 2
SCENE_BEHIND = 3
SCENE_KITCHEN = 4
SCENE_LIVING = 5

; Length-prefixed strings
name_west:    .byte 13, "West of House"
desc_west:    .byte 38, "You stand by a white house. A path leads N."
name_north:   .byte 14, "North of House"
desc_north:   .byte 37, "The north side of the house faces a forest."
name_east:    .byte 13, "East of House"
desc_east:    .byte 39, "A narrow path runs behind the white house."
name_behind:  .byte 12, "Behind House"
desc_behind:  .byte 39, "A small window is slightly ajar here. E/W."
name_kitchen: .byte 7,  "Kitchen"
desc_kitchen: .byte 36, "A plain kitchen with a table and sack."
name_living:  .byte 11, "Living Room"
desc_living:  .byte 37, "A rug lies before a wooden trophy case."

help_text:    .byte 33, "Keys: N/S/E/W move, L look, Q quit"
prompt_text:  .byte 2, "> "

        .code

rooms_init:
        lda #ROOM_WEST
        sta current_room
        rts

; ------------------------------------------------------------
; rooms_draw_current - draw viewport scene + text for current room
; ------------------------------------------------------------
.proc rooms_draw_current
        jsr clear_text_area
        jsr draw_scene_for_current
        jsr draw_room_text
        jsr draw_prompt
        rts
.endproc

; ------------------------------------------------------------
; rooms_handle_key - A has key
; ------------------------------------------------------------
.proc rooms_handle_key
        cmp #'n'
        beq go_north
        cmp #'N'
        beq go_north
        cmp #'e'
        beq go_east
        cmp #'E'
        beq go_east
        cmp #'s'
        beq go_south
        cmp #'S'
        beq go_south
        cmp #'w'
        beq go_west
        cmp #'W'
        beq go_west
        cmp #'l'
        beq look
        cmp #'L'
        beq look
        cmp #'q'
        beq quit
        cmp #'Q'
        beq quit
        rts
look:
        jmp rooms_draw_current
go_north:
        ldx #5              ; offset to north exit in 9-byte record
        jmp try_move
go_east:
        ldx #6
        jmp try_move
go_south:
        ldx #7
        jmp try_move
go_west:
        ldx #8
        jmp try_move
quit:
        ; MVP quit: clear screen to black and halt.
        lda #COLOR_BLACK
        jsr set_gfx_color
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
        jsr draw_rect
halt:   jmp halt
.endproc

; try_move: X = exit offset within room record
.proc try_move
        stx ptr0            ; temp store offset
        jsr get_room_record_ptr ; sets text_ptr to record base
        ldy ptr0
        lda (text_ptr),y
        cmp #NO_EXIT
        beq no_move
        sta current_room
        jmp rooms_draw_current
no_move:
        rts
.endproc

; get_room_record_ptr -> text_ptr points to current room record
.proc get_room_record_ptr
        lda current_room
        ; multiply by 9
        asl                 ; *2
        asl                 ; *4
        asl                 ; *8
        clc
        adc current_room    ; *9
        clc
        adc #<room_table
        sta text_ptr
        lda #>room_table
        adc #0
        sta text_ptr+1
        rts
.endproc

; clear_text_area - fill bottom text area with black rectangle
.proc clear_text_area
        lda #COLOR_BLACK
        jsr set_gfx_color
        lda #<0
        sta NEO_PARAM0
        lda #>0
        sta NEO_PARAM1
        lda #<160
        sta NEO_PARAM2
        lda #>160
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<239
        sta NEO_PARAM6
        lda #>239
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

; set_gfx_color - A = color
.proc set_gfx_color
        sta NEO_PARAM0
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_SET_COLOR
        jsr neo_call
        rts
.endproc

; draw_rect - params already set, issues Draw Rectangle
.proc draw_rect
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_RECT
        jsr neo_call
        rts
.endproc

; draw_text_at
;   text_ptr = pointer to length-prefixed string
;   A = x char col, X = y char row
.proc draw_text_at
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        stx NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda text_ptr
        sta NEO_PARAM4
        lda text_ptr+1
        sta NEO_PARAM5
        lda #NEO_GRP_GRAPH
        ldx #NEO_FN_GFX_TEXT
        jsr neo_call
        rts
.endproc

; draw_room_text - name on row TEXT_Y, desc on DESC_Y, help on row 28
.proc draw_room_text
        jsr get_room_record_ptr
        ldy #0
        lda (text_ptr),y
        sta ptr0
        iny
        lda (text_ptr),y
        sta ptr0+1
        lda ptr0
        sta text_ptr
        lda ptr0+1
        sta text_ptr+1
        lda #COLOR_WHITE
        jsr set_gfx_color
        lda #2
        ldx #TEXT_Y
        jsr draw_text_at

        jsr get_room_record_ptr
        ldy #2
        lda (text_ptr),y
        sta ptr0
        iny
        lda (text_ptr),y
        sta ptr0+1
        lda ptr0
        sta text_ptr
        lda ptr0+1
        sta text_ptr+1
        lda #COLOR_LTGREY
        jsr set_gfx_color
        lda #2
        ldx #DESC_Y
        jsr draw_text_at

        lda #<help_text
        sta text_ptr
        lda #>help_text
        sta text_ptr+1
        lda #COLOR_DKGREY
        jsr set_gfx_color
        lda #2
        ldx #28
        jsr draw_text_at
        rts
.endproc

; draw_prompt
.proc draw_prompt
        lda #<prompt_text
        sta text_ptr
        lda #>prompt_text
        sta text_ptr+1
        lda #COLOR_YELLOW
        jsr set_gfx_color
        lda #2
        ldx #PROMPT_Y
        jsr draw_text_at
        rts
.endproc

; draw_scene_for_current - dispatch by scene byte in room record
.proc draw_scene_for_current
        jsr get_room_record_ptr
        ldy #4
        lda (text_ptr),y
        cmp #SCENE_WEST
        beq scene_west
        cmp #SCENE_NORTH
        beq scene_north
        cmp #SCENE_EAST
        beq scene_east
        cmp #SCENE_BEHIND
        beq scene_behind
        cmp #SCENE_KITCHEN
        beq scene_kitchen
        cmp #SCENE_LIVING
        beq scene_living
        rts
scene_west:   jmp draw_west
scene_north:  jmp draw_north
scene_east:   jmp draw_east
scene_behind: jmp draw_behind
scene_kitchen:jmp draw_kitchen
scene_living: jmp draw_living
.endproc

; ------------------------------------------------------------
; Scene primitives
; ------------------------------------------------------------

; draw_full_bg: A=color, fills viewport 0,0,319,159
.proc draw_full_bg
        jsr set_gfx_color
        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        sta NEO_PARAM2
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<159
        sta NEO_PARAM6
        lda #>159
        sta NEO_PARAM7
        jmp draw_rect
.endproc

; draw_box: ptr0=x0, ptr0+1=y0 (lo bytes), X=x1 lo, Y=y1 lo, A=color, hi bytes assumed 0/<160
; Simplified helper for small coords (<256). For x1=319, call directly.
.proc draw_box_simple
        jsr set_gfx_color
        lda ptr0
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda ptr0+1
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        stx NEO_PARAM4
        lda #0
        sta NEO_PARAM5
        sty NEO_PARAM6
        lda #0
        sta NEO_PARAM7
        jmp draw_rect
.endproc

.proc draw_west
        lda #COLOR_BLUE
        jsr draw_full_bg
        ; ground
        lda #COLOR_DKGREEN
        jsr set_gfx_color
        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        lda #<110
        sta NEO_PARAM2
        lda #>110
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<159
        sta NEO_PARAM6
        lda #>159
        sta NEO_PARAM7
        jsr draw_rect
        ; house body
        lda #COLOR_WHITE
        jsr set_gfx_color
        lda #<140
        sta NEO_PARAM0
        lda #>140
        sta NEO_PARAM1
        lda #<50
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<260
        sta NEO_PARAM4
        lda #>260
        sta NEO_PARAM5
        lda #<120
        sta NEO_PARAM6
        lda #>120
        sta NEO_PARAM7
        jsr draw_rect
        ; door
        lda #COLOR_BROWN
        jsr set_gfx_color
        lda #<190
        sta NEO_PARAM0
        lda #>190
        sta NEO_PARAM1
        lda #<85
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<210
        sta NEO_PARAM4
        lda #>210
        sta NEO_PARAM5
        lda #<120
        sta NEO_PARAM6
        lda #>120
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

.proc draw_north
        lda #COLOR_BLUE
        jsr draw_full_bg
        ; ground
        lda #COLOR_DKGREEN
        jsr set_gfx_color
        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        lda #<120
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<159
        sta NEO_PARAM6
        lda #>159
        sta NEO_PARAM7
        jsr draw_rect
        ; house wall
        lda #COLOR_LTGREY
        jsr set_gfx_color
        lda #<80
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda #<60
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<240
        sta NEO_PARAM4
        lda #>240
        sta NEO_PARAM5
        lda #<130
        sta NEO_PARAM6
        lda #>130
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

.proc draw_east
        lda #COLOR_CYAN
        jsr draw_full_bg
        lda #COLOR_DKGREEN
        jsr set_gfx_color
        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        lda #<115
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<159
        sta NEO_PARAM6
        lda #>159
        sta NEO_PARAM7
        jsr draw_rect
        ; house side
        lda #COLOR_WHITE
        jsr set_gfx_color
        lda #<40
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda #<45
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<160
        sta NEO_PARAM4
        lda #>160
        sta NEO_PARAM5
        lda #<125
        sta NEO_PARAM6
        lda #>125
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

.proc draw_behind
        lda #COLOR_BLUE
        jsr draw_full_bg
        lda #COLOR_DKGREEN
        jsr set_gfx_color
        lda #0
        sta NEO_PARAM0
        sta NEO_PARAM1
        lda #<115
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<319
        sta NEO_PARAM4
        lda #>319
        sta NEO_PARAM5
        lda #<159
        sta NEO_PARAM6
        lda #>159
        sta NEO_PARAM7
        jsr draw_rect
        ; house back
        lda #COLOR_WHITE
        jsr set_gfx_color
        lda #<90
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda #<40
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<250
        sta NEO_PARAM4
        lda #>250
        sta NEO_PARAM5
        lda #<125
        sta NEO_PARAM6
        lda #>125
        sta NEO_PARAM7
        jsr draw_rect
        ; window
        lda #COLOR_CYAN
        jsr set_gfx_color
        lda #<170
        sta NEO_PARAM0
        lda #>170
        sta NEO_PARAM1
        lda #<60
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<195
        sta NEO_PARAM4
        lda #>195
        sta NEO_PARAM5
        lda #<80
        sta NEO_PARAM6
        lda #>80
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

.proc draw_kitchen
        lda #COLOR_BROWN
        jsr draw_full_bg
        ; table
        lda #COLOR_ORANGE
        jsr set_gfx_color
        lda #<90
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda #<80
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<230
        sta NEO_PARAM4
        lda #>230
        sta NEO_PARAM5
        lda #<130
        sta NEO_PARAM6
        lda #>130
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

.proc draw_living
        lda #COLOR_DKGREY
        jsr draw_full_bg
        ; rug
        lda #COLOR_RED
        jsr set_gfx_color
        lda #<70
        sta NEO_PARAM0
        lda #0
        sta NEO_PARAM1
        lda #<95
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<250
        sta NEO_PARAM4
        lda #>250
        sta NEO_PARAM5
        lda #<140
        sta NEO_PARAM6
        lda #>140
        sta NEO_PARAM7
        jsr draw_rect
        ; trophy case
        lda #COLOR_YELLOW
        jsr set_gfx_color
        lda #<130
        sta NEO_PARAM0
        lda #>130
        sta NEO_PARAM1
        lda #<30
        sta NEO_PARAM2
        lda #0
        sta NEO_PARAM3
        lda #<190
        sta NEO_PARAM4
        lda #>190
        sta NEO_PARAM5
        lda #<90
        sta NEO_PARAM6
        lda #>90
        sta NEO_PARAM7
        jsr draw_rect
        rts
.endproc

