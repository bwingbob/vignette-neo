; Neo6502 Morpheus API constants for Vignette (ca65)
; Reference: https://neo6502.com/reference/api-listing

; API registers
NEO_COMMAND   = $FF00
NEO_FUNCTION  = $FF01
NEO_ERROR     = $FF02
NEO_STATUS    = $FF03
NEO_PARAM0    = $FF04
NEO_PARAM1    = $FF05
NEO_PARAM2    = $FF06
NEO_PARAM3    = $FF07
NEO_PARAM4    = $FF08
NEO_PARAM5    = $FF09
NEO_PARAM6    = $FF0A
NEO_PARAM7    = $FF0B

; Groups
NEO_GRP_SYSTEM  = $01
NEO_GRP_CONSOLE = $02
NEO_GRP_FILE    = $03
NEO_GRP_GRAPH   = $05

; Console functions
NEO_FN_READ_CHAR    = $01
NEO_FN_CON_STATUS   = $02
NEO_FN_WRITE_CHAR   = $06
NEO_FN_CLEAR_SCREEN = $0C
NEO_FN_SET_CURSOR   = $07
NEO_FN_CURSOR_POS   = $0D
NEO_FN_SET_COLOR    = $0F

; File functions
NEO_FN_FILE_LOAD    = $02

; Graphics functions
NEO_FN_GFX_DEFAULTS = $01
NEO_FN_GFX_RECT     = $03
NEO_FN_GFX_PIXEL    = $05
NEO_FN_GFX_TEXT     = $06
NEO_FN_GFX_IMAGE    = $07
NEO_FN_GFX_TILEMAP  = $08
NEO_FN_GFX_SET_COLOR = $40
NEO_FN_GFX_SET_SOLID = $41
NEO_FN_GFX_SET_SIZE  = $42
NEO_FN_GFX_SET_FLIP  = $43

; System functions
NEO_FN_TIMER        = $01

; Error codes (common)
NEO_ERR_NONE        = $00

; Screen layout (MVP assumption: 320x240, 40x30 char cells)
SCREEN_W        = 320
SCREEN_H        = 240
CHAR_COLS       = 40
CHAR_ROWS       = 30
VIEWPORT_X      = 0
VIEWPORT_Y      = 0
VIEWPORT_W      = 320
VIEWPORT_H      = 160  ; 10 tiles tall at 16px
TEXT_Y          = 21   ; char row for room name
DESC_Y          = 22   ; char row for description start
PROMPT_Y        = 29   ; char row for prompt

; Colors (Neo palette indices)
COLOR_BLACK     = 0
COLOR_RED       = 1
COLOR_GREEN     = 2
COLOR_YELLOW    = 3
COLOR_BLUE      = 4
COLOR_MAGENTA   = 5
COLOR_CYAN      = 6
COLOR_WHITE     = 7
COLOR_DKGREY    = 9
COLOR_DKGREEN   = 10
COLOR_ORANGE    = 11
COLOR_BROWN     = 13
COLOR_PINK      = 14
COLOR_LTGREY    = 15
