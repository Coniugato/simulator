main: addi t0,t0,1
      call test
      j end
data:
    .data float, 0.1562
    .data int, 1042284544
test:
    addr t0, data
    flw ft0, t0, 0
    lw t1, t0, 4
    fmv.x.w t2, ft0
    fmv.w.x ft1, t2
    fmv.w.x ft2, t1
    fmv.x.w t3, ft2
end:
    nop
