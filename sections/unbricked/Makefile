asm:
	rgbasm -o out/main.o main.asm

link:
	rgblink -o out/unbricked.gb out/main.o

fix:
	rgbfix -v -p 0xFF out/unbricked.gb

run:
	open out/unbricked.gb -a sameboy

map:
	rgblink out/main.o -m out/main.map
