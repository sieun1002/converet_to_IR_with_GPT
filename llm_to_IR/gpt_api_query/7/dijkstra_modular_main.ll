; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__bss_start = external global i8*          ; stream
@byte_40202C = external global i8           ; format string

declare i32 @read_graph(i32*, i32*, i32*)
declare void @dijkstra(i32*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @_fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  ; locals
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [10000 x i32], align 16
  %dist = alloca [100 x i32], align 16

  store i32 0, i32* %ret, align 4

  ; call read_graph(&graph[0], &n, &src)
  %graph.ptr = getelementptr inbounds [10000 x i32], [10000 x i32]* %graph, i64 0, i64 0
  %call.read = call i32 @read_graph(i32* %graph.ptr, i32* %n, i32* %src)
  %ok = icmp eq i32 %call.read, 0
  br i1 %ok, label %do_algo, label %on_error

on_error:                                        ; if (read_graph != 0)
  ; fprintf(stream, format);
  %stream.val = load i8*, i8** @__bss_start, align 8
  %call.fprintf = call i32 (i8*, i8*, ... ) @_fprintf(i8* %stream.val, i8* @byte_40202C)
  store i32 1, i32* %ret, align 4
  br label %done

do_algo:                                         ; else
  ; dijkstra(&graph[0], n, src, &dist[0])
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i32* %graph.ptr, i32 %n.val, i32 %src.val, i32* %dist.ptr)

  ; print_distances(&dist[0], n)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist.ptr, i32 %n.val2)

  store i32 0, i32* %ret, align 4
  br label %done

done:
  %retv = load i32, i32* %ret, align 4
  ret i32 %retv
}