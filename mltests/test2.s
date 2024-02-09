__entry__:
	j min_caml_start
dfdx.43:
	flw	fa1, t6, 4
	fadd.s	fa2, fa0, fa1
	fsw	hp, 0, fa1
	fsw	hp, 4, fa0
	sw	hp, 8, a0
	mv	t6, a0
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 4
	lw	t6, hp, 8
	fsw	hp, 12, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 12
	fsub.s	fa1, fa2, fa1
	flw	fa2, hp, 0
	fdiv.s	fa0, fa1, fa2
	ret
fl_abs.46:
	addrl	a0, l.96
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq1
	addrl	a0, l.96
	flw	fa1, a0, 0
	fsub.s	fa0, fa1, fa0
	ret
.Beq1:
	nop
	ret
newton.48:
	flw	fa1, t6, 8
	lw	a1, t6, 4
	sw	hp, 0, t6
	fsw	hp, 4, fa1
	fsw	hp, 8, fa0
	sw	hp, 12, a0
	sw	hp, 16, a1
	mv	t6, a0
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	fsgnj.s	fa1, fa0, fa0
	lw	a0, hp, 12
	flw	fa2, hp, 8
	lw	t6, hp, 16
	fsw	hp, 20, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 20
	fdiv.s	fa1, fa2, fa1
	flw	fa2, hp, 8
	fsub.s	fa1, fa2, fa1
	fsub.s	fa3, fa1, fa2
	fsw	hp, 24, fa1
	fsgnj.s	fa0, fa3, fa3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	fl_abs.46
	addi	hp, hp, -32
	lw	ra, hp, 28
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 4
	fle.s	a0, fa2, fa1
	beq	a0, zero, .Beq2
	lw	a0, hp, 12
	flw	fa1, hp, 24
	lw	t6, hp, 0
	fsgnj.s	fa0, fa1, fa1
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq2:
	nop
	flw	fa1, hp, 8
	fsgnj.s	fa0, fa1, fa1
	ret
f.51:
	fmul.s	fa1, fa0, fa0
	addrl	a0, l.101
	flw	fa2, a0, 0
	fmul.s	fa2, fa2, fa0
	fsub.s	fa0, fa1, fa2
	ret
rem10.53:
	addi	a1, a0, -10
	bge	a1, zero, .Bge3
	ret
.Bge3:
	nop
	addi	a1, a0, -10
	mv	a0, a1
	j	rem10.53
dight_print.55:
	bge	zero, a0, .Ble4
	sw	hp, 0, a0
	fsw	hp, 4, fa0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_int_of_float
	addi	hp, hp, -12
	lw	ra, hp, 8
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	rem10.53
	addi	hp, hp, -12
	lw	ra, hp, 8
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	addrl	a0, l.103
	flw	fa0, a0, 0
	flw	fa1, hp, 4
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	addi	a0, a0, -1
	j	dight_print.55
.Ble4:
	nop
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_int_of_float
	addi	hp, hp, -12
	lw	ra, hp, 8
	j	min_caml_print_int
min_caml_start:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	fsw	hp, 0, fa0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_read_float
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 3
	flw	fa1, hp, 0
	fadd.s	fa0, fa1, fa0
	sw	hp, 4, a0
	fsw	hp, 8, fa0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_read_float
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fadd.s	fa0, fa1, fa0
	lw	a0, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_float_array
	addi	hp, hp, -16
	lw	ra, hp, 12
	addrl	a1, l.105
	flw	fa0, a1, 0
	addrl	a1, l.105
	flw	fa1, a1, 0
	addi	sp, sp, -8
	mv	a1, sp
	iaddrl	a2, dfdx.43
	sw	a1, 0, a2
	fsw	a1, 4, fa0
	addi	sp, sp, -12
	mv	t6, sp
	iaddrl	a2, newton.48
	sw	t6, 0, a2
	fsw	t6, 8, fa1
	sw	t6, 4, a1
	addi	sp, sp, -4
	mv	a1, sp
	iaddrl	a2, f.51
	sw	a1, 0, a2
	flw	fa0, a0, 8
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 10
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	dight_print.55
	addi	hp, hp, -16
	lw	ra, hp, 12
	j __end__
min_caml_create_float_array:
    beq a0, zero, create_float_array_exit
    addi  sp, sp, -4
    fsw  sp, 0, fa0
    addi  a0, a0, -1
    j min_caml_create_float_array
create_float_array_exit:
    mv  a0, sp
    ret
min_caml_read_float:
    fin fa0
    ret
min_caml_int_of_float:
    fcvt.w.s    a0, fa0
    ret
min_caml_print_int:
    out a0
    ret
__end__:
	nop
l.105:
	.data float, 0.000010
l.103:
	.data float, 10.000000
l.101:
	.data float, 3.141593
l.96:
	.data float, 0.000000
