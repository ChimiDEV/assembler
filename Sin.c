#include <math.h>
#include <stdio.h>

long int factorial(int n) {
    if(n < 0) {
        //Error
        printf("Error! Factorial of a negative number doesn't exist.");
        return -1;
    } else if(n == 0 || n == 1) {
        return 1;
    } else {
        return n * factorial(n-1);
    }
}

double power(double n, int m) {
	double tmp = 1;
	int i;

    // Power of n
	for(i = 0; i < m; i++) {
		tmp *= n;
	}
	return tmp;
}

double sin0(double x) {
    int i;

    // Taylor Approximation (7)
    /* for(i = 0; i < 7; i++) {
        //double sign = power(-1, i);
        sign = -sign;
        double px = power(x, 2*i+1);
        long fac = factorial(2*i+1);
        result += sign * px / fac;
    } */
    double numerator = x;
    double denominator = 1;
    double result = x;

    for ( int i = 1; i < rounds; i++){
        numerator = numerator * (-1) * pow(x, 2.0);
        denominator = denominator * (2*i) * (2*i+1);
        result = result + numerator/denominator;
    }

    return result;
}

double degreeToRadian(double x) {
    return x * M_PI / 180;
}

int main() {
    int mode;
	double x;

    printf("X is in (1)Degress or (2)Radians: ");
    scanf("%d", &mode);

    if(mode == 1) {
        printf("Enter angle in degree: ");
        scanf("%lf", &x);
        x = degreeToRadian(x);
    } else if(mode == 2) {
        printf("Enter angle in radians: ");
        scanf("%lf", &x);
    } else {
        printf("Invalid Input\n");
        return 1;
    }

    printf("Sine of: %.10lf\n", x);

    printf("Result (libary): %.10lf\n", sin(x));
    printf("Result (execerise): %.10lf\n", sin0(x));

    return 0;
}
