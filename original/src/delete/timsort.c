#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define INF_RUNS 128  // run 스택 최대 개수(필요시 늘려도 됨)

static void timsort(int *a, size_t n) {
    if (n < 2) return;

    // 1) minrun 계산 (32..64 범위)
    size_t m = n, minrun;
    unsigned r = 0;
    while (m >= 64) { r |= (unsigned)(m & 1); m >>= 1; }
    minrun = m + r;
    if (minrun < 32) minrun = 32;  // 안전장치

    // 보조 버퍼 1회 할당(안정 병합용)
    int *buf = (int *)malloc(n * sizeof *buf);
    if (!buf) return;

    // run 스택
    size_t base[INF_RUNS];
    size_t len [INF_RUNS];
    size_t top = 0;

    size_t i = 0;

    // 내부에서 사용할 병합 람다 느낌의 블록(함수 없이 구현)
    // merge runs: 스택 top-2와 top-1을 병합
    #define MERGE_TOP() do { \
        size_t b2 = base[top-1], l2 = len[top-1]; \
        size_t b1 = base[top-2], l1 = len[top-2]; \
        /* 안정 병합: 더 짧은 쪽을 buf에 복사 */ \
        if (l1 <= l2) { \
            memcpy(buf, a + b1, l1 * sizeof *a); \
            size_t i1 = 0, i2 = b2, k = b1, e1 = l1, e2 = b2 + l2; \
            while (i1 < e1 && i2 < e2) { \
                if (buf[i1] <= a[i2]) a[k++] = buf[i1++]; \
                else                  a[k++] = a[i2++]; \
            } \
            while (i1 < e1) a[k++] = buf[i1++]; \
            /* 오른쪽 잔여분은 이미 제자리 */ \
        } else { \
            memcpy(buf, a + b2, l2 * sizeof *a); \
            /* 뒤에서 앞으로 병합(안정성 유지: 같으면 오른쪽을 먼저 소모) */ \
            size_t i1 = b1 + l1; /* exclusive */ \
            size_t i2 = l2;      /* buf index exclusive */ \
            size_t k  = b2 + l2; /* dest exclusive */ \
            while (i1 > b1 && i2 > 0) { \
                if (a[i1 - 1] > buf[i2 - 1]) a[--k] = a[--i1]; \
                else                          a[--k] = buf[--i2]; \
            } \
            while (i2 > 0) a[--k] = buf[--i2]; \
            /* 왼쪽 잔여분은 이미 제자리 */ \
        } \
        /* 스택 갱신: top-2 자리에 병합 결과 */ \
        len[top-2] = l1 + l2; \
        top--; \
    } while (0)

    // 스택 불변식 위반 시 병합
    #define COLLAPSE_STACK() do { \
        while (top >= 2) { \
            if (top >= 3) { \
                size_t A = len[top-3], B = len[top-2], C = len[top-1]; \
                /* Timsort 불변식: A > B + C && B > C 를 만족시키도록 병합 */ \
                if (A <= B + C || B <= C) { \
                    if (A < C) { \
                        /* top-3과 top-2 병합(=위쪽보다 더 깊은 쪽) */ \
                        size_t b1 = base[top-3], l1 = len[top-3]; \
                        size_t b2 = base[top-2], l2 = len[top-2]; \
                        /* top-2를 top-1처럼 만들기 위해 한 칸 당겨둠 */ \
                        base[top-2] = b1; len[top-2] = l1; \
                        base[top-3] = b2; len[top-3] = l2; \
                        top--; \
                        /* 이제 (top-2, top-1) 병합 */ \
                        MERGE_TOP(); \
                    } else { \
                        MERGE_TOP(); \
                    } \
                    continue; \
                } \
                break; \
            } else { \
                /* top == 2인 경우: 위반 가능성 검사 */ \
                size_t B = len[top-2], C = len[top-1]; \
                if (B <= C) { MERGE_TOP(); continue; } \
                break; \
            } \
        } \
    } while (0)

    while (i < n) {
        // 2) 자연 발생 run 탐지 (비감소/감소)
        size_t start = i;
        if (i + 1 == n) { i++; }
        else {
            i++;
            if (a[i] < a[i - 1]) {
                // 감소 run
                while (i < n && a[i] < a[i - 1]) i++;
                // 역순 뒤집기
                size_t L = start, R = i - 1;
                while (L < R) { int t = a[L]; a[L] = a[R]; a[R] = t; L++; R--; }
            } else {
                // 비감소 run
                while (i < n && a[i] >= a[i - 1]) i++;
            }
        }
        size_t run_len = i - start;

        // 3) run 길이가 minrun보다 짧으면 minrun까지 삽입정렬로 확장
        size_t target = MIN(n, start + (run_len < minrun ? minrun : run_len));
        for (size_t j = start + run_len; j < target; ++j) {
            int key = a[j];
            size_t k = j;
            while (k > start && a[k - 1] > key) { a[k] = a[k - 1]; --k; }
            a[k] = key;
        }
        run_len = target - start;

        // 4) run을 스택에 push
        base[top] = start;
        len [top] = run_len;
        top++;

        // 5) 스택 불변식 유지(필요하면 병합)
        COLLAPSE_STACK();
    }

    // 6) 남은 run 전부 병합
    while (top > 1) MERGE_TOP();

    free(buf);

    #undef MERGE_TOP
    #undef COLLAPSE_STACK
}

int main(void) {
    int a[] = {5, 3, 1, 2, 9, 5, 5, 6, 7, 8, 0, 4, 4, 10, -1};
    size_t n = sizeof(a)/sizeof(a[0]);

    timsort(a, n);

    for (size_t i = 0; i < n; ++i) {
        printf("%d%s", a[i], (i + 1 < n) ? " " : "\n");
    }
    return 0;
}
