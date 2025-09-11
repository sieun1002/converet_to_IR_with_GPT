#include <stdio.h>
#include <stddef.h>

static void insertion_sort(int *a, size_t n) {
    for (size_t i = 1; i < n; ++i) {
        int key = a[i];
        size_t j = i;
        while (j > 0 && a[j - 1] > key) {
            a[j] = a[j - 1];
            --j;
        }
        a[j] = key;
    }
}

int main(void) {
    int a[] = {9, 1, 5, 3, 7, 2, 8, 6, 4, 0};
    size_t n = sizeof(a) / sizeof(a[0]);

    insertion_sort(a, n);

    for (size_t i = 0; i < n; ++i) {
        printf("%d ", a[i]);
    }
    printf("\n");
    return 0;
}
