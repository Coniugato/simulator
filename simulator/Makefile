all: main input_handle fpu
	gcc main input_handle fpu -O7 -o sim -lm

main: main.c
	gcc -c main.c -O7 -o main

input_handle: input_handle.c
	gcc -c input_handle.c -O7 -o  input_handle

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c -O7 -o fpu

clean:
	rm -rf sim main input_handle fpu