; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@stream = external global i8*
@byte_40202C = external global [1 x i8]

declare i32 @read_graph(i8* %graph, i32* %n, i32* %m)
declare void @dijkstra(i8* %graph, i32 %n, i32 %m, i8* %dist)
declare void @print_distances(i8* %dist, i32 %n)
declare i32 @fprintf(i8* %stream, i8* %fmt, ...)

define dso_local i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %m = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [40416 x i8], align 16

  store i32 0, i32* %ret, align 4

  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %m)
  %iszero = icmp eq i32 %call.read, 0
  br i1 %iszero, label %ok, label %err

err:
  %stream.load = load i8*, i8** @stream
  %fmt.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @byte_40202C, i64 0, i64 0
  %call.fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream.load, i8* %fmt.ptr)
  store i32 1, i32* %ret, align 4
  br label %end

ok:
  %n.val = load i32, i32* %n, align 4
  %m.val = load i32, i32* %m, align 4
  %dist.ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr, i32 %n.val, i32 %m.val, i8* %dist.ptr)
  call void @print_distances(i8* %dist.ptr, i32 %n.val)
  store i32 0, i32* %ret, align 4
  br label %end

end:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}