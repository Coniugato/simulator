main: addi t0,t0,1
      call test
      j end
data:
    .data int, 10
test:
    addr t0, data
    lw t1, t0, 0
    xori t2, t1, 3
    ori t3, t1, 3
    andi t4, t1, 3
    ret
end:
    nop
