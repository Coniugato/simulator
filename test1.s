        li a0, 100
        li a1, 0
        li a2, 10
        lw a1, a0, 0
LOOP:   sw a0, 0, a1
        addi a1, a1, 1
        lim a3, 65537
        add a0, a0, a3
        blt a1, a2, LOOP
