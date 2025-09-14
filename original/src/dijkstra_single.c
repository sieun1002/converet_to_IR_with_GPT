#include <stdio.h>
#include <limits.h>

void dijkstra(int graph[100][100], int V, int src) {
    int dist[100];
    int visited[100];

    for (int i = 0; i < V; i++) {
        dist[i] = INT_MAX;
        visited[i] = 0;
    }
    dist[src] = 0;

    for (int c = 0; c < V - 1; c++) {
        int u = -1, min = INT_MAX;
        for (int i = 0; i < V; i++) {
            if (!visited[i] && dist[i] < min) {
                min = dist[i];
                u = i;
            }
        }
        if (u == -1) break;
        visited[u] = 1;

        for (int v = 0; v < V; v++) {
            if (graph[u][v] && !visited[v] && dist[u] != INT_MAX &&
                dist[v] > dist[u] + graph[u][v]) {
                dist[v] = dist[u] + graph[u][v];
            }
        }
    }

    for (int i = 0; i < V; i++) {
        if (dist[i] == INT_MAX) printf("dist[%d] = INF\n", i);
        else printf("dist[%d] = %d\n", i, dist[i]);
    }
}

int main(void) {
    int V, E;
    scanf("%d %d", &V, &E);

    int graph[100][100] = {0};

    for (int i = 0; i < E; i++) {
        int u, v, w;
        scanf("%d %d %d", &u, &v, &w);
        graph[u][v] = w;
        graph[v][u] = w; // 무방향 그래프, 방향 그래프라면 이 줄 제거
    }

    int src;
    scanf("%d", &src);

    dijkstra(graph, V, src);
    return 0;
}
