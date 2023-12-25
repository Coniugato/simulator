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
    srli t3, t1, 2
    srli t4, t2, 2
    srai t5, t1, 2
    srai t6, t2, 2
    ret
end:
    nop
