        li a0, 1
        li a1, 0
        li a2, 1001
        li a3, 1000
LOOP:   addi a1,a1,1
        blt a2, a3, J1
        sub a2, a2, a3
        j JD
J1:     sub a3, a3, a2
JD:     bne a2,a3,LOOP
        sw a1, 100, a2
        mv zero,zero