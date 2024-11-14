asm:
	rgbasm -o hello-world.o hello-world.asm

link:
	rgblink -o hello-world.gb hello-world.o

fix:
	rgbfix -v -p 0xFF hello-world.gb

run:
	open hello-world.gb -a sameboy

map:
	rgblink hello-world.o -m hello-world.map
