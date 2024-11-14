; Author: Sebastián Romero Cruz
; Description: Main file for the unbricked ROM 
INCLUDE "assets/hardware.inc"
INCLUDE "assets/tiles.asm"
INCLUDE "assets/tilemap.asm"

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