asm:
	rgbasm -o main.o main.asm

link:
	rgblink -o unbricked.gb main.o

fix:
	rgbfix -v -p 0xFF unbricked.gb

run:
	open unbricked.gb -a sameboy

map:
	rgblink hello-world.o -m hello-world.map
