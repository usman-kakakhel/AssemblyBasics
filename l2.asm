#	prog.asm - Creates program for reversal and changing of octal to decimal
#

#	Text Segment
	.text
main:
	
	menuL:	la $a0, msg3		#Output menu message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input the menu choice
		syscall
		move $s0, $v0
		
		bne $s0, 1, m2
		jal readArray
		move $s1, $v0		#Address of array in $s1
		move $s2, $v1		#Size of array in $s2
		
	m2:	bne $s0, 2, m3
		move $a0, $s1		#Setting arguments for method
		move $a1, $s2
		jal display
		
	m3:	bne $s0, 3, m4	
		move $a0, $s1		#Setting arguments for method
		move $a1, $s2
		jal insertionSort
		
	m4:	bne $s0, 4, m5
		move $a0, $s1		#Setting arguments for method
		move $a1, $s2
		jal medianMode
		move $s2, $v0
		move $s3, $v1
		
		la $a0, msg6		#Output median message
		li $v0, 4
		syscall
		li $v0, 1
		move $a0, $s2		#output median
		syscall
		
		la $a0, msg7		#Output mode message
		li $v0, 4
		syscall
		li $v0, 1
		move $a0, $s3		#output median
		syscall
		
	m5:	beq $s0, 5, mDone
		j menuL
		
mDone:	li $v0, 10		#Exit program
	syscall


#	Methods
readArray:
	addi $sp, $sp, -12	#save s0, s1, s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	la $a0, msg4		#Output message
	li $v0, 4
	syscall
	
	li $v0, 5		#Input the menu choice
	syscall
	move $s0, $v0
	
	beqz $s0, rAEnd
	
	li $v0, 9		#allocate heap memory
	move $a0, $s0
	syscall
	
	move $s3, $v0		#address of heap in $s3
	
	move $s4, $v0		#treat $s4 as a counter
	
	li $s1, 0		#Temp reg to track loop
	loop1:	
		la $a0, msg5		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input value
		syscall
		move $s2, $v0		#We have the entered number in $s2
		
		bltz $s2, noSave
		bgt $s2, 100, noSave
		j save
		
	noSave:	la $a0, msg1		#Output message
		li $v0, 4
		syscall
		j loop1
		
	save:	sw $s2, 0($s4)		#save required word in its place
		addi $s4, $s4, 4	#update address for saving
		addi $s1, $s1, 1	#Update offset
		blt $s1, $s0, loop1	#Go back to loop
	
	move $v0, $s3
	move $v1, $s0		#returning address and number of elements
	
rAEnd:	lw $s0, 0($sp)		#load s0, s1, s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra


display:
	addi $sp, $sp, -12	#save s0, s1, s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $s2, $a0
	move $s3, $a1
	
	la $a0, newL		#Output new Line
	li $v0, 4
	syscall
	
	li $s0, 0		#Temp reg to track loop
	loop2:	
		la $a0, newL		#Output new Line
		li $v0, 4
		syscall
	
		lw $a0, 0($s2)		#Output element
		li $v0, 1
		syscall
	
		addi $s0, $s0, 1	#Update offset
		addi $s2, $s2, 4
	
		blt $s0, $s3, loop2	#Go back to loop

dDone:	lw $s0, 0($sp)		#load s0, s1, s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
insertionSort:
	addi $sp, $sp, -12	#save s0, s1, s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $s0, $a0
	addi $s0, $s0, 4
	move $s3, $a1
	li $s4, 1

	oloop:					#insertion sort
		bge $s4, $s3, oLEnd		
		
		lw $s5, 0($s0)			#load the positioned word 
		
		move $s1, $s0			#location 
		inloop:
			ble $s1, $a0, iLEnd	
			addi $s2, $s1, -4	#location -1  
			lw $s6, 0($s2)		#load loc-1
			ble $s6, $s5, iLEnd	
			
			sw $s6, 0($s1)		#save in new location if greater
			
			addi $s1, $s1, -4	
			j inloop
		iLEnd:
		sw $s5, 0($s1)		
		addi $s0, $s0, 4	#increment loop
		addi $s4, $s4, 1
		j oloop
	oLEnd:


iSEnd:	lw $s0, 0($sp)		#load s0, s1, s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra


medianMode:
	addi $sp, $sp, -12	#save s0, s1, s2 to stack
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	#median
	div $s3, $s1, 2
	mul $s4, $s3, 2
	beq $s1, $s4, even
	bne $s1, $s4, odd
	
even:	addi $s4, $s3, -1
	mul $s3, $s3, 4
	mul $s4, $s4, 4
	add $s3, $s3, $s0	#set the middle two location
	add $s4, $s4, $s0
	lw $s3, 0($s3)		#load the middle two locations
	lw $s4, 0($s4)
	add $s3, $s3, $s4	#average the 2 locations
	div $v0, $s3, 2		#put the median in the $v0 to return
	j mode
	
odd:	mul $s3, $s3, 4		#get the address of the middle location
	add $s3, $s3, $s0
	lw $v0, 0($s3)		#put the median in the $v0 to return

mode:	
	
	li $s2, 0		#loop counter
	li $s4, -100		#previous number
	li $s5, 0		#repetitions
	li $s6, 0		#max repetitions
	lw $s7, 0($s0)
modeLoop:
	bge $s2, $s1, mLEnd	#check if loop has gone long enough
	lw $s3, 0($s0)		#get the word on this location	
	
	beq $s3, $s4, eq
	bne $s3, $s4, neq
	
	eq:	addi $s5, $s5, 1
		ble $s5, $s6, fin
		
		move $s6, $s5
		move $s7, $s3
		j fin
		
	neq:	move $s4, $s3
		li $s5, 1
		
fin:	addi $s2, $s2, 1
	addi $s0, $s0, 4	
	j modeLoop
mLEnd:	move $v1, $s7

mMEnd:	lw $s0, 0($sp)		#load s0, s1, s2 from stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra
#	Data Segment
	.data
newL:	.asciiz "\n"
msg3:	.asciiz	"\n\nMenu:\n1- Enter the array.\n2- Display the array.\n3- Insertion sort.\n4- Median Mode.\n5- Exit.\nEnter your choice:\n"
msg4:	.asciiz	"\nEnter the amount of numbers to enter.\n"
msg5:	.asciiz	"\nEnter the Number.\n"
msg1:	.asciiz "\nNumber is wrong!!\n"
msg6:	.asciiz "\nMedian is :\n"
msg7:	.asciiz "\nMode is :\n"
# 	End Of Prelim.asm
