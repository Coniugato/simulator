min_caml_create_float_array_global:
    add a3, t4, a1
min_caml_create_float_array_global_loop:
    beq a0, zero, min_caml_create_float_array_global_exit
    fsw a3, 0, fa0
    addi    a3, a3, 4
    addi  a0, a0, -1
    j min_caml_create_float_array_global_loop
min_caml_create_float_array_global_exit:
    add a0, t4, a1
    ret
