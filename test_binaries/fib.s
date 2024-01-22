main: 
  li t3, 20'
  li t4,1
  blt t4,t3,L1
  mv t4,t3
  j L3 
L1:
  li t4,1
  li t5,1
  li t0,2
L2:
  bge t0,t3,L3
  mv t6,t4
  add t4,t4,t5
  mv t5,t6 
  addi t0,t0,1
  j L2
 L3:
  mv a0,t4