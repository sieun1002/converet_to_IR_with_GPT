// 간단 하네스 템플릿(필요에 맞게 수정)
// 예: 대상 함수가 int target(int)인 경우
#include <stdio.h>
#include <stdlib.h>

extern int target(int);

int main(int argc, char** argv) {
    int x = (argc > 1) ? atoi(argv[1]) : 42;
    int y = target(x);
    printf("%d\n", y);
    return 0;
}
