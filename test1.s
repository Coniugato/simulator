.data int 1
.data int 1
main:   lim a0, 1
        lim a1, 1
        sw hp, 0, a0
        addi hp, hp, 4
        sw hp, 0, a1
        addi hp, hp, 4
        j 0
fib:    beq a0, zero, fib1
        addi a1, zero, 1
        beq a0, a1, fib2 
        addi sp, sp, -4
        sw sp, 0, a0
        addi a0, a0, -1
        j fib
        lw a0, sp, 0
        addi a0, a0, -1
        sw a0, a0

        

        j ra
fib1:   lw a0, hp, 0
        j ra
fib2:   lw a0, hp, 0
        j ra

