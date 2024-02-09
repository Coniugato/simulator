OPT = -O3 

all: main input_handle fpu fpui
	gcc main input_handle fpu fpui $(OPT) -o sim -lm

main: main.c
	gcc -c main.c $(OPT) -o main

input_handle: input_handle.c
	gcc -c input_handle.c -O7 -o  input_handle

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c $(OPT) -o fpu

fpui: fpui.c 
	gcc -lm -c fpui.c $(OPT) -o fpui

clean:
	rm -rf sim main input_handle fpu fpui