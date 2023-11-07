.data int, 2
.data uint, 5
.data char, 7
main: 
  li t3, 20              # int n=10; 'li' converted to 'addi'
  li t4,1
  blt t4,t3,L1          # if (1<n) goto 
  mv t4,t3              # 'mov' converted to 'addi'
  j L3                  # 'j' converted to 'jal'
L1:li t4,1		# int fib=1;
  li t5,1 		# int fibPrev=1;
  li t0,2		# int i=2;
L2:bge t0,t3,L3          # if (i>=n) goto 
  mv t6,t4		# int temp=fib;
  add t4,t4,t5		# fib+=fibPrev;
  mv t5,t6 		# fibPrev=temp;
  addi t0,t0,1		# i++
  j L2
 L3:mv a0,t4