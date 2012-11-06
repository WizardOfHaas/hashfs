kernel: drek.asm
	nasm -f bin -o startup.bin drek.asm
	nasm -f bin -o boot.bin boot.asm
	cat boot.bin startup.bin > booter.bin