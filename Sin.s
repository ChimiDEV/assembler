.data
# Initialization of global data
error: .asciiz "An error occured!"

# Code:
    .globl main
    .text

main:
    # Register:


power:
    # Register: $a0: n, $a1: m, $v0: result, $t0: i (for-loop)
    # n to power of m
    li      $v0, 1              # load 1 to result
    li      $t0, 1              # load 1 to i

    li      $t1, 1                  # load 1 to t1 for if condition
    beq     $a0, $zero, power_end   # if n == 0, then jump to end
    beq     $a0, $t1, power_end     # or if n == 1, then jump to end

power_loop:
    blt     $t0, $a1, power_end     # if i < m, then jump to end
    mult    $v0, $v0, $a0           # result = result * n
    addi    $t0, t0, 1              # i++
    j       power_loop              # jump to power_loop

power_end:
    jr      $ra                     # Jump back

error:
    la      $a0, error
    li      $v0, 4

done:
    move $a0, $s1       # Store sum for printing
    li $v0, 1           # 0: Print integer in $a0
    syscall

    li $v0, 10          # 10: Terminate programm
    syscall
