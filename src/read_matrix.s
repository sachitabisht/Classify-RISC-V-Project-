.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -40 # create stackpoint to make space
    sw s0, 0(sp) # set up registers
    sw s1, 4(sp) # ...
    sw s2, 8(sp) 
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp) #does sp original allocation len matter?
    sw ra, 36(sp) # ra set last elem
    add s1, x0, a1 #create starting registers for inputd
    add s2, x0, a2
    add a1, x0, x0 # ...
    call fopen # call fopen, takes in a0, a1
    add s6, x0, a0 #update values for function
    blt a0, x0, done_1 # check for fopen error or eof
    add a1, x0, s1 #more updates
    addi a2, x0, 4
    call fread # call fread, takes in a0, a1, a2
    addi t0, x0, 4
    bne a0, t0, done_3 # check for fread error or eof
    add a0, x0, s6 #keep updating for reading in future
    add a1, x0, s2
    addi a2, x0, 4 # ...
    call fread # call fread, takes in a0, a1, a2
    addi t0, x0, 4
    bne a0, t0, done_3 # check for fread error or eof
    lw t0, 0(s1) #load words using our registers
    lw t1, 0(s2)
    mul s5, t0, t1 #mul for matrices
    slli s5, s5, 2
    add a0, s5, x0
    call malloc # allocate memory for file reading
    beq a0, x0, done_2 # check for memory allocation error
    add s0, x0, a0 #keep updating values for future reading
    add a0, x0, s6 #PAY close to a vs s vals
    add a1, x0, s0
    add a2, x0, s5 # ...
    call fread # call fread, takes in a0, a1, a2
    bne a0, s5, done_3 # check for fread error or eof
    add a0, x0, s6 
    call fclose # call fclose, takes in a0
    bne a0, x0, done_4 # check for fclose error or eof

    # Epilogue
    add a0, x0, s0 #final updates
    lw s0, 0(sp) # restore all saved registers created at beginning
    lw s1, 4(sp) # ...
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40 #reset stack pointer
    ret

    jr ra #avoid infinite loop

    # Error Cases:

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

