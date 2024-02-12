OPT = -O3 -Wall -Wextra

all: main input_handle fpu fpui handle inout latency memory print util clks
	gcc main input_handle fpu fpui handle inout latency memory print util clks $(OPT) -o sim -lm

main: main.c clks.h
	gcc -c main.c $(OPT) -o main

input_handle: input_handle.c clks.h
	gcc -c input_handle.c  $(OPT) -o  input_handle

print: print.c mainvars.h clks.h
	gcc -c print.c $(OPT) -o print

memory: memory.c util print clks.h
	gcc -c memory.c $(OPT) -o memory

latency: latency.c clks.h
	gcc -c latency.c $(OPT) -o latency

fpu: fpu.c fpu_finv.c fpu_fsqrt.c
	gcc -c fpu.c $(OPT) -o fpu

fpui: fpui.c clks.h
	gcc  -c fpui.c $(OPT) -o fpui

handle: handle.c clks.h
	gcc -c handle.c $(OPT) -o handle

inout: inout.c clks.h
	gcc  -c inout.c $(OPT) -o inout

util: util.c
	gcc -c util.c $(OPT) -o util

clks : clks.c
	gcc -c clks.c $(OPT) -o clks

clean:
	rm -rf sim main input_handle fpu fpui handle inout latency memory print util clks