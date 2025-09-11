Short answer
This ELF64 “mergesort” binary builds a fixed array of 10 integers in its stack, sorts it with a bottom‑up (iterative) mergesort using a 40‑byte heap scratch buffer, then prints the array as “0 1 2 3 4 5 6 7 8 9” followed by a newline. If malloc fails, it skips sorting and prints the original unsorted numbers.

Details
- Initial array (built on the stack via 64‑bit constants):
  9, 1, 5, 3, 7, 2, 8, 6, 4, 0
- It allocates 0x28 (40) bytes (10 ints) as a temporary destination buffer and performs a bottom‑up mergesort:
  - run sizes: 1, 2, 4, 8 (4 passes total; r14d starts at 4 and decrements)
  - indices are clamped with min(…, 10), so no out‑of‑bounds access
  - after each pass (except the last), it swaps the source/destination pointers
- After the last pass, the sorted data ends up back in the stack buffer (so no final copy is needed). It frees the heap buffer.
- It prints each int with "%d " and then prints "\n". No input is read.

Equivalent C (simplified)
int main(void) {
    int a[10] = {9,1,5,3,7,2,8,6,4,0};
    int *tmp = (int*)malloc(sizeof(a));
    int *src = a, *dst = tmp;

    if (tmp) {
        int run = 1;
        for (int passes = 4; passes--; run <<= 1) {       // 1,2,4,8
            for (int L = 0; L < 10; L += 2*run) {
                int M = L + run < 10 ? L + run : 10;
                int R = L + 2*run < 10 ? L + 2*run : 10;
                int i = L, j = M, k = L;
                while (k < R) {
                    if (i < M && (j >= R || src[i] <= src[j])) dst[k++] = src[i++];
                    else                                        dst[k++] = src[j++];
                }
            }
            // swap for next pass (unless that was the last pass)
            if (passes) { int *t = src; src = dst; dst = t; }
        }
        // After 4 passes, src == a (stack), so no copy needed
        free(tmp);
    }

    for (int i = 0; i < 10; ++i) printf("%d ", a[i]);
    printf("\n");
    return 0;
}

Notable bits in the disassembly
- malloc size: edi = 0x28 (40 bytes)
- Format strings: "%d " at .rodata:0x2004, newline at .rodata:0x2008
- Printing via __printf_chk with flag 1 (FORTIFY)
- Stack canary present (__stack_chk_fail path)
- If malloc fails, it jumps to the print loop and outputs the unsorted array

Output (normal case)
0 1 2 3 4 5 6 7 8 9