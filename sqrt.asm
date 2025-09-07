	.data
nl:		.asciz	"\n"
input_prompt:	.asciz "input number you want to calculate square root of:\n"
	
	.text
	la	a0, input_prompt
	li	a7, 4
	ecall
	
	li	s0, 0	# initialize GUESS at 0 (arbitrary) 
	li	s2, 256	# STEP (start at halfway through) ... 256 with 14 fractional bits because s1 is fixed point
	slli	s2, s2, 14	# shifts to being a full
	
	# system input
	li	a7, 5	# system call, reading an int from input console
	ecall		# stops program until user presses enter
	
	slli	s3, a0, 14	# added

loop:	# Computing guess^2 (18.14 * 18.14 = 36.28 bits)
	mulhu	s1, s0, s0	# recovers UPPER 32 Bit | general:  mulh/mulhu gives higher; mul gives lower 
	mul	a1, s0, s0	# recovers LOWER 32 of the produt   # s1:a1 is now the 64 bit number     # bit shift it to recover to 32 (18.14) guess# bit shift it to recover to 32 (18.14) guess

	slli	s1, s1, 18	# lower
	srli	a1, a1, 14	# upper
	or	a2, a1, s1	# result is a 32 bit fixed point value; 18 upper, 14 fractional bits

	# NEXT: compare guess with input value  # recall a0 holds user input, and we assigned the guess (18.14) to register a2          # if guess (a2) greater than input (a0), 
	# beq	a2, s3, equal	# guess squared and input are equal 
	# bge	a2, s3, subtract	#a2,a0, ... subtract step from guess # compare guess squared to input value # then divide by 2     # if guess^2 is less than input ...     # we need to add the step to our guess
	# ble	a2, s3, add
	beq	a2, s3, half_step
	bge 	a2, s3, subtract
	j	add
	
	#subtract step from guess	# compare guess squared to input value	# then divide by 2 # add ot subtract # ble # greater than or equal to

equal:
	j	half_step	# we don't terminate immediately per the rubric
	
	
	
add:	add	s0, s0, s2	# guess (a2) = step added to guess (we are adding a step bc guess is too low)
	j	half_step

half_step:
	srli	s2, s2, 1
	bnez	s2, loop	# banch not equal zero; if not equal zero continue the loop. once zero, exit.
	j	exit


subtract:
	sub s0, s0, s2
	# subtract step to guess;   
	#sub	s0, s0, s2
	j	half_step	# j is unconditional jump statement ... use it!
	
exit:   # print out answer with sys call (if (guess^2 with input) equal or equals 0)
        # TODO: Print out answer and newline
        # TODO: decode the guess squared into a guess (power of one)
	srai	a0, s0, 14
	li	a7, 1	# prints a value of integer
	ecall
	la	a0, nl	# newline
	li	a7, 4	# prints a string
	ecall
	li	a7, 10	#system call (a7) # 10 is exit
	ecall