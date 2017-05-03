Code:
    .globl main
    .text

main:
    # Register: $s0: Return Address of Main

factorial:
    # Register: $a0: n
    move     $t0, $a0        # t0 = a0

done:
    move $a0, $s1       # Store sum for printing
    li $v0, 1           # 0: Print integer in $a0
    syscall

    li $v0, 10          # 10: Terminate programm
    syscall
