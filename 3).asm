#	Part1_3.asm - Calculates x = (c - d) % 16.
#	Just assuming c is always greater than d.

#	Text Segment
	.text
main:
	la $a0, msg1		#Output message
	li $v0, 4
	syscall
	
	li $v0, 5		#Input c
	syscall
	move $s0, $v0
	
	la $a0, msg2		#Output message
	li $v0, 4
	syscall
	
	li $v0, 5		#Input d
	syscall
	move $s1, $v0
	
	sub $t0, $s0, $s1	#c - d
	
	sra $t1, $t0, 4		#$t0 / 16 as shifting right is dividing by 2^n
	
	mul $t1, $t1, 16	#(c - d) - (16 * $t1) should give us x
	sub $t1, $t0, $t1
	
	la $a0, msg3		#output x
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1		
	syscall
	
mDone:	li $v0, 10		#Exit program
	syscall

#	End Of Main	

#	Methods

		
#	Data Segment
	.data
msg1:	.asciiz	"Enter value of c: \n"
msg2:	.asciiz	"Enter value of d: \n"
msg3:	.asciiz	"Value of x: "

# 	End Of Part1_3.asm
