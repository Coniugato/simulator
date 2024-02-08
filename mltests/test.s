__entry__:
	j min_caml_start
fib.10:
	addi	a1, a0, -1
	bge	zero, a1, .Ble1
	addi	a1, a0, -1
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	fib.10
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	addi	a2, a2, -2
	sw	hp, 4, a1
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	fib.10
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	add	a0, a2, a1
	ret
.Ble1:
	nop
	li	a0, 1
	ret
min_caml_start:
	li	a0, 10
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	fib.10
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_print_int
	addi	hp, hp, -4
	lw	ra, hp, 0
	j __end__
min_caml_print_int:
    out a0
    ret
__end__:
	nop
