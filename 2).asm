#	Part1_2.asm - Checks for Palindromes.
#

#	Text Segment
	.text
main:
	la $a0, enter		#Output message
	li $v0, 4
	syscall
	
	la $a0, myAr		#arguments for inputting string
	li $a1, 128
	li $v0, 8		#input string
	syscall
	
	li $a0, 128
	jal check
	
mDone:	li $v0, 10		#Exit program
	syscall

#	End Of Main	

#	Methods

check:
	li $t0, 0		#Loop counter
	
loop:	lb $t1, 0x10010000($t0)	#Find where string ends
	addi $t0, $t0, 1
	bnez $t1, loop
	
	addi $t0, $t0, -3
	
	bgez $t0, res		#Continue with program only if string has any character
	
quit:	la $a0, no		#Output message
	li $v0, 4
	syscall
	j cDone
	
res:	li $t1, 0
	div $t2, $t0, 2
	
loop1:	lb $t3, 0x10010000($t1)	#Check the corresponding bytes whether they have same ascii
	lb $t4, 0x10010000($t0)
	addi $t1, $t1, 1
	addi $t0, $t0, -1
	
	bne $t3, $t4, quit	#quit if not equal
	addi $t2, $t2, -1	
	bgtz $t2, loop1		#loop again with different values to check again
	
	la $a0, yes		#Output message
	li $v0, 4
	syscall
	
cDone:	jr $ra
		
#	Data Segment
	.data
myAr:	.space	128 	#Just assuming that the inputted string will be less than 128 bytes.
			#Instructions not clear 
enter:	.asciiz "Enter String\n"
yes:	.asciiz "Its a Palindrome\n"
no:	.asciiz "Its not a Palindrome\n"

# 	End Of Part1_2.asm
