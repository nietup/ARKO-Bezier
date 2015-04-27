#t1 - width
#t2 - height
li	$t1, 520
li	$t2, 380

la	$t3, control_points
li	$t0, 0x1999
sw	$t0, ($t3)
li	$t0, 0x8000
sw	$t0, 4($t3)

li	$t0, 0x4ccc
sw	$t0, 8($t3)
li	$t0, 0x8000
sw	$t0, 12($t3)

li	$t0, 0x8000
sw	$t0, 16($t3)
li	$t0, 0x8000
sw	$t0, 20($t3)

li	$t0, 0xb333
sw	$t0, 24($t3)
li	$t0, 0x8000
sw	$t0, 28($t3)

li	$t0, 0xe666
sw	$t0, 32($t3)
li	$t0, 0x8000
sw	$t0, 36($t3)