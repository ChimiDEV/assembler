.data
# Initialization of global data
error: .asciiz "An error occured!"

# Code:
    .globl main
    .text

main:
    # Register:
    li      $a0, 2
    li      $a1, 2                  # Power function always is m=2

    jal     sin0
    j       done                    # jump to end of process

power:
    # Register: $a0: n, $a1: m, $v0: result(power), $t0: i (for-loop)
    # n to power of m
    li      $v0, 1                  # load 1 to result
    li      $t0, 0                  # load 0 to i

    li      $t1, 1                  # load 1 to t1 for if condition
    beq     $a0, $zero, power_end   # if n == 0, then jump to end
    beq     $a0, $t1, power_end     # or if n == 1, then jump to end

power_loop:
    bge     $t0, $a1, func_end      # if i >= m, then jump to end
    mul     $v0, $v0, $a0           # result = result * n
    addi    $t0, $t0, 1             # i++
    j       power_loop              # jump to power_loop

sin0:
    # Register: $a0: x, $v0: result(sin), $t2: i (for-loop),
    #           $f0: numerator, $f1: denominator
    #           $s0: main adress, $s1: temp result(sin)
    li      $t1, 1                  # Load 1 in i
    li      $t2, 1                  # denominator = 1
    move    $t1, $a0                # numerator = x
    move    $v0, $a0                # result = x


func_end:
    jr      $ra


#error:
#    la      $a0, error
#    li      $v0, 4

done:
    move $a0, $v0       # Store sum for printing
    li $v0, 1           # 0: Print integer in $a0
    syscall

    li $v0, 10          # 10: Terminate programm
    syscall
