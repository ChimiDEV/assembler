.data
# Initialization of global data
tanError:       .asciiz "Undefined"
startStr:       .asciiz "Starting Value: "
endStr:         .asciiz "End Value: "
stepsStr:       .asciiz "Number of Steps: "
tableHead:      .asciiz "sin(x)\t\tcos(x)\t\ttan(x)\t\tx"
tab:            .asciiz "\t"
newLine:        .asciiz "\n"
zeroDouble:     .double 0.0
oneDouble:      .double 1.0
pi:	            .double 3.14159265359
piHalf:         .double 1.57079632679
distErr:        .double 0.00000000001

intervallErr:   .asciiz "ERROR: Start is greater than end value!"
stepErr:        .asciiz "ERROR: Number of steps must be greater than 1"

# Code:
    .globl main
    .text

main:
    # Register:
    # $f0:  function argument 'x' (may be de-/increased because of sin)
    # (reserverd $f12: print double arg)
    # $f10: start interval, $f14: end interval
    # $f16: x
    # $f18: sin(x)
    # $f20: cos(x) (AND tan(x))
    # $f22: Current step (intervall)
    # $f24: Number of steps
    # $f26: Size of step
    # $f30: Zero Double,
    # $s1: Tayloer Rounds

	l.d     $f30, zeroDouble        # Load 0.0 to $f30
    add.d   $f22, $f22, $f30        # Current step = 0
    li      $s1, 8                  # 8 talyor terms

    ### Start Value
    # Display startStr
    la      $a0, startStr
    li      $v0, 4		            # 4 -> Print String in $a0
    syscall

    # Read double from keyboard: Start Value
	li     $v0, 7       	        # 7 -> Read double to $f0
	syscall
	add.d  $f10, $f10, $f0		    # Save starting value in $f10

    ### End value
    # Display endStr
    la      $a0, endStr
    li      $v0, 4
    syscall

    # Read double from keyboard: End Value
    li      $v0, 7
    syscall
    add.d   $f14, $f14, $f0          # Save end value in $f14

    ### Error handling: Start is greater than End
    c.le.d  $f14, $f10   		    # checks if  end <= start
    cfc1    $t0, $25  			    # load FCCR into t0
    andi    $t0, 1    			    # $t0 = $t0 AND 1

    la      $a0, intervallErr
    beq     $t0, 1, error
    ###

    ### Number of Steps
    # Display stepsStr
    la      $a0, stepsStr
    li      $v0, 4
    syscall

    # Read integer from keyboard: Number of Steps
    li      $v0, 5
    syscall

    ### Error handling: Steps must be greater than 1
    la      $a0, stepErr
    ble     $v0, 1, error
    ###

    addi    $v0, $v0, -1            # Zero based loop -> number of steps = (n - 1)

    mtc1.d  $v0, $f24			    # Convert integer to double...
	cvt.d.w $f24, $f24			    # ... and save it to $f24

    # Calculate size of steps
    sub.d   $f28, $f14, $f10        # size of interval (tmp) = end - start
    div.d   $f26, $f28, $f24        # $f26: Step size = tmp/steps

    ### Printing of Outcome
    # Print Tablehead
    la      $a0, tableHead
    li      $v0, 4
    syscall

    # Print new line
    la      $a0, newLine
    li      $v0, 4
    syscall

main_loop:
    mul.d   $f28, $f22, $f26        # tmp = current step * step size (to determine current x for function)
    add.d   $f0, $f28, $f10         # (function) x = (current step * step size) + start value
    add.d   $f16, $f0, $f30         # save x for representation

    jal     sin
    add.d   $f18, $f2, $f30         # $f18 = sin(x)

    # Display sin(x)
    add.d   $f12, $f18, $f30        # $12 = sin(x) (+ 0)
    li      $v0, 3                  # 3 -> print double in $f12
    syscall

    jal     print_tabulator

    jal     cos
    add.d   $f20, $f2, $f30         # $f20 = cos(x)

    # Display cos(x)
    add.d   $f12, $f20, $f30        # $12 =  os(x)
    li      $v0, 3                  # 3 -> print double in $f12
    syscall

    jal     print_tabulator

    jal     tan
    add.d   $f20, $f2, $f30         # $f20 = tan(x) (sin and cos value no longer needed)

    # Display tan(x)
    add.d   $f12, $f20, $f30        # $12 = tan(x) (+ 0)
    li      $v0, 3                  # 3 -> print double in $f12
    syscall

    ### Continue with displaying x value (for tan error display tan is not used)
on_tanerror:
    jal     print_tabulator

    # Display x
    add.d   $f12, $f16, $f30         # $f12 = x
    li      $v0, 3
    syscall

    jal       print_newline

    ### Check conditions and increase current step
    c.lt.d  $f22, $f24              # If (enough steps are done)
    cfc1    $t0, $25                # load FCCR into t0
    andi    $t0, 1                  # t0 = t0 AND 1
    l.d     $f28, oneDouble         # tmp = 1.0
    add.d   $f22, $f22, $f28        # current step++
    beq     $t0, 1, main_loop       # if t0 = 1 -> not enough steps

    j       done                    # jump to end of process

### sin(x)
sin0:
    # Register: $f0: x, $f2: result, $f28: tmp values (e.g. x*x)
    #           $f4: numerator, $f6: denominatorDouble,
    #           $t0: i - current round (for-loop),
    #           $t1: denominator, $t2: last value for denominator
    #           $s0: main adress, $s1: rounds of taylor

    li      $t0, 1                  # Load 1 in i
    li      $t1, 1                  # denominator = 1
    li      $t2, 1                  # "last value" = 1
    add.d   $f4, $f30, $f0          # numerator = x (+ 0)
    add.d   $f2, $f30, $f0          # result = x

sin0_loop:
    mul.d   $f28, $f0, $f0          # tmp = x*x = x^2
    mul.d   $f4, $f4, $f28
    neg.d   $f4, $f4                # numerator *= (-1) * (x^2)
    #addi    $t2, $t2, 1            #
    add     $t2, $t0, $t0           # $t2 = 2i
    mul     $t1, $t1, $t2           # denominator *= 2i
    addi    $t2, $t2, 1             # $t2 = 2i + 1
    mul     $t1, $t1, $t2           # denominator *= (2i+1)

    mtc1.d  $t1, $f6
    cvt.d.w $f6, $f6                # convert denominator to double

    div.d   $f28, $f4, $f6          # tmp = numerator/denominator
    add.d   $f2, $f2, $f28          # result += res + (numerator/denominator)

    addi    $t0, $t0, 1             # i++
    bge     $t0, $s1, return_main   # jump if enough terms been calculated
    j       sin0_loop

sin:
    # Register:
    # $f0: x
    # $f2: Pi, $f4: +/- Pi/2
    # $s0: return to main, $s2: sign

    move    $s0, $ra                # Save return address

    li      $s2, 1                  # Sign
    l.d     $f2, pi                 # Load pi to $f2
    l.d     $f4, piHalf             # Load pi/2 to $f4


    jal     func_end                # Hacky way: Load address of sin in $ra

    c.le.d  $f4, $f0   		        # checks if x >= Pi/2
    cfc1    $t0, $25  			    # load FCCR into t0
    andi    $t0, 1    			    # $t0 = $t0 AND 1
    beq     $t0, 1, decrease_range  # if x > Pi/2, goes to decrease_range

	neg.d   $f4, $f4
    c.le.d  $f0, $f4   		        # checks if x <= -Pi/2
    cfc1    $t0, $25  			    # load FCCR into t0
    andi    $t0, 1    			    # $t0 = $t0 AND 1
    beq     $t0, 1, increase_range  # if x <= -Pi/2, goes to increase_range

    j       sin0

decrease_range_check:
    # Register:
    # $f0: x
    # $f4: Pi/2

    c.le.d  $f4, $f0   		        # checks if x >= Pi/2
    cfc1    $t0, $25  			    # load FCCR into t0
    andi    $t0, 1    			    # $t0 = $t0 AND 1
    beq     $t0, 1, decrease_range  # if x > Pi/2, goes to decrease_range

    j       func_end                # Return to sin

decrease_range:
    sub.d   $f0, $f0, $f2           # x = x - Pi
    li      $t0, -1
    mul     $s2, $s2, $t0           # Change sign of result

    j       decrease_range_check

increase_range_check:
    # Register:
    # $f0: x
    # $f4: - (Pi/2)
    c.le.d  $f0, $f4   		        # checks if x <= -Pi/2
    cfc1    $t0, $25  			    # load FCCR into t0
    andi    $t0, 1    			    # $t0 = $t0 AND 1
    beq     $t0, 1, increase_range  # if x <= -Pi/2, goes to increase_range

    j       func_end                # Return to sin

increase_range:
    add.d   $f0, $f0, $f2           # x = x + Pi
    li      $t0, -1
    mul     $s2, $s2, $t0           # Change sign of result

    j       increase_range_check

### cos(x)
cos:
    # Register:
    # $f0: x
    # $f4: Pi/2

    l.d     $f4, piHalf
    add.d   $f0, $f4, $f0           # x = x+ Pi/2

    j       sin                     # sin(x + Pi/2) == cos(x)

### tan(x)
tan:
    # Register:
    # $f0: x
    # $f2: result
    # $f18: sin(x)
    # $f20: cos(x)

    # Check special case
    # "tan(x) is not defined for x = kπ + π/2 with k∈Z!"
    l.d     $f4, piHalf
    sub.d   $f0, $f0, $f4
    abs.d   $f28, $f0               # Get the absolute value of the smallest x
    sub.d   $f28, $f28, $f4	    	# get the distance of x to kπ + π/2
    abs.d   $f28, $f28			    # absolute value of distance

    l.d     $f4, distErr            # Distance must be greater than distErr
    c.le.d  $f28, $f4               # Checks distance
    cfc1    $t0, $25  			    # load FCCR into t0
	andi    $t0, 1    			    # $t0 = t0 AND 1
	beq     $t0,1,tanError		    # if distance < distErr, branch tan_error

    # ELSE: Calculate tan(x) = sin(x)/cos(x)
    div.d   $f2, $f18, $f20

    j       func_end

tan_error:
    la      $a0, tanError
    li      $v0, 4
    syscall

    j       on_tanerror

### Helping routines
print_newline:
    # Print new line
    la      $a0, newLine
    li      $v0, 4
    syscall
    j       func_end

print_tabulator:
    # Print Tabulator
    la      $a0, tab
    li      $v0, 4
    syscall
    j       func_end

func_end:
    jr      $ra

return_main:
    move    $ra, $s0                # Return adress of main in $ra

    #Convert sign to double (tmp)
	mtc1.d  $s2, $f28
	cvt.d.w $f28, $f28

	mul.d   $f2, $f2, $f28	        # set sign of result

    jr      $ra

error:
    # Print error message in $a0 (set while error handling)
    li      $v0, 4                  # 4 -> Print string in $a0
    syscall
    ### Continue with terminating ->

done:
    li $v0, 10          # 10: Terminate programm
    syscall
