main: addi t0,t0,1
      call test
      j end
data:
    .data float, 1.32
    .data float, -4.1
    .data float, 2.5
test:
    addr t0, data
    flw fa0, t0, 0
    flw fa1, t0, 4
    flw fa2, t0, 8
    fsgnj.s ft0, fa0, fa1
    fsgnjn.s ft1, fa0, fa1
    fsgnjx.s ft2, fa0, fa1
    fsgnj.s ft3, fa0, fa2
    fsgnjn.s ft4, fa0, fa2
    fsgnjx.s ft5, fa0, fa2
end:
    nop
