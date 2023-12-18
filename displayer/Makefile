all: main input_handle
	gcc main input_handle -o disp -lm

main: main.c
	gcc -c main.c -o main

input_handle: input_handle.c
	gcc -c input_handle.c -o input_handle

clean:
	rm -rf disp main input_handle