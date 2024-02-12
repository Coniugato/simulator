__entry__:
	mv	t4, hp
	lim	hp, 0
	add	hp, hp, t4
	j min_caml_start
loop3.149:
	lw	a1, t6, 20
	lw	a2, t6, 16
	lw	a3, t6, 12
	lw	a4, t6, 8
	lw	a5, t6, 4
	bge	a0, zero, .Bge1
	ret
.Bge1:
	nop
	slli	a6, a2, 2
	add	a6, a3, a6
	lw	a6, a6, 0
	slli	a7, a2, 2
	add	a3, a3, a7
	lw	a3, a3, 0
	slli	a7, a1, 2
	add	a3, a3, a7
	lw	a3, a3, 0
	slli	a2, a2, 2
	add	a2, a5, a2
	lw	a2, a2, 0
	slli	a5, a0, 2
	add	a2, a2, a5
	lw	a2, a2, 0
	slli	a5, a0, 2
	add	a4, a4, a5
	lw	a4, a4, 0
	slli	a5, a1, 2
	add	a4, a4, a5
	lw	a4, a4, 0
	mul	a2, a2, a4
	add	a2, a3, a2
	slli	a1, a1, 2
	add	a1, a6, a1
	sw	a1, 0, a2
	addi	a0, a0, -1
	lw	t5, t6, 0
	jalr	zero, t5, 0
loop2.141:
	lw	a1, t6, 20
	lw	a2, t6, 16
	lw	a3, t6, 12
	lw	a4, t6, 8
	lw	a5, t6, 4
	bge	a0, zero, .Bge2
	ret
.Bge2:
	nop
	addi	sp, sp, -24
	mv	a6, sp
	iaddrl	a7, loop3.149
	sw	a6, 0, a7
	sw	a6, 20, a0
	sw	a6, 16, a2
	sw	a6, 12, a3
	sw	a6, 8, a4
	sw	a6, 4, a5
	addi	a1, a1, -1
	sw	hp, 0, t6
	sw	hp, 4, a0
	mv	a0, a1
	mv	t6, a6
	sw	hp, 8, ra
	addi	hp, hp, 12
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	addi	a0, a0, -1
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
loop1.136:
	lw	a1, t6, 20
	lw	a2, t6, 16
	lw	a3, t6, 12
	lw	a4, t6, 8
	lw	a5, t6, 4
	bge	a0, zero, .Bge3
	ret
.Bge3:
	nop
	addi	sp, sp, -24
	mv	a6, sp
	iaddrl	a7, loop2.141
	sw	a6, 0, a7
	sw	a6, 20, a2
	sw	a6, 16, a0
	sw	a6, 12, a3
	sw	a6, 8, a4
	sw	a6, 4, a5
	addi	a1, a1, -1
	sw	hp, 0, t6
	sw	hp, 4, a0
	mv	a0, a1
	mv	t6, a6
	sw	hp, 8, ra
	addi	hp, hp, 12
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	addi	a0, a0, -1
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
mul.75:
	addi	sp, sp, -24
	mv	t6, sp
	iaddrl	a6, loop1.136
	sw	t6, 0, a6
	sw	t6, 20, a2
	sw	t6, 16, a1
	sw	t6, 12, a5
	sw	t6, 8, a4
	sw	t6, 4, a3
	addi	a0, a0, -1
	lw	t5, t6, 0
	jalr	zero, t5, 0
init.82:
	li	a1, 0
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
	li	a2, 2
	mv	a0, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	li	a2, 2
	lw	a3, hp, 0
	sw	hp, 4, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	sw	a2, 0, a1
	li	a1, 2
	lw	a3, hp, 0
	mv	a0, a1
	mv	a1, a3
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	sw	a2, 4, a1
	mv	a0, a2
	ret
min_caml_start:
	li	a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	init.82
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a1, 0
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	init.82
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a1, 0
	sw	hp, 4, a0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	init.82
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a5, a0
	lw	a3, hp, 0
	lw	a0, a3, 0
	li	a1, 1
	sw	a0, 0, a1
	lw	a0, a3, 0
	li	a1, 1
	sw	a0, 4, a1
	lw	a0, a3, 4
	li	a1, 1
	sw	a0, 4, a1
	lw	a4, hp, 4
	lw	a0, a4, 0
	li	a1, 1
	sw	a0, 0, a1
	lw	a0, a4, 4
	li	a1, 1
	sw	a0, 4, a1
	li	a0, 2
	li	a1, 2
	li	a2, 2
	sw	hp, 8, a5
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	mul.75
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	lw	a0, a0, 0
	lw	a0, a0, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_print_int
	addi	hp, hp, -16
	lw	ra, hp, 12
	j __end__
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
