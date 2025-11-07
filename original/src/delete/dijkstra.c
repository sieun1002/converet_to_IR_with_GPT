#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <limits.h>

#define INF 0x3f3f3f3f  

static void dijkstra(const int *w, size_t n, size_t s, int *dist, int *prev) {
    if (n == 0 || s >= n) return;

    int *used = (int *)malloc(n * sizeof *used);
    if (!used) return;

    for (size_t i = 0; i < n; ++i) {
        dist[i] = INF;
        prev[i] = -1;
        used[i] = 0;
    }
    dist[s] = 0;

    for (size_t it = 0; it < n; ++it) {
        size_t u = n;
        int best = INF;
        for (size_t i = 0; i < n; ++i) {
            if (!used[i] && dist[i] < best) {
                best = dist[i];
                u = i;
            }
        }
        if (u == n) break;      
        used[u] = 1;

        for (size_t v = 0; v < n; ++v) {
            int w_uv = w[u*n + v];   
            if (w_uv >= 0 && !used[v]) {
                if (dist[u] != INF && dist[u] + w_uv < dist[v]) {
                    dist[v] = dist[u] + w_uv;
                    prev[v] = (int)u;
                }
            }
        }
    }

    free(used);
}

int main(void) {
    size_t n = 6;
    int g[6*6];
    for (size_t i = 0; i < n*n; ++i) g[i] = -1;
    for (size_t i = 0; i < n; ++i) g[i*n + i] = 0;

    #define ADD(u,v,w) do { g[(u)*n + (v)] = (w); g[(v)*n + (u)] = (w); } while(0)
    ADD(0,1,7);  ADD(0,2,9);  ADD(0,3,10);
    ADD(1,3,15); ADD(2,3,11); ADD(3,4,6); ADD(4,5,9);
    #undef ADD

    size_t s = 0;      
    int dist[6], prev[6];

    dijkstra(g, n, s, dist, prev);

    for (size_t i = 0; i < n; ++i) {
        if (dist[i] >= INF) printf("dist(%zu -> %zu) = INF\n", s, i);
        else                printf("dist(%zu -> %zu) = %d\n",  s, i, dist[i]);
    }

    size_t t = 5;
    if (dist[t] >= INF) {
        printf("no path from %zu to %zu\n", s, t);
    } else {
        size_t path[6]; size_t k = 0;
        for (int v = (int)t; v != -1; v = prev[v]) path[k++] = (size_t)v;
        printf("path %zu -> %zu:", s, t);
        for (size_t i = 0; i < k; ++i) {
            size_t v = path[k - 1 - i];
            printf(" %zu%s", v, (i + 1 < k) ? " ->" : "");
        }
        printf("\n");
    }
    return 0;
}
