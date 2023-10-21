main:
0  li t3,10              # int n=10;
4  li t4,1
8  blt t4,t3,L1          # if (1<n) goto L1;
12  mv t4,t3
16  j L3
20L1:li t4,1		# int fib=1;
24  li t5,1 		# int fibPrev=1;
28  li t0,2		# int i=2;
32L2:bge t0,t3,L3          # if (i>=n) goto L3;
36  mv t6,t4		# int temp=fib;
40  add t4,t4,t5		# fib+=fibPrev;
44  mv t5,t6 		# fibPrev=temp;
48  addi t0,t0,1		# i++
52  j L2
56 L3:mv a0,t4