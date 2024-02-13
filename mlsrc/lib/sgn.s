min_caml_sgn:
    andi    a0, a0, 1
    beq a0, zero, min_caml_sgn_jmp
    li  a0, -1
    ret
min_caml_sgn_jmp:
    li  a0, 1
    ret
