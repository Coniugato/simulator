main: addi t0,t0,1
      call test
      j end
data:
    .data int, 10
    .data int, -30
    .data int, 2
test:
    addr t0, data
    lw t1, t0, 0
    lw t2, t0, 4
    lw a0, t0, 8
    sll t3, t1, a0
    sll t4, t2, a0
    slli t5, t1, 2
    slli t6, t2, 2
    ret
end:
    nop
