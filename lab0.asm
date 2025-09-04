  
      .data
nl:   .asciz      "\n"

      .text
      li    s0, 0       # initialize GUESS at 0 (arbitrary) 
      li    s2, 256     # STEP (start at halfway through) ... 256 with 14 fractional bits because s1 is fixed point
      slli  s2, s2, 14 # shifts to being a full
      
      # system input
      li    a7, 5       # system call, reading an int from input console
      ecall # stops program until user presses enter

loop:       # Computing guess^2 
            mulhu       s1, a0, a0 # UPPER 32 Bit mulhu (UNSIGNED) vs mul: mulh is upper 32 bits / mul VS mulh: mulh gives upper half, mul gives lower 
            mul   a1, a0, a0 # recovers LOWER 32 of the produt
            # a0:a1 is the 64 bit number
      
      # bit shift it to recover to 32 (18.14) guess
      srli a1, a1, 14 # upper
      slli s1, s1, 18 # lower
      or a2, a1, s1
      
      # compare guess with input value
      # bge  # <a> <b> <c> ; if a >= b, then c ... greater than or equal to 
      bge   a2 a0 subtract #subtract step from guess # compare guess squared to input value # then divide by 2
      ble   a2 a0 add # if guess^2 is less than input ... 
            # we need to add the step to our guess
            
      #subtract step from guess # compare guess squared to input value # then divide by 2
      # add ot subtract
      # ble # greater than or equal to
      
      # stop condition
      # if guess^2 and original are equal
      
      
add:        addi s0 s0 s2 # guess = step added to guess (we are adding a step bc guess is too low) 
            srli s2 s2 1 # divide our guess by 2, the new value overwrites old 
            
subtract:   # subtract step to guess;     
      
exit: # print out answer with sys call (if (guess^2 with input) equal or equals 0)
      # ecall
      
# exit:     a7, 5
#     ecall
      
      
       
      