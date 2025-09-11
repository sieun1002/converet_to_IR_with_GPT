Short answer: it’s a small Linux x86-64 PIE that bubble-sorts a fixed array of 10 integers placed on the stack and prints them.

Details:
- Binary: ELF64 PIE, GNU C++, glibc, stack canary (__stack_chk_fail), fortify (__printf_chk).
- main builds an int array of length 10 on the stack from these immediates:
  [9, 1, 5, 3, 7, 2, 8, 6, 4, 0]
  (They’re packed as qwords like 0x100000009, 0x300000005, 0x200000007, 0x600000008, and 0x4.)
- Sorting: a bubble sort with “last-swap” optimization. It tracks the last index where a swap occurred (r8) and shortens the next pass to that index (rdi = r8). If no swap past index 1, it finishes.
- Printing: it prints each int with format "%d " followed by a newline.

Reconstructed C (conceptually):
int a[10] = {9,1,5,3,7,2,8,6,4,0};
size_t n = 10;
do {
  size_t last = 0;
  int prev = a[0];
  for (size_t i = 1; i < n; ++i) {
    int cur = a[i];
    if (cur < prev) { a[i-1] = cur; a[i] = prev; last = i; }
    else { prev = cur; }
  }
  n = last;
} while (n > 1);
for (int i = 0; i < 10; ++i) printf("%d ", a[i]);
printf("\n");

Program output:
0 1 2 3 4 5 6 7 8 9