#ARKO project - Bezier Curve v1.0
#by Jakub Nietupski
#developed: april 2015

.data

output:		.asciiz "out.bmp"

width_prompt:	.asciiz "podaj szerokosc: "
height_prompt:	.asciiz "\npodaj wysokosc: "
points_prompt:	.asciiz "\npodaj 5 punktow kotrolnych (wartosci procentowe):"
x_prompt:	.asciiz "\n\nx: "
y_prompt:	.asciiz "\ny: "
debug_msg:	.asciiz "\ndopiero teraz skonczono obliczenia\n"

control_points:	.space 10

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
#hardcoded values for testing
#t1 - width
#t2 - height
li	$t1, 520
li	$t2, 380

la	$t3, control_points
li	$t0, 10
sb	$t0, ($t3)
li	$t0, 10
sb	$t0, 1($t3)

li	$t0, 30
sb	$t0, 2($t3)
li	$t0, 33
sb	$t0, 3($t3)

li	$t0, 55
sb	$t0, 4($t3)
li	$t0, 84
sb	$t0, 5($t3)

li	$t0, 76
sb	$t0, 6($t3)
li	$t0, 23
sb	$t0, 7($t3)

li	$t0, 90
sb	$t0, 8($t3)
li	$t0, 90
sb	$t0, 9($t3)
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
move	$t0, $v0

#################################################
#painting starts here


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
la      $a1, ($t0)		#bitmap buffer
move    $a2, $t5		#buffer length
syscall

li      $v0, 16			# close file
move    $a0, $t1
syscall

exit:
li      $v0, 10
syscall
