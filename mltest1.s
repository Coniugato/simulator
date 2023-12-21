	.section	.rodata
	.align	2
l.83:	#! 2.000000
	.word	2.000000
	.align	2
l.81:	#! 0.100000
	.word	0.100000
	.align	2
l.79:	#! 0.000100
	.word	0.000100
	.align	2
l.76:	#! 0.000000
	.word	0.000000
	.align	2
l.67:	#! 1.000000
	.word	1.000000
	.text
	.align 1
	.globl pow.24
	.type pow.24, @function
pow.24:
	li	t4, 0
	ble	a0, t4, ble_else.106
	lui	a0, %hi(l.67)
	addi	a0,a0,%lo(l.67)
	flw	 f10, 0(a0)
	ret
ble_else.106:
	addi	 a0, a0, -1
	fsw	f0, 0(sp)
	sw	ra, 4(sp)
	addi	sp, sp, 8
	call	pow.24
	addi	sp, sp, -8
	ld	ra, 4(sp)
	fmv.s	%f10, %f0
	flw	f1, 0(sp)
	fmul.s	f10, f1, f0
	ret
	.size	pow.24, .-pow.24
	.align 1
	.globl tmp.60
	.type tmp.60, @function
tmp.60:
	lw	 a0, 8(t5)
	flw	 f1, 4(t5)
	fsw	f1, 0(sp)
	sw	ra, 4(sp)
	addi	sp, sp, 8
	call	pow.24
	addi	sp, sp, -8
	ld	ra, 4(sp)
	fmv.s	%f10, %f0
	flw	f1, 0(sp)
	fsub.s	f10, f0, f1
	ret
	.size	tmp.60, .-tmp.60
	.align 1
	.globl f.27
	.type f.27, @function
f.27:
	mv	a1, tp
	addi	 tp, tp, 12
	lui	a2, %hi(tmp.60)
	addi	a2,a2,%lo(tmp.60)
	sw	 a2, 0(a1)
	sw	 a0, 8(a1)
	fsw	 f0, 4(a1)
	mv	a0, a1
	ret
	.size	f.27, .-f.27
	.align 1
	.globl tmp.54
	.type tmp.54, @function
tmp.54:
	lw	 a0, 4(t5)
	fsw	f0, 0(sp)
	sw	a0, 4(sp)
	sw	ra, 8(sp)
	addi	sp, sp, 12
	call	min_caml_float_of_int
	addi	sp, sp, -12
	ld	ra, 8(sp)
	fmv.s	%f10, %f0
	lw	a0, 4(sp)
	addi	 a0, a0, -1
	flw	f1, 0(sp)
	fsw	f0, 8(sp)
	fmv.s	%f0, f1
	sw	ra, 12(sp)
	addi	sp, sp, 16
	call	pow.24
	addi	sp, sp, -16
	ld	ra, 12(sp)
	fmv.s	%f10, %f0
	flw	f1, 8(sp)
	fmul.s	f10, f1, f0
	ret
	.size	tmp.54, .-tmp.54
	.align 1
	.globl df.30
	.type df.30, @function
df.30:
	mv	a1, tp
	addi	 tp, tp, 8
	lui	a2, %hi(tmp.54)
	addi	a2,a2,%lo(tmp.54)
	sw	 a2, 0(a1)
	sw	 a0, 4(a1)
	mv	a0, a1
	ret
	.size	df.30, .-df.30
	.align 1
	.globl abs.33
	.type abs.33, @function
abs.33:
	lui	a0, %hi(l.76)
	addi	a0,a0,%lo(l.76)
	flw	 f1, 0(a0)
	fle.s	t4, f1, f0
	addi	t4, t4, -1
	beqz	t4, bfle_else.107
	fmv.s	f10, f0
	ret
bfle_else.107:
	lui	a0, %hi(l.76)
	addi	a0,a0,%lo(l.76)
	flw	 f1, 0(a0)
	fsub.s	f10, f1, f0
	ret
	.size	abs.33, .-abs.33
	.align 1
	.globl step.35
	.type step.35, @function
step.35:
	flw	 f1, 4(t5)
	sw	a0, 0(sp)
	sw	t5, 4(sp)
	fsw	f1, 8(sp)
	fsw	f0, 12(sp)
	sw	a1, 16(sp)
	mv	t5, a0
	sw	ra, 20(sp)
	lw	t6, 0(t5)
	addi	sp, sp, 24
	jr	t6
	addi	sp, sp, -24
	lw	ra, 20(sp)
	flw	f1, 12(sp)
	lw	t5, 16(sp)
	fsw	f0, 20(sp)
	mv	t5, t5
	fmv.s	%f0, f1
	sw	ra, 24(sp)
	lw	t6, 0(t5)
	addi	sp, sp, 28
	jr	t6
	addi	sp, sp, -28
	lw	ra, 24(sp)
	flw	f1, 20(sp)
	fdiv.s	f0, f1, f0
	flw	f1, 12(sp)
	fsub.s	f0, f1, f0
	fsub.s	f1, f0, f1
	fsw	f0, 24(sp)
	fmv.s	%f0, f1
	sw	ra, 28(sp)
	addi	sp, sp, 32
	call	abs.33
	addi	sp, sp, -32
	ld	ra, 28(sp)
	fmv.s	%f10, %f0
	flw	f1, 8(sp)
	fle.s	t4, f1, f0
	addi	t4, t4, -1
	beqz	t4, bfle_else.108
	flw	f0, 24(sp)
	lw	a0, 0(sp)
	lw	a1, 16(sp)
	lw	t5, 4(sp)
	mv	t5, t5
	lw	t6, 0(t5)
	jr	t6
bfle_else.108:
	flw	f10, 24(sp)
	ret
	.size	step.35, .-step.35
	.align 1
	.globl	min_caml_start
	.type min_caml_start, @function
min_caml_start:
	sw	sp, -112(sp)
	lui	a0, %hi(l.79)
	addi	a0,a0,%lo(l.79)
	flw	 f0, 0(a0)
	mv	a0, tp
	addi	 tp, tp, 8
	lui	a1, %hi(step.35)
	addi	a1,a1,%lo(step.35)
	sw	 a1, 0(a0)
	fsw	 f0, 4(a0)
	lui	a1, %hi(l.81)
	addi	a1,a1,%lo(l.81)
	flw	 f0, 0(a1)
	li	a1, 2
	lui	a2, %hi(l.83)
	addi	a2,a2,%lo(l.83)
	flw	 f1, 0(a2)
	fsw	f0, 0(sp)
	sw	a0, 4(sp)
	mv	%a0, a1
	fmv.s	%f0, f1
	sw	ra, 8(sp)
	addi	sp, sp, 12
	call	f.27
	addi	sp, sp, -12
	ld	ra, 8(sp)
	li	a1, 2
	sw	a0, 8(sp)
	mv	%a0, a1
	sw	ra, 12(sp)
	addi	sp, sp, 16
	call	df.30
	addi	sp, sp, -16
	ld	ra, 12(sp)
	mv	a0, a1
	flw	f0, 0(sp)
	lw	a0, 8(sp)
	lw	t5, 4(sp)
	mv	t5, t5
	sw	ra, 12(sp)
	lw	t6, 0(t5)
	addi	sp, sp, 16
	jr	t6
	addi	sp, sp, -16
	lw	ra, 12(sp)
	sw	ra, 12(sp)
	addi	sp, sp, 16
	call	min_caml_print_float
	addi	sp, sp, -16
	ld	ra, 12(sp)
	ret
	.size	min_caml_start, .-min_caml_start
