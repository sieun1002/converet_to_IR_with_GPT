#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

static void merge_sort(int *a, size_t n) {
    if (n < 2) return;

    int *buf = (int *)malloc(n * sizeof *buf);
    if (!buf) return; // 메모리 부족 시 정렬 건너뜀(필요하면 처리 로직 추가)

    int *src = a, *dst = buf;

    for (size_t width = 1; width < n; width <<= 1) {
        size_t i = 0;
        while (i < n) {
            size_t left = i;
            size_t mid  = i + width;    if (mid  > n) mid  = n;
            size_t right= i + 2*width;  if (right> n) right= n;

            size_t l = left, r = mid;
            for (size_t p = left; p < right; ++p) {
                if (l < mid && (r >= right || src[l] <= src[r])) {
                    dst[p] = src[l++];
                } else {
                    dst[p] = src[r++];
                }
            }
            i += 2 * width;
        }
        // 결과 버퍼와 소스 버퍼 교체
        int *tmp = src; src = dst; dst = tmp;
    }

    // 정렬 결과가 buf에 남아있으면 a로 복사
    if (src != a) {
        memcpy(a, src, n * sizeof *a);
    }
    free(buf);
}

int main(void) {
    int a[] = {9, 1, 5, 3, 7, 2, 8, 6, 4, 0};
    size_t n = sizeof(a) / sizeof(a[0]);

    merge_sort(a, n);

    for (size_t i = 0; i < n; ++i) {
        printf("%d ", a[i]);
    }
    printf("\n");
    return 0;
}
