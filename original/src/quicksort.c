#include <stdio.h>
#include <stddef.h>

static void quick_sort(int *a, long lo, long hi) {
    while (lo < hi) {
        long i = lo, j = hi;
        int pivot = a[lo + (hi - lo) / 2];

        do {
            while (a[i] < pivot) i++;
            while (a[j] > pivot) j--;
            if (i <= j) {
                int t = a[i]; a[i] = a[j]; a[j] = t;
                i++; j--;
            }
        } while (i <= j);

        if ((j - lo) < (hi - i)) {
            if (lo < j) quick_sort(a, lo, j);
            lo = i;
        } else {
            if (i < hi) quick_sort(a, i, hi);
            hi = j;
        }
    }
}

int main(void) {
    int a[] = {9, 1, 5, 3, 7, 2, 8, 6, 4, 0};
    size_t n = sizeof(a) / sizeof(a[0]);

    if (n > 1) quick_sort(a, 0, (long)n - 1);

    for (size_t k = 0; k < n; ++k) printf("%d ", a[k]);
    printf("\n");
    return 0;
}
