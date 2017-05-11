#include <math.h>
#include <stdio.h>

double power(double n, int m) {
	double result = 1;
	int i;
    // n to power of m
    // Isn't used in assembler -> only x*x
    if (n == 0 || n == 1) {
        // return 1
        return result;
    } else {
        for(i = 0; i < m; i++) {
    		result *= n;
        }
        return result;
    }
}

double sin0(double x) {
    int i;
    double numerator = x;
    double denominator = 1;
    double result = x;

    for (int i = 1; i < 7; i++){
        numerator *= (-1) * pow(x, 2);
        denominator *=  (2*i) * (2*i+1);
        result += numerator/denominator;
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
