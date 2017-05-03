#int main () {
#    int i;
#    int sum = 0;
#    for (i = 0; i <= 10; i = i + 1)
#        sum = sum + i * i;
#}
Code:
    .globl main
    .text

main:
    # Register: $s0: i, $s0: sum
    li $s0, 0       # load 0 in i
    li $s1, 0       # load 0 in sum

loop:
    slti $t1, $s0, 11   # set 1 if $t1 if i > 11
    beq $t1, $zero, ready
    mul $t0, $s0, $s0   # temp reg for i*i
    add $s1, $s1, $t0   # sum = sum + i*i
    addi $s0, $s0, 1    # i++
    j loop

ready:
    move $a0, $s1       # Store sum for printing
    li $v0, 1           # 0: Print integer in $a0
    syscall

    li $v0, 10          # 10: Terminate programm
    syscall
