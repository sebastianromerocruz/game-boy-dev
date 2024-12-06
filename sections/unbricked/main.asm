; Author: Sebastián Romero Cruz
; Description: Main file for the unbricked ROM 
INCLUDE "assets/hardware.inc"  ; Include the hardware definitions
INCLUDE "assets/tiles.asm"     ; Include the tiles
INCLUDE "assets/tilemap.asm"   ; Include the tilemap
INCLUDE "assets/paddles.asm"   ; Include the paddle object

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

    ; Clear the OAM RAM (Object Attribute Memory) to avoid garbage data
    ld a, 0                      ; Load 0 into a
    ld b, 160                    ; Load 160 into b (the width of the screen)
    ld hl, _OAMRAM               ; Load the address of the OAM RAM
ClearOam:
    ld [hli], a                  ; Clear the first byte of the OAM RAM
    dec b                        ; Decrement b to keep track of the bytes left
    jp nz, ClearOam              ; If b is not 0, keep clearing the OAM RAM

    ld hl, _OAMRAM               ; Load the address of the OAM RAM
    ld a, 128 + 16               ; Load the sprite flags (128 for the Y flip, 16 for the X flip)
    ld [hli], a                  ; Set the sprite flags for the first sprite

    ld a, 16 + 8                 ; Load the X position of the first sprite
    ld [hli], a                  ; Set the X position of the first sprite

    ld a, 0                      ; Load the Y position of the first sprite
    ld [hli], a                  ; Set the Y position of the first sprite

    ld [hli], a                  ; Set the tile number of the first sprite


    ; Copy the paddle tiles
    ld de, Paddle                ; Load the address of the object
    ld hl, $8000                 ; Load the OAM RAM address into which we will write
    ld bc, PaddleEnd - Paddle    ; Load the size of the paddle (in bytes; for counter)
CopyPaddle:
    ld a, [de]                   ; Load the current byte
    ld [hli], a                  ; Store that byte into OAM RAM and increment
    inc de                       ; Move on to next byte
    dec bc                       ; Decrease counter

    ld a, b                      ; Load high byte of bc
    or a, c                      ; Check if it's zero

    jp nz, CopyPaddle            ; If not, loop back to the next byte


    ; Enable objects
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
    ld [rLCDC], a                ; Turn off the LCD

    ; Load palettes
    ld a, %11100100
    ld [rBGP], a                 ; Background's

    ld a, %11100100
    ld [rOBP0], a                ; Objects'

Main:
    ; game loop
    jp Main