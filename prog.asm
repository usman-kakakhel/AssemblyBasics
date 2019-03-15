#	prog.asm - Creates program for reversal and changing of octal to decimal
#

#	Text Segment
	.text
main:
	jal interactWithUser	#Call interact with user
		
mDone:	li $v0, 10		#Exit program
	syscall


#	Methods
interactWithUser:
	#No s register are saved to the stack as so s registers were used in the main function
	#no other registers than s registers are being used and s registers are only saved when
	#used and all of them are not saved as most of them are not being used anyways.
	menuL:	la $a0, msg3		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input the menu choice
		syscall
		move $s0, $v0
		
	m1:	bne $s0, 1, m2
		la $a0, msg4		#Output message to enter octal number
		li $v0, 4
		syscall
		
		la $a0, arr
		li $a1, 11
		li $v0, 8		#Input octal number
		syscall
		
		jal convertToDec	#call octal to dec function
		
		move $a0, $v0		#print the converted decimal
		li $v0, 1
		syscall
		
	m2:	bne $s0, 2, m3
		la $a0, msg5		#Output message
		li $v0, 4
		syscall
		
		li $v0, 5		#Input decimal number
		syscall
		move $s1, $v0
		
		move $a0, $s1
		li $v0, 34		#print the required hex before reversing
		syscall
		
		la $a0, newL		#Output new line
		li $v0, 4
		syscall
		
		move $a0, $s1
		jal reverseNumber
		
		move $a0, $v0
		
		move $a0, $v0		#print the required hex
		li $v0, 34
		syscall		
		
	m3:	beq $s0, 3, iWUEnd
		j menuL

iWUEnd:	jr $ra
	

convertToDec:
	addi $sp, $sp, -8	#save only s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	move $s1, $a0		#loop counter
	add $s3, $0, $0
	
	loop:	lb $s2, 0($s1)		#Find where string ends
		addi $s1, $s1, 1
		addi $s3, $s3, 1
		bne $s2, 0xa, loop
	
		addi $s1, $s1, -2
		addi $s3, $s3, -2
	
		move $s2, $a0		#loop1 counter
		blt $s1, $s2, cTDEnd	#Continue with program only if string has any character
	
		add $s6, $0, $0		#zero the register
	
	loop1:	lb $s4, 0($s2)		#load the relevent byte
		bne $s4, 0x30, a
		addi $s7, $0, 0		#Since the byte will be in ascii find what
	a:	bne $s4, 0x31, b1	#number it maps to in octal
		addi $s7, $0, 1
	b1:	bne $s4, 0x32, c
		addi $s7, $0, 2
	c:	bne $s4, 0x33, d
		addi $s7, $0, 3
	d:	bne $s4, 0x34, e
		addi $s7, $0, 4
	e:	bne $s4, 0x35, f
		addi $s7, $0, 5
	f:	bne $s4, 0x36, g
		addi $s7, $0, 6
	g:	bne $s4, 0x37, h
		addi $s7, $0, 7
	h:
		add $s0, $0, $0		
	pow:	bge $s0, $s3, powE	#multiply the byte with 8^n n being the $s3
		mul $s7, $s7, 8
		addi $s0, $s0, 1
		j pow
	powE:
		add $s6, $s6, $s7	#add the decimal to a register
	
	en:	addi $s2, $s2, 1
		addi $s3, $s3, -1
		ble $s2, $s1, loop1	

		move $v0, $s6
cTDEnd:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra

reverseNumber:
	addi $sp, $sp, -8	#save only s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	move $s0, $a0
	
	andi $s1, $s0, 0x000000ff	#get the last two bytes in $s1
	andi $s2, $s0, 0x0000ff00	#get the middle two bytes in $s2
	andi $s3, $s0, 0x00ff0000	#get the middle two bytes in $s3
	andi $s4, $s0, 0xff000000	#get the first two bytes in $s4
	
	sll $s1, $s1, 16		#shift last two bits to first two bits
	sll $s1, $s1, 8		
	sll $s2, $s2, 8			#reverse middle two bits
	srl $s3, $s3, 8
	srl $s4, $s4, 16		#shift first two bits to last two bits	
	srl $s4, $s4, 8
	
	andi $s0, $s1, 0xff000000	#get the first two bytes from $s1
	or $s0, $s0, $s2		#get the middle two bytes from $s2
	or $s0, $s0, $s3		#get the middle two bytes from $s3
	or $s0, $s0, $s4		#get the last two bytes from $s4
	
	move $v0, $s0
	
rNEnd:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra


#	Data Segment
	.data
arr:	.space	12 #since we are going to output a 32 bit Int
		   # it can hold a max of 2,147,483,647 in decimal
		   #any space greater than 11 bytes is not required
		   #as 12 bytes in octal holds a 8,589,934,592 in decimal
newL:	.asciiz "\n"
msg3:	.asciiz	"\n\nMenu:\n1- Convert To Decimal.\n2- Reverse Number.\n3- Exit.\nEnter your choice:\n"
msg4:	.asciiz	"\nEnter Octal Number.\n"
msg5:	.asciiz	"\nEnter Decimal Number.\n"
# 	End Of Prelim.asm
