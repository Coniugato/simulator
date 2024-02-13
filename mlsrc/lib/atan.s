min_caml_atan:
    addrl    a0, __atan1__
    flw fa1, a0, 0
    fmul.s  fa3, fa0, fa0
    fadd.s  fa2, fa1, fa3
    fsqrt.s fa2, fa2
    fdiv.s  fa2, fa1, fa2
    addrl    a0, __atan_err__
    flw fa3, a0, 0
    addrl    a1, __atan2__
    flw fa5, a1, 0
    fmul.s  fa0, fa0, fa2
min_caml_atan_loop:
    fsub.s  fa4, fa1, fa2
    fsgnjx.s    fa4, fa4, fa4
    fle.s   a0, fa3, fa4
    beq a0, zero, min_caml_atan_cont
    fadd.s  fa2, fa1, fa2
    fdiv.s  fa2, fa2, fa5
    fmul.s  fa1, fa2, fa1
    fsqrt.s fa1, fa1
    j min_caml_atan_loop
min_caml_atan_cont:
    fdiv.s  fa0, fa0, fa2
    ret
