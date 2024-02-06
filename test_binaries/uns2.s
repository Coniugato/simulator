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
    bltu t1, t2, label1
next:
    bgeu t1, t2, label2
next2:
    divu t5, t2, t1
    remu t6, t2, t1
    ret
label1:
    li t3, 1
    j next
label2:
    li t4, 1
    j next2
end:
    nop
