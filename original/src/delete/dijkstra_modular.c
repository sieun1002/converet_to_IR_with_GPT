#include <stdio.h>
#include <limits.h>

void init_graph(int graph[100][100], int V);
void add_edge(int graph[100][100], int u, int v, int w, int undirected);
int  read_graph(int graph[100][100], int *V, int *src);
int  min_index(const int dist[], const int visited[], int V);
void dijkstra(int graph[100][100], int V, int src, int out_dist[100]);
void print_distances(const int dist[], int V);

void init_graph(int graph[100][100], int V) {
    for (int i = 0; i < V; ++i)
        for (int j = 0; j < V; ++j)
            graph[i][j] = 0; 
}

void add_edge(int graph[100][100], int u, int v, int w, int undirected) {
    if (u < 0 || v < 0) return;
    graph[u][v] = w;
    if (undirected) graph[v][u] = w;
}

int read_graph(int graph[100][100], int *V, int *src) {
    int E;
    if (scanf("%d %d", V, &E) != 2) return -1;
    if (*V <= 0 || *V > 100 || E < 0) return -1;

    init_graph(graph, *V);

    for (int i = 0; i < E; ++i) {
        int u, v, w;
        if (scanf("%d %d %d", &u, &v, &w) != 3) return -1;
        if (u < 0 || u >= *V || v < 0 || v >= *V) return -1;
        add_edge(graph, u, v, w, 1);
    }

    if (scanf("%d", src) != 1) return -1;
    if (*src < 0 || *src >= *V) return -1;
    return 0;
}

int min_index(const int dist[], const int visited[], int V) {
    int u = -1, min = INT_MAX;
    for (int i = 0; i < V; ++i) {
        if (!visited[i] && dist[i] < min) {
            min = dist[i];
            u = i;
        }
    }
    return u;
}

void dijkstra(int graph[100][100], int V, int src, int out_dist[100]) {
    int visited[100] = {0};

    for (int i = 0; i < V; ++i) out_dist[i] = INT_MAX;
    out_dist[src] = 0;

    for (int iter = 0; iter < V - 1; ++iter) {
        int u = min_index(out_dist, visited, V);
        if (u == -1) break;
        visited[u] = 1;

        for (int v = 0; v < V; ++v) {
            if (graph[u][v] && !visited[v] && out_dist[u] != INT_MAX) {
                int nd = out_dist[u] + graph[u][v];
                if (nd < out_dist[v]) out_dist[v] = nd;
            }
        }
    }
}

void print_distances(const int dist[], int V) {
    for (int i = 0; i < V; ++i) {
        if (dist[i] == INT_MAX) printf("dist[%d] = INF\n", i);
        else                printf("dist[%d] = %d\n", i, dist[i]);
    }
}

int main(void) {
    int V, src;
    int graph[100][100];
    int dist[100];

    if (read_graph(graph, &V, &src) != 0) {
        fprintf(stderr, "입력 형식 오류 또는 범위 초과입니다.\n");
        return 1;
    }

    dijkstra(graph, V, src, dist);
    print_distances(dist, V);
    return 0;
}
