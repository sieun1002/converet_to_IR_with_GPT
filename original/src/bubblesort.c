#include <stdio.h>
#include <stddef.h>

static void bubble_sort(int *a, size_t n) {
    if (n < 2) return;

    size_t end = n;           
    while (end > 1) {
        size_t last_swapped = 0;
        for (size_t i = 1; i < end; ++i) {
            if (a[i - 1] > a[i]) {
                int t = a[i - 1];
                a[i - 1] = a[i];
                a[i] = t;
                last_swapped = i; 
            }
        }
        if (last_swapped == 0) break; 
        end = last_swapped;          
    }
}

int main(void) {
    int a[] = {9, 1, 5, 3, 7, 2, 8, 6, 4, 0};
    size_t n = sizeof(a) / sizeof(a[0]);

    bubble_sort(a, n);

    for (size_t i = 0; i < n; ++i) {
        printf("%d ", a[i]);
    }
    printf("\n");
    return 0;
}
