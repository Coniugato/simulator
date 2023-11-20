.data int, 5
main: 
    lw t0, gp, 0
    jal ra, fib
    j end
fib: 
    addi t1, t0, -1
    bge zero, t1, imm

    #save
    addi sp, sp, -16
    sw sp, 0, t0 #save i
    addi sp, sp, -16
    sw sp, 0, ra #save ra

    addi t0, t0, -1
    jal ra, fib #call fib[i-1]

    addi sp, sp, -16
    sw sp, 0, t0 #save fib[i-1]

    addi t0, t0, -1
    jal ra, fib #call fib[i-2]

    #restore
    mv t1, t0 #t1 <- fib[i-2]

    lw t2, sp, 0 #restore fib[i-1]
    addi sp, sp, 16

    lw ra, sp, 0 #restore ra
    addi sp, sp, 16

    lw t0, sp, 0 #restore i(unnecessary)
    addi sp, sp, 16

    add t0, t1, t2
    jalr zero, ra, 0
imm:
    lim t0, 1
    jalr zero, ra, 0 #later set up ret (pseudo) instruction
end: mv t3, t0 #t3 as output
