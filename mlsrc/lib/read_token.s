min_caml_read_token:
    in  a1
    li  a2, 20
    beq a1, a2, min_caml_read_token_ctrl
    li  a2, 9
    beq a1, a2, min_caml_read_token_ctrl
    li  a2, 10
    beq a1, a2, min_caml_read_token_ctrl
    li  a2, 13
    beq a1, a2, min_caml_read_token_ctrl
    lw  a0, t4, 4
    add a2, t4, a0
    sw  a2, 4, a1
    addi    a0, a0, 4
    sw  t4, 4, a0
    li  a0, 1
    j min_caml_read_token
min_caml_read_token_ctrl:
    beq a0, zero, min_caml_read_token_cont
    li  a0, zero
    ret
min_caml_read_token_cont:
    li  a0, 0
    j   min_caml_read_token