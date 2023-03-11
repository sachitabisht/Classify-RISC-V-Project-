.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    li t2, 0
    li t3, 1
    blt a1, t3, done
    lw t5 0(a0)
    add t4, x0, t5
    addi t6, x0, 0

loop_start:
    lw t1 0(a0)
    bge t1, t4, loop_continue #if pointer to previous value is greater than current
    addi a0, a0, 4
    addi t2, t2, 1
    bge t2, a1, loop_end
    j loop_start
    

loop_continue:
    # set pointer to previous value to current
    add t4, x0, t1
    add t6, x0, t2 
    addi a0, a0, 4
    addi t2, t2, 1 
    bge t2, a1, loop_end
    j loop_start

loop_end:
    # Epilogue
    add a0, t6, x0
    ret 

done:
    li a0 36
    j exit
    
    jr ra
