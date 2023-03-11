.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    #Arg check
    addi t5, x0, 5 #num of arguments is 5 as given
    bne t5, a0, done_6 #error check to see if arg len is correct by equal check
    # Read pretrained m0
    addi sp, sp, -40 #create starting stackpoint to alloc for space
    sw s0, 0(sp) #start adding registers 
    sw s1, 4(sp)
    sw s2, 8(sp) 
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp) # ...
    sw ra, 36(sp) #ra set last elem
    add s0, x0, a0 #begin setting registers for our input values
    add s1, x0, a1
    add s2, x0, a2 # ...
    addi sp, sp, -8 #stackpoint alloc changes
    lw a0, 4(s1) #start loading onto args
    add a1, x0, sp #start updating inputs for stack
    addi a2, sp, 4
    call read_matrix #call on our read matrix function to complete reading of file
    add s3, x0, a0 #continue updates
    # Read pretrained m1
    addi sp, sp, -8 #cont. stackpoint var 
    lw a0, 8(s1) #load higher for stack
    add a1, x0, sp #cont. updates
    addi a2, sp, 4
    call read_matrix #call back to reading for any updates for m1
    add s4, x0, a0 #updates cont.
    # Read input matrix
    addi sp, sp, -8 #update stack
    lw a0, 12(s1) #loading higher for stack
    add a1, x0, sp #updates cont for inputs
    addi a2, sp, 4
    call read_matrix #call back to reading function for inputs
    add s5, x0, a0 #updates back 
    # Compute h = matmul(m0, input)
    lw t0, 16(sp) #loading for registers t0
    lw t1, 4(sp) #cont for t1
    mul a0, t0, t1 #mul for reg up
    slli a0, a0, 2
    call malloc #call on malloc function for memory allocation (dyn)
    beq a0, x0, done_2 #error checking for memory alloc problems
    add s6, x0, a0 #update register vals
    add a0, x0, s3 # ...
    lw a1, 16(sp) #loading for sp
    lw a2, 20(sp) # ...
    add a3, x0, s5 #updating vals
    lw a4, 0(sp) #loading for sp 
    lw a5, 4(sp) # ...
    add a6, x0, s6 
    call matmul #call on matmul function for matrices mult.
    # Compute h = relu(h)
    add a0, x0, s6 #updating vals
    lw t0, 16(sp) #loading registers for sp
    lw t1, 4(sp)
    mul a1, t0, t1 #mul for reg up.
    call relu #function call for relu to update negs
    # Compute o = matmul(m1, h)
    lw t0, 8(sp) #loading for registers
    lw t1, 4(sp) # ...
    mul a0, t0, t1 #mul for reg up.
    slli a0, a0, 2
    call malloc #call to malloc for memory alloc. (dyn)
    beq a0, x0, done_2 #error checking for memory problems
    add s7, x0, a0 #updating registers
    add a0, x0, s4 # ...
    lw a1, 8(sp) #loading for stack
    lw a2, 12(sp)
    add a3, x0, s6 #updates cont
    lw a4, 16(sp) #loading for stack
    lw a5, 4(sp)
    add a6, x0, s7 #up
    call matmul #call to matmul to mult. matrices
    # Write output matrix o
    lw a0, 16(s1) #loading inputs
    add a1, x0, s7 #update inputs
    lw a2, 8(sp) #loading for stack
    lw a3, 4(sp)
    call write_matrix #call to write function to write for file 
    # Compute and return argmax(o)
    add a0, x0, s7 #update inputs
    lw t0, 8(sp) #loading for registers
    lw t1, 4(sp) # ...
    mul a1, t0, t1 #mul for reg up
    call argmax #call to argmax function to get largest val
    add s0, x0, a0 #updating registers
    # If enabled, print argmax(o) and newline
    bne a2, x0, free_space #if needed free the mems instead of print
    call print_int #call to given func that prints int
    addi a0, x0, '\n' #adding new line
    call print_char #call to func given that prints char
    # Free Malloc Data Allocations
free_space:
    add a0, x0, s3 #need to free any mem to avoid leaks in allocating
    call free #call to free function to do so
    add a0, x0, s4 #continue for all regs used
    call free # ...
    add a0, x0, s5
    call free
    add a0, x0, s6
    call free
    add a0, x0, s7
    call free # ...
    # Epilogue
    add a0, x0, s0 #final updates
    addi sp, sp, 24 #up for stack
    lw s0, 0(sp) #restore all saved registers created at beginning
    lw s1, 4(sp) # ...
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp) # call to re-myth 
    addi sp, sp, 40 #reset stackpointer

    ret
    
    jr ra #avoid infinite looping

    # Error Codes
done_1:
    li a0 27 #error case for not opening correctly
    j exit

done_2:
    li a0 26 #error case for any malloc/mem allocation errors
    j exit

done_3:
    li a0 29 #error case for not reading correctly
    j exit

done_4:
    li a0 28 #error case for not closing correctly
    j exit

done_5:
    li a0 30 #error case for not writing correctly
    j exit

done_6:
    li a0 31 #error case for incorrect command lines args
    j exit

