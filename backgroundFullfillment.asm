#pls dont do dis with x, y
#fill background
la      $t1, ($t0)
add	$t2, $t1, $t5
li      $t3, 0xff

li	$t7, 0			#"y" location on inmage
lw	$t8, bw
lw	$t9, bh
mul	$t8, $t8, 3
mul	$t9, $t9, 3

fill_loop:
li	$t6, 0			#"x" location on image

fill_row_loop:
#filling row
sb      $t3, ($t1)
addi    $t1, $t1, 1
addi	$t6, $t6, 1
blt	$t6, $t8, fill_row_loop

#next row
addi	$t7, $t7, 1
blt     $t7, $t9, fill_loop