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
    /// TODO: No termination g'tee?
    while (best != approx) {
        approx = best;
        ++k;
        step = (-r * r * step) / (((2 * k) - 1) * (2 * k));
        best = approx + step;
    }
    return best;
}


double exp(double const n) {
    constexpr double e = 2.7182818284590;

    int64_t nearest = n;
    double error = n - nearest;
    if (error < -0.5) {
        nearest += 1;
        error += 1;
    } else if (error > 0.5) {
        nearest -= 1;
        error -= 1;
    }

    double en = 1.0;
    if (nearest > 0) {
        while (nearest--) {
            en *= e;
        }
    } else {
        while (nearest++) {
            en /= e;
        }
    }

    /// TODO Dynamically choose the depth into the tailor series
    double const er = 1 + error + (error * error) / 2 +
        (error * error * error) / 6 +
        (error * error * error * error) / 24 +
        (error * error * error * error * error) / 120;

    return en * er;
}


double floor(double const v) {
    if (v < 0) {
        return static_cast<int64_t>(v - 1);
    } else {
        return static_cast<int64_t>(v);
    }
}


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
