min_caml_create_array_global:
    add a3, t4, a2
min_caml_create_array_global_loop:
    beq a0, zero, min_caml_create_array_global_exit
    sw  a3, 0, a1
    addi    a3, a3, 4
    addi    a0, a0, -1
    j min_caml_create_array_global_loop
min_caml_create_array_global_exit:
    add a0, t4, a2
    ret
