	.data
	
array: 	.space 360
menuText: .asciiz "Enter a value from 0-9 to display. Enter a -1 to Exit. "
invalidInput: .asciiz "\nInvalid Input. Please try again. Want to exit? Enter an -1 or Click cancel: "
frameBuffer: .space 0x80000	
	
	.text

	jal initializeArray	

popUpMenu:

    la $a0, menuText
    li $v0, 51 #opens a input dialog for integers
    syscall
    
    
menuOptions:
    lui $t3, 0xffff  # Resets the memory address saved in t3 to 0xffff
    
    beq $a1, 0, displayOptions # if the input dialog passes, continues to figure out what to display.
    beq $a1, -1, invalidEntry # if a user fails to enter a corect integer, jumps to invalid entry
    beq $a1, -2, exit  # If the user clicks cancel on the dialog, it exits the program.
    beq $a1, -3, invalidEntry # if the user hits okay but does 


displayOptions:
	beq $a0, -1, exit # Exits the program if the user enters a -1
	
	move $t0, $a0
	li $s0, 2
	
	div $s6, $t0, $s0
	mfhi $s4	#D
	
	div $s6, $s6, $s0
	mfhi $s3	#C

	div $s6, $s6, $s0
	mfhi $s2	#B

	div $s6, $s6, $s0
	
	mfhi $s1	#A
	
	li $t9, 1
	
SegmentA:
	add $t0,$s1,$s3	   	#A + C
	and $t1, $s2, $s4  	#BD
	xor $t2, $s2, $t9	#!B 	
	xor $t4, $s4, $t9	#!D
	and $t5, $t2, $t4	#!B!D
	add $t6, $t1, $t5	#BD + !B!D
	add $t6, $t6, $t0	#A + C + BD + !B!D

	move $t0, $t6
	
	slt $t1, $t0,$t9
	beqz $t1, 
	
SegmentB:
	xor $t0, $s2, $t9	#!B
	xor $t1, $s3, $t9	#!C
	xor $t2, $s4, $t9	#!D	
	and $t4, $t1, $t2	#!C!D
	and $t5, $s3, $s4	#CD
	add $t6,$t4, $t5	#!C!D + CD 
	add $t6, $t6, $t0	#!B + !C!D + CD	
	
	move $t0, $t6

	
SegmentC:
	xor $t0, $s3, $t9
	add $t1, $t0, $s2
	add $t1, $t1, $s4
	
	move $t0, $t1

	
SegmentD:	#fix
	xor $t0, $s2, $t9
	xor $t1, $s4, $t9
	xor $t4, $s3, $t9
	and $t2, $t0, $t1
	and $t5, $t0, $s3
	and $t6, $s3, $t0
	and $t7, $s2, $t4
	and $t7, $t7, $s4
	add $t8, $t2, $t5
	add $t8, $t8, $t6
	add $t8, $t8, $t7
	add $t8, $t8, $s1 
	
	move $t0, $t8

	
SegmentE:
	xor $t0, $s2, $t9
	xor $t1, $s4, $t9
	and $t2, $t0, $t1
	and $t4, $t1, $s3
	add $t5, $t2, $t4
	
	move $t0, $t5

	
SegmentF:
	xor $t0, $s3, $t9
	xor $t1, $s4, $t9
	and $t2, $t0, $t1
	and $t4, $s2, $t0
	and $t5, $s2, $t1
	add $t6, $t2, $t4
	add $t6, $t6, $t5
	add $t6, $t6, $s1
	
	move $t0, $t6
	
SegmentG:
	xor $t0, $s2, $t9
	and $t1, $t0, $s3
	xor $t2, $s3, $t9
	and $t4, $s2, $t2
	xor $t5, $s4, $t9
	and $t6, $s3, $t5
	add $t7, $t1, $t4
	add $t7, $t7, $t6
	add $t7, $t7, $s1
	
	move $t0, $t7
	j exit		

		
				
			
invalidEntry:
	la $a0, invalidInput #sets the messsage in the input dialog to invalid entry and has the user try again.
	li $v0, 51
    	syscall
    
    	j menuOptions



initializeArray:
    beq $t0, 360, resetPointersToZeroForReuse

    la $t1, ' ' 
    sw $t1, array($t0)
    addi $t0, $t0, 4

    j initializeArray
    
resetPointersToZeroForReuse: # Resets all saved memeory address to 0 for reuse to void conflicts from old runs.
    li $t0, 0
    li $t1, 0
    li $t2, 0
    li $t3, 0
    li $t4, 0
    li $a0, 0
    li $v0, 0

    lui $t3, 0xffff # Resets the memeory address saved in t3 to 0xffff
    jr $ra
exit: #exits the program.
    li $v0, 10
    syscall
