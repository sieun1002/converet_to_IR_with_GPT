#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>

static void dfs(const int *g, size_t n, size_t s, size_t *order, size_t *ord_len) {
    if (n == 0 || s >= n) { *ord_len = 0; return; }

    int *visited = (int *)malloc(n * sizeof *visited);
    size_t *idx   = (size_t *)malloc(n * sizeof *idx);   
    size_t *st    = (size_t *)malloc(n * sizeof *st);    

    if (!visited || !idx || !st) { 
        free(visited); free(idx); free(st);
        *ord_len = 0; return;
    }

    for (size_t i = 0; i < n; ++i) { visited[i] = 0; idx[i] = 0; }

    size_t top = 0;             
    *ord_len = 0;

    st[top++] = s;
    visited[s] = 1;
    order[(*ord_len)++] = s;

    while (top > 0) {
        size_t u = st[top - 1];
        size_t v;

        for (v = idx[u]; v < n; ++v) {
            if (g[u*n + v] && !visited[v]) {
                idx[u] = v + 1;          
                visited[v] = 1;
                order[(*ord_len)++] = v; 
                st[top++] = v;           
                break;
            }
        }

        if (v == n) {
            top--;
        }
    }

    free(visited);
    free(idx);
    free(st);
}

int main(void) {
    size_t n = 7;
    int g[7*7] = {0};

    #define ADD(u,v) do { g[(u)*n + (v)] = 1; g[(v)*n + (u)] = 1; } while(0)
    ADD(0,1); ADD(0,2); ADD(1,3); ADD(1,4); ADD(2,5); ADD(4,5); ADD(5,6);
    #undef ADD

    size_t s = 0;              
    size_t order[7];
    size_t ord_len = 0;

    dfs(g, n, s, order, &ord_len);

    printf("DFS preorder from %zu: ", s);
    for (size_t i = 0; i < ord_len; ++i) {
        printf("%zu%s", order[i], (i + 1 < ord_len) ? " " : "");
    }
    printf("\n");
    return 0;
}
