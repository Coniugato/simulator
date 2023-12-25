main: addi t0,t0,1
      call test
      j end
data:
    .data int, 10
    .data int, -30
    .data int, 11
test:
    addr t0, data
    lw t1, t0, 0
    lw t2, t0, 4
    lw a0, t0, 8
    slt t3, t1, a0
    slt t4, t2, a0
    sltu t5, t1, a0
    sltu t6, t2, a0
    ret
end:
    nop
