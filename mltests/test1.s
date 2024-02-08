__entry__:
	j min_caml_start
rem10.16:
	addi	a1, a0, -10
	bge	a1, zero, .Bge1
	ret
.Bge1:
	nop
	addi	a1, a0, -10
	mv	a0, a1
	j	rem10.16
dight_print.18:
	sw	hp, 0, a0
	fsw	hp, 4, fa0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_int_of_float
	addi	hp, hp, -12
	lw	ra, hp, 8
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	rem10.16
	addi	hp, hp, -12
	lw	ra, hp, 8
	flw	fa0, hp, 4
	sw	hp, 8, a0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_int_of_float
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	add	a0, a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_float_of_int
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 4
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	bge	zero, a0, .Ble2
	lw	a1, hp, 8
	fsw	hp, 12, fa0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_print_int
	addi	hp, hp, -20
	lw	ra, hp, 16
	addrl	a0, l.38
	flw	fa0, a0, 0
	flw	fa1, hp, 12
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	addi	a0, a0, -1
	j	dight_print.18
.Ble2:
	nop
	lw	a0, hp, 8
	j	min_caml_print_int
min_caml_start:
	addrl	a0, l.40
	flw	fa0, a0, 0
	li	a0, 10
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	dight_print.18
	addi	hp, hp, -4
	lw	ra, hp, 0
	j __end__
min_caml_print_int:
    out a0
    ret
min_caml_float_of_int:
    fcvt.s.w  fa0, a0
    ret
min_caml_int_of_float:
    fcvt.w.s    a0, fa0
    ret
__end__:
	nop
l.40:
	.data float, 3.247650
l.38:
	.data float, 10.000000
