.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error Exceptions checks

    addi t1, x0, 1
    blt a1, t1, done_1 # check rows m0 > 1 #done1
    blt a2, t1, done_1 # check cols m0 > 1 #done1
    blt a4, t1, done_2 # " " m1 #done2
    blt a5, t1, done_2 # " " m1 #done2
    bne a2, a4, done_3 # check cols = rows  #done3


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
    sw s8, 32(sp)
    sw ra, 36(sp) # result addy set 
    add s0, x0, a0 # store inputs as saved registers created above
    add s1, x0, a1 # ...
    add s2, x0, a2
    add s3, x0, a3
    add s4, x0, a4
    add s5, x0, a5
    add s6, x0, a6 #...
    addi s7, x0, 0 # count \/


outer_loop_start:
    bge s7, s1, outer_loop_end #end when looped through arr size
    addi s8, x0, 0 #count for each loop reset to 0


inner_loop_start:
    bge s8, s5, inner_loop_end #end loop when len is met
    mul t0, s7, s2 #start arr mult   
    slli t0, t0, 2 
    add a0, t0, s0 #add diff vals for each arr mult
    slli t0, s8, 2          
    add a1, t0, s3 #keep adding for matrix mult formula
    add a2, x0, s2
    addi a3, x0, 1 #increments
    add a4, x0, s5                              
    jal dot #jump&link (ref) to previous dot func        
    mul t1, s7, s5          
    add t0, t1, s8
    slli t0, t0, 2
    add t0, t0, s6
    sw a0, 0(t0) #set
    addi s8, s8, 1 #ctr increase
    j inner_loop_start


inner_loop_end:
    addi s7, s7, 1 # ctr increase
    j outer_loop_start


outer_loop_end:
    lw s0, 0(sp) #restore all saved registers created at beginning
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp) # call to re-myth 
    addi sp, sp, 40 #reset stackpoint
    ret

    # error cases

done_1:
    li a0 38 #error case for dimensions of m0 < 1
    j exit

done_2:
    li a0 38 #error case for dimensions of m1 < 1
    j exit

done_3:
    li a0 38 #error case for dimensions not matching
    j exit

    jr ra
