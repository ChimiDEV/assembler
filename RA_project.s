	.data 
# Initialization of global data:
str1: .asciiz "Please specify a starting value: "
endval: .asciiz "Please specify an end value: "
steps: .asciiz "Please specify how many steps should be taken (must be greater than 1): "
tanerror: .asciiz "The value is too close to k * pi + pi/2 to display a tan value for n = "
tablehead: .asciiz "sin(n)\t\tcos(n)\t\ttan(n)\t\tn"
space: .asciiz "\t"
nextline: .asciiz "\n"
zeroAsDouble: .double 0.0
oneAsDouble: .double 1.0
twoAsDouble:  .double 2.0
double0: .double 1.3845
double1: .double 0.9645
double2: .double 0.6053
double3: .double 0.3211
double4: .double 0.1259
double5: .double 0.0260
double6: .double 0.0008
double7: .double 0.00000000001
pi:	 .double 3.14159265359
piHalf: .double 1.57079632679

# Code:		
	.text	
	.globl main	
main:   
	# Register usage: $f0 = aquivalent to n , $f2 = sin(n), $f6 = current n, $s0 = required terms, $f10 zero register, $f18 = starting value, $f20 = step size, $f22 = steps, $f24 = Current Round number
	
	# Load the double 0 in $f10
	l.d $f10, zeroAsDouble
	
	# Display str1
	la $a0, str1			    
	li $v0, 4		      
	syscall  				    

	#Read double from keyboard
	li $v0, 7       					
	syscall 
	add.d $f18, $f10, $f0		#Save starting value in $f18
	
	# Display endval
	la $a0, endval			    
	li $v0, 4		      
	syscall  				    

	#Read double from keyboard
	li $v0, 7       					
	syscall 
	add.d $f20, $f10, $f0		#Save end value in $f20
	
	# Display steps
	la $a0, steps			    
	li $v0, 4		      
	syscall  				    

	#Read integer from keyboard
	li $v0, 5       					
	syscall 
	addi $v0, $v0, -1
	mtc1.d $v0, $f22			#Convert integer to double
	cvt.d.w $f22, $f22			#Save number of steps in $f22
	
	l.d $f24, zeroAsDouble		#Current Round number: 0
	sub.d $f20, $f20, $f18		#size of the interval to be calculated
	div.d $f20, $f20, $f22		#$f20 = step size
	
	# print tablehead on terminal 
	la $a0, tablehead
	li $v0, 4		      
	syscall
	
	#print nextline on terminal
	la $a0, nextline
	li $v0, 4		      
	syscall	
	
loopMain:
	mul.d $f4, $f24, $f20
	add.d $f6, $f4, $f18	# save current n in $f6
	add.d $f0, $f6, $f10	# put current n in $f0
	
	jal sin					# calculate the sin
	add.d $f30, $f10, $f2 	# save sin(n) in $f30			
	
	#Display sin(n)
	li $v0, 3			
	add.d $f12,$f10, $f30	
	syscall				
	
	# print space on terminal 
	la $a0, space
	li $v0, 4		      
	syscall 				
	
	
	jal cos					# calculate the cos
	add.d $f28, $f10, $f2	# save cos(n) in $f28
	
	#Display cos(n)
	li $v0, 3			
	add.d $f12,$f10, $f28 	
	syscall		
	
	# print space on terminal 
	la $a0, space
	li $v0, 4		      
	syscall				
	
	jal tan					# calculate the tan	

	#Check if enough steps have been calculated
	c.lt.d $f24,$f22   		# checks if enough steps have been executed
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	l.d $f4, oneAsDouble	# put one in $f4
	add.d $f24, $f24, $f4	# increase current round by 1
	beq $t1,1,loopMain     	# if more steps are needed, go to loopMain

	#Print 2 empty lines on the terminal
	la $a0, nextline
	li $v0, 4		      
	syscall	
	syscall
	
	j main
	
termCalc:
	# Register usage: $f0 = n, $f2 = absolute value of n $f4 = value to compare to, $v0 = required terms, $t1 = flag
	### TODO Push hardcoded values to Stack###
	
	abs.d $f2, $f0			
	
	l.d $f4, double0		# load comparising value in $f4
	c.le.d $f4,$f2  		# checks if absolute of $f0 >= 1.3845 
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only
	beq $t1,1,label1     	# if $f0 > 1.3845, goes to label1
	
	l.d $f4, double1		# load comparising value in $f4
	c.le.d $f4,$f2   		# checks if absolute of $f0 >= 0.9645
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only
	beq $t1,1,label2     	# if $f0 > 0.9645, goes to label2
	
	l.d $f4, double2		# load comparising value in $f4
	c.le.d $f4,$f2   		# checks if absolute of $f0 >= 0.6053
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only
	beq $t1,1,label3     	# if $f0 > 0.6053, goes to label3
	
	l.d $f4, double3		# load comparising value in $f4
	c.le.d $f4,$f2   		# checks if absolute of $f0 >= 0.3211
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,label4     	# if $f0 > 0.3211, goes to label4
	
	l.d $f4, double4		# load comparising value in $f4
	c.le.d $f4,$f2   		# checks if absolute of $f0 >= 0.1259
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,label5     	# if $f0 > 0.1259, goes to label5
	
	l.d $f4, double5		# load comparising value in $f4
	c.le.d $f4,$f2    		# checks if absolute of $f0 >= 0.026
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,label6     	# if $f0 > 0.026, goes to label6
	
	l.d $f4, double6		# load comparising value in $f4
	c.le.d $f4,$f2   		# checks if absolute of $f0 >= 0.0008
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,label7     	# if $f0 > 0.0008, goes to label7
	
	li $v0,1				# $f0 < 0.0008 --> 1 term is enough
	j ret					
label1:
	li $v0, 8				# 8 terms required
	j ret
label2:
	li $v0, 7				# 7 terms required
	j ret
label3:
	li $v0, 6				# 6 terms required
	j ret
label4:
	li $v0, 5				# 5 terms required
	j ret
label5:
	li $v0, 4				# 4 terms required
	j ret
label6:
	li $v0, 3				# 3 terms required
	j ret
label7:
	li $v0, 2				# 2 terms required
	j ret

sin0: 	
	# Register usage:  $f0 = n,  $s0 = required rounds, $s1 = return address to main $t0 = current round, $f4 = numerator, $t1 = denominator, $t2 = value last multiplied to denominator, $f8 = current term, $f2 = res, $f14 = denominator as double
	
	jal termCalc			# Calculate required term number for accurate result
	move $s0, $v0			# save number of required terms
	
	add.d $f2, $f0, $f10	# res = n
	li $t0, 1				# i = 1
	add.d $f4, $f10, $f0	# numerator = n 
	li $t1, 1 				# denominator = 1
	li $t2, 1				# last multiplied number to the denominator is 1
loop:
	mul.d $f4, $f4, $f0	
	mul.d $f4, $f4, $f0	
	neg.d $f4, $f4			# numerator = numerator * n^2 * (-1)
	addi $t2, $t2, 1		# $t2 = 2i
	mul $t1, $t1, $t2		# denominator = denominator * (2i)
	addi $t2, $t2, 1		# $t2 = 2i +1
	mul $t1, $t1, $t2		# denominator = denominator * (2i + 1)
	
	#Convert denominator to double
	mtc1.d $t1, $f14
	cvt.d.w $f14, $f14
	
	div.d $f8, $f4, $f14	# current term = numerator/denominator
	add.d $f2, $f2, $f8		# res = res + (numerator/denominator)
	addi $t0, $t0, 1		# current round is set 1 up
	bge  $t0, $s0, retMain	# if enough terms have been calculated: exit!
	j loop

ret:
	jr $ra					# return to previous programm
	
retMain:
	move $ra, $s1			# return address for main
	
	#Convert sign to double
	mtc1.d $s2, $f16
	cvt.d.w $f16, $f16
	
	mul.d $f2, $f2, $f16	# set sign of result
	
	jr $ra
	
sin:
	# Register Usage: $f0 = n, $f2 = Pi, $f10 = zero register, $f4 = +/- Pi/2, $s1 = return address to main, $s2 = sign of the result
	
	move $s1, $ra			#save return address for main
	
	li $s2, 1
	
	l.d $f2, pi 			#load pi into $f2
	l.d $f4, piHalf			# load pi/2 into $f4
	
	jal ret					# load address of sin in $ra
	
	c.le.d $f4,$f0   		# checks if $f0 >= Pi/2
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,decreaseN  	# if $f0 > Pi/2, goes to decreaseN
	
	neg.d $f4, $f4
	
	c.le.d $f0,$f4   		# checks if $f0 <= -Pi/2
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,increaseN    	# if $f0 <= -Pi/2, goes to increaseN
	
	j sin0
	
decreaseN:
	#Register Usage: $f0 = aquivalent to n, $f2 = Pi, $f4 = Pi/2, $t0 = -1, $s2 = sign of result
	
	sub.d $f0, $f0, $f2
	li $t0, -1
	mul $s2, $s2, $t0		# change sign of the result
	
	c.le.d $f4,$f0   		# checks if $f0 >= Pi/2
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,decreaseN		# if $f0 > Pi/2, goes to decreaseN
	
	j ret					# return to sin
	
increaseN:
	#Register Usage: $f0 = aquivalent to n, $f2 = Pi, $f4 = -Pi/2, $t0 = -1, $s2 = sign of result
	
	add.d $f0, $f0, $f2
	li $t0, -1
	mul $s2, $s2, $t0		# change sign of the result
	
	c.le.d $f0,$f4   		# checks if $f0 <= -Pi/2
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,increaseN    	# if $f0 <= -Pi/2, goes to increaseN
	
	j ret 					# return to sin
	
cos:
	#Register usage: $f0 = n, $f4 = Pi/2
	
	l.d $f4, piHalf
	
	add.d $f0, $f4, $f0		# aquivilent of n = Pi/2 + aquivilent of n
	
	j sin					#calculate sin of n + Pi/2
	
tan: 
	#Register Usage: $f0 = aquivalent of n, $f30 = sin(n), $f28 = cos(n), $f2 = res
		
	l.d $f8, piHalf
	sub.d $f0, $f0, $f8
	abs.d $f2, $f0			# Get the absolute value of the smallest aquivilent of n 
	sub.d $f2, $f2, $f8		# get the distance of n to k*pi+pi/2
	abs.d $f2, $f2			# make distance positive
	
	l.d $f8, double7		# for tan, n must have a greater distance than 0.00000000001 from k*pi + pi/2
	
	c.le.d $f2,$f8  		# checks if distance < 0.00000000001
	cfc1 $t1, $25  			# load FCCR into t0
	andi $t1, 1    			# mask the bit 0 only	
	beq $t1,1,tanError		# if distance < 0.0008, goes to tanError
	
	div.d $f2, $f30, $f28
	
	#Display tan(n)
	li $v0, 3			
	add.d $f12,$f10, $f2 	
	syscall	
	
	# print space on terminal 
	la $a0, space
	li $v0, 4		      
	syscall
	
	#Display n
	li $v0, 3			
	add.d $f12,$f10, $f6	
	syscall
	
	#print nextline on terminal
	la $a0, nextline
	li $v0, 4		      
	syscall
	j ret
	
tanError:
	# Display tanerror
	la $a0, tanerror			    
	li $v0, 4		      
	syscall 
	
	#Display n
	li $v0, 3			
	add.d $f12,$f10, $f6	
	syscall
	
	#print nextline on terminal
	la $a0, nextline
	li $v0, 4		      
	syscall
	
	j ret