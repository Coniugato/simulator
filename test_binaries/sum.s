.data int, 50
main: 
    lw t0, gp, 0
    jal ra, sum
    j end
sum:   
    beq t0, zero, imm

    #save
    addi sp, sp, -16
    sw sp, 0, t0
    addi sp, sp, -16
    sw sp, 0, ra

    addi t0, t0, -1
    jal ra, sum

    #restore
    mv t1, t0
    lw ra, sp, 0
    addi sp, sp, 16
    lw t0, sp, 0 
    addi sp, sp, 16

    add t0, t0, t1
    jalr zero, ra, 0
imm:
    lim t0, 0
    jalr zero, ra, 0 #later set up ret (pseudo) instruction
end: mv t2, t0