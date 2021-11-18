#include  <math.h>


int abs(int n) {
    if (n < 0) {
        return -n;
    } else {
        return n;
    }
}


double fabs(double d) {
    if (d < 0.0) {
        return -d;
    } else {
        return d;
    }
}
