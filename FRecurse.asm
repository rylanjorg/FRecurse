# Emmy Voita 
# 10/31/2022
# CST-307
# Bill Hughes
# This program takes an int (n) inputted by the user and finds the number in the Fibonacci sequence at n position
# Collaborated with Rylan Casanova


.data
	input_Number:	   .word 0
	output_Answer: 	   .word 0
	prompt_Message: .asciiz "Enter a number to find its fibonacci: "
	result_Message: .ascii "\nThe fibonacci at the input number is the following: "
.text
	.globl main
	main:
	
									# Read the number from the user and display the results

	li $v0, 4							# print the prompt message (string -> code = 4)
	la $a0, prompt_Message
	syscall
	
	li $v0, 5							# read in the user input
	syscall
	
	sw $v0, input_Number					# store the user input into input_Number
	

	lw 	$a0, input_Number					# load the number into register $a0
	jal	fibonacci						# execute the recursive function
	sw 	$v0, output_Answer				# save the output number into output_Answer
	
	li $v0, 4							# print the result message (string -> code = 4)
	la $a0, result_Message
	syscall
	
	li $v0, 1							# print the answer (int -> code = 1)
	lw $a0, output_Answer
	syscall


	li $v0, 10							# end of the program
	syscall


#-------------------------------------------------------------------------------------------------
# Recursive functions outline:
#
#
# fibonacci:
#	if (n > 1)
#		fib_recursive(n)
#	else
#		return n

# fib_recursive:
# 	x = fibonacci (n-1)
#	y = fibonacci (n-2)
#	return x + y
#
#------------------------------------------------------------------------------------------------

fibonacci:
	bgt	$a0, 1, fib_recursive				# invert the base case, if the_number is greater than 1, branch to fib_recursive
	move 	$v0, $a0						# return value gets put into register $v0 from $a0
	jr 	$ra							# jump register return $ra (equivalent to a return statement)

#------------------------------------------------------------------------------------------------

fib_recursive:

	sub 	$sp, $sp, 12					# 3 integers will need to be saved to the stack.
									# Thus, 12 bytes of space need to be allocated 
									# [4 bytes per integer].

	sw	$ra, 0($sp)						# Save the return address to the stack 
									# so the function can be accessed later. 

	sw	$a0, 4($sp)						# n needs to be saved to the stack as it is required 
									# to calculate n - 2.
					
	add	$a0, $a0, -1					# n-1

	jal 	fibonacci						# Jump back to fibonacci to calculate (n-1).
		
	lw 	$a0, 4($sp)						# Load the value of n previously stored on the stack.
									# This is where n is used to calculate n-2

	sw	$v0, 8($sp)						# Save fibonaccci (n-1) to the stack.
									# This is needed because $v0 will be used 
									# when calculating fibonacci(n-2)
	
	add	$a0, $a0, -2					# n-2
					
	jal 	fibonacci						# jump back to fibonacci to calculate (n-2)

	lw	$t1, 8($sp)						# load the value of fibonacci(n-1). 
									# This is going to be added to fibonacci(n-2).
									# at this point in time, the return value of 
									# fib(n-1) is in $t1 and fib(n-2) is in $v0
									
	add 	$v0, $t1, $v0					# sum $t1 -> fib(n-1) and $v0 -> fib(n-2)
	
	lw 	$ra, 0($sp)						# load the return address

	add	$sp, $sp, 12					# destory the stack

	jr	$ra							# jump to the return address