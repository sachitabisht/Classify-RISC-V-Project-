.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue

    addi t3, x0, 1
    blt a2, t3, done_1
    blt a3, t3, done_2
    blt a4, t3, done_2
    addi t4, x0, 0
    addi t5, x0, 0
    slli t6, a3, 2
    slli t3, a4, 2

loop_start:
    bge t5, a2, loop_end
    lw t1 0(a0)
    lw t2 0(a1)
    mul t1, t1, t2
    add t4, t4, t1
    addi t5, t5, 1
    add a0, a0, t6
    add a1, a1, t3
    j loop_start

loop_end:
    add a0, t4, x0
    ret

done_1:
    li a0 36
    j exit

done_2:
    li a0 37
    j exit

    jr ra
