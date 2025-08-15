#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <omp.h>

#define N 1000000000
#define d 1E-9

int main ( int argc, char* argv[] )
{
    long long i;
    double PI = 0.0, result = 0.0;

    #pragma omp parallel for reduction(+:result)
    for (i = 0; i < N; i++) {
        double x = d * i;
        result += sqrt(4 * (1 - x * x)) * d;
    }

    PI = 2 * result;
    printf("PI = %f\n", PI);

    return 0;
}

