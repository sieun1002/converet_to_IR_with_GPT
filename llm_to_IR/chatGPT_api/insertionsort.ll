Short answer:
It’s a small 64-bit Linux PIE ELF that performs an insertion sort on a hard-coded array of 10 integers and prints the sorted result.

Array contents (as laid out on the stack):
[9, 1, 5, 3, 7, 2, 8, 6, 4, 0]

Algorithm:
- Classic insertion sort in ascending order.
- Then prints each number with "%d " followed by a newline.

Reconstructed C equivalent:
int main(void) {
    int a[10] = {9, 1, 5, 3, 7, 2, 8, 6, 4, 0};
    for (int i = 1; i < 10; i++) {
        int key = a[i];
        int j = i - 1;
        while (j >= 0 && key < a[j]) {
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = key;
    }
    for (int i = 0; i < 10; i++) {
        printf("%d ", a[i]);
    }
    printf("\n");
    return 0;
}

Expected output:
0 1 2 3 4 5 6 7 8 9