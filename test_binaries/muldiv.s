main: addi t0, t0, 1
      call int_test
      call float_test
      j end
int_data:
    .data int, -5
    .data int, 2
int_test:
    addr t0, int_data
    lw t1, t0, 0
    lw t2, t0, 4
    mul t3, t1, t2
    div t4, t1, t2
    mul t5, t2, t1
    div t6, t2, t1
    ret 0
float_data:
    .data float, -4.9
    .data float, 1.6
float_test:
    addr t0, float_data
    flw ft1, t0, 0
    flw ft2, t0, 4
    fmul.s ft3, ft1, ft2
    fdiv.s ft4, ft1, ft2 
    fmul.s ft5, ft2, ft1
    fdiv.s ft6, ft2, ft1    
    ret 0
end:
    mv a0, a0
