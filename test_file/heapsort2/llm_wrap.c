#include <stddef.h>
extern void llm_heap_sort_raw(int *a, int n);
void heap_sort(int *a, size_t n){ llm_heap_sort_raw(a, (int)n); }
