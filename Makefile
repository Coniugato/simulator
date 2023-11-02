all: main input_handle
	gcc main input_handle -o sim -lm

main: main.c
	gcc -c main.c -o main

input_handle: input_handle.c
	gcc -c input_handle.c -o input_handle

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c -o fpu

clean:
	rm -rf sim main input_handle fpu