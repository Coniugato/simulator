__entry__:
    j min_caml_start
f.10:
    bge    a0, zero, .Bge1
    li    a0, 0
    ret
.Bge1:
    nop
    li    a1, 1
    sw    hp, 0, a0
    mv    a0, a1
    mv    a1, t6
    sw    hp, 4, ra
    addi    hp, hp, 8
    call    min_caml_create_array
    addi    hp, hp, -8
    lw    ra, hp, 4
    mv    a1, a0
    lw    t6, a1, 0
    lw    a1, hp, 0
    addi    a2, a1, -1
    mv    a0, a2
    sw    hp, 4, ra
    addi    hp, hp, 8
    lw    t5, t6, 0
    jalr    ra, t5, 0
    addi    hp, hp, -8
    lw    ra, hp, 4
    mv    a1, a0
    lw    a2, hp, 0
    add    a0, a2, a1
    ret
min_caml_start:
    addi    sp, sp, -4
    mv    t6, sp
    iaddrl    a0, f.10
    sw    t6, 0, a0
    li    a0, 9
    sw    hp, 0, ra
    addi    hp, hp, 4
    lw    t5, t6, 0
    jalr    ra, t5, 0
    addi    hp, hp, -4
    lw    ra, hp, 0
    sw    hp, 0, ra
    addi    hp, hp, 4
    call    min_caml_print_int
    addi    hp, hp, -4
    lw    ra, hp, 0
    j __end__
min_caml_print_int:
    out a0
    ret
min_caml_create_array:
    beq a0, zero, create_array_exit
    addi    sp, sp, -4
    sw  sp, 0, a1
    addi    a0, a0, -1
    j min_caml_create_array
create_array_exit:
    mv  a0, sp
    ret
__end__:
    nop