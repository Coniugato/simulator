main:addi t0,t0,1
      call int_test
      call float_test
      j end
int_data:
    .data int, 20
    .data int, 7
int_test:
    addr t0, int_data
    lw t1, t0, 0
    lw t2, t0, 4  
    beq t1, t2, label1
next2:
    bne t1, t2, label2
next3:
    blt t1, t2, label3
next4:
    bge t1, t2, label4
next5:
    ret
label1:
    li t3, 1
    j next2
label2:
    li t4, 1
    j next3
label3:
    li t5, 1
    j next4
label4:
    li t6, 1
    j next5
float_data:
    .data float, 1.6
    .data float, 4.9
    .data float, 4.9

float_test:addr t0,float_data
    flw ft1,t0, 0
    flw ft2, t0, 4
    flw ft3, t0, 8
    flt.s a0, ft1, ft2
    feq.s a1, ft1, ft2 
    fle.s a2, ft1, ft2
    flt.s a3, ft2, ft3
    fle.s a4, ft2, ft3
    ret 0
end:
    mv a0, a0
