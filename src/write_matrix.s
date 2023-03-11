.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

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
    sw s8, 32(sp) # ...
    sw ra, 36(sp) # result addy set 
    add s1, x0, a1 # set all our registers to correlating inputs
    add s2, x0, a2
    add s3, x0, a3 # ...
    addi a1, x0, 1
    call fopen #start open function for file
    add s6, x0, a0
    blt a0, x0, done_1 #error checking for opening file
    add a0, x0, s6 #updates cont.
    addi sp, sp, -4 #updating stackpoint
    sw s2, 0(sp) #storing registers created
    add a1, x0, sp #update corresponding values
    addi a2, x0, 1 
    addi a3, x0, 4 # ...
    call fwrite #start writing for file function
    addi sp, sp, 4 #updating stackpoint
    addi t0, x0, 1
    bne a0, t0, done_5 #error checking for writing files
    add a0, x0, s6 #keep updating corresponding values
    addi sp, sp, -4
    sw s3, 0(sp) #storing registers
    add a1, x0, sp #more updating
    addi a2, x0, 1
    addi a3, x0, 4 # ...
    call fwrite #back to write function after updates
    addi sp, sp, 4 #updating stackpoint
    addi t0, x0, 1
    bne a0, t0, done_5 #error checking for writing the file
    add a0, x0, s6 #updating values cont.
    add a1, x0, s1
    mul a2, s2, s3 #mul for matrices
    addi a3, x0, 4 # ...
    call fwrite #back to writing function
    mul t0, s2, s3 #updating
    bne a0, t0, done_5 #more error checks for write
    add a0, x0, s6
    call fclose #call to close function to close file
    bne a0, x0, done_4 #error checking for closing 
    # Epilogue
    add a0, x0, s6 #final update
    lw s0, 0(sp) #restore all saved registers created at beginning
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp) # ...
    lw ra, 36(sp) # call to re-myth 
    addi sp, sp, 40 #reset stackpoint
    ret #end

    jr ra #avoid infinite loopings

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

