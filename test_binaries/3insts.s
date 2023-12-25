main: addi t0,t0,1
      call test
      j end
data:
    .data float, 1.32
    .data float, 0.14
    .data float, -4.1
test:
    addr t0, data
    flw ft0, t0, 0
    flw ft1, t0, 4
    flw ft2, t0, 8
    fmadd.s ft3, ft0, ft1, ft2
    fmsub.s ft4, ft0, ft1, ft2
    fnmadd.s ft5, ft0, ft1, ft2
    fnmsub.s ft6, ft0, ft1, ft2
end:
    mv a0, a0
