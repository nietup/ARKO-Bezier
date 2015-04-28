
#gathering resolution information
#t1 - width
#t2 - height
li      $v0, 4			#print string
la      $a0, width_prompt
syscall

li	$v0, 5			#read int
syscall
move	$t1, $v0

li      $v0, 4			#print string
la      $a0, height_prompt
syscall

li	$v0, 5			#read int
syscall
move	$t2, $v0

#gathering control points information
#t3 - array pointer
la	$t3, control_points

li      $v0, 4			#print string
la      $a0, points_prompt
syscall

#1st point
li      $v0, 4			#print string
la      $a0, x_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, ($t3)

li      $v0, 4			#print string
la      $a0, y_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 4($t3)

#2nd point
li      $v0, 4			#print string
la      $a0, x_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 8($t3)

li      $v0, 4			#print string
la      $a0, y_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 12($t3)

#3rd point
li      $v0, 4			#print string
la      $a0, x_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 16($t3)

li      $v0, 4			#print string
la      $a0, y_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 20($t3)

#4th point
li      $v0, 4			#print string
la      $a0, x_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 24($t3)

li      $v0, 4			#print string
la      $a0, y_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 28($t3)

#5th point
li      $v0, 4			#print string
la      $a0, x_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 32($t3)

li      $v0, 4			#print string
la      $a0, y_prompt
syscall

li	$v0, 5			#read int
syscall
mul	$v0, $v0, 655		#0.01 x 2^16
sw	$v0, 36($t3)