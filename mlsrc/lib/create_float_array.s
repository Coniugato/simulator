min_caml_create_float_array:
    beq a0, zero, create_float_array_exit
    addi  sp, sp, -4
    fsw  sp, 0, fa0
    addi  a0, a0, -1
    j min_caml_create_float_array
create_float_array_exit:
    mv  a0, sp
    ret
