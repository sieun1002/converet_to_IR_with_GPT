#include <stdio.h>
#include <stdarg.h>

/* Windows 스타일 심볼을 glibc로 포워딩 */
int _printf(const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    int r = vprintf(fmt, ap);
    va_end(ap);
    return r;
}

/* 혹시 _putchar 참조가 있을 수 있으므로 같이 제공 */
int _putchar(int c) {
    return putchar(c);
}

/* 필요시 _puts도 대비 */
int _puts(const char *s) {
    return puts(s);
}
