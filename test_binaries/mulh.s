main: addi t0,t0,1
      call test
      j end
data:
    .data int, -2
    .data int, 65536
    .data int, 2
test:
    addr t0, data
    lw t1, t0, 0
    lw t2, t0, 4
    mulh t3, t1, t2
    mulhsu t4, t1, t2
    mulhsu t5, t2, t1
    mulhu t6, t1, t2
    ret
end:
    nop
