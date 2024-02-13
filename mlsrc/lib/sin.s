min_caml_sin:
    addrl    a0, __piinv__
    flw fa1, a0, 0
    addrl a1, __pi__
    flw fa2, a1, 0
    addrl    a2, __piover2__
    flw fa3, a2, 0
    fmul.s  fa1, fa0, fa1
    fround    a4, fa1
    fcvt.s.w    fa1, a4
    fmul.s  fa1, fa1, fa2
    fsub.s  fa1, fa0, fa1
    fle.s   a0, fa3, fa1
    beq a0, zero, min_caml_sin_label1
    fsub.s  fa1, fa1, fa2
    addi    a4, a4, -1
    j   min_caml_sin_label2
min_caml_sin_label1:
    fsgnjn.s    fa3, fa3, fa3
    fle.s   a0, fa1, fa3
    beq a0, zero, min_caml_sin_label2
    fadd.s  fa1, fa1, fa2
    addi    a4, a4, 1
min_caml_sin_label2:
    fmul.s  fa3, fa1, fa1
    addrl   a0, __a9__
    flw fa0, a0, 0
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a7__
    flw fa2, a0, 0
    fsub.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a5__
    flw fa2, a0, 0
    fadd.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a3__
    flw fa2, a0, 0
    fsub.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
	fmul.s	fa0, fa0, fa1
    fadd.s  fa0, fa0, fa1
    li  a1, 1
    and a1, a1, a4
    beq a1, zero, min_caml_sin_label3
    fsgnjn.s    fa0, fa0, fa0
min_caml_sin_label3:
    ret