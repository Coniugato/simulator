main: addi t0,t0,1
      call test
      j end
data:
    .data int, 10
    .data int, -30
test:
    addr t0, data
    lw t1, t0, 0
    lw t2, t0, 4
    slti t3, t1, 11
    slti t4, t2, 11
    sltiu t5, t1, 11
    sltiu t6, t2, 11
    ret
end:
    nop
