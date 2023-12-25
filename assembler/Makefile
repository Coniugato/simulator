all: AVLmodule main decoder
	gcc main AVLmodule decoder -o asm

main: main.c
	gcc -c main.c -o main

AVLmodule: AVL.c
	gcc -c AVL.c -o AVLmodule

decoder: decoder.c
	gcc -c decoder.c -o decoder

.PHONY: clean
clean:
	rm -f AVLmodule decoder asm main
