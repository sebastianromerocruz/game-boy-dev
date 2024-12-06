<h2 align=center>Game Boy Development</h2>

<h1 align=center>Unbricked</h1>

<h3 align=center>A First Game</h3>

---

## Sections
1. [**Foreword**](#0)
2. [**The Z80 Programming Language**](#1)
    1. [**Instructions**](#1-1)
    2. [**Directives**](#1-2)
    3. [**Flags**](#1-3)
    4. [**Conditions**](#1-4)
3. [**Setting Up**](#2)
    1. [**Tiles and Tilemap**](2-1)
    2. [**Program Entry Point**](2-2)


---

<a id="0"></a>

## Foreword

So it happens that I begin a new project.

Having dabbled previously with "esoteric" assembly programming using the NES's [**6502**](https://github.com/sebastianromerocruz/game-programming-in-assembly), I figured that GameBoy programming would be, at least, a little easier—given its later release date and hardware—or, at the very least, better documented. What I found surprised me in the most pleasant of ways, as a concise, well-written, and seemingly all-inclusive tutorial of a couple of basic games is to be found over at [**GB ASM Tutorial**](https://gbdev.io/gb-asm-tutorial/index.html). I know the authors of this tutorial are many so, before anything else, I'd like to extend my most profound thanks to their efforts; it's thanks to them that I get to dabble in my little hobbies and, thus, make computer science an actually fun activity.

So, without further ado and all that, let's get into it.

<br>

<a id="1"></a>

## The Z80 Programming Language

One of the first things I noticed when reading up on this tutorial was that the flavour of assembly used in GB development, [**Z80, after its 8-bit microprocessor**](https://en.wikipedia.org/wiki/Zilog_Z80), is immediately less constricting than 6502. To start, it has _7 8-bit general-purpose registers_, as opposed to the NES's 3: `a` (the accumulator), `b`, `c`, `d`, `e`, `h`, `l`. Moreover, we can pair the latter 6 as `bc`, `de`, and `hl` in order to handle 16-bit numbers, which I find super handy! Pairing them up also allows you to modify both of their values at the same time, which also sounds like it come in handy.

`hli` / `hl+` is functionally equivalent to `hl`, except that after being invoked it also _increments_ the value of `hl`. So, using the [**`ld` instruction**](#op), we can see how we can load the value of `a` to the memory address referenced by `hl` and then increment to the next memory address, all in one line:

```asm
    ld [hli], a
```

> As a general reminder, **general-purpose registers** (GPRs) are simply registers that can be used to store arbitrary integer numbers.

<a id="1-1"></a>

### Instructions

The basic operations of the Z80 are referred to as _instructions_, referring to those lines of code that interact directly with the ROM. I will include a list below for my own reference (and yours, if you ever read this—whoever and whenever you are) and will expand on it as I encounter more:

<a id="op"></a>

| Op Code | Instruction | Syntax | Explanation | Example |
|---------|-------------|--------|-------------|---------|
| `ld` | Load | `ld x, y` | Copies value `y` (which can be both a literal or a reference) into `x` | `ld a, 0` |
| `jp` | Jump | `jp label` | Transfers control to the first line below the `label` label | `jp EntryPoint` |
| `ds` | Define storage / space | `ds location, value` | Similar to C's `malloc`, reserves a specified number of bytes in memory, sort of like "padding" for later instantiation. | `ds $150 - @, 0  ; current position up to $150 is filled with zeros` |
| `inc` | Increment | `inc x` | Increments the value of `x` by 1. | `inc bc` |
| `dec` | Decrement | `dec x` | Decrement the value of `x` by 1. | `dec bc` |
| `cp` | Compare | `cp x, y` | Subtracts `y` from `x`, setting the [**`C`arry / `Z`ero flags**](#fl) if necessary. | `dec bc` |
| `add` | Addition | `add x` | Adds `x` from the accumulator. | `add $42` |
| `sub` | Subtraction | `sub x` | Subtracts `x` from the accumulator. | `sub $42` |

<sub>**Figure 1**: Z80 Op Codes.</sub>

<a id="1-2"></a>

### Directives

Directives work more like instructions to the assembler, so more like a [**macro**](https://en.wikipedia.org/wiki/Macro_(computer_science)) or [**metaprogramming**](https://en.wikipedia.org/wiki/Metaprogramming). In other words, instructions are the code, directives are how the assembler should assemble them. Just like with instructions, I'll include a table below of them as I encounter them:

<a id="dir"></a>

| Directive | Syntax | Explanation | Example |
|---------|-------------|--------|-------------|
| `INCLUDE` | `INCLUDE "filepath"` | Pretty much an analogue to C's `include` or Python's `import` | `INCLUDE "hardware.incs"` |
| `SECTION` | `SECTION NAME, ROM0[LOC]` | Groups a series of related instructions and data at a certain in the ROM. | `SECTION "header, ROM0 [$100]` |

<sub>**Figure 2**: Z80 Directives. Note that `[LOC]` in Z80 is how we specify "the value stored at `LOC`" (i.e. absolute addressing).</sub>

<a id="1-3"></a>

### Flags

The Z80's F register is used to keep track of all manner of information related to arithmetic operations. Here they are:

<a id="fl"></a>

| Flag | Explanation |
|------|-------------|
| Sign Flag (S) | Is set if the result of an operation is negative. |
| Zero Flag (Z) | Is set if the result of an operation is zero. |
| Half-Carry Flag (H) | Is set if there was a carry from bit 3 to bit 4 in the result. |
| Parity / Overflow Flag (P / V) | Is set if the number of set bits in the result of an operation is even (i.e. parity), or if there was an overflow in signed arithmetic operations. |
| Subtract Flag (N) | Is set if the last operation was a subtraction. |
| Carry Flag (C) | Is set if there was a carry out of the most significant bit in the result. |

<sub>**Figure 3**: The flags of the Z80's F register.</sub>

<a id="1-4"></a>

### Conditions

<a id="con"></a>

| Name | Mnemonic | Explanation | Example |
|---------|-------------|--------|-------------|
| Zero | `z` | True if the Z flag is set. | `jp z, CopyTiles  ; if a is 0, go to CopyTiles` |
| Non-zero | `nz` | True if the Z flag is not set. | `jp nz, CopyTiles  ; if a is not 0, go to CopyTiles` |
| Carry | `c` | True if the C flag is set (i.e. if the last operation overflowed). | `jp c, CopyTiles` |
| Cary | `nc` | True if the C flag is not set (i.e. if the last operation did not overflow). | `jp nc, CopyTiles` |

<sub>**Figure 4**: The four boolean conditions available to us.</sub>

<br>

<a id="2"></a>

## Setting Up

<a id="2-1"></a>

### Tiles and Tilemap

In order to keep [**`main.asm`**](main.asm) clean, I have opted to keep the tile (sprite) and tilemap data in separate files. For this reason, the very first few lines of our file are `INCLUDE` statements:

```asm
INCLUDE "assets/hardware.inc"  ; Include the hardware definitions
INCLUDE "assets/tiles.asm"     ; Include the tiles
INCLUDE "assets/tilemap.asm"   ; Include the tilemap
```

Interestingly, in order to do this, I have to define a section in both [**`tiles.asm`**](assets/tiles.asm) and [**`tilemap.asm`**](assets/tilemap.asm) denoting the beginning of this data:

```asm
; tiles.asm
SECTION "Tile Data", ROM0
Tiles:
	dw `33333333
	dw `33333333
	dw `33333333
    ...
    ...
    ...
    dw `33333333
	dw `33333333
	dw `33333333
TilesEnd:
```

```asm
; tilemap.asm
SECTION "Tilemap Data", ROM0
Tilemap:
	db $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
    ...
    ...
    ...
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $12, $13, $14, $15, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $16, $17, $18, $19, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:
```

My first question here was: if both `Tile Data` and `Tilemap Data` are being saved in `ROM0`, won't the latter overwrite the former? Turns out that the assembler, working sequentially, will place data destined for `ROM0` at _the next available memory location_. Thus, `Tilemap Data` is actually being implicitly defined right after `Tile Data`. 

Note here that `db` stands for define byte (a single byte of data) and `dw` stands for define word (two bytes of data).

<a id="2-2"></a>

### Program Entry Point

The first few lines of the program are easy to understand, but there was much for me to learn just by looking at them:

```ASM
SECTION "Header", ROM0[$100]
    jp EntryPoint   ; Jump to the entry point

    ds $150 - @, 0  ; Fill the rest of the header with 0s
```

Here, as explained above a section labelled as `"Header"` is being defined in the ROM starting at location `$100` (i.e. 256<sub>10</sub>). Starting the section off is a jump to a specific label, which happens just after the entry point, and the a definition of storage which warrants some explanation.

> In Z80 programming the `@`  is shorthand for the _current location in memory_ that we are presently at.

So, what this line is saying is, in effect, reserves enough memory to reach the address `%150` from the current address and fills that space with zeroes.

<br>

Now, since these games 