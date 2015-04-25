# (x0, y0) =
# addr + 3 * width * (y0 - 1) + 3 * x0
# addr + 3 * width * (y0 - 1) + 3 * x0 + 1
# addr + 3 * width * (y0 - 1) + 3 * x0 + 2


#(260, 180) = addr + 3 * x * (y0 - 1) + 3 * x0 = t1 + 537 * x + 780 = t1 + 279240 + 780 = t1 + 280020
la      $t1, ($t0)
addi	$t1, 280020
li      $t3, 0xff
sb	$t3, ($t1)
addi	$t1, 1
li      $t3, 0x00
sb	$t3, ($t1)
addi	$t1, 1
li      $t3, 0xff
sb	$t3, ($t1)
addi	$t1, 1