__entry__:
	mv	t4, hp
	lim	hp, 1660
	add	hp, hp, t4
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
	addrl	a0, l.6821
	flw	fa1, a0, 0
	feq.s	a0, fa0, fa1
	beq	a0, zero, .Beq3
	addrl	a0, l.6821
	flw	fa0, a0, 0
	ret
.Beq3:
	nop
	addrl	a0, l.6821
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq4
	addrl	a0, l.6819
	flw	fa0, a0, 0
	ret
.Beq4:
	nop
	addrl	a0, l.6817
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
	li	a1, 8
	add	a0, a0, a1
	fsw	a0, 0, fa2
	ret
vecfill.2372:
	fsw	a0, 0, fa0
	fsw	a0, 4, fa0
	li	a1, 8
	add	a0, a0, a1
	fsw	a0, 0, fa0
	ret
vecbzero.2375:
	addrl	a1, l.6821
	flw	fa0, a1, 0
	j	vecfill.2372
veccpy.2377:
	flw	fa0, a1, 0
	fsw	a0, 0, fa0
	flw	fa0, a1, 4
	fsw	a0, 4, fa0
	flw	fa0, a1, 8
	li	a1, 8
	add	a0, a0, a1
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
	addrl	a0, l.6821
	flw	fa1, a0, 0
	feq.s	a0, fa0, fa1
	beq	a0, zero, .Beq7
	addrl	a0, l.6817
	flw	fa0, a0, 0
	j	.Cont8
.Beq7:
	nop
	lw	a0, hp, 4
	beq	a0, zero, .Beq9
	addrl	a0, l.6819
	flw	fa1, a0, 0
	fdiv.s	fa0, fa1, fa0
	j	.Cont10
.Beq9:
	nop
	addrl	a0, l.6817
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
	li	a1, 8
	add	a0, a0, a1
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
	li	a1, 8
	add	a0, a0, a1
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
	li	a1, 8
	add	a0, a0, a1
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
	li	a1, 8
	add	a0, a0, a1
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
	li	a1, 8
	add	a0, a0, a1
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
	li	a0, 0
	add	a0, a1, a0
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
	li	a0, 4
	add	a0, a1, a0
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
	li	a0, 8
	add	a0, a1, a0
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
	li	a0, 0
	add	a0, a1, a0
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
	li	a0, 4
	add	a0, a1, a0
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
	li	a0, 8
	add	a0, a1, a0
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
	li	a0, 0
	add	a0, a1, a0
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
	li	a0, 4
	add	a0, a1, a0
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
	li	a0, 0
	add	a0, a1, a0
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
	li	a0, 4
	add	a0, a1, a0
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
	li	a0, 8
	add	a0, a1, a0
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
	li	a0, 0
	add	a0, a1, a0
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
	li	a0, 4
	add	a0, a1, a0
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
	li	a0, 8
	add	a0, a1, a0
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
	li	a2, 0
	add	a1, a1, a2
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
	li	a0, 0
	add	a0, a2, a0
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
	addrl	a0, l.6830
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	ret
read_screen_settings.2478:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 0
	addi	a0, a0, 1404
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 4
	addi	a0, a0, 1404
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 8
	addi	a0, a0, 1404
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	rad.2476
	addi	hp, hp, -4
	lw	ra, hp, 0
	fsw	hp, 0, fa0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_cos
	addi	hp, hp, -8
	lw	ra, hp, 4
	flw	fa1, hp, 0
	fsw	hp, 4, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_sin
	addi	hp, hp, -12
	lw	ra, hp, 8
	fsw	hp, 8, fa0
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
	fsw	hp, 12, fa0
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
	flw	fa1, hp, 4
	fmul.s	fa2, fa1, fa0
	addrl	a0, l.6833
	flw	fa3, a0, 0
	fmul.s	fa2, fa2, fa3
	li	a0, 0
	addi	a0, a0, 1008
	add	a0, t4, a0
	fsw	a0, 0, fa2
	addrl	a0, l.6835
	flw	fa2, a0, 0
	flw	fa3, hp, 8
	fmul.s	fa2, fa3, fa2
	li	a0, 4
	addi	a0, a0, 1008
	add	a0, t4, a0
	fsw	a0, 0, fa2
	flw	fa2, hp, 16
	fmul.s	fa4, fa1, fa2
	addrl	a0, l.6833
	flw	fa5, a0, 0
	fmul.s	fa4, fa4, fa5
	li	a0, 8
	addi	a0, a0, 1008
	add	a0, t4, a0
	fsw	a0, 0, fa4
	li	a0, 0
	addi	a0, a0, 1032
	add	a0, t4, a0
	fsw	a0, 0, fa2
	addrl	a0, l.6821
	flw	fa4, a0, 0
	li	a0, 4
	addi	a0, a0, 1032
	add	a0, t4, a0
	fsw	a0, 0, fa4
	fsgnjn.s	fa4, fa0, fa0
	li	a0, 8
	addi	a0, a0, 1032
	add	a0, t4, a0
	fsw	a0, 0, fa4
	fsgnjn.s	fa4, fa3, fa3
	fmul.s	fa0, fa4, fa0
	li	a0, 0
	addi	a0, a0, 1020
	add	a0, t4, a0
	fsw	a0, 0, fa0
	fsgnjn.s	fa0, fa1, fa1
	li	a0, 4
	addi	a0, a0, 1020
	add	a0, t4, a0
	fsw	a0, 0, fa0
	fsgnjn.s	fa0, fa3, fa3
	fmul.s	fa0, fa0, fa2
	li	a0, 8
	addi	a0, a0, 1020
	add	a0, t4, a0
	fsw	a0, 0, fa0
	li	a0, 0
	addi	a0, a0, 1404
	add	a0, t4, a0
	flw	fa0, a0, 0
	li	a0, 0
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1392
	add	a0, t4, a0
	fsw	a0, 0, fa0
	li	a0, 4
	addi	a0, a0, 1404
	add	a0, t4, a0
	flw	fa0, a0, 0
	li	a0, 4
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	li	a0, 4
	addi	a0, a0, 1392
	add	a0, t4, a0
	fsw	a0, 0, fa0
	li	a0, 8
	addi	a0, a0, 1404
	add	a0, t4, a0
	flw	fa0, a0, 0
	li	a0, 8
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	li	a0, 8
	addi	a0, a0, 1392
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
read_light.2480:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_int
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_read_float
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	rad.2476
	addi	hp, hp, -4
	lw	ra, hp, 0
	fsw	hp, 0, fa0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_sin
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnjn.s	fa0, fa0, fa0
	li	a0, 4
	addi	a0, a0, 1380
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_read_float
	addi	hp, hp, -8
	lw	ra, hp, 4
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	rad.2476
	addi	hp, hp, -8
	lw	ra, hp, 4
	flw	fa1, hp, 0
	fsw	hp, 4, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_cos
	addi	hp, hp, -12
	lw	ra, hp, 8
	flw	fa1, hp, 4
	fsw	hp, 8, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_sin
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1380
	add	a0, t4, a0
	fsw	a0, 0, fa0
	flw	fa0, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_cos
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	li	a0, 8
	addi	a0, a0, 1380
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_read_float
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 0
	addi	a0, a0, 1376
	add	a0, t4, a0
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
	addrl	a0, l.6838
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
	addrl	a1, l.6838
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
	addrl	a1, l.6838
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
	li	a1, 8
	add	a0, a0, a1
	fsw	a0, 0, fa0
	ret
read_nth_object.2485:
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_read_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	addi	a2, a1, 1
	beq	a2, zero, .Beq11
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_read_int
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
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
	li	a2, 3
	addrl	a3, l.6821
	flw	fa0, a3, 0
	sw	hp, 16, a1
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_create_float_array
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	sw	hp, 20, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_read_float
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	fsw	a1, 0, fa0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_read_float
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	fsw	a1, 4, fa0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_read_float
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 20
	fsw	a1, 8, fa0
	li	a2, 3
	addrl	a3, l.6821
	flw	fa0, a3, 0
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
	addrl	a2, l.6821
	flw	fa0, a2, 0
	fsw	hp, 28, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_read_float
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
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
	addrl	a3, l.6821
	flw	fa0, a3, 0
	sw	hp, 32, a1
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_create_float_array
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	sw	hp, 36, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_read_float
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a1, hp, 36
	fsw	a1, 0, fa0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_read_float
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a1, hp, 36
	fsw	a1, 4, fa0
	li	a2, 3
	addrl	a3, l.6821
	flw	fa0, a3, 0
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
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_read_float
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 40
	fsw	a1, 8, fa0
	li	a2, 3
	addrl	a3, l.6821
	flw	fa0, a3, 0
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_create_float_array
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	lw	a2, hp, 16
	sw	hp, 44, a1
	beq	a2, zero, .Beq14
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	rad.2476
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 44
	fsw	a1, 0, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	rad.2476
	addi	hp, hp, -52
	lw	ra, hp, 48
	lw	a1, hp, 44
	fsw	a1, 4, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_read_float
	addi	hp, hp, -52
	lw	ra, hp, 48
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	rad.2476
	addi	hp, hp, -52
	lw	ra, hp, 48
	li	a1, 8
	lw	a2, hp, 44
	add	a1, a2, a1
	fsw	a1, 0, fa0
	j	.Cont15
.Beq14:
	nop
.Cont15:
	nop
	lw	a1, hp, 8
	addi	a2, a1, -2
	beq	a2, zero, .Beq16
	lw	a2, hp, 32
	j	.Cont17
.Beq16:
	nop
	li	a2, 1
.Cont17:
	nop
	li	a3, 4
	addrl	a4, l.6821
	flw	fa0, a4, 0
	sw	hp, 48, a2
	mv	a0, a3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	min_caml_create_float_array
	addi	hp, hp, -56
	lw	ra, hp, 52
	mv	a1, a0
	addi	sp, sp, -44
	mv	a2, sp
	sw	a2, 40, a1
	lw	a1, hp, 44
	sw	a2, 36, a1
	lw	a3, hp, 40
	sw	a2, 32, a3
	lw	a3, hp, 36
	sw	a2, 28, a3
	lw	a3, hp, 48
	sw	a2, 24, a3
	lw	a3, hp, 24
	sw	a2, 20, a3
	lw	a3, hp, 20
	sw	a2, 16, a3
	lw	a4, hp, 16
	sw	a2, 12, a4
	lw	a5, hp, 12
	sw	a2, 8, a5
	lw	a5, hp, 8
	sw	a2, 4, a5
	lw	a6, hp, 4
	sw	a2, 0, a6
	lw	a6, hp, 0
	slli	a6, a6, 2
	addi	a6, a6, 1416
	add	a6, t4, a6
	sw	a6, 0, a2
	addi	a2, a5, -3
	beq	a2, zero, .Beq18
	addi	a2, a5, -2
	beq	a2, zero, .Beq20
	j	.Cont21
.Beq20:
	nop
	lw	a2, hp, 32
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
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecunit_sgn.2380
	addi	hp, hp, -56
	lw	ra, hp, 52
.Cont21:
	nop
	j	.Cont19
.Beq18:
	nop
	flw	fa0, a3, 0
	addrl	a2, l.6821
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq24
	addrl	a2, l.6821
	flw	fa0, a2, 0
	j	.Cont25
.Beq24:
	nop
	fsw	hp, 52, fa0
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	sgn.2359
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fmul.s	fa1, fa1, fa1
	fdiv.s	fa0, fa0, fa1
.Cont25:
	nop
	lw	a1, hp, 20
	fsw	a1, 0, fa0
	flw	fa0, a1, 4
	addrl	a2, l.6821
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq26
	addrl	a2, l.6821
	flw	fa0, a2, 0
	j	.Cont27
.Beq26:
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
.Cont27:
	nop
	lw	a1, hp, 20
	fsw	a1, 4, fa0
	flw	fa0, a1, 8
	addrl	a2, l.6821
	flw	fa1, a2, 0
	feq.s	a2, fa0, fa1
	beq	a2, zero, .Beq28
	addrl	a2, l.6821
	flw	fa0, a2, 0
	j	.Cont29
.Beq28:
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
.Cont29:
	nop
	li	a1, 8
	lw	a2, hp, 20
	add	a1, a2, a1
	fsw	a1, 0, fa0
.Cont19:
	nop
	lw	a1, hp, 16
	beq	a1, zero, .Beq30
	lw	a1, hp, 20
	lw	a2, hp, 44
	mv	a0, a1
	mv	a1, a2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	rotate_quadratic_matrix.2482
	addi	hp, hp, -68
	lw	ra, hp, 64
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
	addi	a1, a0, -60
	bge	a1, zero, .Bge32
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	read_nth_object.2485
	addi	hp, hp, -8
	lw	ra, hp, 4
	beq	a0, zero, .Beq33
	lw	a0, hp, 0
	addi	a0, a0, 1
	j	read_object.2487
.Beq33:
	nop
	li	a0, 0
	addi	a0, a0, 1656
	add	a0, t4, a0
	lw	a1, hp, 0
	sw	a0, 0, a1
	ret
.Bge32:
	nop
	ret
read_all_object.2489:
	li	a0, 0
	j	read_object.2487
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
	li	a1, 0
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	read_net_item.2491
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a1, a0, 0
	addi	a1, a1, 1
	beq	a1, zero, .Beq36
	lw	a1, hp, 0
	slli	a2, a1, 2
	addi	a2, a2, 1172
	add	a2, t4, a2
	sw	a2, 0, a0
	addi	a0, a1, 1
	j	read_and_network.2495
.Beq36:
	nop
	ret
read_parameter.2497:
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	read_screen_settings.2478
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	read_light.2480
	addi	hp, hp, -4
	lw	ra, hp, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	read_all_object.2489
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	read_and_network.2495
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	read_or_network.2493
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a1, 0
	addi	a1, a1, 1164
	add	a1, t4, a1
	sw	a1, 0, a0
	ret
solver_rect_surface.2499:
	slli	a5, a2, 2
	add	a5, a1, a5
	flw	fa3, a5, 0
	addrl	a5, l.6821
	flw	fa4, a5, 0
	feq.s	a5, fa3, fa4
	beq	a5, zero, .Beq37
	li	a0, 0
	ret
.Beq37:
	nop
	fsw	hp, 0, fa2
	sw	hp, 4, a4
	fsw	hp, 8, fa1
	sw	hp, 12, a3
	fsw	hp, 16, fa0
	sw	hp, 20, a1
	sw	hp, 24, a2
	sw	hp, 28, a0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_abc.2421
	addi	hp, hp, -36
	lw	ra, hp, 32
	mv	a1, a0
	lw	a2, hp, 28
	sw	hp, 32, a1
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_isinvert.2411
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	addrl	a2, l.6821
	flw	fa0, a2, 0
	lw	a2, hp, 24
	slli	a3, a2, 2
	lw	a4, hp, 20
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
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	xor.2356
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	lw	a2, hp, 24
	slli	a3, a2, 2
	lw	a4, hp, 32
	add	a3, a4, a3
	flw	fa0, a3, 0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	fneg_cond.2361
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 16
	fsub.s	fa0, fa0, fa1
	lw	a1, hp, 24
	slli	a1, a1, 2
	lw	a2, hp, 20
	add	a1, a2, a1
	flw	fa1, a1, 0
	fdiv.s	fa0, fa0, fa1
	lw	a1, hp, 12
	slli	a3, a1, 2
	lw	a4, hp, 32
	add	a3, a4, a3
	flw	fa1, a3, 0
	slli	a1, a1, 2
	add	a1, a2, a1
	flw	fa2, a1, 0
	fmul.s	fa2, fa0, fa2
	flw	fa3, hp, 8
	fadd.s	fa2, fa2, fa3
	fsw	hp, 36, fa0
	fsw	hp, 40, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_fabs
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq40
	li	a0, 0
	ret
.Beq40:
	nop
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 32
	add	a2, a3, a2
	flw	fa0, a2, 0
	slli	a1, a1, 2
	lw	a2, hp, 20
	add	a1, a2, a1
	flw	fa1, a1, 0
	flw	fa2, hp, 36
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 0
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
	beq	a1, zero, .Beq41
	li	a0, 0
	ret
.Beq41:
	nop
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, hp, 36
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver_rect.2508:
	li	a2, 0
	li	a3, 1
	li	a4, 2
	fsw	hp, 0, fa0
	fsw	hp, 4, fa2
	fsw	hp, 8, fa1
	sw	hp, 12, a1
	sw	hp, 16, a0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	solver_rect_surface.2499
	addi	hp, hp, -24
	lw	ra, hp, 20
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
	mv	a0, a1
	mv	a1, a5
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	solver_rect_surface.2499
	addi	hp, hp, -24
	lw	ra, hp, 20
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
	mv	a0, a1
	mv	a1, a5
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	solver_rect_surface.2499
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	beq	a1, zero, .Beq44
	li	a0, 3
	ret
.Beq44:
	nop
	li	a0, 0
	ret
solver_surface.2514:
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	fsw	hp, 8, fa0
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_abc.2421
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	lw	a2, hp, 12
	sw	hp, 16, a1
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	veciprod.2383
	addi	hp, hp, -24
	lw	ra, hp, 20
	addrl	a1, l.6821
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq45
	li	a0, 0
	ret
.Beq45:
	nop
	lw	a1, hp, 16
	flw	fa1, hp, 8
	flw	fa2, hp, 4
	flw	fa3, hp, 0
	fsw	hp, 20, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	veciprod2.2386
	addi	hp, hp, -28
	lw	ra, hp, 24
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 20
	fdiv.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
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
	addrl	a0, l.6858
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
	flw	fa3, a1, 0
	flw	fa4, a1, 4
	flw	fa5, a1, 8
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	fsw	hp, 8, fa0
	sw	hp, 12, a0
	sw	hp, 16, a1
	fsgnj.s	fa2, fa5, fa5
	fsgnj.s	fa1, fa4, fa4
	fsgnj.s	fa0, fa3, fa3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	quadratic.2520
	addi	hp, hp, -24
	lw	ra, hp, 20
	addrl	a1, l.6821
	flw	fa1, a1, 0
	feq.s	a1, fa0, fa1
	beq	a1, zero, .Beq48
	li	a0, 0
	ret
.Beq48:
	nop
	lw	a1, hp, 16
	flw	fa1, a1, 0
	flw	fa2, a1, 4
	flw	fa3, a1, 8
	lw	a1, hp, 12
	flw	fa4, hp, 8
	flw	fa5, hp, 4
	flw	fa6, hp, 0
	fsw	hp, 20, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	fsgnj.s	fa3, fa4, fa4
	fsgnj.s	fa4, fa5, fa5
	fsgnj.s	fa5, fa6, fa6
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	bilinear.2525
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 12
	flw	fa1, hp, 8
	flw	fa2, hp, 4
	flw	fa3, hp, 0
	fsw	hp, 24, fa0
	mv	a0, a1
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	quadratic.2520
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 12
	fsw	hp, 28, fa0
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_form.2407
	addi	hp, hp, -36
	lw	ra, hp, 32
	mv	a1, a0
	addi	a1, a1, -3
	beq	a1, zero, .Beq49
	flw	fa0, hp, 28
	j	.Cont50
.Beq49:
	nop
	addrl	a1, l.6817
	flw	fa0, a1, 0
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
.Cont50:
	nop
	flw	fa1, hp, 24
	fmul.s	fa2, fa1, fa1
	flw	fa3, hp, 20
	fmul.s	fa0, fa3, fa0
	fsub.s	fa0, fa2, fa0
	addrl	a1, l.6821
	flw	fa2, a1, 0
	fle.s	a1, fa0, fa2
	beq	a1, zero, .Beq51
	li	a0, 0
	ret
.Beq51:
	nop
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_sqrt
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 12
	fsw	hp, 32, fa0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_isinvert.2411
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	beq	a1, zero, .Beq52
	flw	fa0, hp, 32
	j	.Cont53
.Beq52:
	nop
	flw	fa0, hp, 32
	fsgnjn.s	fa0, fa0, fa0
.Cont53:
	nop
	flw	fa1, hp, 24
	fsub.s	fa0, fa0, fa1
	flw	fa1, hp, 20
	fdiv.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver.2539:
	slli	a3, a0, 2
	addi	a3, a3, 1416
	add	a3, t4, a3
	lw	a3, a3, 0
	flw	fa0, a2, 0
	sw	hp, 0, a1
	sw	hp, 4, a3
	sw	hp, 8, a2
	fsw	hp, 12, fa0
	mv	a0, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_x.2423
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	flw	fa1, a1, 4
	lw	a2, hp, 4
	fsw	hp, 16, fa0
	fsw	hp, 20, fa1
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_y.2425
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 8
	flw	fa1, a1, 8
	lw	a1, hp, 4
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
	lw	a1, hp, 4
	fsw	hp, 32, fa0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_form.2407
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq54
	addi	a1, a1, -2
	beq	a1, zero, .Beq55
	lw	a1, hp, 4
	lw	a2, hp, 0
	flw	fa0, hp, 16
	flw	fa1, hp, 24
	flw	fa2, hp, 32
	mv	a0, a1
	mv	a1, a2
	j	solver_second.2533
.Beq55:
	nop
	lw	a1, hp, 4
	lw	a2, hp, 0
	flw	fa0, hp, 16
	flw	fa1, hp, 24
	flw	fa2, hp, 32
	mv	a0, a1
	mv	a1, a2
	j	solver_surface.2514
.Beq54:
	nop
	lw	a1, hp, 4
	lw	a2, hp, 0
	flw	fa0, hp, 16
	flw	fa1, hp, 24
	flw	fa2, hp, 32
	mv	a0, a1
	mv	a1, a2
	j	solver_rect.2508
solver_rect_fast.2543:
	flw	fa3, a2, 0
	fsub.s	fa3, fa3, fa0
	flw	fa4, a2, 4
	fmul.s	fa3, fa3, fa4
	fsw	hp, 0, fa0
	sw	hp, 4, a2
	fsw	hp, 8, fa2
	sw	hp, 12, a0
	fsw	hp, 16, fa1
	fsw	hp, 20, fa3
	sw	hp, 24, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_b.2417
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 24
	flw	fa1, a1, 4
	flw	fa2, hp, 20
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 16
	fadd.s	fa1, fa1, fa3
	fsw	hp, 28, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_fabs
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq56
	li	a1, 0
	j	.Cont57
.Beq56:
	nop
	lw	a1, hp, 12
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_c.2419
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 24
	flw	fa1, a1, 8
	flw	fa2, hp, 20
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 8
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
	beq	a1, zero, .Beq58
	li	a1, 0
	j	.Cont59
.Beq58:
	nop
	lw	a1, hp, 4
	flw	fa0, a1, 4
	addrl	a2, l.6821
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
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, hp, 20
	fsw	a1, 0, fa0
	li	a0, 1
	ret
.Beq62:
	nop
	lw	a1, hp, 4
	flw	fa0, a1, 8
	flw	fa1, hp, 16
	fsub.s	fa0, fa0, fa1
	flw	fa2, a1, 12
	fmul.s	fa0, fa0, fa2
	lw	a2, hp, 12
	fsw	hp, 36, fa0
	mv	a0, a2
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_a.2415
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a1, hp, 24
	flw	fa1, a1, 0
	flw	fa2, hp, 36
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 0
	fadd.s	fa1, fa1, fa3
	fsw	hp, 40, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_fabs
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq63
	li	a1, 0
	j	.Cont64
.Beq63:
	nop
	lw	a1, hp, 12
	mv	a0, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_c.2419
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 24
	flw	fa1, a1, 8
	flw	fa2, hp, 36
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 8
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
	beq	a1, zero, .Beq65
	li	a1, 0
	j	.Cont66
.Beq65:
	nop
	lw	a1, hp, 4
	flw	fa0, a1, 12
	addrl	a2, l.6821
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
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, hp, 36
	fsw	a1, 0, fa0
	li	a0, 2
	ret
.Beq69:
	nop
	lw	a1, hp, 4
	flw	fa0, a1, 16
	flw	fa1, hp, 8
	fsub.s	fa0, fa0, fa1
	flw	fa1, a1, 20
	fmul.s	fa0, fa0, fa1
	lw	a2, hp, 12
	fsw	hp, 48, fa0
	mv	a0, a2
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_a.2415
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 24
	flw	fa1, a1, 0
	flw	fa2, hp, 48
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 0
	fadd.s	fa1, fa1, fa3
	fsw	hp, 52, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	min_caml_fabs
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq70
	li	a1, 0
	j	.Cont71
.Beq70:
	nop
	lw	a1, hp, 12
	mv	a0, a1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_b.2417
	addi	hp, hp, -60
	lw	ra, hp, 56
	lw	a1, hp, 24
	flw	fa1, a1, 4
	flw	fa2, hp, 48
	fmul.s	fa1, fa2, fa1
	flw	fa3, hp, 16
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
	beq	a1, zero, .Beq72
	li	a1, 0
	j	.Cont73
.Beq72:
	nop
	lw	a1, hp, 4
	flw	fa0, a1, 20
	addrl	a1, l.6821
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
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, hp, 48
	fsw	a1, 0, fa0
	li	a0, 3
	ret
.Beq76:
	nop
	li	a0, 0
	ret
solver_surface_fast.2550:
	addrl	a2, l.6821
	flw	fa3, a2, 0
	flw	fa4, a1, 0
	fle.s	a2, fa3, fa4
	beq	a2, zero, .Beq77
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
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver_second_fast.2556:
	flw	fa3, a1, 0
	addrl	a2, l.6821
	flw	fa4, a2, 0
	feq.s	a2, fa3, fa4
	beq	a2, zero, .Beq78
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
	sw	hp, 0, a1
	fsw	hp, 4, fa3
	fsw	hp, 8, fa4
	sw	hp, 12, a0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	quadratic.2520
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	fsw	hp, 16, fa0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_form.2407
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	addi	a1, a1, -3
	beq	a1, zero, .Beq79
	flw	fa0, hp, 16
	j	.Cont80
.Beq79:
	nop
	addrl	a1, l.6817
	flw	fa0, a1, 0
	flw	fa1, hp, 16
	fsub.s	fa0, fa1, fa0
.Cont80:
	nop
	flw	fa1, hp, 8
	fmul.s	fa2, fa1, fa1
	flw	fa3, hp, 4
	fmul.s	fa0, fa3, fa0
	fsub.s	fa0, fa2, fa0
	addrl	a1, l.6821
	flw	fa2, a1, 0
	fle.s	a1, fa0, fa2
	beq	a1, zero, .Beq81
	li	a0, 0
	ret
.Beq81:
	nop
	lw	a1, hp, 12
	fsw	hp, 20, fa0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_isinvert.2411
	addi	hp, hp, -28
	lw	ra, hp, 24
	mv	a1, a0
	beq	a1, zero, .Beq82
	flw	fa0, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_sqrt
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 8
	fadd.s	fa0, fa1, fa0
	lw	a1, hp, 0
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
	j	.Cont83
.Beq82:
	nop
	flw	fa0, hp, 20
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	min_caml_sqrt
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 8
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 0
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
.Cont83:
	nop
	li	a0, 1
	ret
solver_fast.2562:
	slli	a3, a0, 2
	addi	a3, a3, 1416
	add	a3, t4, a3
	lw	a3, a3, 0
	flw	fa0, a2, 0
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, a3
	sw	hp, 12, a2
	fsw	hp, 16, fa0
	mv	a0, a3
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_x.2423
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 12
	flw	fa1, a1, 4
	lw	a2, hp, 8
	fsw	hp, 20, fa0
	fsw	hp, 24, fa1
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_y.2425
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 12
	flw	fa1, a1, 8
	lw	a1, hp, 8
	fsw	hp, 28, fa0
	fsw	hp, 32, fa1
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_z.2427
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 4
	fsw	hp, 36, fa0
	mv	a0, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	d_const.2468
	addi	hp, hp, -44
	lw	ra, hp, 40
	mv	a1, a0
	lw	a2, hp, 0
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, a1, 0
	lw	a2, hp, 8
	sw	hp, 40, a1
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_form.2407
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq84
	addi	a1, a1, -2
	beq	a1, zero, .Beq85
	lw	a1, hp, 8
	lw	a2, hp, 40
	flw	fa0, hp, 20
	flw	fa1, hp, 28
	flw	fa2, hp, 36
	mv	a0, a1
	mv	a1, a2
	j	solver_second_fast.2556
.Beq85:
	nop
	lw	a1, hp, 8
	lw	a2, hp, 40
	flw	fa0, hp, 20
	flw	fa1, hp, 28
	flw	fa2, hp, 36
	mv	a0, a1
	mv	a1, a2
	j	solver_surface_fast.2550
.Beq84:
	nop
	lw	a1, hp, 4
	mv	a0, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	d_vec.2466
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a1, a0
	lw	a2, hp, 8
	lw	a3, hp, 40
	flw	fa0, hp, 20
	flw	fa1, hp, 28
	flw	fa2, hp, 36
	mv	a0, a2
	mv	a2, a3
	j	solver_rect_fast.2543
solver_surface_fast2.2566:
	addrl	a3, l.6821
	flw	fa0, a3, 0
	flw	fa1, a1, 0
	fle.s	a3, fa0, fa1
	beq	a3, zero, .Beq86
	li	a0, 0
	ret
.Beq86:
	nop
	flw	fa0, a1, 0
	flw	fa1, a2, 12
	fmul.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
	li	a0, 1
	ret
solver_second_fast2.2573:
	flw	fa3, a1, 0
	addrl	a3, l.6821
	flw	fa4, a3, 0
	feq.s	a3, fa3, fa4
	beq	a3, zero, .Beq87
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
	addrl	a2, l.6821
	flw	fa2, a2, 0
	fle.s	a2, fa1, fa2
	beq	a2, zero, .Beq88
	li	a0, 0
	ret
.Beq88:
	nop
	sw	hp, 0, a1
	fsw	hp, 4, fa0
	fsw	hp, 8, fa1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_isinvert.2411
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	beq	a1, zero, .Beq89
	flw	fa0, hp, 8
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_sqrt
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 4
	fadd.s	fa0, fa1, fa0
	lw	a1, hp, 0
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
	j	.Cont90
.Beq89:
	nop
	flw	fa0, hp, 8
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_sqrt
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 4
	fsub.s	fa0, fa1, fa0
	lw	a1, hp, 0
	flw	fa1, a1, 16
	fmul.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	fsw	a1, 0, fa0
.Cont90:
	nop
	li	a0, 1
	ret
solver_fast2.2580:
	slli	a2, a0, 2
	addi	a2, a2, 1416
	add	a2, t4, a2
	lw	a2, a2, 0
	sw	hp, 0, a2
	sw	hp, 4, a0
	sw	hp, 8, a1
	mv	a0, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_param_ctbl.2445
	addi	hp, hp, -16
	lw	ra, hp, 12
	mv	a1, a0
	flw	fa0, a1, 0
	flw	fa1, a1, 4
	flw	fa2, a1, 8
	lw	a2, hp, 8
	sw	hp, 12, a1
	fsw	hp, 16, fa2
	fsw	hp, 20, fa1
	fsw	hp, 24, fa0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	d_const.2468
	addi	hp, hp, -32
	lw	ra, hp, 28
	mv	a1, a0
	lw	a2, hp, 4
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, a1, 0
	lw	a2, hp, 0
	sw	hp, 28, a1
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_form.2407
	addi	hp, hp, -36
	lw	ra, hp, 32
	mv	a1, a0
	addi	a2, a1, -1
	beq	a2, zero, .Beq91
	addi	a1, a1, -2
	beq	a1, zero, .Beq92
	lw	a1, hp, 0
	lw	a2, hp, 28
	lw	a3, hp, 12
	flw	fa0, hp, 24
	flw	fa1, hp, 20
	flw	fa2, hp, 16
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	j	solver_second_fast2.2573
.Beq92:
	nop
	lw	a1, hp, 0
	lw	a2, hp, 28
	lw	a3, hp, 12
	flw	fa0, hp, 24
	flw	fa1, hp, 20
	flw	fa2, hp, 16
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	j	solver_surface_fast2.2566
.Beq91:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	d_vec.2466
	addi	hp, hp, -36
	lw	ra, hp, 32
	mv	a1, a0
	lw	a2, hp, 0
	lw	a3, hp, 28
	flw	fa0, hp, 24
	flw	fa1, hp, 20
	flw	fa2, hp, 16
	mv	a0, a2
	mv	a2, a3
	j	solver_rect_fast.2543
setup_rect_table.2583:
	li	a2, 6
	addrl	a3, l.6821
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
	addrl	a3, l.6821
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq93
	addrl	a3, l.6821
	flw	fa0, a3, 0
	li	a3, 4
	add	a3, a1, a3
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
	addrl	a2, l.6821
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
	addrl	a2, l.6817
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 0
	fdiv.s	fa0, fa0, fa1
	li	a3, 4
	add	a3, a1, a3
	fsw	a3, 0, fa0
.Cont94:
	nop
	flw	fa0, a2, 4
	addrl	a3, l.6821
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq97
	addrl	a3, l.6821
	flw	fa0, a3, 0
	li	a3, 12
	add	a3, a1, a3
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
	addrl	a2, l.6821
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
	addrl	a2, l.6817
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 4
	fdiv.s	fa0, fa0, fa1
	li	a3, 12
	add	a3, a1, a3
	fsw	a3, 0, fa0
.Cont98:
	nop
	flw	fa0, a2, 8
	addrl	a3, l.6821
	flw	fa1, a3, 0
	feq.s	a3, fa0, fa1
	beq	a3, zero, .Beq101
	addrl	a2, l.6821
	flw	fa0, a2, 0
	li	a2, 20
	add	a2, a1, a2
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
	addrl	a2, l.6821
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
	addrl	a2, l.6817
	flw	fa0, a2, 0
	lw	a2, hp, 4
	flw	fa1, a2, 8
	fdiv.s	fa0, fa0, fa1
	li	a2, 20
	add	a2, a1, a2
	fsw	a2, 0, fa0
.Cont102:
	nop
	mv	a0, a1
	ret
setup_surface_table.2586:
	li	a2, 4
	addrl	a3, l.6821
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
	addrl	a1, l.6821
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq105
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 0
	lw	a2, hp, 8
	add	a1, a2, a1
	fsw	a1, 0, fa0
	j	.Cont106
.Beq105:
	nop
	addrl	a1, l.6819
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
	li	a1, 12
	lw	a2, hp, 8
	add	a1, a2, a1
	fsw	a1, 0, fa0
.Cont106:
	nop
	mv	a0, a2
	ret
setup_second_table.2589:
	li	a2, 5
	addrl	a3, l.6821
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
	addrl	a1, l.6858
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
	addrl	a1, l.6858
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
	addrl	a1, l.6858
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 36
	fsub.s	fa0, fa1, fa0
	li	a1, 12
	lw	a2, hp, 8
	add	a1, a2, a1
	fsw	a1, 0, fa0
	j	.Cont108
.Beq107:
	nop
	lw	a1, hp, 8
	flw	fa0, hp, 20
	fsw	a1, 4, fa0
	flw	fa0, hp, 28
	fsw	a1, 8, fa0
	li	a2, 12
	add	a2, a1, a2
	flw	fa0, hp, 36
	fsw	a2, 0, fa0
.Cont108:
	nop
	addrl	a1, l.6821
	flw	fa0, a1, 0
	flw	fa1, hp, 12
	feq.s	a1, fa1, fa0
	beq	a1, zero, .Beq109
	j	.Cont110
.Beq109:
	nop
	addrl	a1, l.6817
	flw	fa0, a1, 0
	fdiv.s	fa0, fa0, fa1
	li	a1, 16
	lw	a2, hp, 8
	add	a1, a2, a1
	fsw	a1, 0, fa0
.Cont110:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	ret
iter_setup_dirvec_constants.2592:
	bge	a1, zero, .Bge111
	ret
.Bge111:
	nop
	slli	a2, a1, 2
	addi	a2, a2, 1416
	add	a2, t4, a2
	lw	a2, a2, 0
	sw	hp, 0, a1
	sw	hp, 4, a2
	sw	hp, 8, a0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	d_const.2468
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	d_vec.2466
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 4
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_form.2407
	addi	hp, hp, -24
	lw	ra, hp, 20
	addi	a1, a0, -1
	beq	a1, zero, .Beq112
	addi	a0, a0, -2
	beq	a0, zero, .Beq114
	lw	a0, hp, 16
	lw	a1, hp, 4
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	setup_second_table.2589
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 0
	slli	a2, a1, 2
	lw	a3, hp, 12
	add	a2, a3, a2
	sw	a2, 0, a0
	j	.Cont115
.Beq114:
	nop
	lw	a0, hp, 16
	lw	a1, hp, 4
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	setup_surface_table.2586
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 0
	slli	a2, a1, 2
	lw	a3, hp, 12
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont115:
	nop
	j	.Cont113
.Beq112:
	nop
	lw	a0, hp, 16
	lw	a1, hp, 4
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	setup_rect_table.2583
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 0
	slli	a2, a1, 2
	lw	a3, hp, 12
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont113:
	nop
	addi	a1, a1, -1
	lw	a0, hp, 8
	j	iter_setup_dirvec_constants.2592
setup_dirvec_constants.2595:
	li	a1, 0
	addi	a1, a1, 1656
	add	a1, t4, a1
	lw	a1, a1, 0
	addi	a1, a1, -1
	j	iter_setup_dirvec_constants.2592
setup_startp_constants.2597:
	bge	a1, zero, .Bge116
	ret
.Bge116:
	nop
	slli	a2, a1, 2
	addi	a2, a2, 1416
	add	a2, t4, a2
	lw	a2, a2, 0
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, a2
	mv	a0, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_param_ctbl.2445
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_form.2407
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 4
	flw	fa0, a1, 0
	lw	a2, hp, 8
	sw	hp, 16, a0
	fsw	hp, 20, fa0
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_x.2423
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 12
	fsw	a0, 0, fa0
	lw	a1, hp, 4
	flw	fa0, a1, 4
	lw	a2, hp, 8
	fsw	hp, 24, fa0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_y.2425
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 12
	fsw	a0, 4, fa0
	lw	a1, hp, 4
	flw	fa0, a1, 8
	lw	a2, hp, 8
	fsw	hp, 28, fa0
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_z.2427
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 12
	fsw	a0, 8, fa0
	lw	a1, hp, 16
	addi	a2, a1, -2
	beq	a2, zero, .Beq117
	addi	a2, a1, -2
	bge	zero, a2, .Ble119
	flw	fa0, a0, 0
	flw	fa1, a0, 4
	flw	fa2, a0, 8
	lw	a2, hp, 8
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	quadratic.2520
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 16
	addi	a0, a0, -3
	beq	a0, zero, .Beq121
	j	.Cont122
.Beq121:
	nop
	addrl	a0, l.6817
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
.Cont122:
	nop
	li	a0, 12
	lw	a1, hp, 12
	add	a0, a1, a0
	fsw	a0, 0, fa0
	j	.Cont120
.Ble119:
	nop
.Cont120:
	nop
	j	.Cont118
.Beq117:
	nop
	lw	a1, hp, 8
	mv	a0, a1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_abc.2421
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 12
	flw	fa0, a1, 0
	flw	fa1, a1, 4
	flw	fa2, a1, 8
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	veciprod2.2386
	addi	hp, hp, -36
	lw	ra, hp, 32
	li	a0, 12
	lw	a1, hp, 12
	add	a0, a1, a0
	fsw	a0, 0, fa0
.Cont118:
	nop
	lw	a0, hp, 0
	addi	a1, a0, -1
	lw	a0, hp, 4
	j	setup_startp_constants.2597
setup_startp.2600:
	addi	a1, t4, 1044
	sw	hp, 0, a0
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	veccpy.2377
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 0
	addi	a0, a0, 1656
	add	a0, t4, a0
	lw	a0, a0, 0
	addi	a1, a0, -1
	lw	a0, hp, 0
	j	setup_startp_constants.2597
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
	addrl	a2, l.6821
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
	addrl	a1, l.6817
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
	addrl	a2, l.6821
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
	slli	a2, a0, 2
	add	a2, a1, a2
	lw	a2, a2, 0
	addi	a3, a2, 1
	beq	a3, zero, .Beq141
	slli	a2, a2, 2
	addi	a2, a2, 1416
	add	a2, t4, a2
	lw	a2, a2, 0
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	fsw	hp, 8, fa0
	sw	hp, 12, a1
	sw	hp, 16, a0
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	is_outside.2617
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	beq	a1, zero, .Beq142
	li	a0, 0
	ret
.Beq142:
	nop
	lw	a1, hp, 16
	addi	a1, a1, 1
	lw	a2, hp, 12
	flw	fa0, hp, 8
	flw	fa1, hp, 4
	flw	fa2, hp, 0
	mv	a0, a1
	mv	a1, a2
	j	check_all_inside.2622
.Beq141:
	nop
	li	a0, 1
	ret
shadow_check_and_group.2628:
	lw	a2, t6, 4
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a3, a3, 1
	beq	a3, zero, .Beq143
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, t4, 1140
	sw	hp, 0, a1
	sw	hp, 4, t6
	sw	hp, 8, a0
	sw	hp, 12, a3
	mv	a1, a2
	mv	a0, a3
	mv	a2, a4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solver_fast.2562
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	li	a2, 0
	addi	a2, a2, 1160
	add	a2, t4, a2
	flw	fa0, a2, 0
	beq	a1, zero, .Beq144
	addrl	a1, l.6902
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
	addrl	a1, l.6900
	flw	fa1, a1, 0
	fadd.s	fa0, fa0, fa1
	li	a1, 0
	addi	a1, a1, 1380
	add	a1, t4, a1
	flw	fa1, a1, 0
	fmul.s	fa1, fa1, fa0
	li	a1, 0
	addi	a1, a1, 1140
	add	a1, t4, a1
	flw	fa2, a1, 0
	fadd.s	fa1, fa1, fa2
	li	a1, 4
	addi	a1, a1, 1380
	add	a1, t4, a1
	flw	fa2, a1, 0
	fmul.s	fa2, fa2, fa0
	li	a1, 4
	addi	a1, a1, 1140
	add	a1, t4, a1
	flw	fa3, a1, 0
	fadd.s	fa2, fa2, fa3
	li	a1, 8
	addi	a1, a1, 1380
	add	a1, t4, a1
	flw	fa3, a1, 0
	fmul.s	fa0, fa3, fa0
	li	a1, 8
	addi	a1, a1, 1140
	add	a1, t4, a1
	flw	fa3, a1, 0
	fadd.s	fa0, fa0, fa3
	li	a1, 0
	lw	a2, hp, 0
	mv	a0, a1
	mv	a1, a2
	fsgnj.s	ft11, fa2, fa2
	fsgnj.s	fa2, fa0, fa0
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, ft11, ft11
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	check_all_inside.2622
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	beq	a1, zero, .Beq149
	li	a0, 1
	ret
.Beq149:
	nop
	lw	a1, hp, 8
	addi	a1, a1, 1
	lw	a2, hp, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a2
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq148:
	nop
	lw	a1, hp, 12
	slli	a1, a1, 2
	addi	a1, a1, 1416
	add	a1, t4, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_isinvert.2411
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	beq	a1, zero, .Beq150
	lw	a1, hp, 8
	addi	a1, a1, 1
	lw	a2, hp, 0
	lw	t6, hp, 4
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
	lw	a2, t6, 4
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, a3, 1
	beq	a4, zero, .Beq151
	slli	a3, a3, 2
	addi	a3, a3, 1172
	add	a3, t4, a3
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
	lw	a2, t6, 8
	lw	a3, t6, 4
	slli	a4, a0, 2
	add	a4, a1, a4
	lw	a4, a4, 0
	lw	a5, a4, 0
	addi	a6, a5, 1
	beq	a6, zero, .Beq153
	addi	a6, a5, -99
	sw	hp, 0, a4
	sw	hp, 4, a2
	sw	hp, 8, a1
	sw	hp, 12, t6
	sw	hp, 16, a0
	beq	a6, zero, .Beq154
	addi	a6, t4, 1140
	mv	a2, a6
	mv	a1, a3
	mv	a0, a5
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	solver_fast.2562
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	beq	a1, zero, .Beq156
	addrl	a1, l.6904
	flw	fa0, a1, 0
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
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
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
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
	sw	hp, 20, ra
	addi	hp, hp, 24
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -24
	lw	ra, hp, 20
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
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, a3, 1
	beq	a4, zero, .Beq164
	addi	a4, t4, 1056
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, a3
	mv	a1, a2
	mv	a0, a3
	mv	a2, a4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solver.2539
	addi	hp, hp, -20
	lw	ra, hp, 16
	beq	a0, zero, .Beq165
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, a1, 0
	addrl	a1, l.6821
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq166
	j	.Cont167
.Beq166:
	nop
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	flw	fa1, a1, 0
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq168
	j	.Cont169
.Beq168:
	nop
	addrl	a1, l.6900
	flw	fa1, a1, 0
	fadd.s	fa0, fa0, fa1
	lw	a1, hp, 0
	flw	fa1, a1, 0
	fmul.s	fa1, fa1, fa0
	li	a2, 0
	addi	a2, a2, 1056
	add	a2, t4, a2
	flw	fa2, a2, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a1, 4
	fmul.s	fa2, fa2, fa0
	li	a2, 4
	addi	a2, a2, 1056
	add	a2, t4, a2
	flw	fa3, a2, 0
	fadd.s	fa2, fa2, fa3
	flw	fa3, a1, 8
	fmul.s	fa3, fa3, fa0
	li	a2, 8
	addi	a2, a2, 1056
	add	a2, t4, a2
	flw	fa4, a2, 0
	fadd.s	fa3, fa3, fa4
	li	a2, 0
	lw	a3, hp, 4
	sw	hp, 16, a0
	fsw	hp, 20, fa3
	fsw	hp, 24, fa2
	fsw	hp, 28, fa1
	fsw	hp, 32, fa0
	mv	a1, a3
	mv	a0, a2
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	check_all_inside.2622
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq170
	li	a0, 0
	addi	a0, a0, 1152
	add	a0, t4, a0
	flw	fa0, hp, 32
	fsw	a0, 0, fa0
	addi	a0, t4, 1140
	flw	fa0, hp, 28
	flw	fa1, hp, 24
	flw	fa2, hp, 20
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecset.2367
	addi	hp, hp, -40
	lw	ra, hp, 36
	li	a0, 0
	addi	a0, a0, 1136
	add	a0, t4, a0
	lw	a1, hp, 12
	sw	a0, 0, a1
	li	a0, 0
	addi	a0, a0, 1156
	add	a0, t4, a0
	lw	a1, hp, 16
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
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_each_element.2637
.Beq165:
	nop
	lw	a0, hp, 12
	slli	a0, a0, 2
	addi	a0, a0, 1416
	add	a0, t4, a0
	lw	a0, a0, 0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_isinvert.2411
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq172
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_each_element.2637
.Beq172:
	nop
	ret
.Beq164:
	nop
	ret
solve_one_or_network.2641:
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, a3, 1
	beq	a4, zero, .Beq173
	slli	a3, a3, 2
	addi	a3, a3, 1172
	add	a3, t4, a3
	lw	a3, a3, 0
	li	a4, 0
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	mv	a1, a3
	mv	a0, a4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	solve_each_element.2637
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_one_or_network.2641
.Beq173:
	nop
	ret
trace_or_matrix.2645:
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	lw	a4, a3, 0
	addi	a5, a4, 1
	beq	a5, zero, .Beq174
	addi	a5, a4, -99
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	beq	a5, zero, .Beq175
	addi	a5, t4, 1056
	sw	hp, 12, a3
	mv	a1, a2
	mv	a0, a4
	mv	a2, a5
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solver.2539
	addi	hp, hp, -20
	lw	ra, hp, 16
	beq	a0, zero, .Beq177
	li	a0, 0
	addi	a0, a0, 1160
	add	a0, t4, a0
	flw	fa0, a0, 0
	li	a0, 0
	addi	a0, a0, 1152
	add	a0, t4, a0
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq179
	j	.Cont180
.Beq179:
	nop
	li	a0, 1
	lw	a1, hp, 12
	lw	a2, hp, 0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solve_one_or_network.2641
	addi	hp, hp, -20
	lw	ra, hp, 16
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
	li	a4, 1
	mv	a1, a3
	mv	a0, a4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solve_one_or_network.2641
	addi	hp, hp, -20
	lw	ra, hp, 16
.Cont176:
	nop
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	trace_or_matrix.2645
.Beq174:
	nop
	ret
judge_intersection.2649:
	addrl	a1, l.6911
	flw	fa0, a1, 0
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	fsw	a1, 0, fa0
	li	a1, 0
	li	a2, 0
	addi	a2, a2, 1164
	add	a2, t4, a2
	lw	a2, a2, 0
	mv	t5, a2
	mv	a2, a0
	mv	a0, a1
	mv	a1, t5
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	trace_or_matrix.2645
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	flw	fa0, a1, 0
	addrl	a1, l.6904
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq181
	li	a0, 0
	ret
.Beq181:
	nop
	addrl	a1, l.6908
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
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	mv	a0, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	d_vec.2466
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	slli	a2, a1, 2
	lw	a3, hp, 4
	add	a2, a3, a2
	lw	a2, a2, 0
	addi	a4, a2, 1
	beq	a4, zero, .Beq183
	lw	a4, hp, 0
	sw	hp, 12, a0
	sw	hp, 16, a2
	mv	a1, a4
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	solver_fast2.2580
	addi	hp, hp, -24
	lw	ra, hp, 20
	beq	a0, zero, .Beq184
	li	a1, 0
	addi	a1, a1, 1160
	add	a1, t4, a1
	flw	fa0, a1, 0
	addrl	a1, l.6821
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq185
	j	.Cont186
.Beq185:
	nop
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	flw	fa1, a1, 0
	fle.s	a1, fa1, fa0
	beq	a1, zero, .Beq187
	j	.Cont188
.Beq187:
	nop
	addrl	a1, l.6900
	flw	fa1, a1, 0
	fadd.s	fa0, fa0, fa1
	lw	a1, hp, 12
	flw	fa1, a1, 0
	fmul.s	fa1, fa1, fa0
	li	a2, 0
	addi	a2, a2, 1044
	add	a2, t4, a2
	flw	fa2, a2, 0
	fadd.s	fa1, fa1, fa2
	flw	fa2, a1, 4
	fmul.s	fa2, fa2, fa0
	li	a2, 4
	addi	a2, a2, 1044
	add	a2, t4, a2
	flw	fa3, a2, 0
	fadd.s	fa2, fa2, fa3
	flw	fa3, a1, 8
	fmul.s	fa3, fa3, fa0
	li	a1, 8
	addi	a1, a1, 1044
	add	a1, t4, a1
	flw	fa4, a1, 0
	fadd.s	fa3, fa3, fa4
	li	a1, 0
	lw	a2, hp, 4
	sw	hp, 20, a0
	fsw	hp, 24, fa3
	fsw	hp, 28, fa2
	fsw	hp, 32, fa1
	fsw	hp, 36, fa0
	mv	a0, a1
	mv	a1, a2
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	fsgnj.s	fa2, fa3, fa3
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	check_all_inside.2622
	addi	hp, hp, -44
	lw	ra, hp, 40
	beq	a0, zero, .Beq189
	li	a0, 0
	addi	a0, a0, 1152
	add	a0, t4, a0
	flw	fa0, hp, 36
	fsw	a0, 0, fa0
	addi	a0, t4, 1140
	flw	fa0, hp, 32
	flw	fa1, hp, 28
	flw	fa2, hp, 24
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	vecset.2367
	addi	hp, hp, -44
	lw	ra, hp, 40
	li	a0, 0
	addi	a0, a0, 1136
	add	a0, t4, a0
	lw	a1, hp, 16
	sw	a0, 0, a1
	li	a0, 0
	addi	a0, a0, 1156
	add	a0, t4, a0
	lw	a1, hp, 20
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
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_each_element_fast.2651
.Beq184:
	nop
	lw	a0, hp, 16
	slli	a0, a0, 2
	addi	a0, a0, 1416
	add	a0, t4, a0
	lw	a0, a0, 0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isinvert.2411
	addi	hp, hp, -44
	lw	ra, hp, 40
	beq	a0, zero, .Beq191
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_each_element_fast.2651
.Beq191:
	nop
	ret
.Beq183:
	nop
	ret
solve_one_or_network_fast.2655:
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	addi	a4, a3, 1
	beq	a4, zero, .Beq192
	slli	a3, a3, 2
	addi	a3, a3, 1172
	add	a3, t4, a3
	lw	a3, a3, 0
	li	a4, 0
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	mv	a1, a3
	mv	a0, a4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	solve_each_element_fast.2651
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	solve_one_or_network_fast.2655
.Beq192:
	nop
	ret
trace_or_matrix_fast.2659:
	slli	a3, a0, 2
	add	a3, a1, a3
	lw	a3, a3, 0
	lw	a4, a3, 0
	addi	a5, a4, 1
	beq	a5, zero, .Beq193
	addi	a5, a4, -99
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	beq	a5, zero, .Beq194
	sw	hp, 12, a3
	mv	a1, a2
	mv	a0, a4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solver_fast2.2580
	addi	hp, hp, -20
	lw	ra, hp, 16
	beq	a0, zero, .Beq196
	li	a0, 0
	addi	a0, a0, 1160
	add	a0, t4, a0
	flw	fa0, a0, 0
	li	a0, 0
	addi	a0, a0, 1152
	add	a0, t4, a0
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq198
	j	.Cont199
.Beq198:
	nop
	li	a0, 1
	lw	a1, hp, 12
	lw	a2, hp, 0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solve_one_or_network_fast.2655
	addi	hp, hp, -20
	lw	ra, hp, 16
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
	li	a4, 1
	mv	a1, a3
	mv	a0, a4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	solve_one_or_network_fast.2655
	addi	hp, hp, -20
	lw	ra, hp, 16
.Cont195:
	nop
	lw	a0, hp, 8
	addi	a0, a0, 1
	lw	a1, hp, 4
	lw	a2, hp, 0
	j	trace_or_matrix_fast.2659
.Beq193:
	nop
	ret
judge_intersection_fast.2663:
	addrl	a1, l.6911
	flw	fa0, a1, 0
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	fsw	a1, 0, fa0
	li	a1, 0
	li	a2, 0
	addi	a2, a2, 1164
	add	a2, t4, a2
	lw	a2, a2, 0
	mv	t5, a2
	mv	a2, a0
	mv	a0, a1
	mv	a1, t5
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	trace_or_matrix_fast.2659
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	flw	fa0, a1, 0
	addrl	a1, l.6904
	flw	fa1, a1, 0
	fle.s	a1, fa0, fa1
	beq	a1, zero, .Beq200
	li	a0, 0
	ret
.Beq200:
	nop
	addrl	a1, l.6908
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
	li	a1, 0
	addi	a1, a1, 1156
	add	a1, t4, a1
	lw	a1, a1, 0
	addi	a2, t4, 1124
	sw	hp, 0, a0
	sw	hp, 4, a1
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	vecbzero.2375
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	addi	a1, a0, -1
	addi	a0, a0, -1
	slli	a0, a0, 2
	lw	a2, hp, 0
	add	a0, a2, a0
	flw	fa0, a0, 0
	sw	hp, 8, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	sgn.2359
	addi	hp, hp, -16
	lw	ra, hp, 12
	fsgnjn.s	fa0, fa0, fa0
	lw	a0, hp, 8
	slli	a0, a0, 2
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
get_nvector_plane.2667:
	sw	hp, 0, a0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	o_param_a.2415
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnjn.s	fa0, fa0, fa0
	li	a0, 0
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	o_param_b.2417
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnjn.s	fa0, fa0, fa0
	li	a0, 4
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	o_param_c.2419
	addi	hp, hp, -8
	lw	ra, hp, 4
	fsgnjn.s	fa0, fa0, fa0
	li	a0, 8
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
get_nvector_second.2669:
	li	a1, 0
	addi	a1, a1, 1140
	add	a1, t4, a1
	flw	fa0, a1, 0
	sw	hp, 0, a0
	fsw	hp, 4, fa0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_param_x.2423
	addi	hp, hp, -12
	lw	ra, hp, 8
	flw	fa1, hp, 4
	fsub.s	fa0, fa1, fa0
	li	a0, 4
	addi	a0, a0, 1140
	add	a0, t4, a0
	flw	fa1, a0, 0
	lw	a0, hp, 0
	fsw	hp, 8, fa0
	fsw	hp, 12, fa1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_y.2425
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	li	a0, 8
	addi	a0, a0, 1140
	add	a0, t4, a0
	flw	fa1, a0, 0
	lw	a0, hp, 0
	fsw	hp, 16, fa0
	fsw	hp, 20, fa1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	o_param_z.2427
	addi	hp, hp, -28
	lw	ra, hp, 24
	flw	fa1, hp, 20
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 24, fa0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_a.2415
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 28, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_b.2417
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 32, fa0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_c.2419
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 36, fa0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_isrot.2413
	addi	hp, hp, -44
	lw	ra, hp, 40
	beq	a0, zero, .Beq202
	lw	a0, hp, 0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	o_param_r3.2443
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 40, fa0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_r2.2441
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	flw	fa2, hp, 40
	fadd.s	fa0, fa2, fa0
	addrl	a0, l.6858
	flw	fa2, a0, 0
	fmul.s	fa0, fa0, fa2
	flw	fa2, hp, 28
	fadd.s	fa0, fa2, fa0
	li	a0, 0
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_r3.2443
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 44, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_r1.2439
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 44
	fadd.s	fa0, fa1, fa0
	addrl	a0, l.6858
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 32
	fadd.s	fa0, fa1, fa0
	li	a0, 4
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_param_r2.2441
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 8
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	fsw	hp, 48, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_param_r1.2439
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 48
	fadd.s	fa0, fa1, fa0
	addrl	a0, l.6858
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 36
	fadd.s	fa0, fa1, fa0
	li	a0, 8
	addi	a0, a0, 1124
	add	a0, t4, a0
	fsw	a0, 0, fa0
	j	.Cont203
.Beq202:
	nop
	li	a0, 0
	addi	a0, a0, 1124
	add	a0, t4, a0
	flw	fa0, hp, 28
	fsw	a0, 0, fa0
	li	a0, 4
	addi	a0, a0, 1124
	add	a0, t4, a0
	flw	fa0, hp, 32
	fsw	a0, 0, fa0
	li	a0, 8
	addi	a0, a0, 1124
	add	a0, t4, a0
	flw	fa0, hp, 36
	fsw	a0, 0, fa0
.Cont203:
	nop
	lw	a0, hp, 0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	o_isinvert.2411
	addi	hp, hp, -56
	lw	ra, hp, 52
	mv	a1, a0
	addi	a0, t4, 1124
	j	vecunit_sgn.2380
get_nvector.2671:
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_form.2407
	addi	hp, hp, -12
	lw	ra, hp, 8
	addi	a1, a0, -1
	beq	a1, zero, .Beq204
	addi	a0, a0, -2
	beq	a0, zero, .Beq205
	lw	a0, hp, 0
	j	get_nvector_second.2669
.Beq205:
	nop
	lw	a0, hp, 0
	j	get_nvector_plane.2667
.Beq204:
	nop
	lw	a0, hp, 4
	j	get_nvector_rect.2665
utexture.2674:
	sw	hp, 0, a1
	sw	hp, 4, a0
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_texturetype.2405
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a1, hp, 4
	sw	hp, 8, a0
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_color_red.2433
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 0
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_color_green.2435
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 4
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_color_blue.2437
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 8
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	lw	a0, hp, 8
	addi	a1, a0, -1
	beq	a1, zero, .Beq206
	addi	a1, a0, -2
	beq	a1, zero, .Beq207
	addi	a1, a0, -3
	beq	a1, zero, .Beq208
	addi	a0, a0, -4
	beq	a0, zero, .Beq209
	ret
.Beq209:
	nop
	lw	a0, hp, 0
	flw	fa0, a0, 0
	lw	a1, hp, 4
	fsw	hp, 12, fa0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_param_x.2423
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 16, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_a.2415
	addi	hp, hp, -24
	lw	ra, hp, 20
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_sqrt
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 8
	lw	a1, hp, 4
	fsw	hp, 20, fa0
	fsw	hp, 24, fa1
	mv	a0, a1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_z.2427
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 28, fa0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	o_param_c.2419
	addi	hp, hp, -36
	lw	ra, hp, 32
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	min_caml_sqrt
	addi	hp, hp, -36
	lw	ra, hp, 32
	flw	fa1, hp, 28
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa2, fa1, fa1
	fmul.s	fa3, fa0, fa0
	fadd.s	fa2, fa2, fa3
	addrl	a0, l.6963
	flw	fa3, a0, 0
	fsw	hp, 32, fa2
	fsw	hp, 36, fa0
	fsw	hp, 40, fa3
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_fabs
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq210
	flw	fa0, hp, 20
	flw	fa1, hp, 36
	fdiv.s	fa0, fa1, fa0
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_fabs
	addi	hp, hp, -48
	lw	ra, hp, 44
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	min_caml_atan
	addi	hp, hp, -48
	lw	ra, hp, 44
	addrl	a0, l.6961
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.6944
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	j	.Cont211
.Beq210:
	nop
	addrl	a0, l.6958
	flw	fa0, a0, 0
.Cont211:
	nop
	fsw	hp, 44, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	min_caml_floor
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 4
	lw	a0, hp, 4
	fsw	hp, 48, fa0
	fsw	hp, 52, fa1
	sw	hp, 56, ra
	addi	hp, hp, 60
	call	o_param_y.2425
	addi	hp, hp, -60
	lw	ra, hp, 56
	flw	fa1, hp, 52
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 4
	fsw	hp, 56, fa0
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_param_b.2417
	addi	hp, hp, -64
	lw	ra, hp, 60
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	min_caml_sqrt
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.6963
	flw	fa1, a0, 0
	flw	fa2, hp, 32
	fsw	hp, 60, fa0
	fsw	hp, 64, fa1
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	min_caml_fabs
	addi	hp, hp, -72
	lw	ra, hp, 68
	flw	fa1, hp, 64
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq212
	flw	fa0, hp, 32
	flw	fa1, hp, 60
	fdiv.s	fa0, fa1, fa0
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	min_caml_fabs
	addi	hp, hp, -72
	lw	ra, hp, 68
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	min_caml_atan
	addi	hp, hp, -72
	lw	ra, hp, 68
	addrl	a0, l.6961
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.6944
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	j	.Cont213
.Beq212:
	nop
	addrl	a0, l.6958
	flw	fa0, a0, 0
.Cont213:
	nop
	fsw	hp, 68, fa0
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	min_caml_floor
	addi	hp, hp, -76
	lw	ra, hp, 72
	flw	fa1, hp, 68
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6956
	flw	fa1, a0, 0
	addrl	a0, l.6858
	flw	fa2, a0, 0
	flw	fa3, hp, 48
	fsub.s	fa2, fa2, fa3
	addrl	a0, l.6858
	flw	fa4, a0, 0
	fsub.s	fa3, fa4, fa3
	fmul.s	fa2, fa2, fa3
	fsub.s	fa1, fa1, fa2
	addrl	a0, l.6858
	flw	fa2, a0, 0
	fsub.s	fa2, fa2, fa0
	addrl	a0, l.6858
	flw	fa3, a0, 0
	fsub.s	fa0, fa3, fa0
	fmul.s	fa0, fa2, fa0
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6821
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq214
	j	.Cont215
.Beq214:
	nop
	addrl	a0, l.6821
	flw	fa0, a0, 0
.Cont215:
	nop
	addrl	a0, l.6921
	flw	fa1, a0, 0
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.6947
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	li	a0, 8
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
.Beq208:
	nop
	lw	a0, hp, 0
	flw	fa0, a0, 0
	lw	a1, hp, 4
	fsw	hp, 72, fa0
	mv	a0, a1
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	o_param_x.2423
	addi	hp, hp, -80
	lw	ra, hp, 76
	flw	fa1, hp, 72
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 0
	flw	fa1, a0, 8
	lw	a0, hp, 4
	fsw	hp, 76, fa0
	fsw	hp, 80, fa1
	sw	hp, 84, ra
	addi	hp, hp, 88
	call	o_param_z.2427
	addi	hp, hp, -88
	lw	ra, hp, 84
	flw	fa1, hp, 80
	fsub.s	fa0, fa1, fa0
	flw	fa1, hp, 76
	fmul.s	fa1, fa1, fa1
	fmul.s	fa0, fa0, fa0
	fadd.s	fa0, fa1, fa0
	sw	hp, 84, ra
	addi	hp, hp, 88
	call	min_caml_sqrt
	addi	hp, hp, -88
	lw	ra, hp, 84
	addrl	a0, l.6926
	flw	fa1, a0, 0
	fdiv.s	fa0, fa0, fa1
	fsw	hp, 84, fa0
	sw	hp, 88, ra
	addi	hp, hp, 92
	call	min_caml_floor
	addi	hp, hp, -92
	lw	ra, hp, 88
	flw	fa1, hp, 84
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6944
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	fsw	hp, 88, fa0
	sw	hp, 92, ra
	addi	hp, hp, 96
	call	min_caml_cos
	addi	hp, hp, -96
	lw	ra, hp, 92
	flw	fa1, hp, 88
	fsw	hp, 92, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 96, ra
	addi	hp, hp, 100
	call	min_caml_cos
	addi	hp, hp, -100
	lw	ra, hp, 96
	flw	fa1, hp, 92
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.6921
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	li	a0, 4
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa1
	addrl	a0, l.6817
	flw	fa1, a0, 0
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6921
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	li	a0, 8
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
.Beq207:
	nop
	lw	a0, hp, 0
	flw	fa0, a0, 4
	addrl	a1, l.6938
	flw	fa1, a1, 0
	fmul.s	fa0, fa0, fa1
	sw	hp, 96, ra
	addi	hp, hp, 100
	call	min_caml_sin
	addi	hp, hp, -100
	lw	ra, hp, 96
	lw	a0, hp, 0
	flw	fa1, a0, 4
	addrl	a0, l.6938
	flw	fa2, a0, 0
	fmul.s	fa1, fa1, fa2
	fsw	hp, 96, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 100, ra
	addi	hp, hp, 104
	call	min_caml_sin
	addi	hp, hp, -104
	lw	ra, hp, 100
	flw	fa1, hp, 96
	fmul.s	fa0, fa1, fa0
	addrl	a0, l.6921
	flw	fa1, a0, 0
	fmul.s	fa1, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa1
	addrl	a0, l.6921
	flw	fa1, a0, 0
	addrl	a0, l.6817
	flw	fa2, a0, 0
	fsub.s	fa0, fa2, fa0
	fmul.s	fa0, fa1, fa0
	li	a0, 4
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
.Beq206:
	nop
	lw	a0, hp, 0
	flw	fa0, a0, 0
	lw	a1, hp, 4
	fsw	hp, 100, fa0
	mv	a0, a1
	sw	hp, 104, ra
	addi	hp, hp, 108
	call	o_param_x.2423
	addi	hp, hp, -108
	lw	ra, hp, 104
	flw	fa1, hp, 100
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6930
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	fsw	hp, 104, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 108, ra
	addi	hp, hp, 112
	call	min_caml_floor
	addi	hp, hp, -112
	lw	ra, hp, 108
	addrl	a0, l.6928
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.6926
	flw	fa1, a0, 0
	flw	fa2, hp, 104
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
	lw	a1, hp, 4
	sw	hp, 108, a0
	fsw	hp, 112, fa0
	mv	a0, a1
	sw	hp, 116, ra
	addi	hp, hp, 120
	call	o_param_z.2427
	addi	hp, hp, -120
	lw	ra, hp, 116
	flw	fa1, hp, 112
	fsub.s	fa0, fa1, fa0
	addrl	a0, l.6930
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	fsw	hp, 116, fa0
	fsgnj.s	fa0, fa1, fa1
	sw	hp, 120, ra
	addi	hp, hp, 124
	call	min_caml_floor
	addi	hp, hp, -124
	lw	ra, hp, 120
	addrl	a0, l.6928
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.6926
	flw	fa1, a0, 0
	flw	fa2, hp, 116
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
	lw	a1, hp, 108
	beq	a1, zero, .Beq220
	beq	a0, zero, .Beq222
	addrl	a0, l.6921
	flw	fa0, a0, 0
	j	.Cont223
.Beq222:
	nop
	addrl	a0, l.6821
	flw	fa0, a0, 0
.Cont223:
	nop
	j	.Cont221
.Beq220:
	nop
	beq	a0, zero, .Beq224
	addrl	a0, l.6821
	flw	fa0, a0, 0
	j	.Cont225
.Beq224:
	nop
	addrl	a0, l.6921
	flw	fa0, a0, 0
.Cont225:
	nop
.Cont221:
	nop
	li	a0, 4
	addi	a0, a0, 1112
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
add_light.2677:
	addrl	a0, l.6821
	flw	fa3, a0, 0
	fle.s	a0, fa0, fa3
	fsw	hp, 0, fa2
	fsw	hp, 4, fa1
	beq	a0, zero, .Beq226
	j	.Cont227
.Beq226:
	nop
	addi	a0, t4, 1088
	addi	a1, t4, 1112
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	vecaccum.2391
	addi	hp, hp, -12
	lw	ra, hp, 8
.Cont227:
	nop
	addrl	a0, l.6821
	flw	fa0, a0, 0
	flw	fa1, hp, 4
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq228
	ret
.Beq228:
	nop
	fmul.s	fa0, fa1, fa1
	fmul.s	fa1, fa1, fa1
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 0
	fmul.s	fa0, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa0, fa1, fa0
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
trace_reflections.2681:
	lw	a2, t6, 4
	bge	a0, zero, .Bge229
	ret
.Bge229:
	nop
	slli	a3, a0, 2
	addi	a3, a3, 4
	add	a3, t4, a3
	lw	a3, a3, 0
	sw	hp, 0, t6
	sw	hp, 4, a0
	fsw	hp, 8, fa1
	sw	hp, 12, a1
	fsw	hp, 16, fa0
	sw	hp, 20, a2
	sw	hp, 24, a3
	mv	a0, a3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	r_dvec.2472
	addi	hp, hp, -32
	lw	ra, hp, 28
	sw	hp, 28, a0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	judge_intersection_fast.2663
	addi	hp, hp, -36
	lw	ra, hp, 32
	beq	a0, zero, .Beq230
	li	a0, 0
	addi	a0, a0, 1136
	add	a0, t4, a0
	lw	a0, a0, 0
	slli	a0, a0, 2
	li	a1, 0
	addi	a1, a1, 1156
	add	a1, t4, a1
	lw	a1, a1, 0
	add	a0, a0, a1
	lw	a1, hp, 24
	sw	hp, 32, a0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	r_surface_id.2470
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 32
	beq	a1, a0, .Beq232
	j	.Cont233
.Beq232:
	nop
	li	a0, 0
	li	a1, 0
	addi	a1, a1, 1164
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	t6, hp, 20
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq234
	j	.Cont235
.Beq234:
	nop
	lw	a0, hp, 28
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	d_vec.2466
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	addi	a0, t4, 1124
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	veciprod.2383
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 24
	fsw	hp, 36, fa0
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	r_bright.2474
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 16
	fmul.s	fa2, fa0, fa1
	flw	fa3, hp, 36
	fmul.s	fa2, fa2, fa3
	lw	a0, hp, 28
	fsw	hp, 40, fa2
	fsw	hp, 44, fa0
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	d_vec.2466
	addi	hp, hp, -52
	lw	ra, hp, 48
	mv	a1, a0
	lw	a0, hp, 12
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	veciprod.2383
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 44
	fmul.s	fa1, fa1, fa0
	flw	fa0, hp, 40
	flw	fa2, hp, 8
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	add_light.2677
	addi	hp, hp, -52
	lw	ra, hp, 48
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
	lw	a1, hp, 12
	flw	fa0, hp, 16
	flw	fa1, hp, 8
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
trace_ray.2686:
	lw	a3, t6, 8
	lw	a4, t6, 4
	addi	a5, a0, -4
	bge	zero, a5, .Ble236
	ret
.Ble236:
	nop
	sw	hp, 0, t6
	fsw	hp, 4, fa1
	sw	hp, 8, a3
	sw	hp, 12, a4
	sw	hp, 16, a2
	fsw	hp, 20, fa0
	sw	hp, 24, a0
	sw	hp, 28, a1
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_surface_ids.2451
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 28
	sw	hp, 32, a0
	mv	a0, a1
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	judge_intersection.2649
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq237
	li	a0, 0
	addi	a0, a0, 1136
	add	a0, t4, a0
	lw	a0, a0, 0
	slli	a1, a0, 2
	addi	a1, a1, 1416
	add	a1, t4, a1
	lw	a1, a1, 0
	sw	hp, 36, a0
	sw	hp, 40, a1
	mv	a0, a1
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_reflectiontype.2409
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a1, hp, 40
	sw	hp, 44, a0
	mv	a0, a1
	sw	hp, 48, ra
	addi	hp, hp, 52
	call	o_diffuse.2429
	addi	hp, hp, -52
	lw	ra, hp, 48
	flw	fa1, hp, 20
	fmul.s	fa0, fa0, fa1
	lw	a0, hp, 40
	lw	a1, hp, 28
	fsw	hp, 48, fa0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	get_nvector.2671
	addi	hp, hp, -56
	lw	ra, hp, 52
	addi	a0, t4, 1056
	addi	a1, t4, 1140
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	veccpy.2377
	addi	hp, hp, -56
	lw	ra, hp, 52
	addi	a1, t4, 1140
	lw	a0, hp, 40
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	utexture.2674
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 36
	slli	a0, a0, 2
	li	a1, 0
	addi	a1, a1, 1156
	add	a1, t4, a1
	lw	a1, a1, 0
	add	a0, a0, a1
	lw	a1, hp, 24
	slli	a2, a1, 2
	lw	a3, hp, 32
	add	a2, a3, a2
	sw	a2, 0, a0
	lw	a0, hp, 16
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	p_intersection_points.2449
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a1, hp, 24
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	addi	a2, t4, 1140
	mv	a1, a2
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	veccpy.2377
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 16
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	p_calc_diffuse.2453
	addi	hp, hp, -56
	lw	ra, hp, 52
	addrl	a1, l.6858
	flw	fa0, a1, 0
	lw	a1, hp, 40
	sw	hp, 52, a0
	fsw	hp, 56, fa0
	mv	a0, a1
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	o_diffuse.2429
	addi	hp, hp, -64
	lw	ra, hp, 60
	flw	fa1, hp, 56
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq238
	li	a0, 1
	lw	a1, hp, 24
	slli	a2, a1, 2
	lw	a3, hp, 52
	add	a2, a3, a2
	sw	a2, 0, a0
	lw	a0, hp, 16
	sw	hp, 60, ra
	addi	hp, hp, 64
	call	p_energy.2455
	addi	hp, hp, -64
	lw	ra, hp, 60
	lw	a1, hp, 24
	slli	a2, a1, 2
	add	a2, a0, a2
	lw	a2, a2, 0
	addi	a3, t4, 1112
	sw	hp, 60, a0
	mv	a1, a3
	mv	a0, a2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	veccpy.2377
	addi	hp, hp, -68
	lw	ra, hp, 64
	lw	a0, hp, 24
	slli	a1, a0, 2
	lw	a2, hp, 60
	add	a1, a2, a1
	lw	a1, a1, 0
	addrl	a2, l.6977
	flw	fa0, a2, 0
	flw	fa1, hp, 48
	fmul.s	fa0, fa0, fa1
	mv	a0, a1
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	vecscale.2398
	addi	hp, hp, -68
	lw	ra, hp, 64
	lw	a0, hp, 16
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	p_nvectors.2464
	addi	hp, hp, -68
	lw	ra, hp, 64
	lw	a1, hp, 24
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	addi	a2, t4, 1124
	mv	a1, a2
	sw	hp, 64, ra
	addi	hp, hp, 68
	call	veccpy.2377
	addi	hp, hp, -68
	lw	ra, hp, 64
	j	.Cont239
.Beq238:
	nop
	li	a0, 0
	lw	a1, hp, 24
	slli	a2, a1, 2
	lw	a3, hp, 52
	add	a2, a3, a2
	sw	a2, 0, a0
.Cont239:
	nop
	addrl	a0, l.6975
	flw	fa0, a0, 0
	addi	a1, t4, 1124
	lw	a0, hp, 28
	fsw	hp, 64, fa0
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	veciprod.2383
	addi	hp, hp, -72
	lw	ra, hp, 68
	flw	fa1, hp, 64
	fmul.s	fa0, fa1, fa0
	addi	a1, t4, 1124
	lw	a0, hp, 28
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	vecaccum.2391
	addi	hp, hp, -72
	lw	ra, hp, 68
	lw	a0, hp, 40
	sw	hp, 68, ra
	addi	hp, hp, 72
	call	o_hilight.2431
	addi	hp, hp, -72
	lw	ra, hp, 68
	flw	fa1, hp, 20
	fmul.s	fa0, fa1, fa0
	li	a0, 0
	li	a1, 0
	addi	a1, a1, 1164
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	t6, hp, 12
	fsw	hp, 68, fa0
	sw	hp, 72, ra
	addi	hp, hp, 76
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -76
	lw	ra, hp, 72
	beq	a0, zero, .Beq240
	j	.Cont241
.Beq240:
	nop
	addi	a0, t4, 1124
	addi	a1, t4, 1380
	sw	hp, 72, ra
	addi	hp, hp, 76
	call	veciprod.2383
	addi	hp, hp, -76
	lw	ra, hp, 72
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 48
	fmul.s	fa0, fa0, fa1
	addi	a1, t4, 1380
	lw	a0, hp, 28
	fsw	hp, 72, fa0
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	veciprod.2383
	addi	hp, hp, -80
	lw	ra, hp, 76
	fsgnjn.s	fa1, fa0, fa0
	flw	fa0, hp, 72
	flw	fa2, hp, 68
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	add_light.2677
	addi	hp, hp, -80
	lw	ra, hp, 76
.Cont241:
	nop
	addi	a0, t4, 1140
	sw	hp, 76, ra
	addi	hp, hp, 80
	call	setup_startp.2600
	addi	hp, hp, -80
	lw	ra, hp, 76
	li	a0, 0
	add	a0, t4, a0
	lw	a0, a0, 0
	addi	a0, a0, -1
	lw	a1, hp, 28
	flw	fa0, hp, 48
	flw	fa1, hp, 68
	lw	t6, hp, 8
	sw	hp, 76, ra
	addi	hp, hp, 80
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -80
	lw	ra, hp, 76
	addrl	a0, l.6973
	flw	fa0, a0, 0
	flw	fa1, hp, 20
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq242
	ret
.Beq242:
	nop
	lw	a0, hp, 24
	addi	a1, a0, -4
	bge	a1, zero, .Bge243
	addi	a1, a0, 1
	li	a2, -1
	slli	a1, a1, 2
	lw	a3, hp, 32
	add	a1, a3, a1
	sw	a1, 0, a2
	j	.Cont244
.Bge243:
	nop
.Cont244:
	nop
	lw	a1, hp, 44
	addi	a1, a1, -2
	beq	a1, zero, .Beq245
	ret
.Beq245:
	nop
	addrl	a1, l.6817
	flw	fa0, a1, 0
	lw	a1, hp, 40
	fsw	hp, 76, fa0
	mv	a0, a1
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	o_diffuse.2429
	addi	hp, hp, -84
	lw	ra, hp, 80
	flw	fa1, hp, 76
	fsub.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 24
	addi	a0, a0, 1
	li	a1, 0
	addi	a1, a1, 1152
	add	a1, t4, a1
	flw	fa1, a1, 0
	flw	fa2, hp, 4
	fadd.s	fa1, fa2, fa1
	lw	a1, hp, 28
	lw	a2, hp, 16
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq237:
	nop
	li	a0, -1
	lw	a1, hp, 24
	slli	a2, a1, 2
	lw	a3, hp, 32
	add	a2, a3, a2
	sw	a2, 0, a0
	beq	a1, zero, .Beq246
	addi	a1, t4, 1380
	lw	a0, hp, 28
	sw	hp, 80, ra
	addi	hp, hp, 84
	call	veciprod.2383
	addi	hp, hp, -84
	lw	ra, hp, 80
	fsgnjn.s	fa0, fa0, fa0
	addrl	a0, l.6821
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq247
	ret
.Beq247:
	nop
	fmul.s	fa1, fa0, fa0
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa0, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1376
	add	a0, t4, a0
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa1, fa1, fa0
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa1, a0, 0
	fadd.s	fa0, fa1, fa0
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	fsw	a0, 0, fa0
	ret
.Beq246:
	nop
	ret
trace_diffuse_ray.2692:
	lw	a1, t6, 4
	fsw	hp, 0, fa0
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	judge_intersection_fast.2663
	addi	hp, hp, -16
	lw	ra, hp, 12
	beq	a0, zero, .Beq248
	li	a0, 0
	addi	a0, a0, 1136
	add	a0, t4, a0
	lw	a0, a0, 0
	slli	a0, a0, 2
	addi	a0, a0, 1416
	add	a0, t4, a0
	lw	a0, a0, 0
	lw	a1, hp, 8
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	d_vec.2466
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	lw	a0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	get_nvector.2671
	addi	hp, hp, -20
	lw	ra, hp, 16
	addi	a1, t4, 1140
	lw	a0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	utexture.2674
	addi	hp, hp, -20
	lw	ra, hp, 16
	li	a0, 0
	li	a1, 0
	addi	a1, a1, 1164
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	t6, hp, 4
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	beq	a0, zero, .Beq249
	ret
.Beq249:
	nop
	addi	a0, t4, 1124
	addi	a1, t4, 1380
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	veciprod.2383
	addi	hp, hp, -20
	lw	ra, hp, 16
	fsgnjn.s	fa0, fa0, fa0
	addrl	a0, l.6821
	flw	fa1, a0, 0
	fle.s	a0, fa0, fa1
	beq	a0, zero, .Beq250
	addrl	a0, l.6821
	flw	fa0, a0, 0
	j	.Cont251
.Beq250:
	nop
.Cont251:
	nop
	flw	fa1, hp, 0
	fmul.s	fa0, fa1, fa0
	lw	a0, hp, 12
	fsw	hp, 16, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_diffuse.2429
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fmul.s	fa0, fa1, fa0
	addi	a0, t4, 1100
	addi	a1, t4, 1112
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
	addrl	a0, l.6821
	flw	fa1, a0, 0
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq253
	lw	a0, hp, 16
	slli	a1, a0, 2
	lw	a2, hp, 12
	add	a1, a2, a1
	lw	a1, a1, 0
	addrl	a3, l.6984
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
	addrl	a3, l.6982
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
	lw	a3, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, a3
	mv	a0, a2
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	setup_startp.2600
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
	lw	t6, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, t6
	sw	hp, 12, a0
	beq	a0, zero, .Beq255
	li	a3, 0
	addi	a3, a3, 976
	add	a3, t4, a3
	lw	a3, a3, 0
	mv	a0, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	j	.Cont256
.Beq255:
	nop
.Cont256:
	nop
	lw	a0, hp, 12
	addi	a1, a0, -1
	beq	a1, zero, .Beq257
	li	a1, 4
	addi	a1, a1, 976
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	lw	a3, hp, 0
	lw	t6, hp, 8
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	j	.Cont258
.Beq257:
	nop
.Cont258:
	nop
	lw	a0, hp, 12
	addi	a1, a0, -2
	beq	a1, zero, .Beq259
	li	a1, 8
	addi	a1, a1, 976
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	lw	a3, hp, 0
	lw	t6, hp, 8
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	j	.Cont260
.Beq259:
	nop
.Cont260:
	nop
	lw	a0, hp, 12
	addi	a1, a0, -3
	beq	a1, zero, .Beq261
	li	a1, 12
	addi	a1, a1, 976
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	a2, hp, 4
	lw	a3, hp, 0
	lw	t6, hp, 8
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -20
	lw	ra, hp, 16
	j	.Cont262
.Beq261:
	nop
.Cont262:
	nop
	lw	a0, hp, 12
	addi	a0, a0, -4
	beq	a0, zero, .Beq263
	li	a0, 16
	addi	a0, a0, 976
	add	a0, t4, a0
	lw	a0, a0, 0
	lw	a1, hp, 4
	lw	a2, hp, 0
	lw	t6, hp, 8
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq263:
	nop
	ret
calc_diffuse_using_1point.2708:
	lw	a2, t6, 4
	sw	hp, 0, a2
	sw	hp, 4, a1
	sw	hp, 8, a0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	p_received_ray_20percent.2457
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a1, hp, 8
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_nvectors.2464
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 8
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	p_intersection_points.2449
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 8
	sw	hp, 20, a0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_energy.2455
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 12
	add	a2, a3, a2
	lw	a2, a2, 0
	addi	a3, t4, 1100
	sw	hp, 24, a0
	mv	a1, a2
	mv	a0, a3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	veccpy.2377
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 8
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	p_group_id.2459
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	slli	a3, a1, 2
	lw	a4, hp, 20
	add	a3, a4, a3
	lw	a3, a3, 0
	lw	t6, hp, 0
	mv	a1, a2
	mv	a2, a3
	sw	hp, 28, ra
	addi	hp, hp, 32
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 4
	slli	a0, a0, 2
	lw	a1, hp, 24
	add	a0, a1, a0
	lw	a1, a0, 0
	addi	a0, t4, 1088
	addi	a2, t4, 1100
	j	vecaccumv.2401
calc_diffuse_using_5points.2711:
	slli	a5, a0, 2
	add	a1, a1, a5
	lw	a1, a1, 0
	sw	hp, 0, a4
	sw	hp, 4, a3
	sw	hp, 8, a2
	sw	hp, 12, a0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_received_ray_20percent.2457
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 12
	addi	a2, a1, -1
	slli	a2, a2, 2
	lw	a3, hp, 8
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 16, a0
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	p_received_ray_20percent.2457
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 12
	slli	a2, a1, 2
	lw	a3, hp, 8
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 20, a0
	mv	a0, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_received_ray_20percent.2457
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 12
	addi	a2, a1, 1
	slli	a2, a2, 2
	lw	a3, hp, 8
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 24, a0
	mv	a0, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	p_received_ray_20percent.2457
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a1, hp, 12
	slli	a2, a1, 2
	lw	a3, hp, 4
	add	a2, a3, a2
	lw	a2, a2, 0
	sw	hp, 28, a0
	mv	a0, a2
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	p_received_ray_20percent.2457
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a1, hp, 0
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	addi	a3, t4, 1100
	sw	hp, 32, a0
	mv	a1, a2
	mv	a0, a3
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	veccpy.2377
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 0
	slli	a1, a0, 2
	lw	a2, hp, 20
	add	a1, a2, a1
	lw	a1, a1, 0
	addi	a2, t4, 1100
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecadd.2395
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 0
	slli	a1, a0, 2
	lw	a2, hp, 24
	add	a1, a2, a1
	lw	a1, a1, 0
	addi	a2, t4, 1100
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecadd.2395
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 0
	slli	a1, a0, 2
	lw	a2, hp, 28
	add	a1, a2, a1
	lw	a1, a1, 0
	addi	a2, t4, 1100
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecadd.2395
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 0
	slli	a1, a0, 2
	lw	a2, hp, 32
	add	a1, a2, a1
	lw	a1, a1, 0
	addi	a2, t4, 1100
	mv	a0, a2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	vecadd.2395
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 12
	slli	a0, a0, 2
	lw	a1, hp, 8
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	p_energy.2455
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a1, hp, 0
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a1, a0, 0
	addi	a0, t4, 1088
	addi	a2, t4, 1100
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
	li	a2, 4
	addi	a2, a2, 1080
	add	a2, t4, a2
	lw	a2, a2, 0
	addi	a3, a1, 1
	bge	a3, a2, .Ble268
	bge	zero, a1, .Ble269
	li	a1, 0
	addi	a1, a1, 1080
	add	a1, t4, a1
	lw	a1, a1, 0
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
	lw	a6, t6, 4
	slli	a7, a0, 2
	add	a7, a3, a7
	lw	a7, a7, 0
	addi	s0, a5, -4
	bge	zero, s0, .Ble276
	ret
.Ble276:
	nop
	sw	hp, 0, a1
	sw	hp, 4, t6
	sw	hp, 8, a7
	sw	hp, 12, a6
	sw	hp, 16, a5
	sw	hp, 20, a4
	sw	hp, 24, a3
	sw	hp, 28, a2
	sw	hp, 32, a0
	mv	a1, a5
	mv	a0, a7
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	get_surface_id.2724
	addi	hp, hp, -40
	lw	ra, hp, 36
	bge	a0, zero, .Bge277
	ret
.Bge277:
	nop
	lw	a0, hp, 32
	lw	a1, hp, 28
	lw	a2, hp, 24
	lw	a3, hp, 20
	lw	a4, hp, 16
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	neighbors_are_available.2727
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq278
	lw	a0, hp, 8
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	p_calc_diffuse.2453
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a4, hp, 16
	slli	a1, a4, 2
	add	a0, a0, a1
	lw	a0, a0, 0
	beq	a0, zero, .Beq279
	lw	a0, hp, 32
	lw	a1, hp, 28
	lw	a2, hp, 24
	lw	a3, hp, 20
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	calc_diffuse_using_5points.2711
	addi	hp, hp, -40
	lw	ra, hp, 36
	j	.Cont280
.Beq279:
	nop
.Cont280:
	nop
	lw	a0, hp, 16
	addi	a5, a0, 1
	lw	a0, hp, 32
	lw	a1, hp, 0
	lw	a2, hp, 28
	lw	a3, hp, 24
	lw	a4, hp, 20
	lw	t6, hp, 4
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Beq278:
	nop
	lw	a0, hp, 32
	slli	a0, a0, 2
	lw	a1, hp, 24
	add	a0, a1, a0
	lw	a0, a0, 0
	lw	a1, hp, 16
	lw	t6, hp, 12
	lw	t5, t6, 0
	jalr	zero, t5, 0
write_ppm_header.2740:
	li	a1, 80
	sw	hp, 0, a0
	mv	a0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	addi	a0, a0, 48
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 10
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 0
	addi	a0, a0, 1080
	add	a0, t4, a0
	lw	a0, a0, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 32
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 4
	addi	a0, a0, 1080
	add	a0, t4, a0
	lw	a0, a0, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_int
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 32
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_char
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 255
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_print_int
	addi	hp, hp, -8
	lw	ra, hp, 4
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
	addi	a0, a0, -3
	beq	a0, zero, .Beq289
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	write_rgb_element_char.2744
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	write_rgb_element_char.2744
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	j	write_rgb_element_char.2744
.Beq289:
	nop
	li	a0, 0
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	write_rgb_element_int.2742
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 32
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_print_char
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 4
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	write_rgb_element_int.2742
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 32
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_print_char
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 8
	addi	a0, a0, 1088
	add	a0, t4, a0
	flw	fa0, a0, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	write_rgb_element_int.2742
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 10
	j	min_caml_print_char
pretrace_diffuse_rays.2748:
	lw	a2, t6, 4
	addi	a3, a1, -4
	bge	zero, a3, .Ble290
	ret
.Ble290:
	nop
	sw	hp, 0, t6
	sw	hp, 4, a2
	sw	hp, 8, a1
	sw	hp, 12, a0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	get_surface_id.2724
	addi	hp, hp, -20
	lw	ra, hp, 16
	bge	a0, zero, .Bge291
	ret
.Bge291:
	nop
	lw	a0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_calc_diffuse.2453
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a1, hp, 8
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	beq	a0, zero, .Beq292
	lw	a0, hp, 12
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	p_group_id.2459
	addi	hp, hp, -20
	lw	ra, hp, 16
	addi	a1, t4, 1100
	sw	hp, 16, a0
	mv	a0, a1
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	vecbzero.2375
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 12
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	p_nvectors.2464
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a1, hp, 12
	sw	hp, 20, a0
	mv	a0, a1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_intersection_points.2449
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 16
	slli	a1, a1, 2
	addi	a1, a1, 976
	add	a1, t4, a1
	lw	a1, a1, 0
	lw	a2, hp, 8
	slli	a3, a2, 2
	lw	a4, hp, 20
	add	a3, a4, a3
	lw	a3, a3, 0
	slli	a4, a2, 2
	add	a0, a0, a4
	lw	a0, a0, 0
	lw	t6, hp, 4
	mv	a2, a0
	mv	a0, a1
	mv	a1, a3
	sw	hp, 24, ra
	addi	hp, hp, 28
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a0, hp, 12
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	p_received_ray_20percent.2457
	addi	hp, hp, -28
	lw	ra, hp, 24
	lw	a1, hp, 8
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, a0, 0
	addi	a2, t4, 1100
	mv	a1, a2
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	veccpy.2377
	addi	hp, hp, -28
	lw	ra, hp, 24
	j	.Cont293
.Beq292:
	nop
.Cont293:
	nop
	lw	a0, hp, 8
	addi	a1, a0, 1
	lw	a0, hp, 12
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
pretrace_pixels.2751:
	lw	a3, t6, 8
	lw	a4, t6, 4
	bge	a1, zero, .Bge294
	ret
.Bge294:
	nop
	li	a5, 0
	addi	a5, a5, 1068
	add	a5, t4, a5
	flw	fa3, a5, 0
	li	a5, 0
	addi	a5, a5, 1072
	add	a5, t4, a5
	lw	a5, a5, 0
	sub	a5, a1, a5
	sw	hp, 0, t6
	sw	hp, 4, a4
	sw	hp, 8, a2
	sw	hp, 12, a3
	sw	hp, 16, a0
	sw	hp, 20, a1
	fsw	hp, 24, fa2
	fsw	hp, 28, fa1
	fsw	hp, 32, fa0
	fsw	hp, 36, fa3
	mv	a0, a5
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	min_caml_float_of_int
	addi	hp, hp, -44
	lw	ra, hp, 40
	flw	fa1, hp, 36
	fmul.s	fa0, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1032
	add	a0, t4, a0
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	flw	fa2, hp, 32
	fadd.s	fa1, fa1, fa2
	li	a0, 0
	addi	a0, a0, 996
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 4
	addi	a0, a0, 1032
	add	a0, t4, a0
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	flw	fa3, hp, 28
	fadd.s	fa1, fa1, fa3
	li	a0, 4
	addi	a0, a0, 996
	add	a0, t4, a0
	fsw	a0, 0, fa1
	li	a0, 8
	addi	a0, a0, 1032
	add	a0, t4, a0
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	flw	fa1, hp, 24
	fadd.s	fa0, fa0, fa1
	li	a0, 8
	addi	a0, a0, 996
	add	a0, t4, a0
	fsw	a0, 0, fa0
	li	a1, 0
	addi	a0, t4, 996
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	vecunit_sgn.2380
	addi	hp, hp, -44
	lw	ra, hp, 40
	addi	a0, t4, 1088
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	vecbzero.2375
	addi	hp, hp, -44
	lw	ra, hp, 40
	addi	a0, t4, 1056
	addi	a1, t4, 1392
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	veccpy.2377
	addi	hp, hp, -44
	lw	ra, hp, 40
	li	a0, 0
	addrl	a1, l.6817
	flw	fa0, a1, 0
	lw	a1, hp, 20
	slli	a2, a1, 2
	lw	a3, hp, 16
	add	a2, a3, a2
	lw	a2, a2, 0
	addrl	a4, l.6821
	flw	fa1, a4, 0
	addi	a4, t4, 996
	lw	t6, hp, 12
	mv	a1, a4
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	p_rgb.2447
	addi	hp, hp, -44
	lw	ra, hp, 40
	addi	a1, t4, 1088
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	veccpy.2377
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	lw	a3, hp, 8
	mv	a0, a1
	mv	a1, a3
	sw	hp, 40, ra
	addi	hp, hp, 44
	call	p_set_group_id.2461
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 20
	slli	a1, a0, 2
	lw	a2, hp, 16
	add	a1, a2, a1
	lw	a1, a1, 0
	li	a3, 0
	lw	t6, hp, 4
	mv	a0, a1
	mv	a1, a3
	sw	hp, 40, ra
	addi	hp, hp, 44
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -44
	lw	ra, hp, 40
	lw	a0, hp, 20
	addi	a0, a0, -1
	li	a1, 1
	lw	a2, hp, 8
	sw	hp, 40, a0
	mv	a0, a2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	add_mod5.2364
	addi	hp, hp, -48
	lw	ra, hp, 44
	mv	a2, a0
	lw	a0, hp, 16
	lw	a1, hp, 40
	flw	fa0, hp, 32
	flw	fa1, hp, 28
	flw	fa2, hp, 24
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
pretrace_line.2758:
	lw	a3, t6, 4
	li	a4, 0
	addi	a4, a4, 1068
	add	a4, t4, a4
	flw	fa0, a4, 0
	li	a4, 4
	addi	a4, a4, 1072
	add	a4, t4, a4
	lw	a4, a4, 0
	sub	a1, a1, a4
	sw	hp, 0, a2
	sw	hp, 4, a0
	sw	hp, 8, a3
	fsw	hp, 12, fa0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_float_of_int
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fmul.s	fa0, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1020
	add	a0, t4, a0
	flw	fa1, a0, 0
	fmul.s	fa1, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa2, a0, 0
	fadd.s	fa1, fa1, fa2
	li	a0, 4
	addi	a0, a0, 1020
	add	a0, t4, a0
	flw	fa2, a0, 0
	fmul.s	fa2, fa0, fa2
	li	a0, 4
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa3, a0, 0
	fadd.s	fa2, fa2, fa3
	li	a0, 8
	addi	a0, a0, 1020
	add	a0, t4, a0
	flw	fa3, a0, 0
	fmul.s	fa0, fa0, fa3
	li	a0, 8
	addi	a0, a0, 1008
	add	a0, t4, a0
	flw	fa3, a0, 0
	fadd.s	fa0, fa0, fa3
	li	a0, 0
	addi	a0, a0, 1080
	add	a0, t4, a0
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
	lw	a6, t6, 8
	lw	a7, t6, 4
	li	s0, 0
	addi	s0, s0, 1080
	add	s0, t4, s0
	lw	s0, s0, 0
	bge	a0, s0, .Ble295
	slli	s0, a0, 2
	add	s0, a3, s0
	lw	s0, s0, 0
	sw	hp, 0, t6
	sw	hp, 4, a5
	sw	hp, 8, a2
	sw	hp, 12, a6
	sw	hp, 16, a7
	sw	hp, 20, a3
	sw	hp, 24, a4
	sw	hp, 28, a1
	sw	hp, 32, a0
	mv	a0, s0
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	p_rgb.2447
	addi	hp, hp, -40
	lw	ra, hp, 36
	mv	a1, a0
	addi	a0, t4, 1088
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	veccpy.2377
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 32
	lw	a1, hp, 28
	lw	a2, hp, 24
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	neighbors_exist.2720
	addi	hp, hp, -40
	lw	ra, hp, 36
	beq	a0, zero, .Beq296
	li	a5, 0
	lw	a0, hp, 32
	lw	a1, hp, 28
	lw	a2, hp, 8
	lw	a3, hp, 20
	lw	a4, hp, 24
	lw	t6, hp, 12
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
	j	.Cont297
.Beq296:
	nop
	lw	a0, hp, 32
	slli	a1, a0, 2
	lw	a2, hp, 20
	add	a1, a2, a1
	lw	a1, a1, 0
	li	a3, 0
	lw	t6, hp, 16
	mv	a0, a1
	mv	a1, a3
	sw	hp, 36, ra
	addi	hp, hp, 40
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -40
	lw	ra, hp, 36
.Cont297:
	nop
	lw	a0, hp, 4
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	write_rgb.2746
	addi	hp, hp, -40
	lw	ra, hp, 36
	lw	a0, hp, 32
	addi	a0, a0, 1
	lw	a1, hp, 28
	lw	a2, hp, 8
	lw	a3, hp, 20
	lw	a4, hp, 24
	lw	a5, hp, 4
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
.Ble295:
	nop
	ret
scan_line.2769:
	lw	a6, t6, 8
	lw	a7, t6, 4
	li	s0, 4
	addi	s0, s0, 1080
	add	s0, t4, s0
	lw	s0, s0, 0
	bge	a0, s0, .Ble298
	li	s0, 4
	addi	s0, s0, 1080
	add	s0, t4, s0
	lw	s0, s0, 0
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
	addrl	a2, l.6821
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
	addrl	a3, l.6821
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
	addrl	a3, l.6821
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
	addrl	a3, l.6821
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
	addrl	a3, l.6821
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
	addrl	a2, l.6821
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
	li	a1, 0
	addi	a1, a1, 1080
	add	a1, t4, a1
	lw	a1, a1, 0
	sw	hp, 0, a1
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	create_pixel.2778
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	lw	a2, hp, 0
	mv	a0, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	li	a2, 0
	addi	a2, a2, 1080
	add	a2, t4, a2
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
	addrl	a0, l.6973
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
	addrl	a0, l.6817
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
	addi	a3, a0, -5
	bge	a3, zero, .Bge302
	fsw	hp, 0, fa2
	sw	hp, 4, a2
	sw	hp, 8, a1
	fsw	hp, 12, fa3
	sw	hp, 16, a0
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa2, fa2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	adjust_position.2787
	addi	hp, hp, -24
	lw	ra, hp, 20
	lw	a0, hp, 16
	addi	a0, a0, 1
	flw	fa1, hp, 12
	fsw	hp, 20, fa0
	sw	hp, 24, a0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	adjust_position.2787
	addi	hp, hp, -32
	lw	ra, hp, 28
	fsgnj.s	fa1, fa0, fa0
	lw	a0, hp, 24
	lw	a1, hp, 8
	lw	a2, hp, 4
	flw	fa0, hp, 20
	flw	fa2, hp, 0
	flw	fa3, hp, 12
	j	calc_dirvec.2790
.Bge302:
	nop
	fmul.s	fa2, fa0, fa0
	fmul.s	fa3, fa1, fa1
	fadd.s	fa2, fa2, fa3
	addrl	a0, l.6817
	flw	fa3, a0, 0
	fadd.s	fa2, fa2, fa3
	sw	hp, 4, a2
	sw	hp, 8, a1
	fsw	hp, 28, fa1
	fsw	hp, 32, fa0
	fsgnj.s	fa0, fa2, fa2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	min_caml_sqrt
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fdiv.s	fa1, fa1, fa0
	flw	fa2, hp, 28
	fdiv.s	fa2, fa2, fa0
	addrl	a0, l.6817
	flw	fa3, a0, 0
	fdiv.s	fa0, fa3, fa0
	lw	a0, hp, 8
	slli	a0, a0, 2
	addi	a0, a0, 976
	add	a0, t4, a0
	lw	a0, a0, 0
	lw	a1, hp, 4
	slli	a2, a1, 2
	add	a2, a0, a2
	lw	a2, a2, 0
	sw	hp, 36, a0
	fsw	hp, 40, fa0
	fsw	hp, 44, fa2
	fsw	hp, 48, fa1
	mv	a0, a2
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 48
	flw	fa1, hp, 44
	flw	fa2, hp, 40
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecset.2367
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 4
	addi	a1, a0, 40
	slli	a1, a1, 2
	lw	a2, hp, 36
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 44
	fsgnjn.s	fa2, fa0, fa0
	flw	fa1, hp, 48
	flw	fa3, hp, 40
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecset.2367
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 4
	addi	a1, a0, 80
	slli	a1, a1, 2
	lw	a2, hp, 36
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 48
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 44
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 40
	fsgnj.s	fa2, fa3, fa3
	fsgnj.s	fa0, fa4, fa4
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecset.2367
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 4
	addi	a1, a0, 1
	slli	a1, a1, 2
	lw	a2, hp, 36
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 48
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 44
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 40
	fsgnjn.s	fa5, fa4, fa4
	fsgnj.s	fa2, fa5, fa5
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecset.2367
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 4
	addi	a1, a0, 41
	slli	a1, a1, 2
	lw	a2, hp, 36
	add	a1, a2, a1
	lw	a1, a1, 0
	mv	a0, a1
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 48
	fsgnjn.s	fa1, fa0, fa0
	flw	fa2, hp, 40
	fsgnjn.s	fa3, fa2, fa2
	flw	fa4, hp, 44
	fsgnj.s	fa2, fa4, fa4
	fsgnj.s	fa0, fa1, fa1
	fsgnj.s	fa1, fa3, fa3
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	vecset.2367
	addi	hp, hp, -56
	lw	ra, hp, 52
	lw	a0, hp, 4
	addi	a0, a0, 81
	slli	a0, a0, 2
	lw	a1, hp, 36
	add	a0, a1, a0
	lw	a0, a0, 0
	sw	hp, 52, ra
	addi	hp, hp, 56
	call	d_vec.2466
	addi	hp, hp, -56
	lw	ra, hp, 52
	flw	fa0, hp, 40
	fsgnjn.s	fa0, fa0, fa0
	flw	fa1, hp, 48
	flw	fa2, hp, 44
	j	vecset.2367
calc_dirvecs.2798:
	bge	a0, zero, .Bge303
	ret
.Bge303:
	nop
	sw	hp, 0, a0
	fsw	hp, 4, fa0
	sw	hp, 8, a2
	sw	hp, 12, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_float_of_int
	addi	hp, hp, -20
	lw	ra, hp, 16
	addrl	a0, l.7002
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7006
	flw	fa1, a0, 0
	fsub.s	fa2, fa0, fa1
	li	a0, 0
	addrl	a1, l.6821
	flw	fa0, a1, 0
	addrl	a1, l.6821
	flw	fa1, a1, 0
	lw	a1, hp, 12
	lw	a2, hp, 8
	flw	fa3, hp, 4
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	calc_dirvec.2790
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 0
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	min_caml_float_of_int
	addi	hp, hp, -20
	lw	ra, hp, 16
	addrl	a0, l.7002
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.6973
	flw	fa1, a0, 0
	fadd.s	fa2, fa0, fa1
	li	a0, 0
	addrl	a1, l.6821
	flw	fa0, a1, 0
	addrl	a1, l.6821
	flw	fa1, a1, 0
	lw	a1, hp, 8
	addi	a2, a1, 2
	lw	a3, hp, 12
	flw	fa3, hp, 4
	mv	a1, a3
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	calc_dirvec.2790
	addi	hp, hp, -20
	lw	ra, hp, 16
	lw	a0, hp, 0
	addi	a0, a0, -1
	li	a1, 1
	lw	a2, hp, 12
	sw	hp, 16, a0
	mv	a0, a2
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	add_mod5.2364
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	lw	a0, hp, 16
	lw	a2, hp, 8
	flw	fa0, hp, 4
	j	calc_dirvecs.2798
calc_dirvec_rows.2803:
	bge	a0, zero, .Bge304
	ret
.Bge304:
	nop
	sw	hp, 0, a0
	sw	hp, 4, a2
	sw	hp, 8, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_float_of_int
	addi	hp, hp, -16
	lw	ra, hp, 12
	addrl	a0, l.7002
	flw	fa1, a0, 0
	fmul.s	fa0, fa0, fa1
	addrl	a0, l.7006
	flw	fa1, a0, 0
	fsub.s	fa0, fa0, fa1
	li	a0, 4
	lw	a1, hp, 8
	lw	a2, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	calc_dirvecs.2798
	addi	hp, hp, -16
	lw	ra, hp, 12
	lw	a0, hp, 0
	addi	a0, a0, -1
	li	a1, 2
	lw	a2, hp, 8
	sw	hp, 12, a0
	mv	a0, a2
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	add_mod5.2364
	addi	hp, hp, -20
	lw	ra, hp, 16
	mv	a1, a0
	lw	a0, hp, 4
	addi	a2, a0, 4
	lw	a0, hp, 12
	j	calc_dirvec_rows.2803
create_dirvec.2807:
	li	a1, 3
	addrl	a2, l.6821
	flw	fa0, a2, 0
	mv	a0, a1
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array
	addi	hp, hp, -4
	lw	ra, hp, 0
	mv	a1, a0
	li	a2, 0
	addi	a2, a2, 1656
	add	a2, t4, a2
	lw	a2, a2, 0
	sw	hp, 0, a1
	mv	a0, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array
	addi	hp, hp, -8
	lw	ra, hp, 4
	mv	a1, a0
	addi	sp, sp, -8
	mv	a2, sp
	sw	a2, 4, a1
	lw	a1, hp, 0
	sw	a2, 0, a1
	mv	a0, a2
	ret
create_dirvec_elements.2809:
	bge	a1, zero, .Bge305
	ret
.Bge305:
	nop
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	create_dirvec.2807
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a1, hp, 4
	slli	a2, a1, 2
	lw	a3, hp, 0
	add	a2, a3, a2
	sw	a2, 0, a0
	addi	a1, a1, -1
	mv	a0, a3
	j	create_dirvec_elements.2809
create_dirvecs.2812:
	bge	a0, zero, .Bge306
	ret
.Bge306:
	nop
	li	a1, 120
	sw	hp, 0, a0
	sw	hp, 4, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	create_dirvec.2807
	addi	hp, hp, -12
	lw	ra, hp, 8
	mv	a1, a0
	lw	a0, hp, 4
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a1, hp, 0
	slli	a2, a1, 2
	addi	a2, a2, 976
	add	a2, t4, a2
	sw	a2, 0, a0
	slli	a0, a1, 2
	addi	a0, a0, 976
	add	a0, t4, a0
	lw	a0, a0, 0
	li	a2, 118
	mv	a1, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	create_dirvec_elements.2809
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 0
	addi	a0, a0, -1
	j	create_dirvecs.2812
init_dirvec_constants.2814:
	bge	a1, zero, .Bge307
	ret
.Bge307:
	nop
	slli	a2, a1, 2
	add	a2, a0, a2
	lw	a2, a2, 0
	sw	hp, 0, a0
	sw	hp, 4, a1
	mv	a0, a2
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	setup_dirvec_constants.2595
	addi	hp, hp, -12
	lw	ra, hp, 8
	lw	a0, hp, 4
	addi	a1, a0, -1
	lw	a0, hp, 0
	j	init_dirvec_constants.2814
init_vecset_constants.2817:
	bge	a0, zero, .Bge308
	ret
.Bge308:
	nop
	slli	a1, a0, 2
	addi	a1, a1, 976
	add	a1, t4, a1
	lw	a1, a1, 0
	li	a2, 119
	sw	hp, 0, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	init_dirvec_constants.2814
	addi	hp, hp, -8
	lw	ra, hp, 4
	lw	a0, hp, 0
	addi	a0, a0, -1
	j	init_vecset_constants.2817
init_dirvecs.2819:
	li	a0, 4
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	create_dirvecs.2812
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 9
	li	a1, 0
	li	a2, 0
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	calc_dirvec_rows.2803
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 4
	j	init_vecset_constants.2817
add_reflection.2821:
	sw	hp, 0, a0
	sw	hp, 4, a1
	fsw	hp, 8, fa0
	fsw	hp, 12, fa3
	fsw	hp, 16, fa2
	fsw	hp, 20, fa1
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	create_dirvec.2807
	addi	hp, hp, -28
	lw	ra, hp, 24
	sw	hp, 24, a0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	d_vec.2466
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa0, hp, 20
	flw	fa1, hp, 16
	flw	fa2, hp, 12
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	vecset.2367
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 24
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	setup_dirvec_constants.2595
	addi	hp, hp, -32
	lw	ra, hp, 28
	addi	sp, sp, -12
	mv	a0, sp
	flw	fa0, hp, 8
	fsw	a0, 8, fa0
	lw	a1, hp, 24
	sw	a0, 4, a1
	lw	a1, hp, 4
	sw	a0, 0, a1
	lw	a1, hp, 0
	slli	a1, a1, 2
	addi	a1, a1, 4
	add	a1, t4, a1
	sw	a1, 0, a0
	ret
setup_rect_reflection.2828:
	slli	a0, a0, 2
	li	a2, 0
	add	a2, t4, a2
	lw	a2, a2, 0
	addrl	a3, l.6817
	flw	fa0, a3, 0
	sw	hp, 0, a2
	sw	hp, 4, a0
	fsw	hp, 8, fa0
	mv	a0, a1
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_diffuse.2429
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fsub.s	fa0, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa1, a0, 0
	fsgnjn.s	fa1, fa1, fa1
	li	a0, 4
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa2, a0, 0
	fsgnjn.s	fa2, fa2, fa2
	li	a0, 8
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa3, a0, 0
	fsgnjn.s	fa3, fa3, fa3
	lw	a0, hp, 4
	addi	a1, a0, 1
	li	a2, 0
	addi	a2, a2, 1380
	add	a2, t4, a2
	flw	fa4, a2, 0
	lw	a2, hp, 0
	fsw	hp, 12, fa2
	fsw	hp, 16, fa3
	fsw	hp, 20, fa1
	fsw	hp, 24, fa0
	mv	a0, a2
	fsgnj.s	fa1, fa4, fa4
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	add_reflection.2821
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 0
	addi	a1, a0, 1
	lw	a2, hp, 4
	addi	a3, a2, 2
	li	a4, 4
	addi	a4, a4, 1380
	add	a4, t4, a4
	flw	fa2, a4, 0
	flw	fa0, hp, 24
	flw	fa1, hp, 20
	flw	fa3, hp, 16
	mv	a0, a1
	mv	a1, a3
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	add_reflection.2821
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 0
	addi	a1, a0, 2
	lw	a2, hp, 4
	addi	a2, a2, 3
	li	a3, 8
	addi	a3, a3, 1380
	add	a3, t4, a3
	flw	fa3, a3, 0
	flw	fa0, hp, 24
	flw	fa1, hp, 20
	flw	fa2, hp, 12
	mv	a0, a1
	mv	a1, a2
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	add_reflection.2821
	addi	hp, hp, -32
	lw	ra, hp, 28
	lw	a0, hp, 0
	addi	a0, a0, 3
	li	a1, 0
	add	a1, t4, a1
	sw	a1, 0, a0
	ret
setup_surface_reflection.2831:
	slli	a0, a0, 2
	addi	a0, a0, 1
	li	a2, 0
	add	a2, t4, a2
	lw	a2, a2, 0
	addrl	a3, l.6817
	flw	fa0, a3, 0
	sw	hp, 0, a0
	sw	hp, 4, a2
	sw	hp, 8, a1
	fsw	hp, 12, fa0
	mv	a0, a1
	sw	hp, 16, ra
	addi	hp, hp, 20
	call	o_diffuse.2429
	addi	hp, hp, -20
	lw	ra, hp, 16
	flw	fa1, hp, 12
	fsub.s	fa0, fa1, fa0
	lw	a0, hp, 8
	fsw	hp, 16, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	o_param_abc.2421
	addi	hp, hp, -24
	lw	ra, hp, 20
	mv	a1, a0
	addi	a0, t4, 1380
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	veciprod.2383
	addi	hp, hp, -24
	lw	ra, hp, 20
	addrl	a0, l.6838
	flw	fa1, a0, 0
	lw	a0, hp, 8
	fsw	hp, 20, fa0
	fsw	hp, 24, fa1
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	o_param_a.2415
	addi	hp, hp, -32
	lw	ra, hp, 28
	flw	fa1, hp, 24
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa0, fa0, fa1
	li	a0, 0
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa2, a0, 0
	fsub.s	fa0, fa0, fa2
	addrl	a0, l.6838
	flw	fa2, a0, 0
	lw	a0, hp, 8
	fsw	hp, 28, fa0
	fsw	hp, 32, fa2
	sw	hp, 36, ra
	addi	hp, hp, 40
	call	o_param_b.2417
	addi	hp, hp, -40
	lw	ra, hp, 36
	flw	fa1, hp, 32
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa0, fa0, fa1
	li	a0, 4
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa2, a0, 0
	fsub.s	fa0, fa0, fa2
	addrl	a0, l.6838
	flw	fa2, a0, 0
	lw	a0, hp, 8
	fsw	hp, 36, fa0
	fsw	hp, 40, fa2
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	o_param_c.2419
	addi	hp, hp, -48
	lw	ra, hp, 44
	flw	fa1, hp, 40
	fmul.s	fa0, fa1, fa0
	flw	fa1, hp, 20
	fmul.s	fa0, fa0, fa1
	li	a0, 8
	addi	a0, a0, 1380
	add	a0, t4, a0
	flw	fa1, a0, 0
	fsub.s	fa3, fa0, fa1
	lw	a0, hp, 4
	lw	a1, hp, 0
	flw	fa0, hp, 16
	flw	fa1, hp, 28
	flw	fa2, hp, 36
	sw	hp, 44, ra
	addi	hp, hp, 48
	call	add_reflection.2821
	addi	hp, hp, -48
	lw	ra, hp, 44
	lw	a0, hp, 4
	addi	a0, a0, 1
	li	a1, 0
	add	a1, t4, a1
	sw	a1, 0, a0
	ret
setup_reflections.2834:
	bge	a0, zero, .Bge309
	ret
.Bge309:
	nop
	slli	a1, a0, 2
	addi	a1, a1, 1416
	add	a1, t4, a1
	lw	a1, a1, 0
	sw	hp, 0, a0
	sw	hp, 4, a1
	mv	a0, a1
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	o_reflectiontype.2409
	addi	hp, hp, -12
	lw	ra, hp, 8
	addi	a0, a0, -2
	beq	a0, zero, .Beq310
	ret
.Beq310:
	nop
	addrl	a0, l.6817
	flw	fa0, a0, 0
	lw	a0, hp, 4
	fsw	hp, 8, fa0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_diffuse.2429
	addi	hp, hp, -16
	lw	ra, hp, 12
	flw	fa1, hp, 8
	fle.s	a0, fa1, fa0
	beq	a0, zero, .Beq311
	ret
.Beq311:
	nop
	lw	a0, hp, 4
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	o_form.2407
	addi	hp, hp, -16
	lw	ra, hp, 12
	addi	a1, a0, -1
	beq	a1, zero, .Beq312
	addi	a0, a0, -2
	beq	a0, zero, .Beq313
	ret
.Beq313:
	nop
	lw	a0, hp, 0
	lw	a1, hp, 4
	j	setup_surface_reflection.2831
.Beq312:
	nop
	lw	a0, hp, 0
	lw	a1, hp, 4
	j	setup_rect_reflection.2828
rt.2836:
	lw	a3, t6, 12
	lw	a4, t6, 8
	lw	a5, t6, 4
	li	a6, 0
	addi	a6, a6, 1080
	add	a6, t4, a6
	sw	a6, 0, a0
	li	a6, 4
	addi	a6, a6, 1080
	add	a6, t4, a6
	sw	a6, 0, a1
	srli	a6, a0, 1
	li	a7, 0
	addi	a7, a7, 1072
	add	a7, t4, a7
	sw	a7, 0, a6
	srli	a1, a1, 1
	li	a6, 4
	addi	a6, a6, 1072
	add	a6, t4, a6
	sw	a6, 0, a1
	addrl	a1, l.7018
	flw	fa0, a1, 0
	sw	hp, 0, a3
	sw	hp, 4, a4
	sw	hp, 8, a5
	sw	hp, 12, a2
	fsw	hp, 16, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	min_caml_float_of_int
	addi	hp, hp, -24
	lw	ra, hp, 20
	flw	fa1, hp, 16
	fdiv.s	fa0, fa1, fa0
	li	a0, 0
	addi	a0, a0, 1068
	add	a0, t4, a0
	fsw	a0, 0, fa0
	sw	hp, 20, ra
	addi	hp, hp, 24
	call	create_pixelline.2783
	addi	hp, hp, -24
	lw	ra, hp, 20
	sw	hp, 20, a0
	sw	hp, 24, ra
	addi	hp, hp, 28
	call	create_pixelline.2783
	addi	hp, hp, -28
	lw	ra, hp, 24
	sw	hp, 24, a0
	sw	hp, 28, ra
	addi	hp, hp, 32
	call	create_pixelline.2783
	addi	hp, hp, -32
	lw	ra, hp, 28
	sw	hp, 28, a0
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	read_parameter.2497
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 12
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	write_ppm_header.2740
	addi	hp, hp, -36
	lw	ra, hp, 32
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	init_dirvecs.2819
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 8
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	d_vec.2466
	addi	hp, hp, -36
	lw	ra, hp, 32
	addi	a1, t4, 1380
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	veccpy.2377
	addi	hp, hp, -36
	lw	ra, hp, 32
	lw	a0, hp, 8
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	setup_dirvec_constants.2595
	addi	hp, hp, -36
	lw	ra, hp, 32
	li	a0, 0
	addi	a0, a0, 1656
	add	a0, t4, a0
	lw	a0, a0, 0
	addi	a0, a0, -1
	sw	hp, 32, ra
	addi	hp, hp, 36
	call	setup_reflections.2834
	addi	hp, hp, -36
	lw	ra, hp, 32
	li	a1, 0
	li	a2, 0
	lw	a0, hp, 24
	lw	t6, hp, 4
	sw	hp, 32, ra
	addi	hp, hp, 36
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -36
	lw	ra, hp, 32
	li	a0, 0
	li	a4, 2
	lw	a1, hp, 20
	lw	a2, hp, 24
	lw	a3, hp, 28
	lw	a5, hp, 12
	lw	t6, hp, 0
	lw	t5, t6, 0
	jalr	zero, t5, 0
min_caml_start:
	li	a0, 1
	li	a1, 0
	lim	a2, 1656
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 0
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1656
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 60
	li	a1, 0
	li	a2, 0
	li	a3, 0
	li	a4, 0
	li	a5, 0
	addi	sp, sp, -44
	mv	a6, sp
	addi	a7, t4, 1656
	sw	a6, 40, a7
	addi	a7, t4, 1656
	sw	a6, 36, a7
	addi	a7, t4, 1656
	sw	a6, 32, a7
	addi	a7, t4, 1656
	sw	a6, 28, a7
	sw	a6, 24, a5
	addi	a5, t4, 1656
	sw	a6, 20, a5
	addi	a5, t4, 1656
	sw	a6, 16, a5
	sw	a6, 12, a4
	sw	a6, 8, a3
	sw	a6, 4, a2
	sw	a6, 0, a1
	mv	a1, a6
	lim	a2, 1416
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1404
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1392
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1380
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 1
	addrl	a1, l.6921
	flw	fa0, a1, 0
	lim	a1, 1376
	sw	hp, 0, ra
	addi	hp, hp, 4
	call	min_caml_create_float_array_global
	addi	hp, hp, -4
	lw	ra, hp, 0
	li	a0, 50
	li	a1, 1
	li	a2, -1
	lim	a3, 1372
	sw	hp, 0, a0
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array_global
	addi	hp, hp, -8
	lw	ra, hp, 4
	lim	a2, 1172
	addi	a1, t4, 1372
	lw	a0, hp, 0
	sw	hp, 4, ra
	addi	hp, hp, 8
	call	min_caml_create_array_global
	addi	hp, hp, -8
	lw	ra, hp, 4
	li	a0, 1
	li	a1, 1
	li	a2, 0
	addi	a2, a2, 1172
	add	a2, t4, a2
	lw	a2, a2, 0
	lim	a3, 1168
	sw	hp, 4, a0
	mv	a0, a1
	mv	a1, a2
	mv	a2, a3
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	lim	a2, 1164
	addi	a1, t4, 1168
	lw	a0, hp, 4
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 1
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1160
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 1
	li	a1, 0
	lim	a2, 1156
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 1
	addrl	a1, l.6911
	flw	fa0, a1, 0
	lim	a1, 1152
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1140
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 1
	li	a1, 0
	lim	a2, 1136
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1124
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1112
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1100
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1088
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 2
	li	a1, 0
	lim	a2, 1080
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 2
	li	a1, 0
	lim	a2, 1072
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 1
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1068
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1056
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1044
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	lim	a1, 1032
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 1020
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 1008
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 996
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 0
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 996
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 0
	li	a2, 996
	addi	a1, t4, 996
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 0
	addi	sp, sp, -8
	mv	a1, sp
	addi	a2, t4, 996
	sw	a1, 4, a2
	addi	a2, t4, 996
	sw	a1, 0, a2
	li	a2, 996
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 5
	li	a2, 976
	addi	a1, t4, 996
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 0
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 976
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 3
	addrl	a1, l.6821
	flw	fa0, a1, 0
	li	a1, 964
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_float_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	li	a0, 60
	li	a2, 724
	addi	a1, t4, 976
	sw	hp, 8, ra
	addi	hp, hp, 12
	call	min_caml_create_array_global
	addi	hp, hp, -12
	lw	ra, hp, 8
	addi	sp, sp, -8
	mv	a0, sp
	addi	a1, t4, 724
	sw	a0, 4, a1
	addi	a1, t4, 964
	sw	a0, 0, a1
	li	a1, 0
	addrl	a2, l.6821
	flw	fa0, a2, 0
	li	a2, 724
	sw	hp, 8, a0
	mv	a0, a1
	mv	a1, a2
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_float_array_global
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 0
	li	a2, 724
	addi	a1, t4, 724
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_array_global
	addi	hp, hp, -16
	lw	ra, hp, 12
	addi	sp, sp, -8
	mv	a0, sp
	addi	a1, t4, 724
	sw	a0, 4, a1
	addi	a1, t4, 724
	sw	a0, 0, a1
	li	a1, 180
	li	a2, 0
	addrl	a3, l.6821
	flw	fa0, a3, 0
	addi	sp, sp, -12
	mv	a3, sp
	fsw	a3, 8, fa0
	sw	a3, 4, a0
	sw	a3, 0, a2
	mv	a0, a3
	li	a2, 4
	mv	t5, a1
	mv	a1, a0
	mv	a0, t5
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_array_global
	addi	hp, hp, -16
	lw	ra, hp, 12
	li	a0, 1
	li	a1, 0
	li	a2, 0
	sw	hp, 12, ra
	addi	hp, hp, 16
	call	min_caml_create_array_global
	addi	hp, hp, -16
	lw	ra, hp, 12
	addi	sp, sp, -8
	mv	a0, sp
	iaddrl	a1, shadow_check_and_group.2628
	sw	a0, 0, a1
	lw	a1, hp, 8
	sw	a0, 4, a1
	addi	sp, sp, -8
	mv	a2, sp
	iaddrl	a3, shadow_check_one_or_group.2631
	sw	a2, 0, a3
	sw	a2, 4, a0
	addi	sp, sp, -12
	mv	a0, sp
	iaddrl	a3, shadow_check_one_or_matrix.2634
	sw	a0, 0, a3
	sw	a0, 8, a2
	sw	a0, 4, a1
	addi	sp, sp, -8
	mv	a2, sp
	iaddrl	a3, trace_reflections.2681
	sw	a2, 0, a3
	sw	a2, 4, a0
	addi	sp, sp, -12
	mv	a3, sp
	iaddrl	a4, trace_ray.2686
	sw	a3, 0, a4
	sw	a3, 8, a2
	sw	a3, 4, a0
	addi	sp, sp, -8
	mv	a2, sp
	iaddrl	a4, trace_diffuse_ray.2692
	sw	a2, 0, a4
	sw	a2, 4, a0
	addi	sp, sp, -8
	mv	a0, sp
	iaddrl	a4, iter_trace_diffuse_rays.2695
	sw	a0, 0, a4
	sw	a0, 4, a2
	addi	sp, sp, -8
	mv	a2, sp
	iaddrl	a4, trace_diffuse_rays.2700
	sw	a2, 0, a4
	sw	a2, 4, a0
	addi	sp, sp, -8
	mv	a0, sp
	iaddrl	a4, trace_diffuse_ray_80percent.2704
	sw	a0, 0, a4
	sw	a0, 4, a2
	addi	sp, sp, -8
	mv	a4, sp
	iaddrl	a5, calc_diffuse_using_1point.2708
	sw	a4, 0, a5
	sw	a4, 4, a0
	addi	sp, sp, -8
	mv	a0, sp
	iaddrl	a5, do_without_neighbors.2717
	sw	a0, 0, a5
	sw	a0, 4, a4
	addi	sp, sp, -8
	mv	a4, sp
	iaddrl	a5, try_exploit_neighbors.2733
	sw	a4, 0, a5
	sw	a4, 4, a0
	addi	sp, sp, -8
	mv	a5, sp
	iaddrl	a6, pretrace_diffuse_rays.2748
	sw	a5, 0, a6
	sw	a5, 4, a2
	addi	sp, sp, -12
	mv	a2, sp
	iaddrl	a6, pretrace_pixels.2751
	sw	a2, 0, a6
	sw	a2, 8, a3
	sw	a2, 4, a5
	addi	sp, sp, -8
	mv	a3, sp
	iaddrl	a5, pretrace_line.2758
	sw	a3, 0, a5
	sw	a3, 4, a2
	addi	sp, sp, -12
	mv	a2, sp
	iaddrl	a5, scan_pixel.2762
	sw	a2, 0, a5
	sw	a2, 8, a4
	sw	a2, 4, a0
	addi	sp, sp, -12
	mv	a0, sp
	iaddrl	a4, scan_line.2769
	sw	a0, 0, a4
	sw	a0, 8, a2
	sw	a0, 4, a3
	addi	sp, sp, -16
	mv	t6, sp
	iaddrl	a2, rt.2836
	sw	t6, 0, a2
	sw	t6, 12, a0
	sw	t6, 8, a3
	sw	t6, 4, a1
	li	a0, 4
	li	a1, 4
	li	a2, 3
	sw	hp, 12, ra
	addi	hp, hp, 16
	lw	t5, t6, 0
	jalr	ra, t5, 0
	addi	hp, hp, -16
	lw	ra, hp, 12
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
min_caml_create_float_array_global:
    add a3, t4, a1
min_caml_create_float_array_global_loop:
    beq a0, zero, min_caml_create_float_array_global_exit
    fsw a3, 0, fa0
    addi    a3, a3, 4
    addi  a0, a0, -1
    j min_caml_create_float_array_global_loop
min_caml_create_float_array_global_exit:
    add a0, t4, a1
    ret
min_caml_float_of_int:
    fcvt.s.w  fa0, a0
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
min_caml_create_float_array:
    beq a0, zero, create_float_array_exit
    addi  sp, sp, -4
    fsw  sp, 0, fa0
    addi  a0, a0, -1
    j min_caml_create_float_array
create_float_array_exit:
    mv  a0, sp
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
    li  a1, 512
    beq a0, a1, min_caml_print_int_512
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
min_caml_print_int_512:
    li  a2, 53
    out a2
    li  a2, 49
    out a2
    li  a2, 50
    out a2
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
l.7018:
	.data float, 128.000000
l.7006:
	.data float, 0.900000
l.7002:
	.data float, 0.200000
l.6984:
	.data float, 150.000000
l.6982:
	.data float, -150.000000
l.6977:
	.data float, 0.003906
l.6975:
	.data float, -2.000000
l.6973:
	.data float, 0.100000
l.6963:
	.data float, 0.000100
l.6961:
	.data float, 30.000000
l.6958:
	.data float, 15.000000
l.6956:
	.data float, 0.150000
l.6947:
	.data float, 0.300000
l.6944:
	.data float, 3.141593
l.6938:
	.data float, 0.250000
l.6930:
	.data float, 0.050000
l.6928:
	.data float, 20.000000
l.6926:
	.data float, 10.000000
l.6921:
	.data float, 255.000000
l.6911:
	.data float, 1000000000.000000
l.6908:
	.data float, 100000000.000000
l.6904:
	.data float, -0.100000
l.6902:
	.data float, -0.200000
l.6900:
	.data float, 0.010000
l.6858:
	.data float, 0.500000
l.6838:
	.data float, 2.000000
l.6835:
	.data float, -200.000000
l.6833:
	.data float, 200.000000
l.6830:
	.data float, 0.017453
l.6821:
	.data float, 0.000000
l.6819:
	.data float, -1.000000
l.6817:
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
