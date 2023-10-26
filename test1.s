        li a0, 100
        li a1, 0
        li a2, 10
LOOP:   sw a0, 0, a1
        addi a1, a1, 1
        lui a3, 65536
        addi a3, a3, 65536
        add a0, a0, a3
        blt a1, a2, LOOP
