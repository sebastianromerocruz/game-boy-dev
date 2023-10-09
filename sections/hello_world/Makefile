asm:
	rgbasm -L -o cartridge.o *.asm

link:
	rgblink -o cartridge.gb cartridge.o

fix:
	rgbfix -v -p 0xFF cartridge.gb

run:
	open cartridge.gb -a visualboyadvance-m