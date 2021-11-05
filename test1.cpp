#include <numeric>
#include <span>
#include <vector>


int accumulate(std::span<int> numbers) {
    return std::accumulate(numbers.begin(), numbers.end(), 0);
}


extern "C" int add(int a, int b) {
    std::vector<int> v;
    v.push_back(a);
    v.push_back(b);
    return accumulate(v);
}
