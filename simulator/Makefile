all: main input_handle fpu fpui
	gcc main input_handle fpu fpui -O7 -o sim -lm

main: main.c
	gcc -c main.c -O7 -o main

input_handle: input_handle.c
	gcc -c input_handle.c -O7 -o  input_handle

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c -O7 -o fpu

fpui: fpui.c 
	gcc -lm -c fpui.c -O7 -o fpui

clean:
	rm -rf sim main input_handle fpu