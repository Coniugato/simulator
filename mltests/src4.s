__entry__:
	j min_caml_start
xor.2356:
	beq	a0, zero, .Beq1
	beq	a1, zero, .Beq2
	li	a0, 0
	ret
.Beq2:
	nop
	li	a0, 1
	ret
.Beq1:
	nop
	mv	a0, a1
	ret
sgn.2359:
	addrl	a0, l.7060
	flw	fa1, a0, 0
	feq.s	a0, fa0, fa1
	beq	a0, zero, .Beq3
	addrl	a0, l.7060
	flw	fa0, a0, 0
	ret
.Beq3:
	nop
	addrl	a0, l.7060
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq4
	addrl	a0, l.7058
	flw	fa0, a0, 0
	ret
.Beq4:
	nop
	addrl	a0, l.7056
	flw	fa0, a0, 0
	ret
fneg_cond.2361:
	beq	a0, zero, .Beq5
	ret
.Beq5:
	nop
	fsgnjn.s	fa0, fa0, fa0
	ret
add_mod5.2364:
	add	a1, a0, a1
	addi	a2, a1, -5
	bge	a2, zero, .Bge6
	mv	a0, a1
	ret
.Bge6:
	nop
	addi	a0, a1, -5
	ret
vecset.2367:
	fsw	a0, 0, fa0
	fsw	a0, 4, fa1
	addi	a0, a0, 8
	fsw	a0, 0, fa2
	ret
vecfill.2372:
	fsw	a0, 0, fa0
	fsw	a0, 4, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
vecbzero.2375:
	addrl	a1, l.7060
	flw	fa0, a1, 0
	j	vecfill.2372
veccpy.2377:
	flw	fa0, a1, 0
	fsw	a0, 0, fa0
	flw	fa0, a1, 4
	fsw	a0, 4, fa0
	flw	fa0, a1, 8
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
vecunit_sgn.2380:
	flw	fa0, a0, 0
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, a0, 4
	flw	fa2, a0, 4
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	flw	fa1, a0, 8
	flw	fa2, a0, 8
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_sqrt
	addi	hp, hp, -12
	lw	ra, hp, 8
	addrl	a0, l.7060
	flw	fa1, a0, 0
	feq.s	a0, fa0, fa1
	beq	a0, zero, .Beq7
	addrl	a0, l.7056
	flw	fa0, a0, 0
	j	.Cont8
.Beq7:
	nop
	lw	a0, hp, 4
	beq	a0, zero, .Beq9
	addrl	a0, l.7058
	flw	fa1, a0, 0
	fdiv.s	fa0, fa1, fa0
	j	.Cont10
.Beq9:
	nop
	addrl	a0, l.7056
	flw	fa1, a0, 0
	fdiv.s	fa0, fa1, fa0
.Cont10:
	nop
.Cont8:
	nop
	lw	a0, hp, 0
	flw	fa1, a0, 0
	fmul.s	fa1, fa1, fa0
	fsw	a0, 0, fa1
	flw	fa1, a0, 4
	fmul.s	fa1, fa1, fa0
	fsw	a0, 4, fa1
	flw	fa1, a0, 8
	fmul.s	fa0, fa1, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
veciprod.2383:
	flw	fa1, a0, 0
	flw	fa2, a1, 0
	fmul.s	fa1, fa1, fa2
	flw	fa2, a0, 4
	flw	fa3, a1, 4
	fmul.s	fa2, fa2, fa3
	fadd.s	fa1, fa1, fa2
	flw	fa2, a0, 8
	flw	fa3, a1, 8
	fmul.s	fa2, fa2, fa3
	fadd.s	fa0, fa1, fa2
	ret
veciprod2.2386:
	flw	fa3, a0, 0
	fmul.s	fa3, fa3, fa0
	flw	fa4, a0, 4
	fmul.s	fa1, fa4, fa1
	fadd.s	fa1, fa3, fa1
	flw	fa3, a0, 8
	fmul.s	fa2, fa3, fa2
	fadd.s	fa0, fa1, fa2
	ret
vecaccum.2391:
	flw	fa1, a0, 0
	flw	fa2, a1, 0
	fmul.s	fa2, fa0, fa2
	fadd.s	fa1, fa1, fa2
	fsw	a0, 0, fa1
	flw	fa1, a0, 4
	flw	fa2, a1, 4
	fmul.s	fa2, fa0, fa2
	fadd.s	fa1, fa1, fa2
	fsw	a0, 4, fa1
	flw	fa1, a0, 8
	flw	fa2, a1, 8
	fmul.s	fa0, fa0, fa2
	fadd.s	fa0, fa1, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
vecadd.2395:
	flw	fa0, a0, 0
	flw	fa1, a1, 0
	fadd.s	fa0, fa0, fa1
	fsw	a0, 0, fa0
	flw	fa0, a0, 4
	flw	fa1, a1, 4
	fadd.s	fa0, fa0, fa1
	fsw	a0, 4, fa0
	flw	fa0, a0, 8
	flw	fa1, a1, 8
	fadd.s	fa0, fa0, fa1
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
vecscale.2398:
	flw	fa1, a0, 0
	fmul.s	fa1, fa1, fa0
	fsw	a0, 0, fa1
	flw	fa1, a0, 4
	fmul.s	fa1, fa1, fa0
	fsw	a0, 4, fa1
	flw	fa1, a0, 8
	fmul.s	fa0, fa1, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
vecaccumv.2401:
	flw	fa0, a0, 0
	flw	fa1, a1, 0
	flw	fa2, a2, 0
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	fsw	a0, 0, fa0
	flw	fa0, a0, 4
	flw	fa1, a1, 4
	flw	fa2, a2, 4
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	fsw	a0, 4, fa0
	flw	fa0, a0, 8
	flw	fa1, a1, 8
	flw	fa2, a2, 8
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
o_texturetype.2405:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a1, a0, 4
	lw	a1, a0, 0
	mv	a0, a1
	ret
o_form.2407:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a1, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
o_reflectiontype.2409:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
o_isinvert.2411:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
o_isrot.2413:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
o_param_a.2415:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	mv	a0, a1
	flw	fa0, a0, 0
	ret
o_param_b.2417:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 4
	flw	fa0, a0, 0
	ret
o_param_c.2419:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 8
	flw	fa0, a0, 0
	ret
o_param_abc.2421:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
o_param_x.2423:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	mv	a0, a1
	flw	fa0, a0, 0
	ret
o_param_y.2425:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 4
	flw	fa0, a0, 0
	ret
o_param_z.2427:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 8
	flw	fa0, a0, 0
	ret
o_diffuse.2429:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	mv	a0, a1
	flw	fa0, a0, 0
	ret
o_hilight.2431:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a1, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 4
	flw	fa0, a0, 0
	ret
o_color_red.2433:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	mv	a0, a1
	flw	fa0, a0, 0
	ret
o_color_green.2435:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 4
	flw	fa0, a0, 0
	ret
o_color_blue.2437:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a1, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 8
	flw	fa0, a0, 0
	ret
o_param_r1.2439:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a2, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	mv	a0, a1
	flw	fa0, a0, 0
	ret
o_param_r2.2441:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a2, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 4
	flw	fa0, a0, 0
	ret
o_param_r3.2443:
	lw	a1, a0, 40
	lw	a1, a0, 36
	lw	a2, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a0, a0, 0
	addi	a0, a1, 8
	flw	fa0, a0, 0
	ret
o_param_ctbl.2445:
	lw	a1, a0, 40
	lw	a2, a0, 36
	lw	a2, a0, 32
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_rgb.2447:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a1, a0, 4
	lw	a1, a0, 0
	mv	a0, a1
	ret
p_intersection_points.2449:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a1, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_surface_ids.2451:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a1, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_calc_diffuse.2453:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a1, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_energy.2455:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a1, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_received_ray_20percent.2457:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a1, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
p_group_id.2459:
	lw	a1, a0, 28
	lw	a1, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	lw	a0, a1, 0
	ret
p_set_group_id.2461:
	lw	a2, a0, 28
	lw	a2, a0, 24
	lw	a3, a0, 20
	lw	a3, a0, 16
	lw	a3, a0, 12
	lw	a3, a0, 8
	lw	a3, a0, 4
	lw	a0, a0, 0
	mv	a0, a2
	sw	a0, 0, a1
	ret
p_nvectors.2464:
	lw	a1, a0, 28
	lw	a2, a0, 24
	lw	a2, a0, 20
	lw	a2, a0, 16
	lw	a2, a0, 12
	lw	a2, a0, 8
	lw	a2, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
d_vec.2466:
	lw	a1, a0, 4
	lw	a1, a0, 0
	mv	a0, a1
	ret
d_const.2468:
	lw	a1, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
r_surface_id.2470:
	flw	fa0, a0, 8
	lw	a1, a0, 4
	lw	a1, a0, 0
	mv	a0, a1
	ret
r_dvec.2472:
	flw	fa0, a0, 8
	lw	a1, a0, 4
	lw	a2, a0, 0
	mv	a0, a1
	ret
r_bright.2474:
	flw	fa1, a0, 8
	lw	a1, a0, 4
	lw	a0, a0, 0
	fsgnj.s	fa0, fa1, fa1
	ret
rad.2476:
	addrl	a0, l.7069
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	ret
read_screen_settings.2478:
	lw	a0, t6, 20
	lw	a1, t6, 16
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a0
	sw	hp, 4, a2
	sw	hp, 8, a3
	sw	hp, 12, a1
	sw	hp, 16, a4
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_float
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 16
	fsw	a0, 0, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_float
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 16
	fsw	a0, 4, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_float
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 16
	fsw	a0, 8, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_float
	addi	hp, hp, -24
	lw	ra, hp, 20
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	rad.2476
	addi	hp, hp, -24
	lw	ra, hp, 20
	fsw	hp, 20, fa0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_cos
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsw	hp, 24, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_sin
	addi	hp, hp, -32
	lw	ra, hp, 28
	fsw	hp, 28, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_read_float
	addi	hp, hp, -36
	lw	ra, hp, 32
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	rad.2476
	addi	hp, hp, -36
	lw	ra, hp, 32
	fsw	hp, 32, fa0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_cos
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fsw	hp, 36, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_sin
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 24
	fmul.s	fa2, fa1, fa0
	addrl	a0, l.7072
	flw	fa3, a0, 0
	fmul.s	fa2, fa2, fa3
	lw	a0, hp, 12
	fsw	a0, 0, fa2
	addrl	a1, l.7074
	flw	fa2, a1, 0
	flw	fa3, hp, 28
	fmul.s	fa2, fa3, fa2
	fsw	a0, 4, fa2
	flw	fa2, hp, 36
	fmul.s	fa4, fa1, fa2
	addrl	a1, l.7072
	flw	fa5, a1, 0
	fmul.s	fa4, fa4, fa5
	fsw	a0, 8, fa4
	lw	a1, hp, 8
	fsw	a1, 0, fa2
	addrl	a2, l.7060
	flw	fa4, a2, 0
	fsw	a1, 4, fa4
	fsgnjn.s	fa4, fa0, fa0
	fsw	a1, 8, fa4
	fsgnjn.s	fa4, fa3, fa3
	fmul.s	fa0, fa4, fa0
	lw	a1, hp, 4
	fsw	a1, 0, fa0
	fsgnjn.s	fa0, fa1, fa1
	fsw	a1, 4, fa0
	fsgnjn.s	fa0, fa3, fa3
	fmul.s	fa0, fa0, fa2
	fsw	a1, 8, fa0
	lw	a1, hp, 16
	flw	fa0, a1, 0
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	lw	a2, hp, 0
	fsw	a2, 0, fa0
	flw	fa0, a1, 4
	flw	fa1, a0, 4
	fsub.s	fa0, fa0, fa1
	fsw	a2, 4, fa0
	flw	fa0, a1, 8
	flw	fa1, a0, 8
	fsub.s	fa0, fa0, fa1
	addi	a0, a2, 8
	fsw	a0, 0, fa0
	ret
read_light.2480:
	lw	a0, t6, 8
	lw	a1, t6, 4
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_read_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_read_float
	addi	hp, hp, -12
	lw	ra, hp, 8
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	rad.2476
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsw	hp, 8, fa0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_sin
	addi	hp, hp, -16
	lw	ra, hp, 12
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 4
	fsw	a0, 4, fa0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_read_float
	addi	hp, hp, -16
	lw	ra, hp, 12
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	rad.2476
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fsw	hp, 12, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_cos
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsw	hp, 16, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_sin
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	a0, 0, fa0
	flw	fa0, hp, 12
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_cos
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	a0, 8, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_float
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 0
	fsw	a0, 0, fa0
	ret
rotate_quadratic_matrix.2482:
	flw	fa0, a1, 0
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_cos
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	flw	fa1, a0, 0
	fsw	hp, 8, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_sin
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 4
	flw	fa1, a0, 4
	fsw	hp, 12, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_cos
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 4
	flw	fa1, a0, 4
	fsw	hp, 16, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_sin
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 4
	flw	fa1, a0, 8
	fsw	hp, 20, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_cos
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a0, hp, 4
	flw	fa1, a0, 8
	fsw	hp, 24, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_sin
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	flw	fa2, hp, 16
	fmul.s	fa3, fa2, fa1
	flw	fa4, hp, 20
	flw	fa5, hp, 12
	fmul.s	fa6, fa5, fa4
	fmul.s	fa6, fa6, fa1
	flw	fa7, hp, 8
	fmul.s	fs0, fa7, fa0
	fsub.s	fa6, fa6, fs0
	fmul.s	fs0, fa7, fa4
	fmul.s	fs0, fs0, fa1
	fmul.s	fs1, fa5, fa0
	fadd.s	fs0, fs0, fs1
	fmul.s	fs1, fa2, fa0
	fmul.s	fs2, fa5, fa4
	fmul.s	fs2, fs2, fa0
	fmul.s	fs3, fa7, fa1
	fadd.s	fs2, fs2, fs3
	fmul.s	fs3, fa7, fa4
	fmul.s	fa0, fs3, fa0
	fmul.s	fa1, fa5, fa1
	fsub.s	fa0, fa0, fa1
	fsgnjn.s	fa1, fa4, fa4
	fmul.s	fa4, fa5, fa2
	fmul.s	fa2, fa7, fa2
	lw	a0, hp, 0
	flw	fa5, a0, 0
	flw	fa7, a0, 4
	flw	fs3, a0, 8
	fmul.s	fs4, fa3, fa3
	fmul.s	fs4, fa5, fs4
	fmul.s	fs5, fs1, fs1
	fmul.s	fs5, fa7, fs5
	fadd.s	fs4, fs4, fs5
	fmul.s	fs5, fa1, fa1
	fmul.s	fs5, fs3, fs5
	fadd.s	fs4, fs4, fs5
	fsw	a0, 0, fs4
	fmul.s	fs4, fa6, fa6
	fmul.s	fs4, fa5, fs4
	fmul.s	fs5, fs2, fs2
	fmul.s	fs5, fa7, fs5
	fadd.s	fs4, fs4, fs5
	fmul.s	fs5, fa4, fa4
	fmul.s	fs5, fs3, fs5
	fadd.s	fs4, fs4, fs5
	fsw	a0, 4, fs4
	fmul.s	fs4, fs0, fs0
	fmul.s	fs4, fa5, fs4
	fmul.s	fs5, fa0, fa0
	fmul.s	fs5, fa7, fs5
	fadd.s	fs4, fs4, fs5
	fmul.s	fs5, fa2, fa2
	fmul.s	fs5, fs3, fs5
	fadd.s	fs4, fs4, fs5
	fsw	a0, 8, fs4
	addrl	a0, l.7077
	flw	fs4, a0, 0
	fmul.s	fs5, fa5, fa6
	fmul.s	fs5, fs5, fs0
	fmul.s	fs6, fa7, fs2
	fmul.s	fs6, fs6, fa0
	fadd.s	fs5, fs5, fs6
	fmul.s	fs6, fs3, fa4
	fmul.s	fs6, fs6, fa2
	fadd.s	fs5, fs5, fs6
	fmul.s	fs4, fs4, fs5
	lw	a0, hp, 4
	fsw	a0, 0, fs4
	addrl	a1, l.7077
	flw	fs4, a1, 0
	fmul.s	fs5, fa5, fa3
	fmul.s	fs0, fs5, fs0
	fmul.s	fs5, fa7, fs1
	fmul.s	fa0, fs5, fa0
	fadd.s	fa0, fs0, fa0
	fmul.s	fs0, fs3, fa1
	fmul.s	fa2, fs0, fa2
	fadd.s	fa0, fa0, fa2
	fmul.s	fa0, fs4, fa0
	fsw	a0, 4, fa0
	addrl	a1, l.7077
	flw	fa0, a1, 0
	fmul.s	fa2, fa5, fa3
	fmul.s	fa2, fa2, fa6
	fmul.s	fa3, fa7, fs1
	fmul.s	fa3, fa3, fs2
	fadd.s	fa2, fa2, fa3
	fmul.s	fa1, fs3, fa1
	fmul.s	fa1, fa1, fa4
	fadd.s	fa1, fa2, fa1
	fmul.s	fa0, fa0, fa1
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
read_nth_object.2485:
	lw	a1, t6, 4
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_read_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	addi	a2, a1, 1
	beq	a2, zero, .Beq11
	sw	hp, 8, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_read_int
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_read_int
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	sw	hp, 16, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_read_int
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 20, a1
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_create_float_array
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	sw	hp, 24, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_read_float
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 24
	fsw	a1, 0, fa0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_read_float
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 24
	fsw	a1, 4, fa0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_read_float
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 24
	fsw	a1, 8, fa0
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_create_float_array
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	sw	hp, 28, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_read_float
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 28
	fsw	a1, 0, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_read_float
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 28
	fsw	a1, 4, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_read_float
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 28
	fsw	a1, 8, fa0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	fsw	hp, 32, fa0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_read_float
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq12
	li	a1, 0
	j	.Cont13
.Beq12:
	nop
	li	a1, 1
.Cont13:
	nop
	li	a2, 2
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 36, a1
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_create_float_array
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	sw	hp, 40, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_read_float
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 40
	fsw	a1, 0, fa0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_read_float
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 40
	fsw	a1, 4, fa0
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_create_float_array
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	sw	hp, 44, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 44
	fsw	a1, 0, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 44
	fsw	a1, 4, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 44
	fsw	a1, 8, fa0
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a2
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_create_float_array
	addi	hp, hp, -52
	lw	ra, hp, 48
	mv	a1, a0
	lw	a2, hp, 20
	beq	a2, zero, .Beq14
	sw	hp, 48, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_read_float
	addi	hp, hp, -56
	lw	ra, hp, 52
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	rad.2476
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 48
	fsw	a1, 0, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_read_float
	addi	hp, hp, -56
	lw	ra, hp, 52
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	rad.2476
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 48
	fsw	a1, 4, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_read_float
	addi	hp, hp, -56
	lw	ra, hp, 52
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	rad.2476
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 48
	addi	a2, a1, 8
	fsw	a2, 0, fa0
	j	.Cont15
.Beq14:
	nop
.Cont15:
	nop
	lw	a2, hp, 12
	addi	a3, a2, -2
	beq	a3, zero, .Beq16
	lw	a3, hp, 36
	j	.Cont17
.Beq16:
	nop
	li	a3, 1
.Cont17:
	nop
	li	a4, 4
	addrl	a5, l.7060
	flw	fa0, a5, 0
	sw	hp, 52, a3
	sw	hp, 48, a1
	mv	a0, a4
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	min_caml_create_float_array
	addi	hp, hp, -60
	lw	ra, hp, 56
	mv	a1, a0
	addi	sp, sp, -44
	mv	a2, sp
	sw	a2, 40, a1
	lw	a1, hp, 48
	sw	a2, 36, a1
	lw	a3, hp, 44
	sw	a2, 32, a3
	lw	a3, hp, 40
	sw	a2, 28, a3
	lw	a3, hp, 52
	sw	a2, 24, a3
	lw	a3, hp, 28
	sw	a2, 20, a3
	lw	a3, hp, 24
	sw	a2, 16, a3
	lw	a4, hp, 20
	sw	a2, 12, a4
	lw	a5, hp, 16
	sw	a2, 8, a5
	lw	a5, hp, 12
	sw	a2, 4, a5
	lw	a6, hp, 8
	sw	a2, 0, a6
	lw	a6, hp, 4
	slli	a6, a6, 2
	lw	a7, hp, 0
	add	a6, a7, a6
	sw	a6, 0, a2
	addi	a2, a5, -3
	beq	a2, zero, .Beq18
	addi	a2, a5, -2
	beq	a2, zero, .Beq20
	j	.Cont21
.Beq20:
	nop
	lw	a2, hp, 36
	beq	a2, zero, .Beq22
	li	a2, 0
	j	.Cont23
.Beq22:
	nop
	li	a2, 1
.Cont23:
	nop
	mv	a1, a2
	mv	a0, a3
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	vecunit_sgn.2380
	addi	hp, hp, -60
	lw	ra, hp, 56
.Cont21:
	nop
	j	.Cont19
.Beq18:
	nop
	flw	fa0, a3, 0
	addrl	a2, l.7060
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq24
	addrl	a2, l.7060
	flw	fa0, a2, 0
	j	.Cont25
.Beq24:
	nop
	fsw	hp, 56, fa0
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	sgn.2359
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fmul.s	fa1, fa1, fa1
	fdiv.s	fa0, fa0, fa1
.Cont25:
	nop
	lw	a1, hp, 24
	fsw	a1, 0, fa0
	flw	fa0, a1, 4
	addrl	a2, l.7060
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq26
	addrl	a2, l.7060
	flw	fa0, a2, 0
	j	.Cont27
.Beq26:
	nop
	fsw	hp, 60, fa0
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	sgn.2359
	addi	hp, hp, -68
	lw	ra, hp, 64
	flw	fa1, hp, 60
	fmul.s	fa1, fa1, fa1
	fdiv.s	fa0, fa0, fa1
.Cont27:
	nop
	lw	a1, hp, 24
	fsw	a1, 4, fa0
	flw	fa0, a1, 8
	addrl	a2, l.7060
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq28
	addrl	a2, l.7060
	flw	fa0, a2, 0
	j	.Cont29
.Beq28:
	nop
	fsw	hp, 64, fa0
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	sgn.2359
	addi	hp, hp, -72
	lw	ra, hp, 68
	flw	fa1, hp, 64
	fmul.s	fa1, fa1, fa1
	fdiv.s	fa0, fa0, fa1
.Cont29:
	nop
	lw	a1, hp, 24
	addi	a2, a1, 8
	fsw	a2, 0, fa0
.Cont19:
	nop
	lw	a1, hp, 20
	beq	a1, zero, .Beq30
	lw	a1, hp, 24
	lw	a2, hp, 48
	mv	a0, a1
	mv	a1, a2
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	rotate_quadratic_matrix.2482
	addi	hp, hp, -72
	lw	ra, hp, 68
	j	.Cont31
.Beq30:
	nop
.Cont31:
	nop
	li	a0, 1
	ret
.Beq11:
	nop
	li	a0, 0
	ret
read_object.2487:
	lw	a1, t6, 8
	lw	a2, t6, 4
	addi	a3, a0, -60
	bge	a3, zero, .Bge32
	sw	hp, 0, t6
	sw	hp, 4, a0
	sw	hp, 8, a2
	mv	t6, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	beq	a0, zero, .Beq33
	lw	a0, hp, 4
	addi	a0, a0, 1
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq33:
	nop
	lw	a0, hp, 8
	lw	a1, hp, 4
	sw	a0, 0, a1
	ret
.Bge32:
	nop
	ret
read_all_object.2489:
	lw	t6, t6, 4
	li	a0, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
read_net_item.2491:
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_read_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	addi	a2, a1, 1
	beq	a2, zero, .Beq34
	lw	a2, hp, 0
	addi	a3, a2, 1
	sw	hp, 4, a1
	mv	a0, a3
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	read_net_item.2491
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 0
	slli	a2, a2, 2
	add	a2, a1, a2
	lw	a3, hp, 4
	sw	a2, 0, a3
	mv	a0, a1
	ret
.Beq34:
	nop
	lw	a1, hp, 0
	addi	a1, a1, 1
	li	a2, -1
	mv	a0, a1
	mv	a1, a2
	j	min_caml_create_array
read_or_network.2493:
	li	a1, 0
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	read_net_item.2491
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, a1, 0
	addi	a2, a2, 1
	beq	a2, zero, .Beq35
	lw	a2, hp, 0
	addi	a3, a2, 1
	sw	hp, 4, a1
	mv	a0, a3
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	read_or_network.2493
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 0
	slli	a2, a2, 2
	add	a2, a1, a2
	lw	a3, hp, 4
	sw	a2, 0, a3
	mv	a0, a1
	ret
.Beq35:
	nop
	lw	a2, hp, 0
	addi	a2, a2, 1
	mv	a0, a2
	j	min_caml_create_array
read_and_network.2495:
	lw	a1, t6, 4
	li	a2, 0
	sw	hp, 0, t6
	sw	hp, 4, a1
	sw	hp, 8, a0
	mv	a0, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	read_net_item.2491
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, a0, 0
	addi	a1, a1, 1
	beq	a1, zero, .Beq36
	lw	a1, hp, 8
	slli	a2, a1, 2
	lw	a3, hp, 4
	add	a2, a3, a2
	sw	a2, 0, a0
	addi	a0, a1, 1
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq36:
	nop
	ret
read_parameter.2497:
	lw	a0, t6, 20
	lw	a1, t6, 16
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a4
	sw	hp, 4, a2
	sw	hp, 8, a3
	sw	hp, 12, a1
	mv	t6, a0
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	t6, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	t6, hp, 8
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	li	a0, 0
	lw	t6, hp, 4
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	li	a0, 0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	read_or_network.2493
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 0
	sw	a1, 0, a0
	ret
solver_rect_surface.2499:
	lw	a5, t6, 4
	slli	a6, a2, 2
	add	a6, a1, a6
	flw	fa3, a6, 0
	addrl	a6, l.7060
	flw	fa4, a6, 0
	feq.s	a6, fa3, fa4
	beq	a6, zero, .Beq37
	li	a0, 0
	ret
.Beq37:
	nop
	sw	hp, 0, a5
	fsw	hp, 4, fa2
	sw	hp, 8, a4
	fsw	hp, 12, fa1
	sw	hp, 16, a3
	fsw	hp, 20, fa0
	sw	hp, 24, a1
	sw	hp, 28, a2
	sw	hp, 32, a0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_abc.2421
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	lw	a2, hp, 32
	sw	hp, 36, a1
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isinvert.2411
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	lw	a2, hp, 28
	slli	a3, a2, 2
	lw	a4, hp, 24
	add	a3, a4, a3
	flw	fa1, a3, 0
	fle.s	a3, fa0, fa1
	beq	a3, zero, .Beq38
	li	a3, 0
	j	.Cont39
.Beq38:
	nop
	li	a3, 1
.Cont39:
	nop
	mv	a0, a1
	mv	a1, a3
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	xor.2356
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	lw	a2, hp, 28
	slli	a3, a2, 2
	lw	a4, hp, 36
	add	a3, a4, a3
	flw	fa0, a3, 0
	mv	a0, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	fneg_cond.2361
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 20
	fsub.s	fa0, fa0, fa1
	lw	a1, hp, 28
	slli	a1, a1, 2
	lw	a2, hp, 24
	add	a1, a2, a1
	flw	fa1, a1, 0
	fdiv.s	fa0, fa0, fa1
	lw	a1, hp, 16
	slli	a3, a1, 2
	lw	a4, hp, 36
	add	a3, a4, a3
	flw	fa1, a3, 0
	slli	a1, a1, 2
	add	a1, a2, a1
	flw	fa2, a1, 0
	fmul.s	fa2, fa0, fa2
	flw	fa3, hp, 12
	fadd.s	fa2, fa2, fa3
	fsw	hp, 40, fa0
	fsw	hp, 44, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_fabs
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq40
	li	a0, 0
	ret
.Beq40:
	nop
	lw	a1, hp, 8
	slli	a2, a1, 2
	lw	a3, hp, 36
	add	a2, a3, a2
	flw	fa0, a2, 0
	slli	a1, a1, 2
	lw	a2, hp, 24
	add	a1, a2, a1
	flw	fa1, a1, 0
	flw	fa2, hp, 40
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 4
	fadd.s	fa1, fa1, fa3
	fsw	hp, 48, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_fabs
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 48
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq41
	li	a0, 0
	ret
.Beq41:
	nop
	lw	a1, hp, 0
	flw	fa0, hp, 40
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver_rect.2508:
	lw	t6, t6, 4
	li	a2, 0
	li	a3, 1
	li	a4, 2
	fsw	hp, 0, fa0
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	sw	hp, 12, a1
	sw	hp, 16, a0
	sw	hp, 20, t6
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq42
	li	a0, 1
	ret
.Beq42:
	nop
	li	a2, 1
	li	a3, 2
	li	a4, 0
	lw	a1, hp, 16
	lw	a5, hp, 12
	flw	fa0, hp, 8
	flw	fa1, hp, 4
	flw	fa2, hp, 0
	lw	t6, hp, 20
	mv	a0, a1
	mv	a1, a5
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq43
	li	a0, 2
	ret
.Beq43:
	nop
	li	a2, 2
	li	a3, 0
	li	a4, 1
	lw	a1, hp, 16
	lw	a5, hp, 12
	flw	fa0, hp, 4
	flw	fa1, hp, 0
	flw	fa2, hp, 8
	lw	t6, hp, 20
	mv	a0, a1
	mv	a1, a5
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq44
	li	a0, 3
	ret
.Beq44:
	nop
	li	a0, 0
	ret
solver_surface.2514:
	lw	a2, t6, 4
	sw	hp, 0, a2
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	fsw	hp, 12, fa0
	sw	hp, 16, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_abc.2421
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	lw	a2, hp, 16
	sw	hp, 20, a1
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	veciprod.2383
	addi	hp, hp, -28
	lw	ra, hp, 24
	addrl	a1, l.7060
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq45
	li	a0, 0
	ret
.Beq45:
	nop
	lw	a1, hp, 20
	flw	fa1, hp, 12
	flw	fa2, hp, 8
	flw	fa3, hp, 4
	fsw	hp, 24, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	veciprod2.2386
	addi	hp, hp, -32
	lw	ra, hp, 28
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 24
	fdiv.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
	li	a0, 1
	ret
quadratic.2520:
	fmul.s	fa3, fa0, fa0
	fsw	hp, 0, fa0
	fsw	hp, 4, fa2
	sw	hp, 8, a0
	fsw	hp, 12, fa1
	fsw	hp, 16, fa3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_a.2415
	addi	hp, hp, -24
	lw	ra, hp, 20
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 16
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 12
	fmul.s	fa3, fa2, fa2
	lw	a0, hp, 8
	fsw	hp, 20, fa1
	fsw	hp, 24, fa3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_b.2417
	addi	hp, hp, -32
	lw	ra, hp, 28
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 24
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 20
	fadd.s	fa1, fa2, fa1
	flw	fa2, hp, 4
	fmul.s	fa3, fa2, fa2
	lw	a0, hp, 8
	fsw	hp, 28, fa1
	fsw	hp, 32, fa3
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 32
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 28
	fadd.s	fa1, fa2, fa1
	lw	a0, hp, 8
	fsw	hp, 36, fa1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isrot.2413
	addi	hp, hp, -44
	lw	ra, hp, 40
	beq	a0, zero, .Beq46
	flw	fa1, hp, 4
	flw	fa2, hp, 12
	fmul.s	fa3, fa2, fa1
	lw	a0, hp, 8
	fsw	hp, 40, fa3
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_r1.2439
	addi	hp, hp, -48
	lw	ra, hp, 44
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 40
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 36
	fadd.s	fa1, fa2, fa1
	flw	fa2, hp, 0
	flw	fa3, hp, 4
	fmul.s	fa3, fa3, fa2
	lw	a0, hp, 8
	fsw	hp, 44, fa1
	fsw	hp, 48, fa3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_r2.2441
	addi	hp, hp, -56
	lw	ra, hp, 52
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 48
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 44
	fadd.s	fa1, fa2, fa1
	flw	fa2, hp, 12
	flw	fa3, hp, 0
	fmul.s	fa2, fa3, fa2
	lw	a0, hp, 8
	fsw	hp, 52, fa1
	fsw	hp, 56, fa2
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_param_r3.2443
	addi	hp, hp, -64
	lw	ra, hp, 60
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 56
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 52
	fadd.s	fa0, fa2, fa1
	ret
.Beq46:
	nop
	flw	fa1, hp, 36
	fsgnj.s	fa0, fa1, fa1
	ret
bilinear.2525:
	fmul.s	fa6, fa0, fa3
	fsw	hp, 0, fa3
	fsw	hp, 4, fa0
	fsw	hp, 8, fa5
	fsw	hp, 12, fa2
	sw	hp, 16, a0
	fsw	hp, 20, fa4
	fsw	hp, 24, fa1
	fsw	hp, 28, fa6
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_a.2415
	addi	hp, hp, -36
	lw	ra, hp, 32
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 28
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 20
	flw	fa3, hp, 24
	fmul.s	fa4, fa3, fa2
	lw	a0, hp, 16
	fsw	hp, 32, fa1
	fsw	hp, 36, fa4
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_b.2417
	addi	hp, hp, -44
	lw	ra, hp, 40
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 36
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 32
	fadd.s	fa1, fa2, fa1
	flw	fa2, hp, 8
	flw	fa3, hp, 12
	fmul.s	fa4, fa3, fa2
	lw	a0, hp, 16
	fsw	hp, 40, fa1
	fsw	hp, 44, fa4
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_c.2419
	addi	hp, hp, -52
	lw	ra, hp, 48
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 44
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 40
	fadd.s	fa1, fa2, fa1
	lw	a0, hp, 16
	fsw	hp, 48, fa1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_isrot.2413
	addi	hp, hp, -56
	lw	ra, hp, 52
	beq	a0, zero, .Beq47
	flw	fa1, hp, 20
	flw	fa2, hp, 12
	fmul.s	fa3, fa2, fa1
	flw	fa4, hp, 8
	flw	fa5, hp, 24
	fmul.s	fa6, fa5, fa4
	fadd.s	fa3, fa3, fa6
	lw	a0, hp, 16
	fsw	hp, 52, fa3
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_r1.2439
	addi	hp, hp, -60
	lw	ra, hp, 56
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 52
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 8
	flw	fa3, hp, 4
	fmul.s	fa2, fa3, fa2
	flw	fa4, hp, 0
	flw	fa5, hp, 12
	fmul.s	fa5, fa5, fa4
	fadd.s	fa2, fa2, fa5
	lw	a0, hp, 16
	fsw	hp, 56, fa1
	fsw	hp, 60, fa2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	o_param_r2.2441
	addi	hp, hp, -68
	lw	ra, hp, 64
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 60
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 56
	fadd.s	fa1, fa2, fa1
	flw	fa2, hp, 20
	flw	fa3, hp, 4
	fmul.s	fa2, fa3, fa2
	flw	fa3, hp, 0
	flw	fa4, hp, 24
	fmul.s	fa3, fa4, fa3
	fadd.s	fa2, fa2, fa3
	lw	a0, hp, 16
	fsw	hp, 64, fa1
	fsw	hp, 68, fa2
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	o_param_r3.2443
	addi	hp, hp, -76
	lw	ra, hp, 72
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 68
	fmul.s	fa1, fa2, fa1
	flw	fa2, hp, 64
	fadd.s	fa1, fa2, fa1
	addrl	a0, l.7097
	flw	fa2, a0, 0
	fmul.s	fa1, fa1, fa2
	flw	fa2, hp, 48
	fadd.s	fa0, fa2, fa1
	ret
.Beq47:
	nop
	flw	fa1, hp, 48
	fsgnj.s	fa0, fa1, fa1
	ret
solver_second.2533:
	lw	a2, t6, 4
	flw	fa3, a1, 0
	flw	fa4, a1, 4
	flw	fa5, a1, 8
	sw	hp, 0, a2
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	fsw	hp, 12, fa0
	sw	hp, 16, a0
	sw	hp, 20, a1
	fsgnj.s	fa2, fa5, fa5
	fsgnj.s	fa1, fa4, fa4
	fsgnj.s	fa0, fa3, fa3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	quadratic.2520
	addi	hp, hp, -28
	lw	ra, hp, 24
	addrl	a1, l.7060
	flw	fa1, a1, 0
	feq.s	a1, fa0, fa1
	beq	a1, zero, .Beq48
	li	a0, 0
	ret
.Beq48:
	nop
	lw	a1, hp, 20
	flw	fa1, a1, 0
	flw	fa2, a1, 4
	flw	fa3, a1, 8
	lw	a1, hp, 16
	flw	fa4, hp, 12
	flw	fa5, hp, 8
	flw	fa6, hp, 4
	fsw	hp, 24, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	fsgnj.s	fa3, fa4, fa4
	fsgnj.s	fa4, fa5, fa5
	fsgnj.s	fa5, fa6, fa6
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	bilinear.2525
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 16
	flw	fa1, hp, 12
	flw	fa2, hp, 8
	flw	fa3, hp, 4
	fsw	hp, 28, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	quadratic.2520
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 16
	fsw	hp, 32, fa0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_form.2407
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	addi	a1, a1, -3
	beq	a1, zero, .Beq49
	flw	fa0, hp, 32
	j	.Cont50
.Beq49:
	nop
	addrl	a1, l.7056
	flw	fa0, a1, 0
	flw	fa1, hp, 32
	fsub.s	fa0, fa1, fa0
.Cont50:
	nop
	flw	fa1, hp, 28
	fmul.s	fa2, fa1, fa1
	flw	fa3, hp, 24
	fmul.s	fa0, fa3, fa0
	fsub.s	fa0, fa2, fa0
	addrl	a1, l.7060
	flw	fa2, a1, 0
	fle.s	a1, fa0, fa2
	beq	a1, zero, .Beq51
	li	a0, 0
	ret
.Beq51:
	nop
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_sqrt
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 16
	fsw	hp, 36, fa0
	mv	a0, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isinvert.2411
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	beq	a1, zero, .Beq52
	flw	fa0, hp, 36
	j	.Cont53
.Beq52:
	nop
	flw	fa0, hp, 36
	fsgnjn.s	fa0, fa0, fa0
.Cont53:
	nop
	flw	fa1, hp, 28
	fsub.s	fa0, fa0, fa1
	flw	fa1, hp, 24
	fdiv.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver.2539:
	lw	a3, t6, 16
	lw	a4, t6, 12
	lw	a5, t6, 8
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a6, a6, a7
	lw	a6, a6, 0
	flw	fa0, a2, 0
	sw	hp, 0, a4
	sw	hp, 4, a3
	sw	hp, 8, a1
	sw	hp, 12, a5
	sw	hp, 16, a6
	sw	hp, 20, a2
	fsw	hp, 24, fa0
	mv	a0, a6
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_x.2423
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 20
	flw	fa1, a1, 4
	lw	a2, hp, 16
	fsw	hp, 28, fa0
	fsw	hp, 32, fa1
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_y.2425
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 20
	flw	fa1, a1, 8
	lw	a1, hp, 16
	fsw	hp, 36, fa0
	fsw	hp, 40, fa1
	mv	a0, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_z.2427
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 16
	fsw	hp, 44, fa0
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_form.2407
	addi	hp, hp, -52
	lw	ra, hp, 48
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq54
	addi	a1, a1, -2
	beq	a1, zero, .Beq55
	lw	a1, hp, 16
	lw	a2, hp, 8
	flw	fa0, hp, 28
	flw	fa1, hp, 36
	flw	fa2, hp, 44
	lw	t6, hp, 0
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq55:
	nop
	lw	a1, hp, 16
	lw	a2, hp, 8
	flw	fa0, hp, 28
	flw	fa1, hp, 36
	flw	fa2, hp, 44
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq54:
	nop
	lw	a1, hp, 16
	lw	a2, hp, 8
	flw	fa0, hp, 28
	flw	fa1, hp, 36
	flw	fa2, hp, 44
	lw	t6, hp, 12
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
solver_rect_fast.2543:
	lw	a3, t6, 4
	flw	fa3, a2, 0
	fsub.s	fa3, fa3, fa0
	flw	fa4, a2, 4
	fmul.s	fa3, fa3, fa4
	sw	hp, 0, a3
	fsw	hp, 4, fa0
	sw	hp, 8, a2
	fsw	hp, 12, fa2
	sw	hp, 16, a0
	fsw	hp, 20, fa1
	fsw	hp, 24, fa3
	sw	hp, 28, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_b.2417
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 28
	flw	fa1, a1, 4
	flw	fa2, hp, 24
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 20
	fadd.s	fa1, fa1, fa3
	fsw	hp, 32, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_fabs
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq56
	li	a1, 0
	j	.Cont57
.Beq56:
	nop
	lw	a1, hp, 16
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 28
	flw	fa1, a1, 8
	flw	fa2, hp, 24
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 12
	fadd.s	fa1, fa1, fa3
	fsw	hp, 36, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_fabs
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 36
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq58
	li	a1, 0
	j	.Cont59
.Beq58:
	nop
	lw	a1, hp, 8
	flw	fa0, a1, 4
	addrl	a2, l.7060
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq60
	li	a1, 0
	j	.Cont61
.Beq60:
	nop
	li	a1, 1
.Cont61:
	nop
.Cont59:
	nop
.Cont57:
	nop
	beq	a1, zero, .Beq62
	lw	a1, hp, 0
	flw	fa0, hp, 24
	fsw	a1, 0, fa0
	li	a0, 1
	ret
.Beq62:
	nop
	lw	a1, hp, 8
	flw	fa0, a1, 8
	flw	fa1, hp, 20
	fsub.s	fa0, fa0, fa1
	flw	fa2, a1, 12
	fmul.s	fa0, fa0, fa2
	lw	a2, hp, 16
	fsw	hp, 40, fa0
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_a.2415
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 28
	flw	fa1, a1, 0
	flw	fa2, hp, 40
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 4
	fadd.s	fa1, fa1, fa3
	fsw	hp, 44, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_fabs
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq63
	li	a1, 0
	j	.Cont64
.Beq63:
	nop
	lw	a1, hp, 16
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_c.2419
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 28
	flw	fa1, a1, 8
	flw	fa2, hp, 40
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 12
	fadd.s	fa1, fa1, fa3
	fsw	hp, 48, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_fabs
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 48
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq65
	li	a1, 0
	j	.Cont66
.Beq65:
	nop
	lw	a1, hp, 8
	flw	fa0, a1, 12
	addrl	a2, l.7060
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq67
	li	a1, 0
	j	.Cont68
.Beq67:
	nop
	li	a1, 1
.Cont68:
	nop
.Cont66:
	nop
.Cont64:
	nop
	beq	a1, zero, .Beq69
	lw	a1, hp, 0
	flw	fa0, hp, 40
	fsw	a1, 0, fa0
	li	a0, 2
	ret
.Beq69:
	nop
	lw	a1, hp, 8
	flw	fa0, a1, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa0, fa1
	flw	fa1, a1, 20
	fmul.s	fa0, fa0, fa1
	lw	a2, hp, 16
	fsw	hp, 52, fa0
	mv	a0, a2
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_a.2415
	addi	hp, hp, -60
	lw	ra, hp, 56
	lw	a1, hp, 28
	flw	fa1, a1, 0
	flw	fa2, hp, 52
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 4
	fadd.s	fa1, fa1, fa3
	fsw	hp, 56, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	min_caml_fabs
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq70
	li	a1, 0
	j	.Cont71
.Beq70:
	nop
	lw	a1, hp, 16
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_param_b.2417
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a1, hp, 28
	flw	fa1, a1, 4
	flw	fa2, hp, 52
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 20
	fadd.s	fa1, fa1, fa3
	fsw	hp, 60, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	min_caml_fabs
	addi	hp, hp, -68
	lw	ra, hp, 64
	flw	fa1, hp, 60
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq72
	li	a1, 0
	j	.Cont73
.Beq72:
	nop
	lw	a1, hp, 8
	flw	fa0, a1, 20
	addrl	a1, l.7060
	flw	fa1, a1, 0
	feq.s	a1, fa0, fa1
	beq	a1, zero, .Beq74
	li	a1, 0
	j	.Cont75
.Beq74:
	nop
	li	a1, 1
.Cont75:
	nop
.Cont73:
	nop
.Cont71:
	nop
	beq	a1, zero, .Beq76
	lw	a1, hp, 0
	flw	fa0, hp, 52
	fsw	a1, 0, fa0
	li	a0, 3
	ret
.Beq76:
	nop
	li	a0, 0
	ret
solver_surface_fast.2550:
	lw	a2, t6, 4
	addrl	a3, l.7060
	flw	fa3, a3, 0
	flw	fa4, a1, 0
	fle.s	a3, fa3, fa4
	beq	a3, zero, .Beq77
	li	a0, 0
	ret
.Beq77:
	nop
	flw	fa3, a1, 4
	fmul.s	fa0, fa3, fa0
	flw	fa3, a1, 8
	fmul.s	fa1, fa3, fa1
	fadd.s	fa0, fa0, fa1
	flw	fa1, a1, 12
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	fsw	a2, 0, fa0
	li	a0, 1
	ret
solver_second_fast.2556:
	lw	a2, t6, 4
	flw	fa3, a1, 0
	addrl	a3, l.7060
	flw	fa4, a3, 0
	feq.s	a3, fa3, fa4
	beq	a3, zero, .Beq78
	li	a0, 0
	ret
.Beq78:
	nop
	flw	fa4, a1, 4
	fmul.s	fa4, fa4, fa0
	flw	fa5, a1, 8
	fmul.s	fa5, fa5, fa1
	fadd.s	fa4, fa4, fa5
	flw	fa5, a1, 12
	fmul.s	fa5, fa5, fa2
	fadd.s	fa4, fa4, fa5
	sw	hp, 0, a2
	sw	hp, 4, a1
	fsw	hp, 8, fa3
	fsw	hp, 12, fa4
	sw	hp, 16, a0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	quadratic.2520
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 16
	fsw	hp, 20, fa0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_form.2407
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	addi	a1, a1, -3
	beq	a1, zero, .Beq79
	flw	fa0, hp, 20
	j	.Cont80
.Beq79:
	nop
	addrl	a1, l.7056
	flw	fa0, a1, 0
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
.Cont80:
	nop
	flw	fa1, hp, 12
	fmul.s	fa2, fa1, fa1
	flw	fa3, hp, 8
	fmul.s	fa0, fa3, fa0
	fsub.s	fa0, fa2, fa0
	addrl	a1, l.7060
	flw	fa2, a1, 0
	fle.s	a1, fa0, fa2
	beq	a1, zero, .Beq81
	li	a0, 0
	ret
.Beq81:
	nop
	lw	a1, hp, 16
	fsw	hp, 24, fa0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_isinvert.2411
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	beq	a1, zero, .Beq82
	flw	fa0, hp, 24
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_sqrt
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 12
	fadd.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
	j	.Cont83
.Beq82:
	nop
	flw	fa0, hp, 24
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_sqrt
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
.Cont83:
	nop
	li	a0, 1
	ret
solver_fast.2562:
	lw	a3, t6, 16
	lw	a4, t6, 12
	lw	a5, t6, 8
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a6, a6, a7
	lw	a6, a6, 0
	flw	fa0, a2, 0
	sw	hp, 0, a4
	sw	hp, 4, a3
	sw	hp, 8, a5
	sw	hp, 12, a0
	sw	hp, 16, a1
	sw	hp, 20, a6
	sw	hp, 24, a2
	fsw	hp, 28, fa0
	mv	a0, a6
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_x.2423
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 24
	flw	fa1, a1, 4
	lw	a2, hp, 20
	fsw	hp, 32, fa0
	fsw	hp, 36, fa1
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_y.2425
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 36
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 24
	flw	fa1, a1, 8
	lw	a1, hp, 20
	fsw	hp, 40, fa0
	fsw	hp, 44, fa1
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_z.2427
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 16
	fsw	hp, 48, fa0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_const.2468
	addi	hp, hp, -56
	lw	ra, hp, 52
	mv	a1, a0
	lw	a2, hp, 12
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, a1, 0
	lw	a2, hp, 20
	sw	hp, 52, a1
	mv	a0, a2
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_form.2407
	addi	hp, hp, -60
	lw	ra, hp, 56
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq84
	addi	a1, a1, -2
	beq	a1, zero, .Beq85
	lw	a1, hp, 20
	lw	a2, hp, 52
	flw	fa0, hp, 32
	flw	fa1, hp, 40
	flw	fa2, hp, 48
	lw	t6, hp, 0
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq85:
	nop
	lw	a1, hp, 20
	lw	a2, hp, 52
	flw	fa0, hp, 32
	flw	fa1, hp, 40
	flw	fa2, hp, 48
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq84:
	nop
	lw	a1, hp, 16
	mv	a0, a1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	d_vec.2466
	addi	hp, hp, -60
	lw	ra, hp, 56
	mv	a1, a0
	lw	a2, hp, 20
	lw	a3, hp, 52
	flw	fa0, hp, 32
	flw	fa1, hp, 40
	flw	fa2, hp, 48
	lw	t6, hp, 8
	mv	a0, a2
	mv	a2, a3
	lw	t5, t6, 0
	jalr	zero, t5, 0
solver_surface_fast2.2566:
	lw	a3, t6, 4
	addrl	a4, l.7060
	flw	fa0, a4, 0
	flw	fa1, a1, 0
	fle.s	a4, fa0, fa1
	beq	a4, zero, .Beq86
	li	a0, 0
	ret
.Beq86:
	nop
	flw	fa0, a1, 0
	flw	fa1, a2, 12
	fmul.s	fa0, fa0, fa1
	fsw	a3, 0, fa0
	li	a0, 1
	ret
solver_second_fast2.2573:
	lw	a3, t6, 4
	flw	fa3, a1, 0
	addrl	a4, l.7060
	flw	fa4, a4, 0
	feq.s	a4, fa3, fa4
	beq	a4, zero, .Beq87
	li	a0, 0
	ret
.Beq87:
	nop
	flw	fa4, a1, 4
	fmul.s	fa0, fa4, fa0
	flw	fa4, a1, 8
	fmul.s	fa1, fa4, fa1
	fadd.s	fa0, fa0, fa1
	flw	fa1, a1, 12
	fmul.s	fa1, fa1, fa2
	fadd.s	fa0, fa0, fa1
	flw	fa1, a2, 12
	fmul.s	fa2, fa0, fa0
	fmul.s	fa1, fa3, fa1
	fsub.s	fa1, fa2, fa1
	addrl	a2, l.7060
	flw	fa2, a2, 0
	fle.s	a2, fa1, fa2
	beq	a2, zero, .Beq88
	li	a0, 0
	ret
.Beq88:
	nop
	sw	hp, 0, a3
	sw	hp, 4, a1
	fsw	hp, 8, fa0
	fsw	hp, 12, fa1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_isinvert.2411
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	beq	a1, zero, .Beq89
	flw	fa0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_sqrt
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 8
	fadd.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
	j	.Cont90
.Beq89:
	nop
	flw	fa0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_sqrt
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 8
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	lw	a1, hp, 0
	fsw	a1, 0, fa0
.Cont90:
	nop
	li	a0, 1
	ret
solver_fast2.2580:
	lw	a2, t6, 16
	lw	a3, t6, 12
	lw	a4, t6, 8
	lw	a5, t6, 4
	slli	a6, a0, 2
	add	a5, a5, a6
	lw	a5, a5, 0
	sw	hp, 0, a3
	sw	hp, 4, a2
	sw	hp, 8, a4
	sw	hp, 12, a5
	sw	hp, 16, a0
	sw	hp, 20, a1
	mv	a0, a5
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_ctbl.2445
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	flw	fa0, a1, 0
	flw	fa1, a1, 4
	flw	fa2, a1, 8
	lw	a2, hp, 20
	sw	hp, 24, a1
	fsw	hp, 28, fa2
	fsw	hp, 32, fa1
	fsw	hp, 36, fa0
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	d_const.2468
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	lw	a2, hp, 16
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, a1, 0
	lw	a2, hp, 12
	sw	hp, 40, a1
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_form.2407
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq91
	addi	a1, a1, -2
	beq	a1, zero, .Beq92
	lw	a1, hp, 12
	lw	a2, hp, 40
	lw	a3, hp, 24
	flw	fa0, hp, 36
	flw	fa1, hp, 32
	flw	fa2, hp, 28
	lw	t6, hp, 0
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq92:
	nop
	lw	a1, hp, 12
	lw	a2, hp, 40
	lw	a3, hp, 24
	flw	fa0, hp, 36
	flw	fa1, hp, 32
	flw	fa2, hp, 28
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq91:
	nop
	lw	a1, hp, 20
	mv	a0, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	d_vec.2466
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	lw	a2, hp, 12
	lw	a3, hp, 40
	flw	fa0, hp, 36
	flw	fa1, hp, 32
	flw	fa2, hp, 28
	lw	t6, hp, 8
	mv	a0, a2
	mv	a2, a3
	lw	t5, t6, 0
	jalr	zero, t5, 0
setup_rect_table.2583:
	li	a2, 6
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	flw	fa0, a2, 0
	addrl	a3, l.7060
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq93
	addrl	a3, l.7060
	flw	fa0, a3, 0
	addi	a3, a1, 4
	fsw	a3, 0, fa0
	j	.Cont94
.Beq93:
	nop
	lw	a3, hp, 0
	sw	hp, 8, a1
	mv	a0, a3
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_isinvert.2411
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 0
	fle.s	a3, fa0, fa1
	beq	a3, zero, .Beq95
	li	a3, 0
	j	.Cont96
.Beq95:
	nop
	li	a3, 1
.Cont96:
	nop
	mv	a0, a1
	mv	a1, a3
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	xor.2356
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	lw	a2, hp, 0
	sw	hp, 12, a1
	mv	a0, a2
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_a.2415
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	fneg_cond.2361
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 8
	fsw	a1, 0, fa0
	addrl	a2, l.7056
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 0
	fdiv.s	fa0, fa0, fa1
	addi	a3, a1, 4
	fsw	a3, 0, fa0
.Cont94:
	nop
	flw	fa0, a2, 4
	addrl	a3, l.7060
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq97
	addrl	a3, l.7060
	flw	fa0, a3, 0
	addi	a3, a1, 12
	fsw	a3, 0, fa0
	j	.Cont98
.Beq97:
	nop
	lw	a3, hp, 0
	sw	hp, 8, a1
	mv	a0, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_isinvert.2411
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 4
	fle.s	a3, fa0, fa1
	beq	a3, zero, .Beq99
	li	a3, 0
	j	.Cont100
.Beq99:
	nop
	li	a3, 1
.Cont100:
	nop
	mv	a0, a1
	mv	a1, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	xor.2356
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	lw	a2, hp, 0
	sw	hp, 16, a1
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_b.2417
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 16
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	fneg_cond.2361
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 8
	fsw	a1, 8, fa0
	addrl	a2, l.7056
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 4
	fdiv.s	fa0, fa0, fa1
	addi	a3, a1, 12
	fsw	a3, 0, fa0
.Cont98:
	nop
	flw	fa0, a2, 8
	addrl	a3, l.7060
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq101
	addrl	a2, l.7060
	flw	fa0, a2, 0
	addi	a2, a1, 20
	fsw	a2, 0, fa0
	j	.Cont102
.Beq101:
	nop
	lw	a3, hp, 0
	sw	hp, 8, a1
	mv	a0, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_isinvert.2411
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 8
	fle.s	a3, fa0, fa1
	beq	a3, zero, .Beq103
	li	a3, 0
	j	.Cont104
.Beq103:
	nop
	li	a3, 1
.Cont104:
	nop
	mv	a0, a1
	mv	a1, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	xor.2356
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	lw	a2, hp, 0
	sw	hp, 20, a1
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_c.2419
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	fneg_cond.2361
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 8
	fsw	a1, 16, fa0
	addrl	a2, l.7056
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 8
	fdiv.s	fa0, fa0, fa1
	addi	a2, a1, 20
	fsw	a2, 0, fa0
.Cont102:
	nop
	mv	a0, a1
	ret
setup_surface_table.2586:
	li	a2, 4
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	flw	fa0, a2, 0
	lw	a3, hp, 0
	sw	hp, 8, a1
	fsw	hp, 12, fa0
	mv	a0, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_a.2415
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fmul.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 4
	lw	a2, hp, 0
	fsw	hp, 16, fa0
	fsw	hp, 20, fa1
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_b.2417
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 16
	fadd.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 8
	lw	a1, hp, 0
	fsw	hp, 24, fa0
	fsw	hp, 28, fa1
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_c.2419
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 24
	fadd.s	fa0, fa1, fa0
	addrl	a1, l.7060
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq105
	addrl	a1, l.7060
	flw	fa0, a1, 0
	lw	a1, hp, 8
	mv	a2, a1
	fsw	a2, 0, fa0
	j	.Cont106
.Beq105:
	nop
	addrl	a1, l.7058
	flw	fa1, a1, 0
	fdiv.s	fa1, fa1, fa0
	lw	a1, hp, 8
	fsw	a1, 0, fa1
	lw	a2, hp, 0
	fsw	hp, 32, fa0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_a.2415
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fdiv.s	fa0, fa0, fa1
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 8
	fsw	a1, 4, fa0
	lw	a2, hp, 0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_b.2417
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fdiv.s	fa0, fa0, fa1
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 8
	fsw	a1, 8, fa0
	lw	a2, hp, 0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fdiv.s	fa0, fa0, fa1
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 8
	addi	a2, a1, 12
	fsw	a2, 0, fa0
.Cont106:
	nop
	mv	a0, a1
	ret
setup_second_table.2589:
	li	a2, 5
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	flw	fa0, a2, 0
	flw	fa1, a2, 4
	flw	fa2, a2, 8
	lw	a3, hp, 0
	sw	hp, 8, a1
	mv	a0, a3
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	quadratic.2520
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 4
	flw	fa1, a1, 0
	lw	a2, hp, 0
	fsw	hp, 12, fa0
	fsw	hp, 16, fa1
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_a.2415
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 4
	lw	a2, hp, 0
	fsw	hp, 20, fa0
	fsw	hp, 24, fa1
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_b.2417
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 8
	lw	a2, hp, 0
	fsw	hp, 28, fa0
	fsw	hp, 32, fa1
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	fsgnjn.s	fa0, fa0, fa0
	lw	a1, hp, 8
	flw	fa1, hp, 12
	fsw	a1, 0, fa1
	lw	a2, hp, 0
	fsw	hp, 36, fa0
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isrot.2413
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	beq	a1, zero, .Beq107
	lw	a1, hp, 4
	flw	fa0, a1, 8
	lw	a2, hp, 0
	fsw	hp, 40, fa0
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_r2.2441
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fmul.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 4
	lw	a2, hp, 0
	fsw	hp, 44, fa0
	fsw	hp, 48, fa1
	mv	a0, a2
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_r3.2443
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 48
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 44
	fadd.s	fa0, fa1, fa0
	addrl	a1, l.7097
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	fsw	a1, 4, fa0
	lw	a2, hp, 4
	flw	fa0, a2, 8
	lw	a3, hp, 0
	fsw	hp, 52, fa0
	mv	a0, a3
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_r1.2439
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fmul.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 0
	lw	a2, hp, 0
	fsw	hp, 56, fa0
	fsw	hp, 60, fa1
	mv	a0, a2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	o_param_r3.2443
	addi	hp, hp, -68
	lw	ra, hp, 64
	flw	fa1, hp, 60
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 56
	fadd.s	fa0, fa1, fa0
	addrl	a1, l.7097
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	fsw	a1, 8, fa0
	lw	a2, hp, 4
	flw	fa0, a2, 4
	lw	a3, hp, 0
	fsw	hp, 64, fa0
	mv	a0, a3
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	o_param_r1.2439
	addi	hp, hp, -72
	lw	ra, hp, 68
	flw	fa1, hp, 64
	fmul.s	fa0, fa1, fa0
	lw	a1, hp, 4
	flw	fa1, a1, 0
	lw	a1, hp, 0
	fsw	hp, 68, fa0
	fsw	hp, 72, fa1
	mv	a0, a1
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	o_param_r2.2441
	addi	hp, hp, -80
	lw	ra, hp, 76
	flw	fa1, hp, 72
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 68
	fadd.s	fa0, fa1, fa0
	addrl	a1, l.7097
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 36
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	addi	a2, a1, 12
	fsw	a2, 0, fa0
	j	.Cont108
.Beq107:
	nop
	lw	a1, hp, 8
	flw	fa0, hp, 20
	fsw	a1, 4, fa0
	flw	fa0, hp, 28
	fsw	a1, 8, fa0
	addi	a2, a1, 12
	flw	fa0, hp, 36
	fsw	a2, 0, fa0
.Cont108:
	nop
	addrl	a2, l.7060
	flw	fa0, a2, 0
	flw	fa1, hp, 12
	feq.s	a2, fa1, fa0
	beq	a2, zero, .Beq109
	j	.Cont110
.Beq109:
	nop
	addrl	a2, l.7056
	flw	fa0, a2, 0
	fdiv.s	fa0, fa0, fa1
	addi	a2, a1, 16
	fsw	a2, 0, fa0
.Cont110:
	nop
	mv	a0, a1
	ret
iter_setup_dirvec_constants.2592:
	lw	a2, t6, 4
	bge	a1, zero, .Bge111
	ret
.Bge111:
	nop
	slli	a3, a1, 2
	add	a2, a2, a3
	lw	a2, a2, 0
	sw	hp, 0, t6
	sw	hp, 4, a1
	sw	hp, 8, a2
	sw	hp, 12, a0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	d_const.2468
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	d_vec.2466
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 8
	sw	hp, 20, a0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_form.2407
	addi	hp, hp, -28
	lw	ra, hp, 24
	addi	a1, a0, -1
	beq	a1, zero, .Beq112
	addi	a0, a0, -2
	beq	a0, zero, .Beq114
	lw	a0, hp, 20
	lw	a1, hp, 8
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	setup_second_table.2589
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	sw	a2, 0, a0
	j	.Cont115
.Beq114:
	nop
	lw	a0, hp, 20
	lw	a1, hp, 8
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	setup_surface_table.2586
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont115:
	nop
	j	.Cont113
.Beq112:
	nop
	lw	a0, hp, 20
	lw	a1, hp, 8
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	setup_rect_table.2583
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont113:
	nop
	addi	a1, a1, -1
	lw	a0, hp, 12
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
setup_dirvec_constants.2595:
	lw	a1, t6, 8
	lw	t6, t6, 4
	lw	a1, a1, 0
	addi	a1, a1, -1
	lw	t5, t6, 0
	jalr	zero, t5, 0
setup_startp_constants.2597:
	lw	a2, t6, 4
	bge	a1, zero, .Bge116
	ret
.Bge116:
	nop
	slli	a3, a1, 2
	add	a2, a2, a3
	lw	a2, a2, 0
	sw	hp, 0, t6
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, a2
	mv	a0, a2
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_ctbl.2445
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_form.2407
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 8
	flw	fa0, a1, 0
	lw	a2, hp, 12
	sw	hp, 20, a0
	fsw	hp, 24, fa0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_x.2423
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 16
	fsw	a0, 0, fa0
	lw	a1, hp, 8
	flw	fa0, a1, 4
	lw	a2, hp, 12
	fsw	hp, 28, fa0
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_y.2425
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 16
	fsw	a0, 4, fa0
	lw	a1, hp, 8
	flw	fa0, a1, 8
	lw	a2, hp, 12
	fsw	hp, 32, fa0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_z.2427
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 16
	fsw	a0, 8, fa0
	lw	a1, hp, 20
	addi	a2, a1, -2
	beq	a2, zero, .Beq117
	addi	a2, a1, -2
	bge	zero, a2, .Ble119
	flw	fa0, a0, 0
	flw	fa1, a0, 4
	flw	fa2, a0, 8
	lw	a2, hp, 12
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	quadratic.2520
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 20
	addi	a0, a0, -3
	beq	a0, zero, .Beq121
	j	.Cont122
.Beq121:
	nop
	addrl	a0, l.7056
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
.Cont122:
	nop
	lw	a0, hp, 16
	addi	a0, a0, 12
	fsw	a0, 0, fa0
	j	.Cont120
.Ble119:
	nop
.Cont120:
	nop
	j	.Cont118
.Beq117:
	nop
	lw	a1, hp, 12
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_abc.2421
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 16
	flw	fa0, a1, 0
	flw	fa1, a1, 4
	flw	fa2, a1, 8
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	veciprod2.2386
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 16
	addi	a0, a0, 12
	fsw	a0, 0, fa0
.Cont118:
	nop
	lw	a0, hp, 4
	addi	a1, a0, -1
	lw	a0, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
setup_startp.2600:
	lw	a1, t6, 12
	lw	a2, t6, 8
	lw	a3, t6, 4
	sw	hp, 0, a0
	sw	hp, 4, a2
	sw	hp, 8, a3
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	veccpy.2377
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	lw	a0, a0, 0
	addi	a1, a0, -1
	lw	a0, hp, 0
	lw	t6, hp, 4
	lw	t5, t6, 0
	jalr	zero, t5, 0
is_rect_outside.2602:
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	sw	hp, 8, a0
	fsw	hp, 12, fa0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_a.2415
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsw	hp, 16, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_fabs
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq123
	li	a1, 0
	j	.Cont124
.Beq123:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_b.2417
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 4
	fsw	hp, 20, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_fabs
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq125
	li	a1, 0
	j	.Cont126
.Beq125:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_c.2419
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 0
	fsw	hp, 24, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_fabs
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq127
	li	a1, 0
	j	.Cont128
.Beq127:
	nop
	li	a1, 1
.Cont128:
	nop
.Cont126:
	nop
.Cont124:
	nop
	beq	a1, zero, .Beq129
	lw	a1, hp, 8
	mv	a0, a1
	j	o_isinvert.2411
.Beq129:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_isinvert.2411
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	beq	a1, zero, .Beq130
	li	a0, 0
	ret
.Beq130:
	nop
	li	a0, 1
	ret
is_plane_outside.2607:
	sw	hp, 0, a0
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	fsw	hp, 12, fa0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_abc.2421
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	flw	fa0, hp, 12
	flw	fa1, hp, 8
	flw	fa2, hp, 4
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	veciprod2.2386
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 0
	fsw	hp, 16, fa0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_isinvert.2411
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	flw	fa1, hp, 16
	fle.s	a2, fa0, fa1
	beq	a2, zero, .Beq131
	li	a2, 0
	j	.Cont132
.Beq131:
	nop
	li	a2, 1
.Cont132:
	nop
	mv	a0, a1
	mv	a1, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	xor.2356
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	beq	a1, zero, .Beq133
	li	a0, 0
	ret
.Beq133:
	nop
	li	a0, 1
	ret
is_second_outside.2612:
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	quadratic.2520
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a1, hp, 0
	fsw	hp, 4, fa0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_form.2407
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	addi	a1, a1, -3
	beq	a1, zero, .Beq134
	flw	fa0, hp, 4
	j	.Cont135
.Beq134:
	nop
	addrl	a1, l.7056
	flw	fa0, a1, 0
	flw	fa1, hp, 4
	fsub.s	fa0, fa1, fa0
.Cont135:
	nop
	lw	a1, hp, 0
	fsw	hp, 8, fa0
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_isinvert.2411
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	flw	fa1, hp, 8
	fle.s	a2, fa0, fa1
	beq	a2, zero, .Beq136
	li	a2, 0
	j	.Cont137
.Beq136:
	nop
	li	a2, 1
.Cont137:
	nop
	mv	a0, a1
	mv	a1, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	xor.2356
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	beq	a1, zero, .Beq138
	li	a0, 0
	ret
.Beq138:
	nop
	li	a0, 1
	ret
is_outside.2617:
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	sw	hp, 8, a0
	fsw	hp, 12, fa0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_x.2423
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	fsw	hp, 16, fa0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_y.2425
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 4
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	fsw	hp, 20, fa0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_z.2427
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 0
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	fsw	hp, 24, fa0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_form.2407
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq139
	addi	a1, a1, -2
	beq	a1, zero, .Beq140
	lw	a1, hp, 8
	flw	fa0, hp, 16
	flw	fa1, hp, 20
	flw	fa2, hp, 24
	mv	a0, a1
	j	is_second_outside.2612
.Beq140:
	nop
	lw	a1, hp, 8
	flw	fa0, hp, 16
	flw	fa1, hp, 20
	flw	fa2, hp, 24
	mv	a0, a1
	j	is_plane_outside.2607
.Beq139:
	nop
	lw	a1, hp, 8
	flw	fa0, hp, 16
	flw	fa1, hp, 20
	flw	fa2, hp, 24
	mv	a0, a1
	j	is_rect_outside.2602
check_all_inside.2622:
	lw	a2, t6, 4
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, a3, 1
	beq	a4, zero, .Beq141
	slli	a3, a3, 2
	add	a2, a2, a3
	lw	a2, a2, 0
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	fsw	hp, 8, fa0
	sw	hp, 12, a1
	sw	hp, 16, t6
	sw	hp, 20, a0
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	is_outside.2617
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq142
	li	a0, 0
	ret
.Beq142:
	nop
	lw	a1, hp, 20
	addi	a1, a1, 1
	lw	a2, hp, 12
	flw	fa0, hp, 8
	flw	fa1, hp, 4
	flw	fa2, hp, 0
	lw	t6, hp, 16
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq141:
	nop
	li	a0, 1
	ret
shadow_check_and_group.2628:
	lw	a2, t6, 28
	lw	a3, t6, 24
	lw	a4, t6, 20
	lw	a5, t6, 16
	lw	a6, t6, 12
	lw	a7, t6, 8
	lw	s0, t6, 4
	slli	s1, a0, 2
	add	s1, a1, s1
	lw	s1, s1, 0
	addi	s1, s1, 1
	beq	s1, zero, .Beq143
	slli	s1, a0, 2
	add	s1, a1, s1
	lw	s1, s1, 0
	sw	hp, 0, s0
	sw	hp, 4, a7
	sw	hp, 8, a6
	sw	hp, 12, a1
	sw	hp, 16, t6
	sw	hp, 20, a0
	sw	hp, 24, a4
	sw	hp, 28, s1
	sw	hp, 32, a3
	mv	a1, a5
	mv	a0, s1
	mv	t6, a2
	mv	a2, a7
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	lw	a2, hp, 32
	flw	fa0, a2, 0
	beq	a1, zero, .Beq144
	addrl	a1, l.7141
	flw	fa1, a1, 0
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq146
	li	a1, 0
	j	.Cont147
.Beq146:
	nop
	li	a1, 1
.Cont147:
	nop
	j	.Cont145
.Beq144:
	nop
	li	a1, 0
.Cont145:
	nop
	beq	a1, zero, .Beq148
	addrl	a1, l.7139
	flw	fa1, a1, 0
	fadd.s	fa0, fa0, fa1
	lw	a1, hp, 8
	flw	fa1, a1, 0
	fmul.s	fa1, fa1, fa0
	lw	a2, hp, 4
	flw	fa2, a2, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a1, 4
	fmul.s	fa2, fa2, fa0
	flw	fa3, a2, 4
	fadd.s	fa2, fa2, fa3
	flw	fa3, a1, 8
	fmul.s	fa0, fa3, fa0
	flw	fa3, a2, 8
	fadd.s	fa0, fa0, fa3
	li	a1, 0
	lw	a2, hp, 12
	lw	t6, hp, 0
	mv	a0, a1
	mv	a1, a2
	fsgnj.s	ft11, fa2, fa2
	fsgnj.s	fa2, fa0, fa0
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, ft11, ft11
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	beq	a1, zero, .Beq149
	li	a0, 1
	ret
.Beq149:
	nop
	lw	a1, hp, 20
	addi	a1, a1, 1
	lw	a2, hp, 12
	lw	t6, hp, 16
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq148:
	nop
	lw	a1, hp, 28
	slli	a1, a1, 2
	lw	a2, hp, 24
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_isinvert.2411
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	beq	a1, zero, .Beq150
	lw	a1, hp, 20
	addi	a1, a1, 1
	lw	a2, hp, 12
	lw	t6, hp, 16
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq150:
	nop
	li	a0, 0
	ret
.Beq143:
	nop
	li	a0, 0
	ret
shadow_check_one_or_group.2631:
	lw	a2, t6, 8
	lw	a3, t6, 4
	slli	a4, a0, 2
	add	a4, a1, a4
	lw	a4, a4, 0
	addi	a5, a4, 1
	beq	a5, zero, .Beq151
	slli	a4, a4, 2
	add	a3, a3, a4
	lw	a3, a3, 0
	li	a4, 0
	sw	hp, 0, a1
	sw	hp, 4, t6
	sw	hp, 8, a0
	mv	a1, a3
	mv	a0, a4
	mv	t6, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	beq	a1, zero, .Beq152
	li	a0, 1
	ret
.Beq152:
	nop
	lw	a1, hp, 8
	addi	a1, a1, 1
	lw	a2, hp, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq151:
	nop
	li	a0, 0
	ret
shadow_check_one_or_matrix.2634:
	lw	a2, t6, 20
	lw	a3, t6, 16
	lw	a4, t6, 12
	lw	a5, t6, 8
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a7, a1, a7
	lw	a7, a7, 0
	lw	s0, a7, 0
	addi	s1, s0, 1
	beq	s1, zero, .Beq153
	addi	s1, s0, -99
	sw	hp, 0, a7
	sw	hp, 4, a4
	sw	hp, 8, a1
	sw	hp, 12, t6
	sw	hp, 16, a0
	beq	s1, zero, .Beq154
	sw	hp, 20, a3
	mv	a1, a5
	mv	a0, s0
	mv	t6, a2
	mv	a2, a6
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq156
	addrl	a1, l.7143
	flw	fa0, a1, 0
	lw	a1, hp, 20
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq158
	li	a1, 0
	j	.Cont159
.Beq158:
	nop
	li	a1, 1
	lw	a2, hp, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq160
	li	a1, 1
	j	.Cont161
.Beq160:
	nop
	li	a1, 0
.Cont161:
	nop
.Cont159:
	nop
	j	.Cont157
.Beq156:
	nop
	li	a1, 0
.Cont157:
	nop
	j	.Cont155
.Beq154:
	nop
	li	a1, 1
.Cont155:
	nop
	beq	a1, zero, .Beq162
	li	a1, 1
	lw	a2, hp, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq163
	li	a0, 1
	ret
.Beq163:
	nop
	lw	a1, hp, 16
	addi	a1, a1, 1
	lw	a2, hp, 8
	lw	t6, hp, 12
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq162:
	nop
	lw	a1, hp, 16
	addi	a1, a1, 1
	lw	a2, hp, 8
	lw	t6, hp, 12
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq153:
	nop
	li	a0, 0
	ret
solve_each_element.2637:
	lw	a3, t6, 36
	lw	a4, t6, 32
	lw	a5, t6, 28
	lw	a6, t6, 24
	lw	a7, t6, 20
	lw	s0, t6, 16
	lw	s1, t6, 12
	lw	s2, t6, 8
	lw	s3, t6, 4
	slli	s4, a0, 2
	add	s4, a1, s4
	lw	s4, s4, 0
	addi	s5, s4, 1
	beq	s5, zero, .Beq164
	sw	hp, 0, s0
	sw	hp, 4, s2
	sw	hp, 8, s1
	sw	hp, 12, s3
	sw	hp, 16, a4
	sw	hp, 20, a3
	sw	hp, 24, a5
	sw	hp, 28, a2
	sw	hp, 32, a1
	sw	hp, 36, t6
	sw	hp, 40, a0
	sw	hp, 44, a7
	sw	hp, 48, s4
	mv	a1, a2
	mv	a0, s4
	mv	t6, a6
	mv	a2, a4
	sw	hp, 52, ra
	addi	hp, hp, 56
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -56
	lw	ra, hp, 52
	beq	a0, zero, .Beq165
	lw	a1, hp, 24
	flw	fa0, a1, 0
	addrl	a1, l.7060
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq166
	j	.Cont167
.Beq166:
	nop
	lw	a1, hp, 20
	flw	fa1, a1, 0
	fle.s	a2, fa1, fa0
	beq	a2, zero, .Beq168
	j	.Cont169
.Beq168:
	nop
	addrl	a2, l.7139
	flw	fa1, a2, 0
	fadd.s	fa0, fa0, fa1
	lw	a2, hp, 28
	flw	fa1, a2, 0
	fmul.s	fa1, fa1, fa0
	lw	a3, hp, 16
	flw	fa2, a3, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a2, 4
	fmul.s	fa2, fa2, fa0
	flw	fa3, a3, 4
	fadd.s	fa2, fa2, fa3
	flw	fa3, a2, 8
	fmul.s	fa3, fa3, fa0
	flw	fa4, a3, 8
	fadd.s	fa3, fa3, fa4
	li	a3, 0
	lw	a4, hp, 32
	lw	t6, hp, 12
	sw	hp, 52, a0
	fsw	hp, 56, fa3
	fsw	hp, 60, fa2
	fsw	hp, 64, fa1
	fsw	hp, 68, fa0
	mv	a1, a4
	mv	a0, a3
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 72, ra
	addi	hp, hp, 76
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -76
	lw	ra, hp, 72
	beq	a0, zero, .Beq170
	lw	a0, hp, 20
	flw	fa0, hp, 68
	fsw	a0, 0, fa0
	lw	a0, hp, 8
	flw	fa0, hp, 64
	flw	fa1, hp, 60
	flw	fa2, hp, 56
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	vecset.2367
	addi	hp, hp, -76
	lw	ra, hp, 72
	lw	a0, hp, 4
	lw	a1, hp, 48
	sw	a0, 0, a1
	lw	a0, hp, 0
	lw	a1, hp, 52
	sw	a0, 0, a1
	j	.Cont171
.Beq170:
	nop
.Cont171:
	nop
.Cont169:
	nop
.Cont167:
	nop
	lw	a0, hp, 40
	addi	a0, a0, 1
	lw	a1, hp, 32
	lw	a2, hp, 28
	lw	t6, hp, 36
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq165:
	nop
	lw	a0, hp, 48
	slli	a0, a0, 2
	lw	a1, hp, 44
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	o_isinvert.2411
	addi	hp, hp, -76
	lw	ra, hp, 72
	beq	a0, zero, .Beq172
	lw	a0, hp, 40
	addi	a0, a0, 1
	lw	a1, hp, 32
	lw	a2, hp, 28
	lw	t6, hp, 36
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq172:
	nop
	ret
.Beq164:
	nop
	ret
solve_one_or_network.2641:
	lw	a3, t6, 8
	lw	a4, t6, 4
	slli	a5, a0, 2
	add	a5, a1, a5
	lw	a5, a5, 0
	addi	a6, a5, 1
	beq	a6, zero, .Beq173
	slli	a5, a5, 2
	add	a4, a4, a5
	lw	a4, a4, 0
	li	a5, 0
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, t6
	sw	hp, 12, a0
	mv	a1, a4
	mv	a0, a5
	mv	t6, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 12
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq173:
	nop
	ret
trace_or_matrix.2645:
	lw	a3, t6, 20
	lw	a4, t6, 16
	lw	a5, t6, 12
	lw	a6, t6, 8
	lw	a7, t6, 4
	slli	s0, a0, 2
	add	s0, a1, s0
	lw	s0, s0, 0
	lw	s1, s0, 0
	addi	s2, s1, 1
	beq	s2, zero, .Beq174
	addi	s2, s1, -99
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, t6
	sw	hp, 12, a0
	beq	s2, zero, .Beq175
	sw	hp, 16, s0
	sw	hp, 20, a7
	sw	hp, 24, a3
	sw	hp, 28, a5
	mv	a1, a2
	mv	a0, s1
	mv	t6, a6
	mv	a2, a4
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	beq	a0, zero, .Beq177
	lw	a0, hp, 28
	flw	fa0, a0, 0
	lw	a0, hp, 24
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq179
	j	.Cont180
.Beq179:
	nop
	li	a0, 1
	lw	a1, hp, 16
	lw	a2, hp, 0
	lw	t6, hp, 20
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
.Cont180:
	nop
	j	.Cont178
.Beq177:
	nop
.Cont178:
	nop
	j	.Cont176
.Beq175:
	nop
	li	a3, 1
	mv	a1, s0
	mv	a0, a3
	mv	t6, a7
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
.Cont176:
	nop
	lw	a0, hp, 12
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq174:
	nop
	ret
judge_intersection.2649:
	lw	a1, t6, 12
	lw	a2, t6, 8
	lw	a3, t6, 4
	addrl	a4, l.7150
	flw	fa0, a4, 0
	fsw	a2, 0, fa0
	li	a4, 0
	lw	a3, a3, 0
	sw	hp, 0, a2
	mv	a2, a0
	mv	t6, a1
	mv	a1, a3
	mv	a0, a4
	sw	hp, 4, ra
	addi	hp, hp, 8
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a1, hp, 0
	flw	fa0, a1, 0
	addrl	a1, l.7143
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq181
	li	a0, 0
	ret
.Beq181:
	nop
	addrl	a1, l.7147
	flw	fa1, a1, 0
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq182
	li	a0, 0
	ret
.Beq182:
	nop
	li	a0, 1
	ret
solve_each_element_fast.2651:
	lw	a3, t6, 36
	lw	a4, t6, 32
	lw	a5, t6, 28
	lw	a6, t6, 24
	lw	a7, t6, 20
	lw	s0, t6, 16
	lw	s1, t6, 12
	lw	s2, t6, 8
	lw	s3, t6, 4
	sw	hp, 0, s0
	sw	hp, 4, s2
	sw	hp, 8, s1
	sw	hp, 12, s3
	sw	hp, 16, a4
	sw	hp, 20, a3
	sw	hp, 24, a6
	sw	hp, 28, t6
	sw	hp, 32, a7
	sw	hp, 36, a2
	sw	hp, 40, a5
	sw	hp, 44, a1
	sw	hp, 48, a0
	mv	a0, a2
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 48
	slli	a2, a1, 2
	lw	a3, hp, 44
	add	a2, a3, a2
	lw	a2, a2, 0
	addi	a4, a2, 1
	beq	a4, zero, .Beq183
	lw	a4, hp, 36
	lw	t6, hp, 40
	sw	hp, 52, a0
	sw	hp, 56, a2
	mv	a1, a4
	mv	a0, a2
	sw	hp, 60, ra
	addi	hp, hp, 64
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -64
	lw	ra, hp, 60
	beq	a0, zero, .Beq184
	lw	a1, hp, 24
	flw	fa0, a1, 0
	addrl	a1, l.7060
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq185
	j	.Cont186
.Beq185:
	nop
	lw	a1, hp, 20
	flw	fa1, a1, 0
	fle.s	a2, fa1, fa0
	beq	a2, zero, .Beq187
	j	.Cont188
.Beq187:
	nop
	addrl	a2, l.7139
	flw	fa1, a2, 0
	fadd.s	fa0, fa0, fa1
	lw	a2, hp, 52
	flw	fa1, a2, 0
	fmul.s	fa1, fa1, fa0
	lw	a3, hp, 16
	flw	fa2, a3, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a2, 4
	fmul.s	fa2, fa2, fa0
	flw	fa3, a3, 4
	fadd.s	fa2, fa2, fa3
	flw	fa3, a2, 8
	fmul.s	fa3, fa3, fa0
	flw	fa4, a3, 8
	fadd.s	fa3, fa3, fa4
	li	a2, 0
	lw	a3, hp, 44
	lw	t6, hp, 12
	sw	hp, 60, a0
	fsw	hp, 64, fa3
	fsw	hp, 68, fa2
	fsw	hp, 72, fa1
	fsw	hp, 76, fa0
	mv	a1, a3
	mv	a0, a2
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 80, ra
	addi	hp, hp, 84
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -84
	lw	ra, hp, 80
	beq	a0, zero, .Beq189
	lw	a0, hp, 20
	flw	fa0, hp, 76
	fsw	a0, 0, fa0
	lw	a0, hp, 8
	flw	fa0, hp, 72
	flw	fa1, hp, 68
	flw	fa2, hp, 64
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	vecset.2367
	addi	hp, hp, -84
	lw	ra, hp, 80
	lw	a0, hp, 4
	lw	a1, hp, 56
	sw	a0, 0, a1
	lw	a0, hp, 0
	lw	a1, hp, 60
	sw	a0, 0, a1
	j	.Cont190
.Beq189:
	nop
.Cont190:
	nop
.Cont188:
	nop
.Cont186:
	nop
	lw	a0, hp, 48
	addi	a0, a0, 1
	lw	a1, hp, 44
	lw	a2, hp, 36
	lw	t6, hp, 28
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq184:
	nop
	lw	a0, hp, 56
	slli	a0, a0, 2
	lw	a1, hp, 32
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	o_isinvert.2411
	addi	hp, hp, -84
	lw	ra, hp, 80
	beq	a0, zero, .Beq191
	lw	a0, hp, 48
	addi	a0, a0, 1
	lw	a1, hp, 44
	lw	a2, hp, 36
	lw	t6, hp, 28
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq191:
	nop
	ret
.Beq183:
	nop
	ret
solve_one_or_network_fast.2655:
	lw	a3, t6, 8
	lw	a4, t6, 4
	slli	a5, a0, 2
	add	a5, a1, a5
	lw	a5, a5, 0
	addi	a6, a5, 1
	beq	a6, zero, .Beq192
	slli	a5, a5, 2
	add	a4, a4, a5
	lw	a4, a4, 0
	li	a5, 0
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, t6
	sw	hp, 12, a0
	mv	a1, a4
	mv	a0, a5
	mv	t6, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 12
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq192:
	nop
	ret
trace_or_matrix_fast.2659:
	lw	a3, t6, 16
	lw	a4, t6, 12
	lw	a5, t6, 8
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a7, a1, a7
	lw	a7, a7, 0
	lw	s0, a7, 0
	addi	s1, s0, 1
	beq	s1, zero, .Beq193
	addi	s1, s0, -99
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, t6
	sw	hp, 12, a0
	beq	s1, zero, .Beq194
	sw	hp, 16, a7
	sw	hp, 20, a6
	sw	hp, 24, a3
	sw	hp, 28, a5
	mv	a1, a2
	mv	a0, s0
	mv	t6, a4
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	beq	a0, zero, .Beq196
	lw	a0, hp, 28
	flw	fa0, a0, 0
	lw	a0, hp, 24
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq198
	j	.Cont199
.Beq198:
	nop
	li	a0, 1
	lw	a1, hp, 16
	lw	a2, hp, 0
	lw	t6, hp, 20
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
.Cont199:
	nop
	j	.Cont197
.Beq196:
	nop
.Cont197:
	nop
	j	.Cont195
.Beq194:
	nop
	li	a3, 1
	mv	a1, a7
	mv	a0, a3
	mv	t6, a6
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
.Cont195:
	nop
	lw	a0, hp, 12
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq193:
	nop
	ret
judge_intersection_fast.2663:
	lw	a1, t6, 12
	lw	a2, t6, 8
	lw	a3, t6, 4
	addrl	a4, l.7150
	flw	fa0, a4, 0
	fsw	a2, 0, fa0
	li	a4, 0
	lw	a3, a3, 0
	sw	hp, 0, a2
	mv	a2, a0
	mv	t6, a1
	mv	a1, a3
	mv	a0, a4
	sw	hp, 4, ra
	addi	hp, hp, 8
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a1, hp, 0
	flw	fa0, a1, 0
	addrl	a1, l.7143
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq200
	li	a0, 0
	ret
.Beq200:
	nop
	addrl	a1, l.7147
	flw	fa1, a1, 0
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq201
	li	a0, 0
	ret
.Beq201:
	nop
	li	a0, 1
	ret
get_nvector_rect.2665:
	lw	a1, t6, 8
	lw	a2, t6, 4
	lw	a2, a2, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, a2
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	vecbzero.2375
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	addi	a1, a0, -1
	addi	a0, a0, -1
	slli	a0, a0, 2
	lw	a2, hp, 4
	add	a0, a2, a0
	flw	fa0, a0, 0
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	sgn.2359
	addi	hp, hp, -20
	lw	ra, hp, 16
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 12
	slli	a0, a0, 2
	lw	a1, hp, 0
	add	a0, a1, a0
	fsw	a0, 0, fa0
	ret
get_nvector_plane.2667:
	lw	a1, t6, 4
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_param_a.2415
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 4
	fsw	a0, 0, fa0
	lw	a1, hp, 0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_param_b.2417
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 4
	fsw	a0, 4, fa0
	lw	a1, hp, 0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_param_c.2419
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 4
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
get_nvector_second.2669:
	lw	a1, t6, 8
	lw	a2, t6, 4
	flw	fa0, a2, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, a2
	fsw	hp, 12, fa0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_x.2423
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	flw	fa1, a0, 4
	lw	a1, hp, 4
	fsw	hp, 16, fa0
	fsw	hp, 20, fa1
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_y.2425
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	flw	fa1, a0, 8
	lw	a0, hp, 4
	fsw	hp, 24, fa0
	fsw	hp, 28, fa1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_z.2427
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 32, fa0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_a.2415
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 36, fa0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_b.2417
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 40, fa0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_c.2419
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 44, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_isrot.2413
	addi	hp, hp, -52
	lw	ra, hp, 48
	beq	a0, zero, .Beq202
	lw	a0, hp, 4
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_r3.2443
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 48, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_r2.2441
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	flw	fa2, hp, 48
	fadd.s	fa0, fa2, fa0
	addrl	a0, l.7097
	flw	fa2, a0, 0
	fmul.s	fa0, fa0, fa2
	flw	fa2, hp, 36
	fadd.s	fa0, fa2, fa0
	lw	a0, hp, 0
	fsw	a0, 0, fa0
	lw	a1, hp, 4
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_r3.2443
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 52, fa0
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_r1.2439
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 52
	fadd.s	fa0, fa1, fa0
	addrl	a0, l.7097
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 40
	fadd.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	a0, 4, fa0
	lw	a1, hp, 4
	mv	a0, a1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_r2.2441
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 56, fa0
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_param_r1.2439
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 56
	fadd.s	fa0, fa1, fa0
	addrl	a0, l.7097
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 44
	fadd.s	fa0, fa1, fa0
	lw	a0, hp, 0
	addi	a1, a0, 8
	fsw	a1, 0, fa0
	j	.Cont203
.Beq202:
	nop
	lw	a0, hp, 0
	flw	fa0, hp, 36
	fsw	a0, 0, fa0
	flw	fa0, hp, 40
	fsw	a0, 4, fa0
	addi	a1, a0, 8
	flw	fa0, hp, 44
	fsw	a1, 0, fa0
.Cont203:
	nop
	lw	a1, hp, 4
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_isinvert.2411
	addi	hp, hp, -64
	lw	ra, hp, 60
	mv	a1, a0
	lw	a0, hp, 0
	j	vecunit_sgn.2380
get_nvector.2671:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a0
	sw	hp, 8, a4
	sw	hp, 12, a1
	sw	hp, 16, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_form.2407
	addi	hp, hp, -24
	lw	ra, hp, 20
	addi	a1, a0, -1
	beq	a1, zero, .Beq204
	addi	a0, a0, -2
	beq	a0, zero, .Beq205
	lw	a0, hp, 4
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq205:
	nop
	lw	a0, hp, 4
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq204:
	nop
	lw	a0, hp, 12
	lw	t6, hp, 16
	lw	t5, t6, 0
	jalr	zero, t5, 0
utexture.2674:
	lw	a2, t6, 4
	sw	hp, 0, a1
	sw	hp, 4, a2
	sw	hp, 8, a0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_texturetype.2405
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_color_red.2433
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 4
	fsw	a0, 0, fa0
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_color_green.2435
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 4
	fsw	a0, 4, fa0
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_color_blue.2437
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 4
	fsw	a0, 8, fa0
	lw	a1, hp, 12
	addi	a2, a1, -1
	beq	a2, zero, .Beq206
	addi	a2, a1, -2
	beq	a2, zero, .Beq207
	addi	a2, a1, -3
	beq	a2, zero, .Beq208
	addi	a1, a1, -4
	beq	a1, zero, .Beq209
	ret
.Beq209:
	nop
	lw	a1, hp, 0
	flw	fa0, a1, 0
	lw	a2, hp, 8
	fsw	hp, 16, fa0
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_x.2423
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	fsw	hp, 20, fa0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_a.2415
	addi	hp, hp, -28
	lw	ra, hp, 24
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_sqrt
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 8
	lw	a1, hp, 8
	fsw	hp, 24, fa0
	fsw	hp, 28, fa1
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_z.2427
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	fsw	hp, 32, fa0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_sqrt
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 24
	fmul.s	fa2, fa1, fa1
	fmul.s	fa3, fa0, fa0
	fadd.s	fa2, fa2, fa3
	addrl	a0, l.7202
	flw	fa3, a0, 0
	fsw	hp, 36, fa2
	fsw	hp, 40, fa0
	fsw	hp, 44, fa3
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_fabs
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq210
	flw	fa0, hp, 24
	flw	fa1, hp, 40
	fdiv.s	fa0, fa1, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_fabs
	addi	hp, hp, -52
	lw	ra, hp, 48
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_atan
	addi	hp, hp, -52
	lw	ra, hp, 48
	addrl	a0, l.7200
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7183
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	j	.Cont211
.Beq210:
	nop
	addrl	a0, l.7197
	flw	fa0, a0, 0
.Cont211:
	nop
	fsw	hp, 48, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_floor
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 48
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 4
	lw	a0, hp, 8
	fsw	hp, 52, fa0
	fsw	hp, 56, fa1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_param_y.2425
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	fsw	hp, 60, fa0
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	o_param_b.2417
	addi	hp, hp, -68
	lw	ra, hp, 64
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	min_caml_sqrt
	addi	hp, hp, -68
	lw	ra, hp, 64
	flw	fa1, hp, 60
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.7202
	flw	fa1, a0, 0
	flw	fa2, hp, 36
	fsw	hp, 64, fa0
	fsw	hp, 68, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	min_caml_fabs
	addi	hp, hp, -76
	lw	ra, hp, 72
	flw	fa1, hp, 68
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq212
	flw	fa0, hp, 36
	flw	fa1, hp, 64
	fdiv.s	fa0, fa1, fa0
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	min_caml_fabs
	addi	hp, hp, -76
	lw	ra, hp, 72
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	min_caml_atan
	addi	hp, hp, -76
	lw	ra, hp, 72
	addrl	a0, l.7200
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7183
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	j	.Cont213
.Beq212:
	nop
	addrl	a0, l.7197
	flw	fa0, a0, 0
.Cont213:
	nop
	fsw	hp, 72, fa0
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	min_caml_floor
	addi	hp, hp, -80
	lw	ra, hp, 76
	flw	fa1, hp, 72
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.7195
	flw	fa1, a0, 0
	addrl	a0, l.7097
	flw	fa2, a0, 0
	flw	fa3, hp, 52
	fsub.s	fa2, fa2, fa3
	addrl	a0, l.7097
	flw	fa4, a0, 0
	fsub.s	fa3, fa4, fa3
	fmul.s	fa2, fa2, fa3
	fsub.s	fa1, fa1, fa2
	addrl	a0, l.7097
	flw	fa2, a0, 0
	fsub.s	fa2, fa2, fa0
	addrl	a0, l.7097
	flw	fa3, a0, 0
	fsub.s	fa0, fa3, fa0
	fmul.s	fa0, fa2, fa0
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.7060
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq214
	j	.Cont215
.Beq214:
	nop
	addrl	a0, l.7060
	flw	fa0, a0, 0
.Cont215:
	nop
	addrl	a0, l.7160
	flw	fa1, a0, 0
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.7186
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	lw	a0, hp, 4
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
.Beq208:
	nop
	lw	a1, hp, 0
	flw	fa0, a1, 0
	lw	a2, hp, 8
	fsw	hp, 76, fa0
	mv	a0, a2
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	o_param_x.2423
	addi	hp, hp, -84
	lw	ra, hp, 80
	flw	fa1, hp, 76
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 8
	lw	a0, hp, 8
	fsw	hp, 80, fa0
	fsw	hp, 84, fa1
	sw	hp, 88, ra
	addi	hp, hp, 92
	call	o_param_z.2427
	addi	hp, hp, -92
	lw	ra, hp, 88
	flw	fa1, hp, 84
	fsub.s	fa0, fa1, fa0
	flw	fa1, hp, 80
	fmul.s	fa1, fa1, fa1
	fmul.s	fa0, fa0, fa0
	fadd.s	fa0, fa1, fa0
	sw	hp, 88, ra
	addi	hp, hp, 92
	call	min_caml_sqrt
	addi	hp, hp, -92
	lw	ra, hp, 88
	addrl	a0, l.7165
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	fsw	hp, 88, fa0
	sw	hp, 92, ra
	addi	hp, hp, 96
	call	min_caml_floor
	addi	hp, hp, -96
	lw	ra, hp, 92
	flw	fa1, hp, 88
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.7183
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	fsw	hp, 92, fa0
	sw	hp, 96, ra
	addi	hp, hp, 100
	call	min_caml_cos
	addi	hp, hp, -100
	lw	ra, hp, 96
	flw	fa1, hp, 92
	fsw	hp, 96, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 100, ra
	addi	hp, hp, 104
	call	min_caml_cos
	addi	hp, hp, -104
	lw	ra, hp, 100
	flw	fa1, hp, 96
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.7160
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	lw	a0, hp, 4
	fsw	a0, 4, fa1
	addrl	a1, l.7056
	flw	fa1, a1, 0
	fsub.s	fa0, fa1, fa0
	addrl	a1, l.7160
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
.Beq207:
	nop
	lw	a1, hp, 0
	flw	fa0, a1, 4
	addrl	a2, l.7177
	flw	fa1, a2, 0
	fmul.s	fa0, fa0, fa1
	sw	hp, 100, ra
	addi	hp, hp, 104
	call	min_caml_sin
	addi	hp, hp, -104
	lw	ra, hp, 100
	lw	a0, hp, 0
	flw	fa1, a0, 4
	addrl	a0, l.7177
	flw	fa2, a0, 0
	fmul.s	fa1, fa1, fa2
	fsw	hp, 100, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 104, ra
	addi	hp, hp, 108
	call	min_caml_sin
	addi	hp, hp, -108
	lw	ra, hp, 104
	flw	fa1, hp, 100
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.7160
	flw	fa1, a0, 0
	fmul.s	fa1, fa1, fa0
	lw	a0, hp, 4
	fsw	a0, 0, fa1
	addrl	a1, l.7160
	flw	fa1, a1, 0
	addrl	a1, l.7056
	flw	fa2, a1, 0
	fsub.s	fa0, fa2, fa0
	fmul.s	fa0, fa1, fa0
	addi	a0, a0, 4
	fsw	a0, 0, fa0
	ret
.Beq206:
	nop
	lw	a1, hp, 0
	flw	fa0, a1, 0
	lw	a2, hp, 8
	fsw	hp, 104, fa0
	mv	a0, a2
	sw	hp, 108, ra
	addi	hp, hp, 112
	call	o_param_x.2423
	addi	hp, hp, -112
	lw	ra, hp, 108
	flw	fa1, hp, 104
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.7169
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	fsw	hp, 108, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 112, ra
	addi	hp, hp, 116
	call	min_caml_floor
	addi	hp, hp, -116
	lw	ra, hp, 112
	addrl	a0, l.7167
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7165
	flw	fa1, a0, 0
	flw	fa2, hp, 108
	fsub.s	fa0, fa2, fa0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq216
	li	a0, 0
	j	.Cont217
.Beq216:
	nop
	li	a0, 1
.Cont217:
	nop
	lw	a1, hp, 0
	flw	fa0, a1, 8
	lw	a1, hp, 8
	sw	hp, 112, a0
	fsw	hp, 116, fa0
	mv	a0, a1
	sw	hp, 120, ra
	addi	hp, hp, 124
	call	o_param_z.2427
	addi	hp, hp, -124
	lw	ra, hp, 120
	flw	fa1, hp, 116
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.7169
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	fsw	hp, 120, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	min_caml_floor
	addi	hp, hp, -128
	lw	ra, hp, 124
	addrl	a0, l.7167
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7165
	flw	fa1, a0, 0
	flw	fa2, hp, 120
	fsub.s	fa0, fa2, fa0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq218
	li	a0, 0
	j	.Cont219
.Beq218:
	nop
	li	a0, 1
.Cont219:
	nop
	lw	a1, hp, 112
	beq	a1, zero, .Beq220
	beq	a0, zero, .Beq222
	addrl	a0, l.7160
	flw	fa0, a0, 0
	j	.Cont223
.Beq222:
	nop
	addrl	a0, l.7060
	flw	fa0, a0, 0
.Cont223:
	nop
	j	.Cont221
.Beq220:
	nop
	beq	a0, zero, .Beq224
	addrl	a0, l.7060
	flw	fa0, a0, 0
	j	.Cont225
.Beq224:
	nop
	addrl	a0, l.7160
	flw	fa0, a0, 0
.Cont225:
	nop
.Cont221:
	nop
	lw	a0, hp, 4
	addi	a0, a0, 4
	fsw	a0, 0, fa0
	ret
add_light.2677:
	lw	a1, t6, 8
	lw	a0, t6, 4
	addrl	a2, l.7060
	flw	fa3, a2, 0
	fle.s	a2, fa0, fa3
	sw	hp, 0, a0
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	beq	a2, zero, .Beq226
	j	.Cont227
.Beq226:
	nop
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	vecaccum.2391
	addi	hp, hp, -16
	lw	ra, hp, 12
.Cont227:
	nop
	addrl	a0, l.7060
	flw	fa0, a0, 0
	flw	fa1, hp, 8
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq228
	ret
.Beq228:
	nop
	fmul.s	fa0, fa1, fa1
	fmul.s	fa1, fa1, fa1
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 4
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 0
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	fsw	a0, 0, fa1
	flw	fa1, a0, 4
	fadd.s	fa1, fa1, fa0
	fsw	a0, 4, fa1
	flw	fa1, a0, 8
	fadd.s	fa0, fa1, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
trace_reflections.2681:
	lw	a2, t6, 32
	lw	a3, t6, 28
	lw	a4, t6, 24
	lw	a5, t6, 20
	lw	a6, t6, 16
	lw	a7, t6, 12
	lw	s0, t6, 8
	lw	s1, t6, 4
	bge	a0, zero, .Bge229
	ret
.Bge229:
	nop
	slli	s2, a0, 2
	add	a3, a3, s2
	lw	a3, a3, 0
	sw	hp, 0, t6
	sw	hp, 4, a0
	fsw	hp, 8, fa1
	sw	hp, 12, s1
	sw	hp, 16, a1
	fsw	hp, 20, fa0
	sw	hp, 24, a5
	sw	hp, 28, a2
	sw	hp, 32, a4
	sw	hp, 36, a3
	sw	hp, 40, a7
	sw	hp, 44, s0
	sw	hp, 48, a6
	mv	a0, a3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	r_dvec.2472
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	t6, hp, 48
	sw	hp, 52, a0
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	beq	a0, zero, .Beq230
	lw	a0, hp, 44
	lw	a0, a0, 0
	slli	a0, a0, 2
	lw	a1, hp, 40
	lw	a1, a1, 0
	add	a0, a0, a1
	lw	a1, hp, 36
	sw	hp, 56, a0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	r_surface_id.2470
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a1, hp, 56
	beq	a1, a0, .Beq232
	j	.Cont233
.Beq232:
	nop
	li	a0, 0
	lw	a1, hp, 32
	lw	a1, a1, 0
	lw	t6, hp, 28
	sw	hp, 60, ra
	addi	hp, hp, 64
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -64
	lw	ra, hp, 60
	beq	a0, zero, .Beq234
	j	.Cont235
.Beq234:
	nop
	lw	a0, hp, 52
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	mv	a1, a0
	lw	a0, hp, 24
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	veciprod.2383
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 36
	fsw	hp, 60, fa0
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	r_bright.2474
	addi	hp, hp, -68
	lw	ra, hp, 64
	flw	fa1, hp, 20
	fmul.s	fa2, fa0, fa1
	flw	fa3, hp, 60
	fmul.s	fa2, fa2, fa3
	lw	a0, hp, 52
	fsw	hp, 64, fa2
	fsw	hp, 68, fa0
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	d_vec.2466
	addi	hp, hp, -76
	lw	ra, hp, 72
	mv	a1, a0
	lw	a0, hp, 16
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	veciprod.2383
	addi	hp, hp, -76
	lw	ra, hp, 72
	flw	fa1, hp, 68
	fmul.s	fa1, fa1, fa0
	flw	fa0, hp, 64
	flw	fa2, hp, 8
	lw	t6, hp, 12
	sw	hp, 72, ra
	addi	hp, hp, 76
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -76
	lw	ra, hp, 72
.Cont235:
	nop
.Cont233:
	nop
	j	.Cont231
.Beq230:
	nop
.Cont231:
	nop
	lw	a0, hp, 4
	addi	a0, a0, -1
	lw	a1, hp, 16
	flw	fa0, hp, 20
	flw	fa1, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
trace_ray.2686:
	lw	a3, t6, 80
	lw	a4, t6, 76
	lw	a5, t6, 72
	lw	a6, t6, 68
	lw	a7, t6, 64
	lw	s0, t6, 60
	lw	s1, t6, 56
	lw	s2, t6, 52
	lw	s3, t6, 48
	lw	s4, t6, 44
	lw	s5, t6, 40
	lw	s6, t6, 36
	lw	s7, t6, 32
	lw	s8, t6, 28
	lw	s9, t6, 24
	lw	s10, t6, 20
	lw	s11, t6, 16
	lw	t0, t6, 12
	lw	t1, t6, 8
	lw	t2, t6, 4
	addi	t3, a0, -4
	bge	zero, t3, .Ble236
	ret
.Ble236:
	nop
	sw	hp, 0, t6
	fsw	hp, 4, fa1
	sw	hp, 8, a5
	sw	hp, 12, a4
	sw	hp, 16, s6
	sw	hp, 20, s1
	sw	hp, 24, t2
	sw	hp, 28, s0
	sw	hp, 32, s3
	sw	hp, 36, s5
	sw	hp, 40, a6
	sw	hp, 44, a2
	sw	hp, 48, s9
	sw	hp, 52, a3
	sw	hp, 56, s10
	sw	hp, 60, a7
	sw	hp, 64, t0
	sw	hp, 68, s4
	sw	hp, 72, s11
	sw	hp, 76, s2
	sw	hp, 80, t1
	fsw	hp, 84, fa0
	sw	hp, 88, s7
	sw	hp, 92, a0
	sw	hp, 96, a1
	sw	hp, 100, s8
	mv	a0, a2
	sw	hp, 104, ra
	addi	hp, hp, 108
	call	p_surface_ids.2451
	addi	hp, hp, -108
	lw	ra, hp, 104
	lw	a1, hp, 96
	lw	t6, hp, 100
	sw	hp, 104, a0
	mv	a0, a1
	sw	hp, 108, ra
	addi	hp, hp, 112
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -112
	lw	ra, hp, 108
	beq	a0, zero, .Beq237
	lw	a0, hp, 72
	lw	a0, a0, 0
	slli	a1, a0, 2
	lw	a2, hp, 68
	add	a1, a2, a1
	lw	a1, a1, 0
	sw	hp, 108, a0
	sw	hp, 112, a1
	mv	a0, a1
	sw	hp, 116, ra
	addi	hp, hp, 120
	call	o_reflectiontype.2409
	addi	hp, hp, -120
	lw	ra, hp, 116
	lw	a1, hp, 112
	sw	hp, 116, a0
	mv	a0, a1
	sw	hp, 120, ra
	addi	hp, hp, 124
	call	o_diffuse.2429
	addi	hp, hp, -124
	lw	ra, hp, 120
	flw	fa1, hp, 84
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 112
	lw	a1, hp, 96
	lw	t6, hp, 64
	fsw	hp, 120, fa0
	sw	hp, 124, ra
	addi	hp, hp, 128
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -128
	lw	ra, hp, 124
	lw	a0, hp, 60
	lw	a1, hp, 56
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	veccpy.2377
	addi	hp, hp, -128
	lw	ra, hp, 124
	lw	a0, hp, 112
	lw	a1, hp, 56
	lw	t6, hp, 52
	sw	hp, 124, ra
	addi	hp, hp, 128
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -128
	lw	ra, hp, 124
	lw	a0, hp, 108
	slli	a0, a0, 2
	lw	a1, hp, 48
	lw	a1, a1, 0
	add	a0, a0, a1
	lw	a1, hp, 92
	slli	a2, a1, 2
	lw	a3, hp, 104
	add	a2, a3, a2
	sw	a2, 0, a0
	lw	a0, hp, 44
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	p_intersection_points.2449
	addi	hp, hp, -128
	lw	ra, hp, 124
	lw	a1, hp, 92
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	lw	a2, hp, 56
	mv	a1, a2
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	veccpy.2377
	addi	hp, hp, -128
	lw	ra, hp, 124
	lw	a0, hp, 44
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	p_calc_diffuse.2453
	addi	hp, hp, -128
	lw	ra, hp, 124
	addrl	a1, l.7097
	flw	fa0, a1, 0
	lw	a1, hp, 112
	sw	hp, 124, a0
	fsw	hp, 128, fa0
	mv	a0, a1
	sw	hp, 132, ra
	addi	hp, hp, 136
	call	o_diffuse.2429
	addi	hp, hp, -136
	lw	ra, hp, 132
	flw	fa1, hp, 128
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq238
	li	a0, 1
	lw	a1, hp, 92
	slli	a2, a1, 2
	lw	a3, hp, 124
	add	a2, a3, a2
	sw	a2, 0, a0
	lw	a0, hp, 44
	sw	hp, 132, ra
	addi	hp, hp, 136
	call	p_energy.2455
	addi	hp, hp, -136
	lw	ra, hp, 132
	lw	a1, hp, 92
	slli	a2, a1, 2
	add	a2, a0, a2
	lw	a2, a2, 0
	lw	a3, hp, 40
	sw	hp, 132, a0
	mv	a1, a3
	mv	a0, a2
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	veccpy.2377
	addi	hp, hp, -140
	lw	ra, hp, 136
	lw	a0, hp, 92
	slli	a1, a0, 2
	lw	a2, hp, 132
	add	a1, a2, a1
	lw	a1, a1, 0
	addrl	a2, l.7216
	flw	fa0, a2, 0
	flw	fa1, hp, 120
	fmul.s	fa0, fa0, fa1
	mv	a0, a1
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	vecscale.2398
	addi	hp, hp, -140
	lw	ra, hp, 136
	lw	a0, hp, 44
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	p_nvectors.2464
	addi	hp, hp, -140
	lw	ra, hp, 136
	lw	a1, hp, 92
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	lw	a2, hp, 36
	mv	a1, a2
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	veccpy.2377
	addi	hp, hp, -140
	lw	ra, hp, 136
	j	.Cont239
.Beq238:
	nop
	li	a0, 0
	lw	a1, hp, 92
	slli	a2, a1, 2
	lw	a3, hp, 124
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont239:
	nop
	addrl	a0, l.7214
	flw	fa0, a0, 0
	lw	a0, hp, 96
	lw	a1, hp, 36
	fsw	hp, 136, fa0
	sw	hp, 140, ra
	addi	hp, hp, 144
	call	veciprod.2383
	addi	hp, hp, -144
	lw	ra, hp, 140
	flw	fa1, hp, 136
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 96
	lw	a1, hp, 36
	sw	hp, 140, ra
	addi	hp, hp, 144
	call	vecaccum.2391
	addi	hp, hp, -144
	lw	ra, hp, 140
	lw	a0, hp, 112
	sw	hp, 140, ra
	addi	hp, hp, 144
	call	o_hilight.2431
	addi	hp, hp, -144
	lw	ra, hp, 140
	flw	fa1, hp, 84
	fmul.s	fa0, fa1, fa0
	li	a0, 0
	lw	a1, hp, 32
	lw	a1, a1, 0
	lw	t6, hp, 28
	fsw	hp, 140, fa0
	sw	hp, 144, ra
	addi	hp, hp, 148
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -148
	lw	ra, hp, 144
	beq	a0, zero, .Beq240
	j	.Cont241
.Beq240:
	nop
	lw	a0, hp, 36
	lw	a1, hp, 88
	sw	hp, 144, ra
	addi	hp, hp, 148
	call	veciprod.2383
	addi	hp, hp, -148
	lw	ra, hp, 144
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 120
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 96
	lw	a1, hp, 88
	fsw	hp, 144, fa0
	sw	hp, 148, ra
	addi	hp, hp, 152
	call	veciprod.2383
	addi	hp, hp, -152
	lw	ra, hp, 148
	fsgnjn.s	fa1, fa0, fa0
	flw	fa0, hp, 144
	flw	fa2, hp, 140
	lw	t6, hp, 24
	sw	hp, 148, ra
	addi	hp, hp, 152
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -152
	lw	ra, hp, 148
.Cont241:
	nop
	lw	a0, hp, 56
	lw	t6, hp, 20
	sw	hp, 148, ra
	addi	hp, hp, 152
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -152
	lw	ra, hp, 148
	lw	a0, hp, 16
	lw	a0, a0, 0
	addi	a0, a0, -1
	lw	a1, hp, 96
	flw	fa0, hp, 120
	flw	fa1, hp, 140
	lw	t6, hp, 12
	sw	hp, 148, ra
	addi	hp, hp, 152
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -152
	lw	ra, hp, 148
	addrl	a0, l.7212
	flw	fa0, a0, 0
	flw	fa1, hp, 84
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq242
	ret
.Beq242:
	nop
	lw	a0, hp, 92
	addi	a1, a0, -4
	bge	a1, zero, .Bge243
	addi	a1, a0, 1
	li	a2, -1
	slli	a1, a1, 2
	lw	a3, hp, 104
	add	a1, a3, a1
	sw	a1, 0, a2
	j	.Cont244
.Bge243:
	nop
.Cont244:
	nop
	lw	a1, hp, 116
	addi	a1, a1, -2
	beq	a1, zero, .Beq245
	ret
.Beq245:
	nop
	addrl	a1, l.7056
	flw	fa0, a1, 0
	lw	a1, hp, 112
	fsw	hp, 148, fa0
	mv	a0, a1
	sw	hp, 152, ra
	addi	hp, hp, 156
	call	o_diffuse.2429
	addi	hp, hp, -156
	lw	ra, hp, 152
	flw	fa1, hp, 148
	fsub.s	fa0, fa1, fa0
	flw	fa1, hp, 84
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 92
	addi	a0, a0, 1
	lw	a1, hp, 8
	flw	fa1, a1, 0
	flw	fa2, hp, 4
	fadd.s	fa1, fa2, fa1
	lw	a1, hp, 96
	lw	a2, hp, 44
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq237:
	nop
	li	a0, -1
	lw	a1, hp, 92
	slli	a2, a1, 2
	lw	a3, hp, 104
	add	a2, a3, a2
	sw	a2, 0, a0
	beq	a1, zero, .Beq246
	lw	a0, hp, 96
	lw	a1, hp, 88
	sw	hp, 152, ra
	addi	hp, hp, 156
	call	veciprod.2383
	addi	hp, hp, -156
	lw	ra, hp, 152
	fsgnjn.s	fa0, fa0, fa0
	addrl	a0, l.7060
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq247
	ret
.Beq247:
	nop
	fmul.s	fa1, fa0, fa0
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 84
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 80
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 76
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	fsw	a0, 0, fa1
	flw	fa1, a0, 4
	fadd.s	fa1, fa1, fa0
	fsw	a0, 4, fa1
	flw	fa1, a0, 8
	fadd.s	fa0, fa1, fa0
	addi	a0, a0, 8
	fsw	a0, 0, fa0
	ret
.Beq246:
	nop
	ret
trace_diffuse_ray.2692:
	lw	a1, t6, 48
	lw	a2, t6, 44
	lw	a3, t6, 40
	lw	a4, t6, 36
	lw	a5, t6, 32
	lw	a6, t6, 28
	lw	a7, t6, 24
	lw	s0, t6, 20
	lw	s1, t6, 16
	lw	s2, t6, 12
	lw	s3, t6, 8
	lw	s4, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, s4
	fsw	hp, 8, fa0
	sw	hp, 12, a7
	sw	hp, 16, a6
	sw	hp, 20, a3
	sw	hp, 24, a4
	sw	hp, 28, s1
	sw	hp, 32, a1
	sw	hp, 36, s3
	sw	hp, 40, a0
	sw	hp, 44, a5
	sw	hp, 48, s2
	mv	t6, s0
	sw	hp, 52, ra
	addi	hp, hp, 56
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -56
	lw	ra, hp, 52
	beq	a0, zero, .Beq248
	lw	a0, hp, 48
	lw	a0, a0, 0
	slli	a0, a0, 2
	lw	a1, hp, 44
	add	a0, a1, a0
	lw	a0, a0, 0
	lw	a1, hp, 40
	sw	hp, 52, a0
	mv	a0, a1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	d_vec.2466
	addi	hp, hp, -60
	lw	ra, hp, 56
	mv	a1, a0
	lw	a0, hp, 52
	lw	t6, hp, 36
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	lw	a0, hp, 52
	lw	a1, hp, 28
	lw	t6, hp, 32
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	li	a0, 0
	lw	a1, hp, 24
	lw	a1, a1, 0
	lw	t6, hp, 20
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	beq	a0, zero, .Beq249
	ret
.Beq249:
	nop
	lw	a0, hp, 16
	lw	a1, hp, 12
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	veciprod.2383
	addi	hp, hp, -60
	lw	ra, hp, 56
	fsgnjn.s	fa0, fa0, fa0
	addrl	a0, l.7060
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq250
	addrl	a0, l.7060
	flw	fa0, a0, 0
	j	.Cont251
.Beq250:
	nop
.Cont251:
	nop
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 52
	fsw	hp, 56, fa0
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_diffuse.2429
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 4
	lw	a1, hp, 0
	j	vecaccum.2391
.Beq248:
	nop
	ret
iter_trace_diffuse_rays.2695:
	lw	a4, t6, 4
	bge	a3, zero, .Bge252
	ret
.Bge252:
	nop
	slli	a5, a3, 2
	add	a5, a0, a5
	lw	a5, a5, 0
	sw	hp, 0, a2
	sw	hp, 4, t6
	sw	hp, 8, a4
	sw	hp, 12, a0
	sw	hp, 16, a3
	sw	hp, 20, a1
	mv	a0, a5
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	d_vec.2466
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	veciprod.2383
	addi	hp, hp, -28
	lw	ra, hp, 24
	addrl	a0, l.7060
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq253
	lw	a0, hp, 16
	slli	a1, a0, 2
	lw	a2, hp, 12
	add	a1, a2, a1
	lw	a1, a1, 0
	addrl	a3, l.7223
	flw	fa1, a3, 0
	fdiv.s	fa0, fa0, fa1
	lw	t6, hp, 8
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	j	.Cont254
.Beq253:
	nop
	lw	a0, hp, 16
	addi	a1, a0, 1
	slli	a1, a1, 2
	lw	a2, hp, 12
	add	a1, a2, a1
	lw	a1, a1, 0
	addrl	a3, l.7221
	flw	fa1, a3, 0
	fdiv.s	fa0, fa0, fa1
	lw	t6, hp, 8
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
.Cont254:
	nop
	lw	a0, hp, 16
	addi	a3, a0, -2
	lw	a0, hp, 12
	lw	a1, hp, 20
	lw	a2, hp, 0
	lw	t6, hp, 4
	lw	t5, t6, 0
	jalr	zero, t5, 0
trace_diffuse_rays.2700:
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, a4
	mv	a0, a2
	mv	t6, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	li	a3, 118
	lw	a0, hp, 8
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 12
	lw	t5, t6, 0
	jalr	zero, t5, 0
trace_diffuse_ray_80percent.2704:
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a3
	sw	hp, 12, a4
	sw	hp, 16, a0
	beq	a0, zero, .Beq255
	lw	a5, a4, 0
	mv	a0, a5
	mv	t6, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	j	.Cont256
.Beq255:
	nop
.Cont256:
	nop
	lw	a0, hp, 16
	addi	a1, a0, -1
	beq	a1, zero, .Beq257
	lw	a1, hp, 12
	lw	a2, a1, 4
	lw	a3, hp, 4
	lw	a4, hp, 0
	lw	t6, hp, 8
	mv	a1, a3
	mv	a0, a2
	mv	a2, a4
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	j	.Cont258
.Beq257:
	nop
.Cont258:
	nop
	lw	a0, hp, 16
	addi	a1, a0, -2
	beq	a1, zero, .Beq259
	lw	a1, hp, 12
	lw	a2, a1, 8
	lw	a3, hp, 4
	lw	a4, hp, 0
	lw	t6, hp, 8
	mv	a1, a3
	mv	a0, a2
	mv	a2, a4
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	j	.Cont260
.Beq259:
	nop
.Cont260:
	nop
	lw	a0, hp, 16
	addi	a1, a0, -3
	beq	a1, zero, .Beq261
	lw	a1, hp, 12
	lw	a2, a1, 12
	lw	a3, hp, 4
	lw	a4, hp, 0
	lw	t6, hp, 8
	mv	a1, a3
	mv	a0, a2
	mv	a2, a4
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	j	.Cont262
.Beq261:
	nop
.Cont262:
	nop
	lw	a0, hp, 16
	addi	a0, a0, -4
	beq	a0, zero, .Beq263
	lw	a0, hp, 12
	lw	a0, a0, 16
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq263:
	nop
	ret
calc_diffuse_using_1point.2708:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	sw	hp, 0, a3
	sw	hp, 4, a2
	sw	hp, 8, a4
	sw	hp, 12, a1
	sw	hp, 16, a0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	p_received_ray_20percent.2457
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 16
	sw	hp, 20, a0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_nvectors.2464
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 16
	sw	hp, 24, a0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	p_intersection_points.2449
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 16
	sw	hp, 28, a0
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_energy.2455
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 12
	slli	a2, a1, 2
	lw	a3, hp, 20
	add	a2, a3, a2
	lw	a2, a2, 0
	lw	a3, hp, 8
	sw	hp, 32, a0
	mv	a1, a2
	mv	a0, a3
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	veccpy.2377
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 16
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	p_group_id.2459
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 12
	slli	a2, a1, 2
	lw	a3, hp, 24
	add	a2, a3, a2
	lw	a2, a2, 0
	slli	a3, a1, 2
	lw	a4, hp, 28
	add	a3, a4, a3
	lw	a3, a3, 0
	lw	t6, hp, 4
	mv	a1, a2
	mv	a2, a3
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 12
	slli	a0, a0, 2
	lw	a1, hp, 32
	add	a0, a1, a0
	lw	a1, a0, 0
	lw	a0, hp, 0
	lw	a2, hp, 8
	j	vecaccumv.2401
calc_diffuse_using_5points.2711:
	lw	a5, t6, 8
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a1, a1, a7
	lw	a1, a1, 0
	sw	hp, 0, a5
	sw	hp, 4, a6
	sw	hp, 8, a4
	sw	hp, 12, a3
	sw	hp, 16, a2
	sw	hp, 20, a0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_received_ray_20percent.2457
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	addi	a2, a1, -1
	slli	a2, a2, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 24, a0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	p_received_ray_20percent.2457
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 20
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 28, a0
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_received_ray_20percent.2457
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 20
	addi	a2, a1, 1
	slli	a2, a2, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 32, a0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	p_received_ray_20percent.2457
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 20
	slli	a2, a1, 2
	lw	a3, hp, 12
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 36, a0
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	p_received_ray_20percent.2457
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a1, hp, 8
	slli	a2, a1, 2
	lw	a3, hp, 24
	add	a2, a3, a2
	lw	a2, a2, 0
	lw	a3, hp, 4
	sw	hp, 40, a0
	mv	a1, a2
	mv	a0, a3
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	veccpy.2377
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 8
	slli	a1, a0, 2
	lw	a2, hp, 28
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	vecadd.2395
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 8
	slli	a1, a0, 2
	lw	a2, hp, 32
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	vecadd.2395
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 8
	slli	a1, a0, 2
	lw	a2, hp, 36
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	vecadd.2395
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 8
	slli	a1, a0, 2
	lw	a2, hp, 40
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	vecadd.2395
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 20
	slli	a0, a0, 2
	lw	a1, hp, 16
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	p_energy.2455
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 8
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, a0, 0
	lw	a0, hp, 0
	lw	a2, hp, 4
	j	vecaccumv.2401
do_without_neighbors.2717:
	lw	a2, t6, 4
	addi	a3, a1, -4
	bge	zero, a3, .Ble264
	ret
.Ble264:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a2
	sw	hp, 8, a0
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_surface_ids.2451
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	bge	a0, zero, .Bge265
	ret
.Bge265:
	nop
	lw	a0, hp, 8
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_calc_diffuse.2453
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	beq	a0, zero, .Beq266
	lw	a0, hp, 8
	lw	t6, hp, 4
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	j	.Cont267
.Beq266:
	nop
.Cont267:
	nop
	lw	a0, hp, 12
	addi	a1, a0, 1
	lw	a0, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
neighbors_exist.2720:
	lw	a2, t6, 4
	lw	a3, a2, 4
	addi	a4, a1, 1
	bge	a4, a3, .Ble268
	bge	zero, a1, .Ble269
	lw	a1, a2, 0
	addi	a2, a0, 1
	bge	a2, a1, .Ble270
	bge	zero, a0, .Ble271
	li	a0, 1
	ret
.Ble271:
	nop
	li	a0, 0
	ret
.Ble270:
	nop
	li	a0, 0
	ret
.Ble269:
	nop
	li	a0, 0
	ret
.Ble268:
	nop
	li	a0, 0
	ret
get_surface_id.2724:
	sw	hp, 0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	p_surface_ids.2451
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a0, a1, 0
	ret
neighbors_are_available.2727:
	slli	a5, a0, 2
	add	a5, a2, a5
	lw	a5, a5, 0
	sw	hp, 0, a2
	sw	hp, 4, a3
	sw	hp, 8, a4
	sw	hp, 12, a1
	sw	hp, 16, a0
	mv	a1, a4
	mv	a0, a5
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	get_surface_id.2724
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	lw	a2, hp, 16
	slli	a3, a2, 2
	lw	a4, hp, 12
	add	a3, a4, a3
	lw	a3, a3, 0
	lw	a4, hp, 8
	sw	hp, 20, a1
	mv	a1, a4
	mv	a0, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	get_surface_id.2724
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	lw	a2, hp, 20
	beq	a1, a2, .Beq272
	li	a0, 0
	ret
.Beq272:
	nop
	lw	a1, hp, 16
	slli	a3, a1, 2
	lw	a4, hp, 4
	add	a3, a4, a3
	lw	a3, a3, 0
	lw	a4, hp, 8
	mv	a1, a4
	mv	a0, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	get_surface_id.2724
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	lw	a2, hp, 20
	beq	a1, a2, .Beq273
	li	a0, 0
	ret
.Beq273:
	nop
	lw	a1, hp, 16
	addi	a3, a1, -1
	slli	a3, a3, 2
	lw	a4, hp, 0
	add	a3, a4, a3
	lw	a3, a3, 0
	lw	a5, hp, 8
	mv	a1, a5
	mv	a0, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	get_surface_id.2724
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	lw	a2, hp, 20
	beq	a1, a2, .Beq274
	li	a0, 0
	ret
.Beq274:
	nop
	lw	a1, hp, 16
	addi	a1, a1, 1
	slli	a1, a1, 2
	lw	a3, hp, 0
	add	a1, a3, a1
	lw	a1, a1, 0
	lw	a3, hp, 8
	mv	a0, a1
	mv	a1, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	get_surface_id.2724
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	lw	a2, hp, 20
	beq	a1, a2, .Beq275
	li	a0, 0
	ret
.Beq275:
	nop
	li	a0, 1
	ret
try_exploit_neighbors.2733:
	lw	a6, t6, 8
	lw	a7, t6, 4
	slli	s0, a0, 2
	add	s0, a3, s0
	lw	s0, s0, 0
	addi	s1, a5, -4
	bge	zero, s1, .Ble276
	ret
.Ble276:
	nop
	sw	hp, 0, a1
	sw	hp, 4, t6
	sw	hp, 8, a7
	sw	hp, 12, s0
	sw	hp, 16, a6
	sw	hp, 20, a5
	sw	hp, 24, a4
	sw	hp, 28, a3
	sw	hp, 32, a2
	sw	hp, 36, a0
	mv	a1, a5
	mv	a0, s0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	get_surface_id.2724
	addi	hp, hp, -44
	lw	ra, hp, 40
	bge	a0, zero, .Bge277
	ret
.Bge277:
	nop
	lw	a0, hp, 36
	lw	a1, hp, 32
	lw	a2, hp, 28
	lw	a3, hp, 24
	lw	a4, hp, 20
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	neighbors_are_available.2727
	addi	hp, hp, -44
	lw	ra, hp, 40
	beq	a0, zero, .Beq278
	lw	a0, hp, 12
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	p_calc_diffuse.2453
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a4, hp, 20
	slli	a1, a4, 2
	add	a0, a0, a1
	lw	a0, a0, 0
	beq	a0, zero, .Beq279
	lw	a0, hp, 36
	lw	a1, hp, 32
	lw	a2, hp, 28
	lw	a3, hp, 24
	lw	t6, hp, 8
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	j	.Cont280
.Beq279:
	nop
.Cont280:
	nop
	lw	a0, hp, 20
	addi	a5, a0, 1
	lw	a0, hp, 36
	lw	a1, hp, 0
	lw	a2, hp, 32
	lw	a3, hp, 28
	lw	a4, hp, 24
	lw	t6, hp, 4
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq278:
	nop
	lw	a0, hp, 36
	slli	a0, a0, 2
	lw	a1, hp, 28
	add	a0, a1, a0
	lw	a0, a0, 0
	lw	a1, hp, 20
	lw	t6, hp, 16
	lw	t5, t6, 0
	jalr	zero, t5, 0
write_ppm_header.2740:
	lw	a1, t6, 4
	li	a2, 80
	sw	hp, 0, a1
	sw	hp, 4, a0
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_char
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	addi	a0, a0, 48
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_char
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 10
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_char
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 0
	lw	a1, a0, 0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 32
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_char
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 0
	lw	a0, a0, 4
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 32
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_char
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 255
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_print_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 10
	j	min_caml_print_char
write_rgb_element_int.2742:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_int_of_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	addi	a1, a0, -255
	bge	zero, a1, .Ble281
	li	a0, 255
	j	.Cont282
.Ble281:
	nop
	bge	a0, zero, .Bge283
	li	a0, 0
	j	.Cont284
.Bge283:
	nop
.Cont284:
	nop
.Cont282:
	nop
	j	min_caml_print_int
write_rgb_element_char.2744:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_int_of_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	addi	a1, a0, -255
	bge	zero, a1, .Ble285
	li	a0, 255
	j	.Cont286
.Ble285:
	nop
	bge	a0, zero, .Bge287
	li	a0, 0
	j	.Cont288
.Bge287:
	nop
.Cont288:
	nop
.Cont286:
	nop
	j	min_caml_print_char
write_rgb.2746:
	lw	a1, t6, 4
	addi	a0, a0, -3
	beq	a0, zero, .Beq289
	flw	fa0, a1, 0
	sw	hp, 0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	write_rgb_element_char.2744
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	flw	fa0, a0, 4
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	write_rgb_element_char.2744
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	flw	fa0, a0, 8
	j	write_rgb_element_char.2744
.Beq289:
	nop
	flw	fa0, a1, 0
	sw	hp, 0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	write_rgb_element_int.2742
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 32
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	flw	fa0, a0, 4
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	write_rgb_element_int.2742
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 32
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	flw	fa0, a0, 8
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	write_rgb_element_int.2742
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 10
	j	min_caml_print_char
pretrace_diffuse_rays.2748:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	addi	a5, a1, -4
	bge	zero, a5, .Ble290
	ret
.Ble290:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a2
	sw	hp, 8, a3
	sw	hp, 12, a4
	sw	hp, 16, a1
	sw	hp, 20, a0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	get_surface_id.2724
	addi	hp, hp, -28
	lw	ra, hp, 24
	bge	a0, zero, .Bge291
	ret
.Bge291:
	nop
	lw	a0, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_calc_diffuse.2453
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 16
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	beq	a0, zero, .Beq292
	lw	a0, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_group_id.2459
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 12
	sw	hp, 24, a0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	vecbzero.2375
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 20
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	p_nvectors.2464
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 20
	sw	hp, 28, a0
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_intersection_points.2449
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 24
	slli	a1, a1, 2
	lw	a2, hp, 8
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a2, hp, 16
	slli	a3, a2, 2
	lw	a4, hp, 28
	add	a3, a4, a3
	lw	a3, a3, 0
	slli	a4, a2, 2
	add	a0, a0, a4
	lw	a0, a0, 0
	lw	t6, hp, 4
	mv	a2, a0
	mv	a0, a1
	mv	a1, a3
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 20
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_received_ray_20percent.2457
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 16
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	lw	a2, hp, 12
	mv	a1, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	veccpy.2377
	addi	hp, hp, -36
	lw	ra, hp, 32
	j	.Cont293
.Beq292:
	nop
.Cont293:
	nop
	lw	a0, hp, 16
	addi	a1, a0, 1
	lw	a0, hp, 20
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
pretrace_pixels.2751:
	lw	a3, t6, 36
	lw	a4, t6, 32
	lw	a5, t6, 28
	lw	a6, t6, 24
	lw	a7, t6, 20
	lw	s0, t6, 16
	lw	s1, t6, 12
	lw	s2, t6, 8
	lw	s3, t6, 4
	bge	a1, zero, .Bge294
	ret
.Bge294:
	nop
	flw	fa3, a7, 0
	lw	a7, s3, 0
	sub	a7, a1, a7
	sw	hp, 0, t6
	sw	hp, 4, s2
	sw	hp, 8, a2
	sw	hp, 12, a4
	sw	hp, 16, a0
	sw	hp, 20, a1
	sw	hp, 24, a3
	sw	hp, 28, a5
	sw	hp, 32, s0
	fsw	hp, 36, fa2
	fsw	hp, 40, fa1
	sw	hp, 44, s1
	fsw	hp, 48, fa0
	sw	hp, 52, a6
	fsw	hp, 56, fa3
	mv	a0, a7
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	min_caml_float_of_int
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 52
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	flw	fa2, hp, 48
	fadd.s	fa1, fa1, fa2
	lw	a1, hp, 44
	fsw	a1, 0, fa1
	flw	fa1, a0, 4
	fmul.s	fa1, fa0, fa1
	flw	fa3, hp, 40
	fadd.s	fa1, fa1, fa3
	fsw	a1, 4, fa1
	flw	fa1, a0, 8
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 36
	fadd.s	fa0, fa0, fa1
	fsw	a1, 8, fa0
	li	a0, 0
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecunit_sgn.2380
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 32
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecbzero.2375
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 28
	lw	a1, hp, 24
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	veccpy.2377
	addi	hp, hp, -64
	lw	ra, hp, 60
	li	a0, 0
	addrl	a1, l.7056
	flw	fa0, a1, 0
	lw	a1, hp, 20
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	addrl	a4, l.7060
	flw	fa1, a4, 0
	lw	a4, hp, 44
	lw	t6, hp, 12
	mv	a1, a4
	sw	hp, 60, ra
	addi	hp, hp, 64
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	p_rgb.2447
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a1, hp, 32
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	veccpy.2377
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a3, hp, 8
	mv	a0, a1
	mv	a1, a3
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	p_set_group_id.2461
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	li	a3, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a3
	sw	hp, 60, ra
	addi	hp, hp, 64
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 20
	addi	a0, a0, -1
	li	a1, 1
	lw	a2, hp, 8
	sw	hp, 60, a0
	mv	a0, a2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	add_mod5.2364
	addi	hp, hp, -68
	lw	ra, hp, 64
	mv	a2, a0
	lw	a0, hp, 16
	lw	a1, hp, 60
	flw	fa0, hp, 48
	flw	fa1, hp, 40
	flw	fa2, hp, 36
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
pretrace_line.2758:
	lw	a3, t6, 24
	lw	a4, t6, 20
	lw	a5, t6, 16
	lw	a6, t6, 12
	lw	a7, t6, 8
	lw	s0, t6, 4
	flw	fa0, a5, 0
	lw	a5, s0, 4
	sub	a1, a1, a5
	sw	hp, 0, a2
	sw	hp, 4, a0
	sw	hp, 8, a6
	sw	hp, 12, a7
	sw	hp, 16, a3
	sw	hp, 20, a4
	fsw	hp, 24, fa0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_float_of_int
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 20
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	lw	a1, hp, 16
	flw	fa2, a1, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a0, 4
	fmul.s	fa2, fa0, fa2
	flw	fa3, a1, 4
	fadd.s	fa2, fa2, fa3
	flw	fa3, a0, 8
	fmul.s	fa0, fa0, fa3
	flw	fa3, a1, 8
	fadd.s	fa0, fa0, fa3
	lw	a0, hp, 12
	lw	a0, a0, 0
	addi	a1, a0, -1
	lw	a0, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	fsgnj.s	ft11, fa2, fa2
	fsgnj.s	fa2, fa0, fa0
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, ft11, ft11
	lw	t5, t6, 0
	jalr	zero, t5, 0
scan_pixel.2762:
	lw	a6, t6, 24
	lw	a7, t6, 20
	lw	s0, t6, 16
	lw	s1, t6, 12
	lw	s2, t6, 8
	lw	s3, t6, 4
	lw	s2, s2, 0
	bge	a0, s2, .Ble295
	slli	s2, a0, 2
	add	s2, a3, s2
	lw	s2, s2, 0
	sw	hp, 0, t6
	sw	hp, 4, a5
	sw	hp, 8, a6
	sw	hp, 12, a2
	sw	hp, 16, a7
	sw	hp, 20, s3
	sw	hp, 24, a3
	sw	hp, 28, a4
	sw	hp, 32, a1
	sw	hp, 36, a0
	sw	hp, 40, s1
	sw	hp, 44, s0
	mv	a0, s2
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	p_rgb.2447
	addi	hp, hp, -52
	lw	ra, hp, 48
	mv	a1, a0
	lw	a0, hp, 44
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	veccpy.2377
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a0, hp, 36
	lw	a1, hp, 32
	lw	a2, hp, 28
	lw	t6, hp, 40
	sw	hp, 48, ra
	addi	hp, hp, 52
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -52
	lw	ra, hp, 48
	beq	a0, zero, .Beq296
	li	a5, 0
	lw	a0, hp, 36
	lw	a1, hp, 32
	lw	a2, hp, 12
	lw	a3, hp, 24
	lw	a4, hp, 28
	lw	t6, hp, 16
	sw	hp, 48, ra
	addi	hp, hp, 52
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -52
	lw	ra, hp, 48
	j	.Cont297
.Beq296:
	nop
	lw	a0, hp, 36
	slli	a1, a0, 2
	lw	a2, hp, 24
	add	a1, a2, a1
	lw	a1, a1, 0
	li	a3, 0
	lw	t6, hp, 20
	mv	a0, a1
	mv	a1, a3
	sw	hp, 48, ra
	addi	hp, hp, 52
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -52
	lw	ra, hp, 48
.Cont297:
	nop
	lw	a0, hp, 4
	lw	t6, hp, 8
	sw	hp, 48, ra
	addi	hp, hp, 52
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a0, hp, 36
	addi	a0, a0, 1
	lw	a1, hp, 32
	lw	a2, hp, 12
	lw	a3, hp, 24
	lw	a4, hp, 28
	lw	a5, hp, 4
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Ble295:
	nop
	ret
scan_line.2769:
	lw	a6, t6, 12
	lw	a7, t6, 8
	lw	s0, t6, 4
	lw	s1, s0, 4
	bge	a0, s1, .Ble298
	lw	s0, s0, 4
	addi	s0, s0, -1
	sw	hp, 0, t6
	sw	hp, 4, a4
	sw	hp, 8, a5
	sw	hp, 12, a3
	sw	hp, 16, a2
	sw	hp, 20, a1
	sw	hp, 24, a0
	sw	hp, 28, a6
	bge	a0, s0, .Ble299
	addi	s0, a0, 1
	mv	a2, a4
	mv	a1, s0
	mv	a0, a3
	mv	t6, a7
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	j	.Cont300
.Ble299:
	nop
.Cont300:
	nop
	li	a0, 0
	lw	a1, hp, 24
	lw	a2, hp, 20
	lw	a3, hp, 16
	lw	a4, hp, 12
	lw	a5, hp, 8
	lw	t6, hp, 28
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 24
	addi	a0, a0, 1
	li	a1, 2
	lw	a2, hp, 4
	sw	hp, 32, a0
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	add_mod5.2364
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a4, a0
	lw	a0, hp, 32
	lw	a1, hp, 16
	lw	a2, hp, 12
	lw	a3, hp, 20
	lw	a5, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Ble298:
	nop
	ret
create_float5x3array.2776:
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	mv	a0, a1
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array
	addi	hp, hp, -4
	lw	ra, hp, 0
	mv	a1, a0
	li	a2, 5
	mv	a0, a2
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_array
	addi	hp, hp, -4
	lw	ra, hp, 0
	mv	a1, a0
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 0, a1
	mv	a0, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	sw	a2, 4, a1
	li	a1, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	sw	a2, 8, a1
	li	a1, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	sw	a2, 12, a1
	li	a1, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	sw	a2, 16, a1
	mv	a0, a2
	ret
create_pixel.2778:
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	mv	a0, a1
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array
	addi	hp, hp, -4
	lw	ra, hp, 0
	mv	a1, a0
	sw	hp, 0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	create_float5x3array.2776
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	li	a2, 5
	li	a3, 0
	sw	hp, 4, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	li	a2, 5
	li	a3, 0
	sw	hp, 8, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_array
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	create_float5x3array.2776
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	sw	hp, 16, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	create_float5x3array.2776
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	li	a2, 1
	li	a3, 0
	sw	hp, 20, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_create_array
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	sw	hp, 24, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	create_float5x3array.2776
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	addi	sp, sp, -32
	mv	a2, sp
	sw	a2, 28, a1
	lw	a1, hp, 24
	sw	a2, 24, a1
	lw	a1, hp, 20
	sw	a2, 20, a1
	lw	a1, hp, 16
	sw	a2, 16, a1
	lw	a1, hp, 12
	sw	a2, 12, a1
	lw	a1, hp, 8
	sw	a2, 8, a1
	lw	a1, hp, 4
	sw	a2, 4, a1
	lw	a1, hp, 0
	sw	a2, 0, a1
	mv	a0, a2
	ret
init_line_elements.2780:
	bge	a1, zero, .Bge301
	ret
.Bge301:
	nop
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	create_pixel.2778
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	slli	a3, a2, 2
	lw	a4, hp, 0
	add	a3, a4, a3
	sw	a3, 0, a1
	addi	a1, a2, -1
	mv	a0, a4
	j	init_line_elements.2780
create_pixelline.2783:
	lw	a1, t6, 4
	lw	a2, a1, 0
	sw	hp, 0, a1
	sw	hp, 4, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	create_pixel.2778
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 4
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a2, hp, 0
	lw	a2, a2, 0
	addi	a2, a2, -2
	mv	a0, a1
	mv	a1, a2
	j	init_line_elements.2780
tan.2785:
	fsw	hp, 0, fa0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_sin
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 0
	fsw	hp, 4, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_cos
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 4
	fdiv.s	fa0, fa2, fa1
	ret
adjust_position.2787:
	fmul.s	fa2, fa0, fa0
	addrl	a0, l.7212
	flw	fa3, a0, 0
	fadd.s	fa2, fa2, fa3
	fsw	hp, 0, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_sqrt
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnj.s	fa1, fa0, fa0
	addrl	a0, l.7056
	flw	fa2, a0, 0
	fdiv.s	fa2, fa2, fa1
	fsw	hp, 4, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_atan
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 0
	fmul.s	fa1, fa1, fa2
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	tan.2785
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsgnj.s	fa1, fa0, fa0
	flw	fa2, hp, 4
	fmul.s	fa0, fa1, fa2
	ret
calc_dirvec.2790:
	lw	a3, t6, 4
	addi	a4, a0, -5
	bge	a4, zero, .Bge302
	fsw	hp, 0, fa2
	sw	hp, 4, a2
	sw	hp, 8, a1
	sw	hp, 12, t6
	fsw	hp, 16, fa3
	sw	hp, 20, a0
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	adjust_position.2787
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a0, hp, 20
	addi	a0, a0, 1
	flw	fa1, hp, 16
	fsw	hp, 24, fa0
	sw	hp, 28, a0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	adjust_position.2787
	addi	hp, hp, -36
	lw	ra, hp, 32
	fsgnj.s	fa1, fa0, fa0
	lw	a0, hp, 28
	lw	a1, hp, 8
	lw	a2, hp, 4
	flw	fa0, hp, 24
	flw	fa2, hp, 0
	flw	fa3, hp, 16
	lw	t6, hp, 12
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Bge302:
	nop
	fmul.s	fa2, fa0, fa0
	fmul.s	fa3, fa1, fa1
	fadd.s	fa2, fa2, fa3
	addrl	a0, l.7056
	flw	fa3, a0, 0
	fadd.s	fa2, fa2, fa3
	sw	hp, 4, a2
	sw	hp, 32, a3
	sw	hp, 8, a1
	fsw	hp, 36, fa1
	fsw	hp, 40, fa0
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_sqrt
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fdiv.s	fa1, fa1, fa0
	flw	fa2, hp, 36
	fdiv.s	fa2, fa2, fa0
	addrl	a0, l.7056
	flw	fa3, a0, 0
	fdiv.s	fa0, fa3, fa0
	lw	a0, hp, 8
	slli	a0, a0, 2
	lw	a1, hp, 32
	add	a0, a1, a0
	lw	a0, a0, 0
	lw	a1, hp, 4
	slli	a2, a1, 2
	add	a2, a0, a2
	lw	a2, a2, 0
	sw	hp, 44, a0
	fsw	hp, 48, fa0
	fsw	hp, 52, fa2
	fsw	hp, 56, fa1
	mv	a0, a2
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 56
	flw	fa1, hp, 52
	flw	fa2, hp, 48
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecset.2367
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 4
	addi	a1, a0, 40
	slli	a1, a1, 2
	lw	a2, hp, 44
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 52
	fsgnjn.s	fa2, fa0, fa0
	flw	fa1, hp, 56
	flw	fa3, hp, 48
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecset.2367
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 4
	addi	a1, a0, 80
	slli	a1, a1, 2
	lw	a2, hp, 44
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 56
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 52
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 48
	fsgnj.s	fa2, fa3, fa3
	fsgnj.s	fa0, fa4, fa4
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecset.2367
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 4
	addi	a1, a0, 1
	slli	a1, a1, 2
	lw	a2, hp, 44
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 56
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 52
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 48
	fsgnjn.s	fa5, fa4, fa4
	fsgnj.s	fa2, fa5, fa5
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecset.2367
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 4
	addi	a1, a0, 41
	slli	a1, a1, 2
	lw	a2, hp, 44
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 56
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 48
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 52
	fsgnj.s	fa2, fa4, fa4
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	vecset.2367
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a0, hp, 4
	addi	a0, a0, 81
	slli	a0, a0, 2
	lw	a1, hp, 44
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	d_vec.2466
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa0, hp, 48
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 56
	flw	fa2, hp, 52
	j	vecset.2367
calc_dirvecs.2798:
	lw	a3, t6, 4
	bge	a0, zero, .Bge303
	ret
.Bge303:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a0
	fsw	hp, 8, fa0
	sw	hp, 12, a2
	sw	hp, 16, a1
	sw	hp, 20, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_float_of_int
	addi	hp, hp, -28
	lw	ra, hp, 24
	addrl	a0, l.7241
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7245
	flw	fa1, a0, 0
	fsub.s	fa2, fa0, fa1
	li	a0, 0
	addrl	a1, l.7060
	flw	fa0, a1, 0
	addrl	a1, l.7060
	flw	fa1, a1, 0
	lw	a1, hp, 16
	lw	a2, hp, 12
	flw	fa3, hp, 8
	lw	t6, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a0, hp, 4
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_float_of_int
	addi	hp, hp, -28
	lw	ra, hp, 24
	addrl	a0, l.7241
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7212
	flw	fa1, a0, 0
	fadd.s	fa2, fa0, fa1
	li	a0, 0
	addrl	a1, l.7060
	flw	fa0, a1, 0
	addrl	a1, l.7060
	flw	fa1, a1, 0
	lw	a1, hp, 12
	addi	a2, a1, 2
	lw	a3, hp, 16
	flw	fa3, hp, 8
	lw	t6, hp, 20
	mv	a1, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a0, hp, 4
	addi	a0, a0, -1
	li	a1, 1
	lw	a2, hp, 16
	sw	hp, 24, a0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	add_mod5.2364
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	lw	a0, hp, 24
	lw	a2, hp, 12
	flw	fa0, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
calc_dirvec_rows.2803:
	lw	a3, t6, 4
	bge	a0, zero, .Bge304
	ret
.Bge304:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a0
	sw	hp, 8, a2
	sw	hp, 12, a1
	sw	hp, 16, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_float_of_int
	addi	hp, hp, -24
	lw	ra, hp, 20
	addrl	a0, l.7241
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7245
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	li	a0, 4
	lw	a1, hp, 12
	lw	a2, hp, 8
	lw	t6, hp, 16
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 4
	addi	a0, a0, -1
	li	a1, 2
	lw	a2, hp, 12
	sw	hp, 20, a0
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	add_mod5.2364
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	lw	a0, hp, 8
	addi	a2, a0, 4
	lw	a0, hp, 20
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
create_dirvec.2807:
	lw	a1, t6, 4
	li	a2, 3
	addrl	a3, l.7060
	flw	fa0, a3, 0
	sw	hp, 0, a1
	mv	a0, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	lw	a2, a2, 0
	sw	hp, 4, a1
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	addi	sp, sp, -8
	mv	a2, sp
	sw	a2, 4, a1
	lw	a1, hp, 4
	sw	a2, 0, a1
	mv	a0, a2
	ret
create_dirvec_elements.2809:
	lw	a2, t6, 4
	bge	a1, zero, .Bge305
	ret
.Bge305:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a0
	sw	hp, 8, a1
	mv	t6, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	slli	a2, a1, 2
	lw	a3, hp, 4
	add	a2, a3, a2
	sw	a2, 0, a0
	addi	a1, a1, -1
	lw	t6, hp, 0
	mv	a0, a3
	lw	t5, t6, 0
	jalr	zero, t5, 0
create_dirvecs.2812:
	lw	a1, t6, 12
	lw	a2, t6, 8
	lw	a3, t6, 4
	bge	a0, zero, .Bge306
	ret
.Bge306:
	nop
	li	a4, 120
	sw	hp, 0, t6
	sw	hp, 4, a2
	sw	hp, 8, a1
	sw	hp, 12, a0
	sw	hp, 16, a4
	mv	t6, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	lw	a0, hp, 16
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_create_array
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 12
	slli	a2, a1, 2
	lw	a3, hp, 8
	add	a2, a3, a2
	sw	a2, 0, a0
	slli	a0, a1, 2
	add	a0, a3, a0
	lw	a0, a0, 0
	li	a2, 118
	lw	t6, hp, 4
	mv	a1, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 12
	addi	a0, a0, -1
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
init_dirvec_constants.2814:
	lw	a2, t6, 4
	bge	a1, zero, .Bge307
	ret
.Bge307:
	nop
	slli	a3, a1, 2
	add	a3, a0, a3
	lw	a3, a3, 0
	sw	hp, 0, a0
	sw	hp, 4, t6
	sw	hp, 8, a1
	mv	a0, a3
	mv	t6, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	addi	a1, a0, -1
	lw	a0, hp, 0
	lw	t6, hp, 4
	lw	t5, t6, 0
	jalr	zero, t5, 0
init_vecset_constants.2817:
	lw	a1, t6, 8
	lw	a2, t6, 4
	bge	a0, zero, .Bge308
	ret
.Bge308:
	nop
	slli	a3, a0, 2
	add	a2, a2, a3
	lw	a2, a2, 0
	li	a3, 119
	sw	hp, 0, t6
	sw	hp, 4, a0
	mv	a0, a2
	mv	t6, a1
	mv	a1, a3
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
init_dirvecs.2819:
	lw	a0, t6, 12
	lw	a1, t6, 8
	lw	a2, t6, 4
	li	a3, 4
	sw	hp, 0, a0
	sw	hp, 4, a2
	mv	a0, a3
	mv	t6, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 9
	li	a1, 0
	li	a2, 0
	lw	t6, hp, 4
	sw	hp, 8, ra
	addi	hp, hp, 12
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 4
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
add_reflection.2821:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	t6, t6, 4
	sw	hp, 0, a3
	sw	hp, 4, a0
	sw	hp, 8, a1
	fsw	hp, 12, fa0
	sw	hp, 16, a2
	fsw	hp, 20, fa3
	fsw	hp, 24, fa2
	fsw	hp, 28, fa1
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	sw	hp, 32, a0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	d_vec.2466
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa0, hp, 28
	flw	fa1, hp, 24
	flw	fa2, hp, 20
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecset.2367
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 32
	lw	t6, hp, 16
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	addi	sp, sp, -12
	mv	a0, sp
	flw	fa0, hp, 12
	fsw	a0, 8, fa0
	lw	a1, hp, 32
	sw	a0, 4, a1
	lw	a1, hp, 8
	sw	a0, 0, a1
	lw	a1, hp, 4
	slli	a1, a1, 2
	lw	a2, hp, 0
	add	a1, a2, a1
	sw	a1, 0, a0
	ret
setup_rect_reflection.2828:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	slli	a0, a0, 2
	lw	a5, a2, 0
	addrl	a6, l.7056
	flw	fa0, a6, 0
	sw	hp, 0, a2
	sw	hp, 4, a5
	sw	hp, 8, a4
	sw	hp, 12, a0
	sw	hp, 16, a3
	fsw	hp, 20, fa0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_diffuse.2429
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 16
	flw	fa1, a0, 0
	fsgnjn.s	fa1, fa1, fa1
	flw	fa2, a0, 4
	fsgnjn.s	fa2, fa2, fa2
	flw	fa3, a0, 8
	fsgnjn.s	fa3, fa3, fa3
	lw	a1, hp, 12
	addi	a2, a1, 1
	flw	fa4, a0, 0
	lw	a3, hp, 4
	lw	t6, hp, 8
	fsw	hp, 24, fa2
	fsw	hp, 28, fa3
	fsw	hp, 32, fa1
	fsw	hp, 36, fa0
	mv	a1, a2
	mv	a0, a3
	fsgnj.s	fa1, fa4, fa4
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 4
	addi	a1, a0, 1
	lw	a2, hp, 12
	addi	a3, a2, 2
	lw	a4, hp, 16
	flw	fa2, a4, 4
	flw	fa0, hp, 36
	flw	fa1, hp, 32
	flw	fa3, hp, 28
	lw	t6, hp, 8
	mv	a0, a1
	mv	a1, a3
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 4
	addi	a1, a0, 2
	lw	a2, hp, 12
	addi	a2, a2, 3
	lw	a3, hp, 16
	flw	fa3, a3, 8
	flw	fa0, hp, 36
	flw	fa1, hp, 32
	flw	fa2, hp, 24
	lw	t6, hp, 8
	mv	a0, a1
	mv	a1, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 4
	addi	a0, a0, 3
	lw	a1, hp, 0
	sw	a1, 0, a0
	ret
setup_surface_reflection.2831:
	lw	a2, t6, 12
	lw	a3, t6, 8
	lw	a4, t6, 4
	slli	a0, a0, 2
	addi	a0, a0, 1
	lw	a5, a2, 0
	addrl	a6, l.7056
	flw	fa0, a6, 0
	sw	hp, 0, a2
	sw	hp, 4, a0
	sw	hp, 8, a5
	sw	hp, 12, a4
	sw	hp, 16, a3
	sw	hp, 20, a1
	fsw	hp, 24, fa0
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_diffuse.2429
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 20
	fsw	hp, 28, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_abc.2421
	addi	hp, hp, -36
	lw	ra, hp, 32
	mv	a1, a0
	lw	a0, hp, 16
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	veciprod.2383
	addi	hp, hp, -36
	lw	ra, hp, 32
	addrl	a0, l.7077
	flw	fa1, a0, 0
	lw	a0, hp, 20
	fsw	hp, 32, fa0
	fsw	hp, 36, fa1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_a.2415
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 36
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 32
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 16
	flw	fa2, a0, 0
	fsub.s	fa0, fa0, fa2
	addrl	a1, l.7077
	flw	fa2, a1, 0
	lw	a1, hp, 20
	fsw	hp, 40, fa0
	fsw	hp, 44, fa2
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_b.2417
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 32
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 16
	flw	fa2, a0, 4
	fsub.s	fa0, fa0, fa2
	addrl	a1, l.7077
	flw	fa2, a1, 0
	lw	a1, hp, 20
	fsw	hp, 48, fa0
	fsw	hp, 52, fa2
	mv	a0, a1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_c.2419
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 32
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 16
	flw	fa1, a0, 8
	fsub.s	fa3, fa0, fa1
	lw	a0, hp, 8
	lw	a1, hp, 4
	flw	fa0, hp, 28
	flw	fa1, hp, 40
	flw	fa2, hp, 48
	lw	t6, hp, 12
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 0
	sw	a1, 0, a0
	ret
setup_reflections.2834:
	lw	a1, t6, 12
	lw	a2, t6, 8
	lw	a3, t6, 4
	bge	a0, zero, .Bge309
	ret
.Bge309:
	nop
	slli	a4, a0, 2
	add	a3, a3, a4
	lw	a3, a3, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, a2
	sw	hp, 12, a3
	mv	a0, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_reflectiontype.2409
	addi	hp, hp, -20
	lw	ra, hp, 16
	addi	a0, a0, -2
	beq	a0, zero, .Beq310
	ret
.Beq310:
	nop
	addrl	a0, l.7056
	flw	fa0, a0, 0
	lw	a0, hp, 12
	fsw	hp, 16, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_diffuse.2429
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq311
	ret
.Beq311:
	nop
	lw	a0, hp, 12
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_form.2407
	addi	hp, hp, -24
	lw	ra, hp, 20
	addi	a1, a0, -1
	beq	a1, zero, .Beq312
	addi	a0, a0, -2
	beq	a0, zero, .Beq313
	ret
.Beq313:
	nop
	lw	a0, hp, 4
	lw	a1, hp, 12
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq312:
	nop
	lw	a0, hp, 4
	lw	a1, hp, 12
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
rt.2836:
	lw	a3, t6, 56
	lw	a4, t6, 52
	lw	a5, t6, 48
	lw	a6, t6, 44
	lw	a7, t6, 40
	lw	s0, t6, 36
	lw	s1, t6, 32
	lw	s2, t6, 28
	lw	s3, t6, 24
	lw	s4, t6, 20
	lw	s5, t6, 16
	lw	s6, t6, 12
	lw	s7, t6, 8
	lw	s8, t6, 4
	sw	s6, 0, a0
	sw	s6, 4, a1
	srli	s6, a0, 1
	sw	s7, 0, s6
	srli	a1, a1, 1
	sw	s7, 4, a1
	addrl	a1, l.7257
	flw	fa0, a1, 0
	sw	hp, 0, a7
	sw	hp, 4, s1
	sw	hp, 8, a4
	sw	hp, 12, s2
	sw	hp, 16, a5
	sw	hp, 20, s4
	sw	hp, 24, s3
	sw	hp, 28, s5
	sw	hp, 32, a2
	sw	hp, 36, a3
	sw	hp, 40, s0
	sw	hp, 44, s8
	sw	hp, 48, a6
	fsw	hp, 52, fa0
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	min_caml_float_of_int
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fdiv.s	fa0, fa1, fa0
	lw	a0, hp, 48
	fsw	a0, 0, fa0
	lw	t6, hp, 44
	sw	hp, 56, ra
	addi	hp, hp, 60
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -60
	lw	ra, hp, 56
	lw	t6, hp, 44
	sw	hp, 56, a0
	sw	hp, 60, ra
	addi	hp, hp, 64
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	t6, hp, 44
	sw	hp, 60, a0
	sw	hp, 64, ra
	addi	hp, hp, 68
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -68
	lw	ra, hp, 64
	lw	t6, hp, 40
	sw	hp, 64, a0
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a0, hp, 32
	lw	t6, hp, 36
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	t6, hp, 28
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a0, hp, 24
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	d_vec.2466
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a1, hp, 20
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	veccpy.2377
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a0, hp, 24
	lw	t6, hp, 16
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a0, hp, 12
	lw	a0, a0, 0
	addi	a0, a0, -1
	lw	t6, hp, 8
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	li	a1, 0
	li	a2, 0
	lw	a0, hp, 60
	lw	t6, hp, 4
	sw	hp, 68, ra
	addi	hp, hp, 72
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -72
	lw	ra, hp, 68
	li	a0, 0
	li	a4, 2
	lw	a1, hp, 56
	lw	a2, hp, 60
	lw	a3, hp, 64
	lw	a5, hp, 32
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
min_caml_start:
	li	a0, 1
	li	a1, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_array
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a1, 0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_float_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a1, 60
	li	a2, 0
	li	a3, 0
	li	a4, 0
	li	a5, 0
	li	a6, 0
	addi	sp, sp, -44
	mv	a7, sp
	sw	a7, 40, a0
	sw	a7, 36, a0
	sw	a7, 32, a0
	sw	a7, 28, a0
	sw	a7, 24, a6
	sw	a7, 20, a0
	sw	a7, 16, a0
	sw	a7, 12, a5
	sw	a7, 8, a4
	sw	a7, 4, a3
	sw	a7, 0, a2
	mv	a0, a7
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 4, a0
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 8, a0
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_float_array
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_create_float_array
	addi	hp, hp, -20
	lw	ra, hp, 16
	li	a1, 1
	addrl	a2, l.7160
	flw	fa0, a2, 0
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_create_float_array
	addi	hp, hp, -24
	lw	ra, hp, 20
	li	a1, 50
	li	a2, 1
	li	a3, -1
	sw	hp, 20, a0
	sw	hp, 24, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_create_array
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	lw	a0, hp, 24
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	min_caml_create_array
	addi	hp, hp, -32
	lw	ra, hp, 28
	li	a1, 1
	li	a2, 1
	lw	a3, a0, 0
	sw	hp, 28, a0
	sw	hp, 32, a1
	mv	a1, a3
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_create_array
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	lw	a0, hp, 32
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_create_array
	addi	hp, hp, -40
	lw	ra, hp, 36
	li	a1, 1
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 36, a0
	mv	a0, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_create_float_array
	addi	hp, hp, -44
	lw	ra, hp, 40
	li	a1, 1
	li	a2, 0
	sw	hp, 40, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_create_array
	addi	hp, hp, -48
	lw	ra, hp, 44
	li	a1, 1
	addrl	a2, l.7150
	flw	fa0, a2, 0
	sw	hp, 44, a0
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_create_float_array
	addi	hp, hp, -52
	lw	ra, hp, 48
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 48, a0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_create_float_array
	addi	hp, hp, -56
	lw	ra, hp, 52
	li	a1, 1
	li	a2, 0
	sw	hp, 52, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	min_caml_create_array
	addi	hp, hp, -60
	lw	ra, hp, 56
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 56, a0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	min_caml_create_float_array
	addi	hp, hp, -64
	lw	ra, hp, 60
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 60, a0
	mv	a0, a1
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	min_caml_create_float_array
	addi	hp, hp, -68
	lw	ra, hp, 64
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 64, a0
	mv	a0, a1
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	min_caml_create_float_array
	addi	hp, hp, -72
	lw	ra, hp, 68
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 68, a0
	mv	a0, a1
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	min_caml_create_float_array
	addi	hp, hp, -76
	lw	ra, hp, 72
	li	a1, 2
	li	a2, 0
	sw	hp, 72, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	min_caml_create_array
	addi	hp, hp, -80
	lw	ra, hp, 76
	li	a1, 2
	li	a2, 0
	sw	hp, 76, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	min_caml_create_array
	addi	hp, hp, -84
	lw	ra, hp, 80
	li	a1, 1
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 80, a0
	mv	a0, a1
	sw	hp, 84, ra
	addi	hp, hp, 88
	call	min_caml_create_float_array
	addi	hp, hp, -88
	lw	ra, hp, 84
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 84, a0
	mv	a0, a1
	sw	hp, 88, ra
	addi	hp, hp, 92
	call	min_caml_create_float_array
	addi	hp, hp, -92
	lw	ra, hp, 88
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 88, a0
	mv	a0, a1
	sw	hp, 92, ra
	addi	hp, hp, 96
	call	min_caml_create_float_array
	addi	hp, hp, -96
	lw	ra, hp, 92
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 92, a0
	mv	a0, a1
	sw	hp, 96, ra
	addi	hp, hp, 100
	call	min_caml_create_float_array
	addi	hp, hp, -100
	lw	ra, hp, 96
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 96, a0
	mv	a0, a1
	sw	hp, 100, ra
	addi	hp, hp, 104
	call	min_caml_create_float_array
	addi	hp, hp, -104
	lw	ra, hp, 100
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 100, a0
	mv	a0, a1
	sw	hp, 104, ra
	addi	hp, hp, 108
	call	min_caml_create_float_array
	addi	hp, hp, -108
	lw	ra, hp, 104
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 104, a0
	mv	a0, a1
	sw	hp, 108, ra
	addi	hp, hp, 112
	call	min_caml_create_float_array
	addi	hp, hp, -112
	lw	ra, hp, 108
	li	a1, 0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 108, a0
	mv	a0, a1
	sw	hp, 112, ra
	addi	hp, hp, 116
	call	min_caml_create_float_array
	addi	hp, hp, -116
	lw	ra, hp, 112
	mv	a1, a0
	li	a0, 0
	sw	hp, 112, a1
	sw	hp, 116, ra
	addi	hp, hp, 120
	call	min_caml_create_array
	addi	hp, hp, -120
	lw	ra, hp, 116
	li	a1, 0
	addi	sp, sp, -8
	mv	a2, sp
	sw	a2, 4, a0
	lw	a0, hp, 112
	sw	a2, 0, a0
	mv	a0, a2
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 116, ra
	addi	hp, hp, 120
	call	min_caml_create_array
	addi	hp, hp, -120
	lw	ra, hp, 116
	mv	a1, a0
	li	a0, 5
	sw	hp, 116, ra
	addi	hp, hp, 120
	call	min_caml_create_array
	addi	hp, hp, -120
	lw	ra, hp, 116
	li	a1, 0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 116, a0
	mv	a0, a1
	sw	hp, 120, ra
	addi	hp, hp, 124
	call	min_caml_create_float_array
	addi	hp, hp, -124
	lw	ra, hp, 120
	li	a1, 3
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 120, a0
	mv	a0, a1
	sw	hp, 124, ra
	addi	hp, hp, 128
	call	min_caml_create_float_array
	addi	hp, hp, -128
	lw	ra, hp, 124
	li	a1, 60
	lw	a2, hp, 120
	sw	hp, 124, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 128, ra
	addi	hp, hp, 132
	call	min_caml_create_array
	addi	hp, hp, -132
	lw	ra, hp, 128
	addi	sp, sp, -8
	mv	a1, sp
	sw	a1, 4, a0
	lw	a0, hp, 124
	sw	a1, 0, a0
	mv	a0, a1
	li	a1, 0
	addrl	a2, l.7060
	flw	fa0, a2, 0
	sw	hp, 128, a0
	mv	a0, a1
	sw	hp, 132, ra
	addi	hp, hp, 136
	call	min_caml_create_float_array
	addi	hp, hp, -136
	lw	ra, hp, 132
	mv	a1, a0
	li	a0, 0
	sw	hp, 132, a1
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	min_caml_create_array
	addi	hp, hp, -140
	lw	ra, hp, 136
	addi	sp, sp, -8
	mv	a1, sp
	sw	a1, 4, a0
	lw	a0, hp, 132
	sw	a1, 0, a0
	mv	a0, a1
	li	a1, 180
	li	a2, 0
	addrl	a3, l.7060
	flw	fa0, a3, 0
	addi	sp, sp, -12
	mv	a3, sp
	fsw	a3, 8, fa0
	sw	a3, 4, a0
	sw	a3, 0, a2
	mv	a0, a3
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 136, ra
	addi	hp, hp, 140
	call	min_caml_create_array
	addi	hp, hp, -140
	lw	ra, hp, 136
	li	a1, 1
	li	a2, 0
	sw	hp, 136, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 140, ra
	addi	hp, hp, 144
	call	min_caml_create_array
	addi	hp, hp, -144
	lw	ra, hp, 140
	addi	sp, sp, -24
	mv	a1, sp
	iaddrl	a2, read_screen_settings.2478
	sw	a1, 0, a2
	lw	a2, hp, 12
	sw	a1, 20, a2
	lw	a3, hp, 104
	sw	a1, 16, a3
	lw	a4, hp, 100
	sw	a1, 12, a4
	lw	a5, hp, 96
	sw	a1, 8, a5
	lw	a6, hp, 8
	sw	a1, 4, a6
	addi	sp, sp, -12
	mv	a6, sp
	iaddrl	a7, read_light.2480
	sw	a6, 0, a7
	lw	a7, hp, 16
	sw	a6, 8, a7
	lw	s0, hp, 20
	sw	a6, 4, s0
	addi	sp, sp, -8
	mv	s1, sp
	iaddrl	s2, read_nth_object.2485
	sw	s1, 0, s2
	lw	s2, hp, 4
	sw	s1, 4, s2
	addi	sp, sp, -12
	mv	s3, sp
	iaddrl	s4, read_object.2487
	sw	s3, 0, s4
	sw	s3, 8, s1
	lw	s1, hp, 0
	sw	s3, 4, s1
	addi	sp, sp, -8
	mv	s4, sp
	iaddrl	s5, read_all_object.2489
	sw	s4, 0, s5
	sw	s4, 4, s3
	addi	sp, sp, -8
	mv	s3, sp
	iaddrl	s5, read_and_network.2495
	sw	s3, 0, s5
	lw	s5, hp, 28
	sw	s3, 4, s5
	addi	sp, sp, -24
	mv	s6, sp
	iaddrl	s7, read_parameter.2497
	sw	s6, 0, s7
	sw	s6, 20, a1
	sw	s6, 16, a6
	sw	s6, 12, s3
	sw	s6, 8, s4
	lw	a1, hp, 36
	sw	s6, 4, a1
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s3, solver_rect_surface.2499
	sw	a6, 0, s3
	lw	s3, hp, 40
	sw	a6, 4, s3
	addi	sp, sp, -8
	mv	s4, sp
	iaddrl	s7, solver_rect.2508
	sw	s4, 0, s7
	sw	s4, 4, a6
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s7, solver_surface.2514
	sw	a6, 0, s7
	sw	a6, 4, s3
	addi	sp, sp, -8
	mv	s7, sp
	iaddrl	s8, solver_second.2533
	sw	s7, 0, s8
	sw	s7, 4, s3
	addi	sp, sp, -20
	mv	s8, sp
	iaddrl	s9, solver.2539
	sw	s8, 0, s9
	sw	s8, 16, a6
	sw	s8, 12, s7
	sw	s8, 8, s4
	sw	s8, 4, s2
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s4, solver_rect_fast.2543
	sw	a6, 0, s4
	sw	a6, 4, s3
	addi	sp, sp, -8
	mv	s4, sp
	iaddrl	s7, solver_surface_fast.2550
	sw	s4, 0, s7
	sw	s4, 4, s3
	addi	sp, sp, -8
	mv	s7, sp
	iaddrl	s9, solver_second_fast.2556
	sw	s7, 0, s9
	sw	s7, 4, s3
	addi	sp, sp, -20
	mv	s9, sp
	iaddrl	s10, solver_fast.2562
	sw	s9, 0, s10
	sw	s9, 16, s4
	sw	s9, 12, s7
	sw	s9, 8, a6
	sw	s9, 4, s2
	addi	sp, sp, -8
	mv	s4, sp
	iaddrl	s7, solver_surface_fast2.2566
	sw	s4, 0, s7
	sw	s4, 4, s3
	addi	sp, sp, -8
	mv	s7, sp
	iaddrl	s10, solver_second_fast2.2573
	sw	s7, 0, s10
	sw	s7, 4, s3
	addi	sp, sp, -20
	mv	s10, sp
	iaddrl	s11, solver_fast2.2580
	sw	s10, 0, s11
	sw	s10, 16, s4
	sw	s10, 12, s7
	sw	s10, 8, a6
	sw	s10, 4, s2
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s4, iter_setup_dirvec_constants.2592
	sw	a6, 0, s4
	sw	a6, 4, s2
	addi	sp, sp, -12
	mv	s4, sp
	iaddrl	s7, setup_dirvec_constants.2595
	sw	s4, 0, s7
	sw	s4, 8, s1
	sw	s4, 4, a6
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s7, setup_startp_constants.2597
	sw	a6, 0, s7
	sw	a6, 4, s2
	addi	sp, sp, -16
	mv	s7, sp
	iaddrl	s11, setup_startp.2600
	sw	s7, 0, s11
	lw	s11, hp, 92
	sw	s7, 12, s11
	sw	s7, 8, a6
	sw	s7, 4, s1
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	t0, check_all_inside.2622
	sw	a6, 0, t0
	sw	a6, 4, s2
	addi	sp, sp, -32
	mv	t0, sp
	iaddrl	t1, shadow_check_and_group.2628
	sw	t0, 0, t1
	sw	t0, 28, s9
	sw	t0, 24, s3
	sw	t0, 20, s2
	lw	t1, hp, 128
	sw	t0, 16, t1
	sw	t0, 12, a7
	lw	t2, hp, 52
	sw	t0, 8, t2
	sw	t0, 4, a6
	addi	sp, sp, -12
	mv	t3, sp
	iaddrl	t4, shadow_check_one_or_group.2631
	sw	t3, 0, t4
	sw	t3, 8, t0
	sw	t3, 4, s5
	addi	sp, sp, -24
	mv	t0, sp
	iaddrl	t4, shadow_check_one_or_matrix.2634
	sw	t0, 0, t4
	sw	t0, 20, s9
	sw	t0, 16, s3
	sw	t0, 12, t3
	sw	t0, 8, t1
	sw	t0, 4, t2
	addi	sp, sp, -40
	mv	s9, sp
	iaddrl	t3, solve_each_element.2637
	sw	s9, 0, t3
	lw	t3, hp, 48
	sw	s9, 36, t3
	lw	t4, hp, 88
	sw	s9, 32, t4
	sw	s9, 28, s3
	sw	s9, 24, s8
	sw	s9, 20, s2
	lw	t5, hp, 44
	sw	s9, 16, t5
	sw	s9, 12, t2
	lw	t6, hp, 56
	sw	s9, 8, t6
	sw	s9, 4, a6
	addi	sp, sp, -12
	mv	t1, sp
	sw	hp, 140, s6
	iaddrl	s6, solve_one_or_network.2641
	sw	t1, 0, s6
	sw	t1, 8, s9
	sw	t1, 4, s5
	addi	sp, sp, -24
	mv	s6, sp
	iaddrl	s9, trace_or_matrix.2645
	sw	s6, 0, s9
	sw	s6, 20, t3
	sw	s6, 16, t4
	sw	s6, 12, s3
	sw	s6, 8, s8
	sw	s6, 4, t1
	addi	sp, sp, -16
	mv	s8, sp
	iaddrl	s9, judge_intersection.2649
	sw	s8, 0, s9
	sw	s8, 12, s6
	sw	s8, 8, t3
	sw	s8, 4, a1
	addi	sp, sp, -40
	mv	s6, sp
	iaddrl	s9, solve_each_element_fast.2651
	sw	s6, 0, s9
	sw	s6, 36, t3
	sw	s6, 32, s11
	sw	s6, 28, s10
	sw	s6, 24, s3
	sw	s6, 20, s2
	sw	s6, 16, t5
	sw	s6, 12, t2
	sw	s6, 8, t6
	sw	s6, 4, a6
	addi	sp, sp, -12
	mv	a6, sp
	iaddrl	s9, solve_one_or_network_fast.2655
	sw	a6, 0, s9
	sw	a6, 8, s6
	sw	a6, 4, s5
	addi	sp, sp, -20
	mv	s5, sp
	iaddrl	s6, trace_or_matrix_fast.2659
	sw	s5, 0, s6
	sw	s5, 16, t3
	sw	s5, 12, s10
	sw	s5, 8, s3
	sw	s5, 4, a6
	addi	sp, sp, -16
	mv	a6, sp
	iaddrl	s3, judge_intersection_fast.2663
	sw	a6, 0, s3
	sw	a6, 12, s5
	sw	a6, 8, t3
	sw	a6, 4, a1
	addi	sp, sp, -12
	mv	s3, sp
	iaddrl	s5, get_nvector_rect.2665
	sw	s3, 0, s5
	lw	s5, hp, 60
	sw	s3, 8, s5
	sw	s3, 4, t5
	addi	sp, sp, -8
	mv	s6, sp
	iaddrl	s9, get_nvector_plane.2667
	sw	s6, 0, s9
	sw	s6, 4, s5
	addi	sp, sp, -12
	mv	s9, sp
	iaddrl	s10, get_nvector_second.2669
	sw	s9, 0, s10
	sw	s9, 8, s5
	sw	s9, 4, t2
	addi	sp, sp, -16
	mv	s10, sp
	iaddrl	s11, get_nvector.2671
	sw	s10, 0, s11
	sw	s10, 12, s9
	sw	s10, 8, s3
	sw	s10, 4, s6
	addi	sp, sp, -8
	mv	s3, sp
	iaddrl	s6, utexture.2674
	sw	s3, 0, s6
	lw	s6, hp, 64
	sw	s3, 4, s6
	addi	sp, sp, -12
	mv	s9, sp
	iaddrl	s11, add_light.2677
	sw	s9, 0, s11
	sw	s9, 8, s6
	lw	s11, hp, 72
	sw	s9, 4, s11
	addi	sp, sp, -36
	mv	t1, sp
	sw	hp, 144, s4
	iaddrl	s4, trace_reflections.2681
	sw	t1, 0, s4
	sw	t1, 32, t0
	lw	s4, hp, 136
	sw	t1, 28, s4
	sw	t1, 24, a1
	sw	t1, 20, s5
	sw	t1, 16, a6
	sw	t1, 12, t5
	sw	t1, 8, t6
	sw	t1, 4, s9
	addi	sp, sp, -84
	mv	s4, sp
	iaddrl	s1, trace_ray.2686
	sw	s4, 0, s1
	sw	s4, 80, s3
	sw	s4, 76, t1
	sw	s4, 72, t3
	sw	s4, 68, s6
	sw	s4, 64, t4
	sw	s4, 60, t0
	sw	s4, 56, s7
	sw	s4, 52, s11
	sw	s4, 48, a1
	sw	s4, 44, s2
	sw	s4, 40, s5
	sw	s4, 36, a0
	sw	s4, 32, a7
	sw	s4, 28, s8
	sw	s4, 24, t5
	sw	s4, 20, t2
	sw	s4, 16, t6
	sw	s4, 12, s10
	sw	s4, 8, s0
	sw	s4, 4, s9
	addi	sp, sp, -52
	mv	s0, sp
	iaddrl	s1, trace_diffuse_ray.2692
	sw	s0, 0, s1
	sw	s0, 48, s3
	sw	s0, 44, s6
	sw	s0, 40, t0
	sw	s0, 36, a1
	sw	s0, 32, s2
	sw	s0, 28, s5
	sw	s0, 24, a7
	sw	s0, 20, a6
	sw	s0, 16, t2
	sw	s0, 12, t6
	sw	s0, 8, s10
	lw	a1, hp, 68
	sw	s0, 4, a1
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s1, iter_trace_diffuse_rays.2695
	sw	a6, 0, s1
	sw	a6, 4, s0
	addi	sp, sp, -12
	mv	s0, sp
	iaddrl	s1, trace_diffuse_rays.2700
	sw	s0, 0, s1
	sw	s0, 8, s7
	sw	s0, 4, a6
	addi	sp, sp, -12
	mv	a6, sp
	iaddrl	s1, trace_diffuse_ray_80percent.2704
	sw	a6, 0, s1
	sw	a6, 8, s0
	lw	s1, hp, 116
	sw	a6, 4, s1
	addi	sp, sp, -16
	mv	s3, sp
	iaddrl	s5, calc_diffuse_using_1point.2708
	sw	s3, 0, s5
	sw	s3, 12, a6
	sw	s3, 8, s11
	sw	s3, 4, a1
	addi	sp, sp, -12
	mv	a6, sp
	iaddrl	s5, calc_diffuse_using_5points.2711
	sw	a6, 0, s5
	sw	a6, 8, s11
	sw	a6, 4, a1
	addi	sp, sp, -8
	mv	s5, sp
	iaddrl	s6, do_without_neighbors.2717
	sw	s5, 0, s6
	sw	s5, 4, s3
	addi	sp, sp, -8
	mv	s3, sp
	iaddrl	s6, neighbors_exist.2720
	sw	s3, 0, s6
	lw	s6, hp, 76
	sw	s3, 4, s6
	addi	sp, sp, -12
	mv	s7, sp
	iaddrl	s8, try_exploit_neighbors.2733
	sw	s7, 0, s8
	sw	s7, 8, s5
	sw	s7, 4, a6
	addi	sp, sp, -8
	mv	a6, sp
	iaddrl	s8, write_ppm_header.2740
	sw	a6, 0, s8
	sw	a6, 4, s6
	addi	sp, sp, -8
	mv	s8, sp
	iaddrl	s9, write_rgb.2746
	sw	s8, 0, s9
	sw	s8, 4, s11
	addi	sp, sp, -16
	mv	s9, sp
	iaddrl	s10, pretrace_diffuse_rays.2748
	sw	s9, 0, s10
	sw	s9, 12, s0
	sw	s9, 8, s1
	sw	s9, 4, a1
	addi	sp, sp, -40
	mv	a1, sp
	iaddrl	s0, pretrace_pixels.2751
	sw	a1, 0, s0
	sw	a1, 36, a2
	sw	a1, 32, s4
	sw	a1, 28, t4
	sw	a1, 24, a5
	lw	a2, hp, 84
	sw	a1, 20, a2
	sw	a1, 16, s11
	lw	a5, hp, 108
	sw	a1, 12, a5
	sw	a1, 8, s9
	lw	a5, hp, 80
	sw	a1, 4, a5
	addi	sp, sp, -28
	mv	s0, sp
	iaddrl	s4, pretrace_line.2758
	sw	s0, 0, s4
	sw	s0, 24, a3
	sw	s0, 20, a4
	sw	s0, 16, a2
	sw	s0, 12, a1
	sw	s0, 8, s6
	sw	s0, 4, a5
	addi	sp, sp, -28
	mv	a1, sp
	iaddrl	a3, scan_pixel.2762
	sw	a1, 0, a3
	sw	a1, 24, s8
	sw	a1, 20, s7
	sw	a1, 16, s11
	sw	a1, 12, s3
	sw	a1, 8, s6
	sw	a1, 4, s5
	addi	sp, sp, -16
	mv	a3, sp
	iaddrl	a4, scan_line.2769
	sw	a3, 0, a4
	sw	a3, 12, a1
	sw	a3, 8, s0
	sw	a3, 4, s6
	addi	sp, sp, -8
	mv	a1, sp
	iaddrl	a4, create_pixelline.2783
	sw	a1, 0, a4
	sw	a1, 4, s6
	addi	sp, sp, -8
	mv	a4, sp
	iaddrl	s3, calc_dirvec.2790
	sw	a4, 0, s3
	sw	a4, 4, s1
	addi	sp, sp, -8
	mv	s3, sp
	iaddrl	s4, calc_dirvecs.2798
	sw	s3, 0, s4
	sw	s3, 4, a4
	addi	sp, sp, -8
	mv	a4, sp
	iaddrl	s4, calc_dirvec_rows.2803
	sw	a4, 0, s4
	sw	a4, 4, s3
	addi	sp, sp, -8
	mv	s3, sp
	iaddrl	s4, create_dirvec.2807
	sw	s3, 0, s4
	lw	s4, hp, 0
	sw	s3, 4, s4
	addi	sp, sp, -8
	mv	s5, sp
	iaddrl	s7, create_dirvec_elements.2809
	sw	s5, 0, s7
	sw	s5, 4, s3
	addi	sp, sp, -16
	mv	s7, sp
	iaddrl	s8, create_dirvecs.2812
	sw	s7, 0, s8
	sw	s7, 12, s1
	sw	s7, 8, s5
	sw	s7, 4, s3
	addi	sp, sp, -8
	mv	s5, sp
	iaddrl	s8, init_dirvec_constants.2814
	sw	s5, 0, s8
	lw	s8, hp, 144
	sw	s5, 4, s8
	addi	sp, sp, -12
	mv	s9, sp
	iaddrl	s10, init_vecset_constants.2817
	sw	s9, 0, s10
	sw	s9, 8, s5
	sw	s9, 4, s1
	addi	sp, sp, -16
	mv	s1, sp
	iaddrl	s5, init_dirvecs.2819
	sw	s1, 0, s5
	sw	s1, 12, s9
	sw	s1, 8, s7
	sw	s1, 4, a4
	addi	sp, sp, -16
	mv	a4, sp
	iaddrl	s5, add_reflection.2821
	sw	a4, 0, s5
	sw	a4, 12, s8
	lw	s5, hp, 136
	sw	a4, 8, s5
	sw	a4, 4, s3
	addi	sp, sp, -16
	mv	s3, sp
	iaddrl	s5, setup_rect_reflection.2828
	sw	s3, 0, s5
	sw	s3, 12, a0
	sw	s3, 8, a7
	sw	s3, 4, a4
	addi	sp, sp, -16
	mv	s5, sp
	iaddrl	s7, setup_surface_reflection.2831
	sw	s5, 0, s7
	sw	s5, 12, a0
	sw	s5, 8, a7
	sw	s5, 4, a4
	addi	sp, sp, -16
	mv	a0, sp
	iaddrl	a4, setup_reflections.2834
	sw	a0, 0, a4
	sw	a0, 12, s5
	sw	a0, 8, s3
	sw	a0, 4, s2
	addi	sp, sp, -60
	mv	t6, sp
	iaddrl	a4, rt.2836
	sw	t6, 0, a4
	sw	t6, 56, a6
	sw	t6, 52, a0
	sw	t6, 48, s8
	sw	t6, 44, a2
	sw	t6, 40, a3
	lw	a0, hp, 140
	sw	t6, 36, a0
	sw	t6, 32, s0
	sw	t6, 28, s4
	lw	a0, hp, 128
	sw	t6, 24, a0
	sw	t6, 20, a7
	sw	t6, 16, s1
	sw	t6, 12, s6
	sw	t6, 8, a5
	sw	t6, 4, a1
	li	a0, 4
	li	a1, 4
	li	a2, 3
	sw	hp, 148, ra
	addi	hp, hp, 152
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -152
	lw	ra, hp, 148
	j __end__
min_caml_create_array:
    beq a0, zero, create_array_exit
    addi    sp, sp, -4
    sw  sp, 0, a1
    addi    a0, a0, -1
    j min_caml_create_array
create_array_exit:
    mv  a0, sp
    ret
min_caml_create_float_array:
    beq a0, zero, create_float_array_exit
    addi  sp, sp, -4
    fsw  sp, 0, fa0
    addi  a0, a0, -1
    j min_caml_create_float_array
create_float_array_exit:
    mv  a0, sp
    ret
min_caml_float_of_int:
    fcvt.s.w  fa0, a0
    ret
min_caml_sqrt:
    fsqrt.s  fa0, fa0
    ret
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
min_caml_cos:
    addrl    a0, __piinvc__
    flw fa1, a0, 0
    addrl a1, __pic__
    flw fa2, a1, 0
    addrl    a2, __piover2c__
    flw fa3, a2, 0
    fmul.s  fa1, fa0, fa1
    fround    a4, fa1
    fcvt.s.w    fa1, a4
    fmul.s  fa1, fa1, fa2
    fsub.s  fa1, fa0, fa1
    fle.s   a0, fa3, fa1
    beq a0, zero, min_caml_cos_label1
    fsub.s  fa1, fa1, fa2
    addi    a4, a4, -1
    j   min_caml_cos_label2
min_caml_cos_label1:
    fsgnjn.s    fa3, fa3, fa3
    fle.s   a0, fa1, fa3
    beq a0, zero, min_caml_cos_label2
    fadd.s  fa1, fa1, fa2
    addi    a4, a4, 1
min_caml_cos_label2:
    fmul.s  fa3, fa1, fa1
    addrl   a0, __a8__
    flw fa0, a0, 0
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a6__
    flw fa2, a0, 0
    fsub.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a4__
    flw fa2, a0, 0
    fadd.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
    addrl   a0, __a2__
    flw fa2, a0, 0
    fsub.s  fa0, fa0, fa2
    fmul.s  fa0, fa0, fa3
    li  a1, 1
    fcvt.s.w    fa1, a1
    fadd.s  fa0, fa0, fa1
    and a1, a1, a4
    beq a1, zero, min_caml_cos_label3
    fsgnjn.s    fa0, fa0, fa0
min_caml_cos_label3:
    ret
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
min_caml_print_char:
    out a0
    ret
min_caml_int_of_float:
    fcvt.w.s    a0, fa0
    ret
min_caml_print_int:
    out a0
    ret
min_caml_floor:
    floor   a0, fa0
    fcvt.s.w    fa0, a0
    ret
min_caml_fabs:
    fsgnjx.s    fa0, fa0, fa0
    ret
min_caml_read_int:
    in a0
    ret
min_caml_read_float:
    fin fa0
    ret
__end__:
	nop
l.7257:
	.data float, 128.000000
l.7245:
	.data float, 0.900000
l.7241:
	.data float, 0.200000
l.7223:
	.data float, 150.000000
l.7221:
	.data float, -150.000000
l.7216:
	.data float, 0.003906
l.7214:
	.data float, -2.000000
l.7212:
	.data float, 0.100000
l.7202:
	.data float, 0.000100
l.7200:
	.data float, 30.000000
l.7197:
	.data float, 15.000000
l.7195:
	.data float, 0.150000
l.7186:
	.data float, 0.300000
l.7183:
	.data float, 3.141593
l.7177:
	.data float, 0.250000
l.7169:
	.data float, 0.050000
l.7167:
	.data float, 20.000000
l.7165:
	.data float, 10.000000
l.7160:
	.data float, 255.000000
l.7150:
	.data float, 1000000000.000000
l.7147:
	.data float, 100000000.000000
l.7143:
	.data float, -0.100000
l.7141:
	.data float, -0.200000
l.7139:
	.data float, 0.010000
l.7097:
	.data float, 0.500000
l.7077:
	.data float, 2.000000
l.7074:
	.data float, -200.000000
l.7072:
	.data float, 200.000000
l.7069:
	.data float, 0.017453
l.7060:
	.data float, 0.000000
l.7058:
	.data float, -1.000000
l.7056:
	.data float, 1.000000
__atan1__:
	.data float, 1.000000
__atan2__:
	.data float, 2.000000
__atan_err__:
    .data float, 0.000010
__pic__:
    .data float, 3.1415927
__piinvc__:
    .data float, 0.31830987
__piover2c__:
    .data float, 1.5707964
__a0__:
	.data float, 1.000000
__a2__:
	.data float, 0.500000
__a4__:
	.data float, 0.041667
__a6__:
	.data float, 0.001389
__a8__:
	.data float, 0.000025
__pi__:
    .data float, 3.1415927
__piinv__:
    .data float, 0.31830987
__piover2__:
    .data float, 1.5707964
__a3__:
    .data float, 0.166667
__a5__:
    .data float, 0.008333
__a7__:
    .data float, 0.000198
__a9__:
    .data float, 0.000003
__floor0__:
    .data   float, 0.00000
__floor1__:
    .data   float, 1.00000
