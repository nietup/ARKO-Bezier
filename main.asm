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
y_prompt:	.asciiz "\ny: "
debug_msg:	.asciiz "\ndopiero teraz skonczono obliczenia\n"

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

bm_data_start:	.word 0

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
#WKLEIC TU POTEM:
#readInput.asm
#!!!

#!!!
#WYWALIC TO POTEM:
#hardcoded, converted to fixed binary values for testing
#t1 - width
#t2 - height
li	$t1, 520
li	$t2, 380

la	$t3, control_points
li	$t0, 0x1999
sw	$t0, ($t3)
li	$t0, 0x1999
sw	$t0, 4($t3)

li	$t0, 0x4ccc
sw	$t0, 8($t3)
li	$t0, 0x4ccf
sw	$t0, 12($t3)

li	$t0, 0x8ccc
sw	$t0, 16($t3)
li	$t0, 0xd70a
sw	$t0, 20($t3)

li	$t0, 0xc28f
sw	$t0, 24($t3)
li	$t0, 0x3ae1
sw	$t0, 28($t3)

li	$t0, 0xe666
sw	$t0, 32($t3)
li	$t0, 0xe666
sw	$t0, 36($t3)
#!!!

#assighning correct size
sw	$t1, bw
sw	$t2, bh

mul	$t4, $t1, $t2		#width x heigth x 3(bytes per pixel) + 54 (bitmap header)
sll	$t5, $t4, 1
add	$t5, $t5, $t4
addi	$t4, $t5, 54
sw	$t4, bitmap_size

li	$v0, 9			#sbrk
move	$a0, $t5
syscall
sb	$v0, bm_data_start

#################################################
#painting starts here

#for now, u will be incremented fo 1/16 (0x1000)
li	$t0, 0x1000
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

#drawing point


addi	$t0, $t0, 0x1000
#blt	$t0, 0x10000, casteljau_loop	

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
la      $a1, bm_data_start	#bitmap buffer
move    $a2, $t5		#buffer length
syscall

li      $v0, 16			# close file
move    $a0, $t1
syscall

exit:
li      $v0, 10
syscall
