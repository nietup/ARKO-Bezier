
#point calculations
#1st column
lw	$t2, control_points
lw	$t3, control_points + 4
lw	$t4, control_points + 8
lw	$t5, control_points + 12
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$t6, $t4, $t0
srl	$t6, $t6, 16
add	$t2, $t2, $t6
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$t7, $t5, $t0
srl	$t7, $t7, 16
add	$t3, $t3, $t7			#"10"

lw	$t6, control_points + 16
lw	$t7, control_points + 20
mul	$t4, $t4, $t1
srl	$t4, $t4, 16
mul	$t8, $t6, $t0
srl	$t8, $t8, 16
add	$t4, $t4, $t8
mul	$t5, $t5, $t1
srl	$t5, $t5, 16
mul	$t9, $t7, $t0
srl	$t9, $t9, 16
add	$t5, $t5, $t9			#"11"

lw	$t8, control_points + 24
lw	$t9, control_points + 28
mul	$t6, $t6, $t1
srl	$t6, $t6, 16
mul	$s0, $t8, $t0
srl	$s0, $s0, 16
add	$t6, $t6, $s0
mul	$t7, $t7, $t1
srl	$t7, $t7, 16
mul	$s1, $t9, $t0
srl	$s1, $s1, 16
add	$t7, $t7, $s1			#"12"

lw	$s0, control_points + 32
lw	$s1, control_points + 36
mul	$t8, $t8, $t1
srl	$t8, $t8, 16
mul	$s0, $s0, $t0
srl	$s0, $s0, 16
add	$t8, $t8, $s0
mul	$t9, $t9, $t1
srl	$t9, $t9, 16
mul	$s1, $s1, $t0
srl	$s1, $s1, 16
add	$t5, $t9, $s1			#"13"

#2nd column
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$t6, $t4, $t0
srl	$t6, $t6, 16
add	$t2, $t2, $t6
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$t7, $t5, $t0
srl	$t7, $t7, 16
add	$t3, $t3, $t7			#"20"

mul	$t4, $t4, $t1
srl	$t4, $t4, 16
mul	$t8, $t6, $t0
srl	$t8, $t8, 16
add	$t4, $t4, $t8
mul	$t5, $t5, $t1
srl	$t5, $t5, 16
mul	$t9, $t7, $t0
srl	$t9, $t9, 16
add	$t5, $t5, $t9			#"21"

mul	$t6, $t6, $t1
srl	$t6, $t6, 16
mul	$t8, $t8, $t0
srl	$t8, $t8, 16
add	$t6, $t6, $t8
mul	$t7, $t7, $t1
srl	$t7, $t7, 16
mul	$t9, $t9, $t0
srl	$t9, $t9, 16
add	$t7, $t7, $t9			#"22"

#3rd column
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$t6, $t4, $t0
srl	$t6, $t6, 16
add	$t2, $t2, $t6
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$t7, $t5, $t0
srl	$t7, $t7, 16
add	$t3, $t3, $t7			#"30"

mul	$t4, $t4, $t1
srl	$t4, $t4, 16
mul	$t6, $t6, $t0
srl	$t6, $t6, 16
add	$t4, $t4, $t6
mul	$t5, $t5, $t1
srl	$t5, $t5, 16
mul	$t7, $t7, $t0
srl	$t7, $t7, 16
add	$t5, $t5, $t7			#"31"

#4th column
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$t4, $t4, $t0
srl	$t4, $t4, 16
add	$t2, $t2, $t4
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$t5, $t5, $t0
srl	$t5, $t5, 16
add	$t3, $t3, $t5			#"40" - final point

#for debug:
li	$v0,4
la	$a0,x_prompt
syscall
li	$v0,1
move	$a0,$t2
syscall
li	$v0,4
la	$a0,y_prompt
syscall
li	$v0,1
move	$a0,$t3
syscall

#drawing point
# (x0, y0) =
# addr + 3 * width * (y0 - 1) + 3 * x0
# addr + 3 * width * (y0 - 1) + 3 * x0 + 1
# addr + 3 * width * (y0 - 1) + 3 * x0 + 2

lw	$t4, bw
lw	$t5, bh
mul	$t2, $t2, $t4			#x0
srl	$t2, $t2, 16
mul	$t3, $t3, $t5			#y0
srl	$t3, $t3, 16

la	$t6, bm_data_start		#addr
lw	$t4, triple_w			#3 * width
subi	$t3, $t3, 0x10000		#y0 - 1
mul	$t3, $t3, $t4
srl	$t3, $t3, 16			#3 * width * (y0 - 1)
sll	$t7, $t2, 1
add	$t2, $t7, $t2			#3 * x0
add	$t6, $t6, $t3
add	$t6, $t6, $t2

li      $t3, 0xff			#putting pixel
#sb	$t3, ($t6)
addi	$t6, $t6, 1
li      $t3, 0xff
#sb	$t3, ($t6)
addi	$t6, $t6, 1
li      $t3, 0xff
#sb	$t3, ($t6)
