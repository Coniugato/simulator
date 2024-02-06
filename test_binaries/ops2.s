main: addi t0, t0, 1
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
    rem t3, t1, t2
    and t4, t1, t2
    or t5, t1, t2
    xor t6, t1, t2
    ret 0
float_data:
    .data float, 4.9
    .data float, 1.6
float_test:
    addr t0, float_data
    flw ft1, t0, 0
    flw ft2, t0, 4
    fmin.s ft3, ft1, ft2
    fmax.s ft4, ft1, ft2
    fsqrt.s ft5, ft1 
    ret 0
end:
    mv a0, a0
