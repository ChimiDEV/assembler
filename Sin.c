#include <math.h>

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

}

int main() {
    int n = 6;
    printf("%d\n", factorial(n));
}
