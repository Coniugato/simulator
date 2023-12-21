main:addi t0,t0,1
      call test
      j end
int_data:
    .data int, 20
    .data int, -20
test:
    addr t0, int_data
    lw t1, t0, 0
    lw t2, t0, 4
    fcvt.s.w ft0, t1
    fcvt.s.wu ft1, t1
    fcvt.s.w ft2, t2
    fcvt.s.wu ft3, t2
    fcvt.w.s t3, ft0
    fcvt.wu.s t4, ft0  
    fcvt.w.s t5, ft2
    fcvt.wu.s t6, ft2    
end:
    mv a0, a0
