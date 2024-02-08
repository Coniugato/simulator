all: main input_handle fpu
	gcc main input_handle fpu -O5 -o sim -lm

main: main.c
	gcc -c main.c -O5 -o main

input_handle: input_handle.c
	gcc -c input_handle.c -O5 -o  input_handle

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c -O5 -o fpu

clean:
	rm -rf sim main input_handle fpu