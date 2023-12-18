main: addi t0, t0, 1
      call int_test
      call float_test
      j end
int_data:
    .data int, 5
    .data int, 2
int_test:
    addr t0, int_data
    lw t1, t0, 0
    lw t2, t0, 4
    add t3, t1, t2
    sub t4, t1, t2
    mul t5, t1, t2
    div t6, t1, t2
    ret 0
float_data:
    .data float, 4.9
    .data float, 1.6
float_test:
    addr t0, float_data
    flw ft1, t0, 0
    flw ft2, t0, 4
    fadd.s ft3, ft1, ft2
    fsub.s ft4, ft1, ft2
    fmul.s ft5, ft1, ft2
    fdiv.s ft6, ft1, ft2    
    ret 0
end:
    mv a0, a0
