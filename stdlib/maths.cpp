#include  <math.h>


int abs(int n) {
    if (n < 0) {
        return -n;
    } else {
        return n;
    }
}


double cos(double const r) {
    return 1.0;
}


double exp(double const n) {
    return 0.0;
}


double floor(double const v) {
    return static_cast<int>(v);
}


double fabs(double d) {
    if (d < 0.0) {
        return -d;
    } else {
        return d;
    }
}


double sqrt(double const a) {
    return 1.0;
}
