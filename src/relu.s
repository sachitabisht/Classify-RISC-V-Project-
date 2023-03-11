.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue

    #load a0 which is pointer to array

    li t2, 0
    li t3, 1
    blt a1, t3, done
    
loop_start:
    lw t1 0(a0)
    blt t1, x0, loop_continue
    addi a0, a0, 4
    addi t2, t2, 1
    bge t2, a1, loop_end
    j loop_start

loop_continue:
    sw x0, 0(a0)
    addi a0, a0, 4
    addi t2, t2, 1
    bge t2, a1, loop_end
    j loop_start
    
loop_end:
    ret

done:
    li a0 36
    j exit
    
    jr ra