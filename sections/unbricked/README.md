<h2 align=center>Game Boy Development</h2>

<h1 align=center>Unbricked</h1>

<h3 align=center>A First Game</h3>

---

## Sections
1. [**Foreword**](#0)
2. [**Setting Up**](#1)
    1. [****]

---

<a id="0"></a>

## Foreword

So it happens that I begin a new project.

Having dabbled previously with "esoteric" assembly programming using the NES's [**6502**](https://github.com/sebastianromerocruz/game-programming-in-assembly), I figured that GameBoy programming would be, at least, a little easier—given its later release date and hardware—or, at the very least, better documented. What I found surprised me in the most pleasant of ways, as a concise, well-written, and seemingly all-inclusive tutorial of a couple of basic games is to be found over at [**GB ASM Tutorial**](https://gbdev.io/gb-asm-tutorial/index.html). I know the authors of this tutorial are many so, before anything else, I'd like to extend my most profound thanks to their efforts; it's thanks to them that I get to dabble in my little hobbies and, thus, make computer science an actually fun activity.

So, without further ado and all that, let's get into it.

<br>

<a id="1"></a>

## Setting Up

### The Z80 Programming Language

One of the first things I noticed when reading up on this tutorial was that the flavour of assembly used in GB development, [**Z80, after its 8-bit microprocessor**](https://en.wikipedia.org/wiki/Zilog_Z80), is immediately less constricting than 6502. To start, it has _7 8-bit general-purpose registers_, as opposed to the NES's 3: `a` (the accumulator), `b`, `c`, `d`, `e`, `h`, `l`. Moreover, we can pair the latter 6 as `bc`, `de`, and `hl` in order to handle 16-bit numbers, which I find super handy! Pairing them up also allows you to modify both of their values at the same time, which also sounds like it come in handy.

> As a general reminder, **general-purpose registers** (GPRs) are simply registers that can be used to store arbitrary integer numbers.

#### Instructions

The basic operations of the Z80 are referred to as _instructions_, referring to those lines of code that interact directly with the ROM. I will include a list below for my own reference (and yours, if you ever read this—whoever and whenever you are) and will expand on it as I encounter more:

<a id="op"></a>

| Op Code | Instruction | Syntax | Explanation | Example |
|---------|-------------|--------|-------------|---------|
| `ld` | Load | `ld x, y` | Copies value `y` (which can be both a literal or a reference) into `x` | `ld a, 0` |
| `jp` | Jump | `jp label` | Transfers control to the first line below the `label` label | `jp EntryPoint` |
| `ds` | Define storage / space | `ds location, value` | Similar to C's `malloc`, reserves a specified number of bytes in memory, sort of like "padding" for later instantiation. | `jp EntryPoint` |

<sub>**Figure 1**: Z80 Op Codes.</sub>

#### Directives

Directives work more like instructions to the assembler, so more like a [**macro**](https://en.wikipedia.org/wiki/Macro_(computer_science)) or [**metaprogramming**](https://en.wikipedia.org/wiki/Metaprogramming). In other words, instructions are the code, directives are how the assembler should assemble them. Just like with instructions, I'll include a table below of them as I encounter them:

<a id="dir"></a>

| Directive | Syntax | Explanation | Example |
|---------|-------------|--------|-------------|
| `INCLUDE` | `INCLUDE "filepath"` | Pretty much an analogue to C's `include` or Python's `import` | `INCLUDE "hardware.incs"` |
| `SECTION` | `SECTION NAME, ROM0[LOC]` | Groups a series of related instructions and data at a certain in the ROM. | `SECTION "ds $150 - @, 0  ; current position up to $150 is filled with zeros` |

<sub>**Figure 2**: Z80 Directives. Note that `[LOC]` in Z80 is how we specify "the value stored at `LOC` (i.e. absolute addressing).</sub>