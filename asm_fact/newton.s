.data float, 0.001
.data int, 203
main: 
    lw t0, gp, 0
    fcvt.s.w fa0, zero
    jal ra, fib
    j end
f:
	

    #save
    addi sp, sp, -4
    sw sp, 0, ft1 #save ft1
    addi sp, sp, -4
    sw sp, 0, ft2 #save ft2
    addi sp, sp, -4
    sw sp, 0, t0 #save t0

	lw t0, gp, 4
	fcvt.s.w fa0, zero
    
	addi t0, t0, -1
    call fib #call fib[i-1]

    addi sp, sp, -4
    fsw sp, 0, ft0 #save fib[i-1]


    lw t0, sp, 8

    addi t0, t0, -2
    call fib #call fib[i-2]


    #restore
    fadd.s ft1, ft0, fa0 #t1 <- fib[i-2]

    flw ft2, sp, 0 #restore fib[i-1]
    addi sp, sp, 4

    lw ra, sp, 0 #restore ra
    addi sp, sp, 4

    lw t4, sp, 0 #restore i(unnecessary)
    addi sp, sp, 4


    fadd.s ft0, ft1, ft2
    ret 0
imm:
    lim t0, 1
    fcvt.s.w ft0, t0
    
    ret 0 
end: mv t3, t0 #t3 as output
