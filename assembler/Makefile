all: AVLmodule main decoder
	gcc main AVLmodule decoder

main: main.c
	gcc -c main.c -o main

AVLmodule: AVL.c
	gcc -c AVL.c -o AVLmodule

decoder: decoder.c
	gcc -c decoder.c -o decoder

.PHONY: clean
clean:
	rm -f AVLmodule main decoder
