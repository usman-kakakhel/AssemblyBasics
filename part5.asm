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
	la $a2, arr
	
	
	blez $s0, mDone		#If required elements are none then exit function
	bgt $s0, 100, mDone	#If required elements are greater than alotted space
	
	jal insert		#Call insert
	
	jal display		#Call display required argument already in $a1
	
	menuL:	la $a0, msg3		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input the menu choice
		syscall
		move $s1, $v0
		
		bne $s1, 1, m2
		la $a0, msg4		#Output message
		li $v0, 4
		syscall
		li $v0, 5		#Input lower limit number
		syscall
		move $a3, $v0
		jal act1
		
	m2:	bne $s1, 2, m3
		la $a0, msg4		#Output message
		li $v0, 4
		syscall
		li $v0, 5		#Input lower limit number
		syscall
		move $a3, $v0
		la $a0, msg5		#Output message
		li $v0, 4
		syscall
		li $v0, 5		#Input upper limit number
		syscall
		move $a0, $v0
		jal act2
		
	m3:	bne $s1, 3, m4
		la $a0, msg6		#Output message
		li $v0, 4
		syscall
		li $v0, 5		#Input divisor
		syscall
		move $a3, $v0
		jal act3
		
	m4:	bne $s1, 4, m5
		jal act4
		
	m5:	beq $s1, 5, mDone
		j menuL
			
mDone:	li $v0, 10		#Exit program
	syscall


#	Methods
act1:
	addi $sp, $sp, -8	#save s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	addi $t0, $0, 0
	addi $s3, $0, 0
	mul $t1, $a1, 4
	loop4:	
		lw $s0, 0x10010000($t0)	#get the required element
		ble $s0, $a3, out	#check if greater than limit
		add $s3, $s3, $s0	#add to summation if it is
	out:	addi $t0, $t0, 4	#increment
		ble $t0, $t1, loop4	
	
	la $a0, msg7		#Output message
	li $v0, 4
	syscall	
	
	li $v0, 1
	move $a0, $s3
	syscall	
	
	la $a0, newL		#Output message
	li $v0, 4
	syscall	
	
a1Done:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
act2:
	addi $sp, $sp, -8	#save s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	addi $t0, $0, 0
	addi $s3, $0, 0
	mul $t1, $a1, 4
	loop5:	
		lw $s0, 0x10010000($t0)	#get the required element
		ble $s0, $a3, out1	#check if greater than lower limit
		bge $s0, $a0, out1	#check if lower than greater limit
		add $s3, $s3, $s0	#add to summation if it is
	out1:	addi $t0, $t0, 4	#increment
		ble $t0, $t1, loop5	
	
	la $a0, msg7		#Output message
	li $v0, 4
	syscall	
	
	li $v0, 1
	move $a0, $s3
	syscall	
	
	la $a0, newL		#Output message
	li $v0, 4
	syscall	
	
a2Done:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra

act3:
	addi $sp, $sp, -8	#save s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	addi $t0, $0, 0
	addi $s4, $0, 0
	mul $t1, $a1, 4
	loop6:	
		lw $s0, 0x10010000($t0)	#get the required element
		div $s3, $s0, $a3
		mul $s3, $s3, $a3	#divie and check if divisable
		bne $s3, $s0, l6E
		addi $s4, $s4, 1
	l6E:	addi $t0, $t0, 4	#increment
		ble $t0, $t1, loop6	
	addi $s4, $s4, -1
	la $a0, msg8		#Output message
	li $v0, 4
	syscall	
	
	li $v0, 1
	move $a0, $s4
	syscall	
	
	la $a0, newL		#Output message
	li $v0, 4
	syscall	
	
a3Done:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra

act4:
	addi $sp, $sp, -8	#save s0 and s1 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	
	addi $t0, $0, 1
	addi $s4, $0, 0
	
	oloop:					#insertion sort
		bge $t0, $a1, oLEnd
		
		mul $t1, $t0, 4			#get the word position
		lw $s0, 0x10010000($t1)		#load the positioned word
		
		move $t2, $t0			#location
		inloop:
			blez $t2, iLEnd		
			addi $t3, $t2, -1	#location -1
			mul $t3, $t3, 4		#postion loc-1 in array
			lw $s1, 0x10010000($t3)	#load loc-1
			ble $s1, $s0, iLEnd
			
			mul $t1, $t2, 4
			sw $s1, 0x10010000($t1)	#save in new location if greater
			
			addi $t2, $t2, -1
			j inloop
		iLEnd:
		mul $t1, $t2, 4
		sw $s0, 0x10010000($t1)
		addi $t0, $t0, 1	#increment loop
		j oloop
	oLEnd:
	
		addi $t0, $0, 1		#Zero 2 registers	
		addi $t1, $0, 1
		mul $t2, $t0, 4
		lw $s0, 0x10010000($0)
	forr:
		bge $t0, $a1, fEnd
		mul $t2, $t0, 4
		lw $s1, 0x10010000($t2)
		
		beq $s0, $s1, iff
		addi $t1, $t1, 1
		
	iff:	move $s0, $s1
		addi $t0, $t0, 1
		j forr
	fEnd:
	
	la $a0, msg9		#Output message
	li $v0, 4
	syscall	
	
	li $v0, 1
	move $a0, $t1
	syscall	
		
a4Done:	lw $s0, 0($sp)		#load s0 and s1 from stack
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	jr $ra

display:
	addi $sp, $sp, -4	#save s0 to stack
	sw $s0, 0($sp)
	
	la $a0, newL		#Output new Line
	li $v0, 4
	syscall
	
	li $s0, 0		#Temp reg to track loop
	loop2:	
		la $a0, newL		#Output new Line
		li $v0, 4
		syscall
	
		lw $a0, 0x10010000($s0)	#Output element
		li $v0, 1
		syscall
	
		addi $s0, $s0, 4	#Update offset
	
		mul $t1, $a1, 4
		blt $s0, $t1, loop2	#Go back to loop

dDone:	lw $s0, 0($sp)		#load s0 from stack
	addi $sp, $sp, 4
	jr $ra


insert:
	addi $sp, $sp, -4	#save s0 to stack
	sw $s0, 0($sp)
	
	li $s0, 0		#Temp reg to track loop
	loop1:	
		la $a0, msg2		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input value
		syscall
		sw $v0, 0x10010000($s0)	#Save the 4 byte word in its space
	
		addi $s0, $s0, 4	#Update offset
	
		mul $s1, $a1, 4
		blt $s0, $s1, loop1	#Go back to loop
	
iDone:	lw $s0, 0($sp)		#load s0 from stack
	addi $sp, $sp, 4
	jr $ra	




#	Data Segment
	.data
arr:	.space	400
msg1:	.asciiz	"Enter the number of elements to enter\n"
msg2:	.asciiz	"Enter element\n"
newL:	.asciiz "\n"
msg3:	.asciiz	"\n\nMenu:\n1- Find summation greater than a given number.\n2- Find summation within given range.\n3- Display number of elements divisible by given number.\n4- Display number of unique elements.\n5- Quit.\nEnter your choice:\n"
msg4:	.asciiz	"\nEnter lower limit.\n"
msg5:	.asciiz	"\nEnter upper limit.\n"
msg6:	.asciiz	"\nEnter divisor.\n"
msg7:	.asciiz	"\nSummation:"
msg8:	.asciiz	"\nOccurrences:"
msg9:	.asciiz	"\nNumber of Unique Numbers:"
# 	End Of Part4.asm
