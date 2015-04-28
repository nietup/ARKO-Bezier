#ARKO project - Bezier Curve v1.0
#by Jakub Nietupski
#developed: april 2015
#note: for all fixed point operations precision is 16,16 

.data

output:		.asciiz "out.bmp"

width_prompt:	.asciiz "podaj szerokosc: "
height_prompt:	.asciiz "\npodaj wysokosc: "
points_prompt:	.asciiz "\npodaj 5 punktow kotrolnych (wartosci procentowe):"
x_prompt:	.asciiz "\n\nx: "
y_prompt:	.asciiz "y: "
debug:		.asciiz "\n-------------------------------------\n"

control_points:	.word 0
		.word 0
		.word 0
		.word 0
		.word 0
		.word 0
		.word 0
		.word 0
		.word 0
		.word 0

bm_data_start:	.word 0     # addres in heap

triple_w:	.word 0     # used in painting computation

# bitmap buffer (54 bytes for header)
bitmap_size:    .word 0
                .half 0

# BMP header
bitmap:         .byte 'B'   # bfType
                .byte 'M'
                .word 0     # bfSize; 
                .half 0     # bfReserved1
                .half 0     # bfReserved2
                .word 54    # bfOffBits

                .word 40    # biSize
bw:             .word 0     # biWidth
bh:             .word 0     # biHeight
                .half 0     # biPlanes
                .half 24    # biBitCount
                .word 0     # biCompression
                .word 0     # biSizeImage
                .word 0     # biXPelsPerMeter
                .word 0     # biYPelsPerMeter
                .word 0     # biClrUsed
                .word 0     # biClrImportant

#bitmap_data:    .space 57600
#bitmap_end:     .word 0

.text
#################################################
#getting input starts here

#!!!
#readInput.asm

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
#!!!

#!!!
#hardcoded, converted to fixed binary values for testing can be put here
#!!!

#assighning correct size
sw	$t1, bw
sw	$t2, bh

sll	$t4, $t1, 1
add	$t4, $t4, $t1		#width x 3

and	$t5, $t4, 3		#division by 4 check
#beqz	$t5, no_correction
li	$t6, 4
sub	$t5, $t6, $t5
and	$t5, $t5, 3
add	$t4, $t4, $t5
#no_correction:

sw	$t4, triple_w

#mul	$t4, $t1, $t2		#width x heigth x 3(bytes per pixel) + 54 (bitmap header)
#sll	$t5, $t4, 1
#add	$t5, $t5, $t4
mul	$t5, $t4, $t2
addi	$t4, $t5, 54
sw	$t4, bitmap_size

li	$v0, 9			#sbrk
move	$a0, $t5
syscall
sw	$v0, bm_data_start

#################################################
#painting starts here

#fill background
lw 	$t1, bm_data_start
add	$t2, $t1, $t5
li	$t3, 0x0

fill_next_byte:
sb	 $t3, ($t1)
addi	 $t1, $t1, 1
blt	 $t1, $t2, fill_next_byte

#beginning of casteljau algorithm
li	$t0, 0x80
lw	$s2, bw
lw	$s3, bh
casteljau_loop:
li	$t2, 0x10000
sub	$t1, $t2, $t0

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
add	$t9, $t9, $s1			#"13"

#2nd column
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$s0, $t4, $t0
srl	$s0, $s0, 16
add	$t2, $t2, $s0
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$s0, $t5, $t0
srl	$s0, $s0, 16
add	$t3, $t3, $s0			#"20"

mul	$t4, $t4, $t1
srl	$t4, $t4, 16
mul	$s0, $t6, $t0
srl	$s0, $s0, 16
add	$t4, $t4, $s0
mul	$t5, $t5, $t1
srl	$t5, $t5, 16
mul	$s0, $t7, $t0
srl	$s0, $s0, 16
add	$t5, $t5, $s0			#"21"

mul	$t6, $t6, $t1
srl	$t6, $t6, 16
mul	$s0, $t8, $t0
srl	$s0, $s0, 16
add	$t6, $t6, $s0
mul	$t7, $t7, $t1
srl	$t7, $t7, 16
mul	$s1, $t9, $t0
srl	$s1, $s1, 16
add	$t7, $t7, $s1			#"22"

#3rd column
mul	$t2, $t2, $t1
srl	$t2, $t2, 16
mul	$s0, $t4, $t0
srl	$s0, $s0, 16
add	$t2, $t2, $s0
mul	$t3, $t3, $t1
srl	$t3, $t3, 16
mul	$s0, $t5, $t0
srl	$s0, $s0, 16
add	$t3, $t3, $s0			#"30"

mul	$t4, $t4, $t1
srl	$t4, $t4, 16
mul	$s0, $t6, $t0
srl	$s0, $s0, 16
add	$t4, $t4, $s0
mul	$t5, $t5, $t1
srl	$t5, $t5, 16
mul	$s0, $t7, $t0
srl	$s0, $s0, 16
add	$t5, $t5, $s0			#"31"

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

#drawing point
# (x0, y0) =
# addr + 3 * width * (y0 - 1) + 3 * x0
# addr + 3 * width * (y0 - 1) + 3 * x0 + 1
# addr + 3 * width * (y0 - 1) + 3 * x0 + 2

#lw	$t4, bw
#lw	$t5, bh
mul	$t2, $t2, $s2			#x0
srl	$t2, $t2, 16
mul	$t3, $t3, $s3			#y0
srl	$t3, $t3, 16

lw	$t6, bm_data_start		#addr
lw	$t4, triple_w			#3 * width
subi	$t3, $t3, 1			#y0 - 1
mul	$t3, $t3, $t4			#3 * width * (y0 - 1)
sll	$t7, $t2, 1
add	$t2, $t7, $t2			#3 * x0
add	$t6, $t6, $t3
add	$t6, $t6, $t2

#li      $t3, 0x0			#putting pixel
#sb	$t3, ($t6)
#addi	$t6, $t6, 1
#li      $t3, 0x0
#sb	$t3, ($t6)
#addi	$t6, $t6, 1
addi	$t6, $t6, 2
li      $t3, 0xef
sb	$t3, ($t6)

addi	$t0, $t0, 0x80
blt	$t0, 0x10000, casteljau_loop


#################################################
#saving stuff starts here

#save bitmap from buffer to file
li      $v0, 13			#open file
la      $a0, output		#file name
li      $a1 1			#write mode
syscall
move    $t1, $v0

#write header
li      $v0, 15			#write to file
move    $a0, $t1		#file desc
la      $a1, bitmap		#bitmap buffer
li      $a2, 54			#buffer length
syscall

#write pixels
li      $v0, 15			#write to file
move    $a0, $t1		#file desc
lw      $a1, bm_data_start	#bitmap buffer
lw	$t5, bitmap_size
subi	$t5, $t5, 54
move    $a2, $t5		#buffer length
syscall

li      $v0, 16			# close file
move    $a0, $t1
syscall

exit:
li      $v0, 10
syscall
