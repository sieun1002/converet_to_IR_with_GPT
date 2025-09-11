#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

static void bfs(const int *g, size_t n, size_t s, int *dist, size_t *order, size_t *ord_len) {
    if (n == 0 || s >= n) { *ord_len = 0; return; }

    for (size_t i = 0; i < n; ++i) dist[i] = -1;

    size_t *q = (size_t *)malloc(n * sizeof *q);
    if (!q) { *ord_len = 0; return; }

    size_t head = 0, tail = 0;
    dist[s] = 0;
    q[tail++] = s;

    *ord_len = 0;
    while (head < tail) {
        size_t u = q[head++];
        order[(*ord_len)++] = u;            

        for (size_t v = 0; v < n; ++v) {
            if (g[u*n + v] && dist[v] == -1) {
                dist[v] = dist[u] + 1;
                q[tail++] = v;
            }
        }
    }

    free(q);
}

int main(void) {
    size_t n = 7;
    int g[7*7] = {0};

    #define ADD(u,v) do { g[(u)*n + (v)] = 1; g[(v)*n + (u)] = 1; } while(0)
    ADD(0,1); ADD(0,2); ADD(1,3); ADD(1,4); ADD(2,5); ADD(4,5); ADD(5,6);
    #undef ADD

    size_t s = 0;                
    int dist[7];
    size_t order[7];
    size_t ord_len = 0;

    bfs(g, n, s, dist, order, &ord_len);

    printf("BFS order from %zu: ", s);
    for (size_t i = 0; i < ord_len; ++i) {
        printf("%zu%s", order[i], (i + 1 < ord_len) ? " " : "");
    }
    printf("\n");

    for (size_t i = 0; i < n; ++i) {
        printf("dist(%zu -> %zu) = %d\n", s, i, dist[i]);
    }
    return 0;
}
