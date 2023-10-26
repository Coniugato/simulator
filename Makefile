all: main input_handle
	gcc main input_handle -o sim -lm

main: main.c
	gcc -c main.c -o main

input_handle: input_handle.c
	gcc -c input_handle.c -o input_handle

clean:
	rm -rf sim main input_handle