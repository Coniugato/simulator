.data int, 20
main: 
    lw t0, gp, 0
    fcvt.w.u ft0, t0
    loop:
        
    
f:
    addi sp, sp, -4
    fsw sp, 0, ft1
    addi sp, sp, -4
    fsw sp, 0, t1
    
    #calculate ft[0]^3
    fcvt.w.u ft1, zero
    fadd ft1, ft1, ft0
    fmul ft0, ft0, ft1
    fmul ft0, ft0, ft0

    flw t1, sp, 0
    addi sp, sp, 4
    flw ft1, sp, 0
    addi sp, sp, 4

    ret 0
