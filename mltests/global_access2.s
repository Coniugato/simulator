__entry__:
	mv	t4, hp
	lim	hp, 8
	add	hp, hp, t4
	j min_caml_start
prod_pred.33:
	li	a1, 2
	li	a2, 0
	sw	hp, 0, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	lw	a3, a2, 0
	sw	hp, 4, a1
	mv	a0, a3
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_succ
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	sw	a2, 0, a1
	lw	a1, hp, 0
	lw	a1, a1, 0
	sw	a2, 4, a1
	mv	a0, a2
	ret
loop.35:
	beq	a0, zero, .Beq1
	addi	a2, a0, -1
	mv	a0, a2
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	loop.35
	addi	hp, hp, -4
	lw	ra, hp, 0
	mv	a1, a0
	mv	a0, a1
	j	prod_pred.33
.Beq1:
	nop
	mv	a0, a1
	ret
snd.38:
	li	a1, 4
	add	a1, a0, a1
	lw	a0, a1, 0
	ret
rem10.40:
	addi	a1, a0, -10
	bge	a1, zero, .Bge2
	ret
.Bge2:
	nop
	addi	a1, a0, -10
	mv	a0, a1
	j	rem10.40
dight_print.42:
	bge	zero, a0, .Ble3
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	rem10.40
	addi	hp, hp, -8
	lw	ra, hp, 4
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_float_of_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	addrl	a0, l.83
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_int_of_float
	addi	hp, hp, -8
	lw	ra, hp, 4
	j	dight_print.42
.Ble3:
	nop
	ret
min_caml_start:
	li	a0, 2
	li	a1, 0
	li	a2, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	lim	a0, 13285
	mv	a1, t4
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	loop.35
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	snd.38
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	dight_print.42
	addi	hp, hp, -4
	lw	ra, hp, 0
	j __end__
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
min_caml_int_of_float:
    fcvt.w.s    a0, fa0
    ret
min_caml_float_of_int:
    fcvt.s.w  fa0, a0
    ret
min_caml_print_int:
    li  a1, 200
    bge a0, a1, min_caml_print_int_100_2
    li  a1, 100
    bge a0, a1, min_caml_print_int_100_1
    j   min_caml_print_int_100_0
min_caml_print_int_100_2:
    li  a2, 50
    out a2
    sub a0, a0, a1
    j   min_caml_print_int_10
min_caml_print_int_100_1:
    li  a2, 49
    out a2
    sub a0, a0, a1
    j   min_caml_print_int_10
min_caml_print_int_100_0:
    li  a2, 48
    out a2
min_caml_print_int_10:
    li a1, 90
    bge a0, a1, min_caml_print_int_10_9
    li a1, 80
    bge a0, a1, min_caml_print_int_10_8
    li a1, 70
    bge a0, a1, min_caml_print_int_10_7
    li a1, 60
    bge a0, a1, min_caml_print_int_10_6
    li a1, 50
    bge a0, a1, min_caml_print_int_10_5
    li a1, 40
    bge a0, a1, min_caml_print_int_10_4
    li a1, 30
    bge a0, a1, min_caml_print_int_10_3
    li a1, 20
    bge a0, a1, min_caml_print_int_10_2
    li a1, 10
    bge a0, a1, min_caml_print_int_10_1
    j min_caml_print_int_10_0
min_caml_print_int_10_9:
    li  a2, 57
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_8:
    li  a2, 56
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_7:
    li  a2, 55
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_6:
    li  a2, 54
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_5:
    li  a2, 53
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_4:
    li  a2, 52
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_3:
    li  a2, 51
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_2:
    li  a2, 50
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_1:
    li  a2, 49
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_0:
    li  a2, 48
    out a2
min_caml_print_int_1:
    li a1, 9
    bge a0, a1, min_caml_print_int_1_9
    li a1, 8
    bge a0, a1, min_caml_print_int_1_8
    li a1, 7
    bge a0, a1, min_caml_print_int_1_7
    li a1, 6
    bge a0, a1, min_caml_print_int_1_6
    li a1, 5
    bge a0, a1, min_caml_print_int_1_5
    li a1, 4
    bge a0, a1, min_caml_print_int_1_4
    li a1, 3
    bge a0, a1, min_caml_print_int_1_3
    li a1, 2
    bge a0, a1, min_caml_print_int_1_2
    li a1, 1
    bge a0, a1, min_caml_print_int_1_1
    li a1, 0
    bge a0, a1, min_caml_print_int_1_0
min_caml_print_int_1_9:
    li  a2, 57
    out a2
    ret
min_caml_print_int_1_8:
    li  a2, 56
    out a2
    ret
min_caml_print_int_1_7:
    li  a2, 55
    out a2
    ret
min_caml_print_int_1_6:
    li  a2, 54
    out a2
    ret
min_caml_print_int_1_5:
    li  a2, 53
    out a2
    ret
min_caml_print_int_1_4:
    li  a2, 52
    out a2
    ret
min_caml_print_int_1_3:
    li  a2, 51
    out a2
    ret
min_caml_print_int_1_2:
    li  a2, 50
    out a2
    ret
min_caml_print_int_1_1:
    li  a2, 49
    out a2
    ret
min_caml_print_int_1_0:
    li  a2, 48
    out a2
    ret
min_caml_succ:
    addi a0, a0, 1
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
l.83:
	.data float, 10.000000
