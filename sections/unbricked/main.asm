; Author: Sebastián Romero Cruz
; Description: Main file for the unbricked ROM 
INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
    jp EntryPoint   ; Jump to the entry point

    ds $150 - @, 0  ; Fill the rest of the header with 0s

EntryPoint:
    ; Do not turn the LCD off outside of VBlank
WaitVBlank:
    ; Wait for the VBlank period
    ld a, [rLY]             ; Load the current line
    cp 144                  ; Check if we are in the VBlank period
    jp c, WaitVBlank        ; If we are not, keep waiting

    ; Turn off the LCD
    ld a, 0                 ; We load 0 into a first since
    ld [rLCDC], a           ; ld can't write directly to memory

    ; Copy tiles to VRAM
    ;   - VRAM stands for Video RAM, which is the memory where the Game
    ;     Boy stores the tiles that are going to be displayed on the screen
    ld de, Tiles            ; Load the address of the tiles
    ld hl, $9000            ; Load the address of the VRAM
    ld bc, TilesEnd - Tiles ; Load the number of bytes to copy

CopyTiles:
    ld a, [de]              ; Load the byte from the tiles
    ld [hli], a             ; Copy the byte to VRAM and increment hl
    inc de                  ; Increment de to point to the next byte
    dec bc                  ; Decrement bc to keep track of the bytes left
    ld a, b                 ; Load the high byte of bc
    or a, c                 ; Check if bc is 0 (both bytes are 0)
    jp nz, CopyTiles        ; If bc is not 0, keep copying tiles

    ; Copy the tilemap to VRAM
    ld de, Tilemap              ; Load the address of the tilemap
    ld hl, $9800                ; Load the address of the tilemap in VRAM
    ld bc, TilemapEnd - Tilemap ; Load the number of bytes to copy

CopyTileMap:
    ld a, [de]             ; Load the byte from the tilemap
    ld [hli], a            ; Copy the byte to VRAM and increment hl
    inc de                 ; Increment de to point to the next byte
    dec bc                 ; Decrement bc to keep track of the bytes left
    ld a, b                ; Load the high byte of bc
    or a, c                ; Check if bc is 0 (both bytes are 0)
    jp nz, CopyTileMap     ; If bc is not 0, keep copying the tilemap

    ; Turn on the LCD and set the background palette
    ld a, LCDCF_ON | LCDCF_BGON  ; Load the LCD control flags (LCD and background)
    ld [rLCDC], a                ; Turn on the LCD and set the background palette

    ld a, %11100100              ; Load the background palette (white, light gray, dark gray, black)
    ld [rBGP], a                 ; Set the background palette to white, light gray, dark gray, and black

Done:
    jp Done

Tiles:
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33322222
	dw `33322222
	dw `33322222
	dw `33322211
	dw `33322211
	dw `33333333
	dw `33333333
	dw `33333333
	dw `22222222
	dw `22222222
	dw `22222222
	dw `11111111
	dw `11111111
	dw `33333333
	dw `33333333
	dw `33333333
	dw `22222333
	dw `22222333
	dw `22222333
	dw `11222333
	dw `11222333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `22222222
	dw `20000000
	dw `20111111
	dw `20111111
	dw `20111111
	dw `20111111
	dw `22222222
	dw `33333333
	dw `22222223
	dw `00000023
	dw `11111123
	dw `11111123
	dw `11111123
	dw `11111123
	dw `22222223
	dw `33333333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `11001100
	dw `11111111
	dw `11111111
	dw `21212121
	dw `22222222
	dw `22322232
	dw `23232323
	dw `33333333
	; Paste your logo here:
    dw `33000000
	dw `33000000
	dw `33000000
	dw `33000000
	dw `33111100
	dw `33111100
	dw `33111111
	dw `33111111
	dw `33331111
	dw `00331111
	dw `00331111
	dw `00331111
	dw `00331111
	dw `00331111
	dw `11331111
	dw `11331111
	dw `11333300
	dw `11113300
	dw `11113300
	dw `11113300
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `00003333
	dw `00000033
	dw `00000033
	dw `00000033
	dw `11000033
	dw `11000033
	dw `11111133
	dw `11111133
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11113311
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `33111111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11331111
	dw `11330000
	dw `11330000
	dw `11330000
	dw `33330000
	dw `11113311
	dw `11113311
	dw `00003311
	dw `00003311
	dw `00003311
	dw `00003311
	dw `00003311
	dw `00333311
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11111133
	dw `11113333
TilesEnd:

Tilemap:
	db $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $0A, $0B, $0C, $0D, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $0E, $0F, $10, $11, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $12, $13, $14, $15, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $16, $17, $18, $19, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:
