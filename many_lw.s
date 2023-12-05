
addi t0, zero, 4
addi sp, sp, -4
sw sp, 0, t0

addi t0, zero, 3
addi sp, sp, -4
sw sp, 0, t0


lw t0, sp, 0
lw t1, sp, 4
add t2, t0, t1
