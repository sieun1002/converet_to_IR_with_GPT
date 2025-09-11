#include <stdio.h>
#include <stddef.h>

void heap_sort(int *a, size_t n) {
    if (n < 2) return;

    for (size_t i = n / 2; i-- > 0; ) {
        size_t root = i;
        for (;;) {
            size_t left = root * 2 + 1;
            if (left >= n) break;
            size_t right = left + 1;
            size_t swap_idx = (right < n && a[right] > a[left]) ? right : left;
            if (a[root] >= a[swap_idx]) break;
            int t = a[root]; a[root] = a[swap_idx]; a[swap_idx] = t;
            root = swap_idx;
        }
    }

    for (size_t end = n - 1; end > 0; --end) {
        int t = a[0]; a[0] = a[end]; a[end] = t;
        size_t root = 0;
        for (;;) {
            size_t left = root * 2 + 1;
            if (left >= end) break;
            size_t right = left + 1;
            size_t swap_idx = (right < end && a[right] > a[left]) ? right : left;
            if (a[root] >= a[swap_idx]) break;
            int tt = a[root]; a[root] = a[swap_idx]; a[swap_idx] = tt;
            root = swap_idx;
        }
    }
}

int main(void) {
    int arr[] = {7, 3, 9, 1, 4, 8, 2, 6, 5};
    size_t n = sizeof(arr)/sizeof(arr[0]);

    printf("원본: ");
    for (size_t i = 0; i < n; i++) printf("%d ", arr[i]);
    printf("\n");

    heap_sort(arr, n);

    printf("정렬 후: ");
    for (size_t i = 0; i < n; i++) printf("%d ", arr[i]);
    printf("\n");

    return 0;
}
