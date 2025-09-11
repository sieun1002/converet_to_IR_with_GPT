#include <stdio.h>
#include <stddef.h>

static long binary_search(const int *a, size_t n, int key) {
    size_t lo = 0, hi = n;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        if (a[mid] < key) lo = mid + 1;
        else hi = mid;
    }
    if (lo < n && a[lo] == key) return (long)lo; 
    return -1; 
}

int main(void) {
    int a[] = {-5, -1, 0, 2, 2, 3, 7, 9, 12};   
    size_t n = sizeof(a) / sizeof(a[0]);

    int keys[] = {2, 5, -5};
    size_t qn = sizeof(keys) / sizeof(keys[0]);

    for (size_t i = 0; i < qn; ++i) {
        long idx = binary_search(a, n, keys[i]);
        if (idx >= 0) printf("key %d -> index %ld\n", keys[i], idx);
        else          printf("key %d -> not found\n", keys[i]);
    }
    return 0;
}
