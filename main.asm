#ARKO project - Bezier Curve v1.0
#by Jakub Nietupski
#
#Registers:
#

.data

output:         .asciiz "out.bmp"

# bmp values
bitmap_width:   .word 160
bitmap_height:  .word 120

# bitmap buffer (54 bytes for header)
bitmap_size:    .word 57654
                .half 0

# BMP header
bitmap:         .byte 'B'   # bfType
                .byte 'M'
                .word 0     # bfSize; 
                .half 0     # bfReserved1
                .half 0     # bfReserved2
                .word 54    # bfOffBits

                .word 40    # biSize
                .word 160   # biWidth
                .word 120   # biHeight
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

#fill bacgkorer
la      $t1, bitmap_data
la      $t2, bitmap_end
li      $t3, 0x88

fill_loop:
sb      $t3, ($t1)
addi    $t1, $t1, 1
blt     $t1, $t2, fill_loop

#close opened file
li      $v0, 16
move    $a0, $s0
syscall

#save bitmap from buffer to file
li      $v0, 13             #open file
la      $a0, output         #file name
li      $a1 1               #write mode
syscall
move    $t1, $v0

li      $v0, 15             #write to file
move    $a0, $t1            #file desc
la      $a1, bitmap         #bitmap buffer
lw      $a2, bitmap_size    #buffer length
syscall

li $v0, 16  # close file
move $a0, $t1
syscall


    # exit
exit:
    li $v0, 10
    syscall