#include  <math.h>
extern "C" {
#include <platform.h>
#include <softfloat.h>
}


int abs(int n) {
    if (n < 0) {
        return -n;
    } else {
        return n;
    }
}


double cos(double const r) {
    /**
     * Tailor series expansion
     *
     * cos x = 1 - x^2/2! + x^4/4! - x^6/6! + ...
     */
    unsigned k = 1;
    double step = -r * r / 2.0, approx = 1.0, best = approx + step;
    while (best != approx) {
        approx = best;
        ++k;
        step = (-r * r * step) / (((2 * k) - 1) * (2 * k));
        best = approx + step;
    }
    return best;
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
    return f64_sqrt(a);
}
