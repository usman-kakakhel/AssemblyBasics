#	Part1_1.asm - Creates Array and reverses It.
#

#	Text Segment
	.text
main:
	la $a0, msg1		#Output message
	li $v0, 4
	syscall
	
	li $v0, 5		#Input number of elements required
	syscall
	move $s0, $v0
	
	move $a1, $s0		#Arguments for insert elements in array function
	la $a2, myStr
	
	
	blez $s0, mDone		#If required elements are none then exit function
	bgt $s0, 20, mDone	#If required elements are greater than alotted space
	
	jal insert		#Call insert
	
	jal display		#Call display required argument already in $a1
	
	jal reverse		#Call reverse required argument already in $a1
	
	jal display		#Call display required argument already in $a1
	
	
mDone:	li $v0, 10		#Exit program
	syscall

#	End Of Main	

#	Methods
display:
	la $a0, newL		#Output new Line
	li $v0, 4
	syscall
	
	li $t0, 0		#Temp reg to track loop
loop2:	
	la $a0, newL		#Output new Line
	li $v0, 4
	syscall
	
	lw $a0, 0x10010000($t0)	#Output element
	li $v0, 1
	syscall
	
	addi $t0, $t0, 4	#Update offset
	
	mul $t1, $a1, 4
	blt $t0, $t1, loop2	#Go back to loop

dDone:	jr $ra

reverse:
	addi $a1, $a1, -1
	li $t0, 0		#Temp for lower offset
	mul $t1, $a1, 4		#Temp for upper offset
	div $t2, $a1, 2		#Temp for loop
	mul $t2, $t2, 4
	addi $a1, $a1, 1
	
loop3:	
	lw $t3, 0x10010000($t0)	#swap elements at lower and upper offsets
	lw $t4, 0x10010000($t1)
	sw $t3, 0x10010000($t1)
	sw $t4, 0x10010000($t0)
	
	addi $t0, $t0, 4	#Update offsets
	addi $t1, $t1, -4
	
	ble $t0, $t2, loop3	#Go to loop
	
rDone:	jr $ra

insert:
	li $t0, 0		#Temp reg to track loop
loop1:	
	la $a0, msg2		#Output message
	li $v0, 4
	syscall
	
	li $v0, 5		#Input value
	syscall
	sw $v0, 0x10010000($t0)	#Save the 4 byte word in its space
	
	addi $t0, $t0, 4	#Update offset
	
	mul $t1, $a1, 4
	blt $t0, $t1, loop1	#Go back to loop
	
iDone:	jr $ra	
		
#	Data Segment
	.data
myStr:	.space	80	#Assuming each element at most needs 4 Bytes (a word). Instructions unclear.
msg1:	.asciiz	"Enter the number of elements to enter\n"
msg2:	.asciiz	"Enter element\n"
newL:	.asciiz "\n"

# 	End Of Part1_1.asm
