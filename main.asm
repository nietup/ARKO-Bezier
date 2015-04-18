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
                .word 0   # biWidth
                .word 0   # biHeight
                .half 0     # biPlanes
                .half 24    # biBitCount
                .word 0     # biCompression
                .word 0     # biSizeImage
                .word 0     # biXPelsPerMeter
                .word 0     # biYPelsPerMeter
                .word 0     # biClrUsed
                .word 0     # biClrImportant

bitmap_data:    .space 57600
bitmap_end:     .word 0

.text

#!!!
#WKLEIC TU POTEM:
#readInput.asm
#!!!

#!!!
#WYWALIC TO POTEM:
#hardcoded values for testing
#t1 - width
#t2 - height
li	$t1, 160
li	$t2, 120

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
sb	$t0, 2($t3)
li	$t0, 84
sb	$t0, 3($t3)

li	$t0, 76
sb	$t0, 2($t3)
li	$t0, 23
sb	$t0, 3($t3)

li	$t0, 90
sb	$t0, 2($t3)
li	$t0, 90
sb	$t0, 3($t3)
#!!!

#assighning correct size


#fill background
la      $t1, bitmap_data
la      $t2, bitmap_end
li      $t3, 0xff

fill_loop:
sb      $t3, ($t1)
addi    $t1, $t1, 1
blt     $t1, $t2, fill_loop

#save bitmap from buffer to file
li      $v0, 13			#open file
la      $a0, output		#file name
li      $a1 1			#write mode
syscall
move    $t1, $v0

li      $v0, 15			#write to file
move    $a0, $t1		#file desc
la      $a1, bitmap		#bitmap buffer
lw      $a2, bitmap_size	#buffer length
syscall

li      $v0, 16			# close file
move    $a0, $t1
syscall

exit:
li      $v0, 10
syscall
