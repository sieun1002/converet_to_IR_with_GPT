; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@__bss_start = external global i8*
@byte_40202C = private unnamed_addr constant [13 x i8] c"input error\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i8*)
declare void @print_distances(i8*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %status = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [400 x i8], align 16
  store i32 0, i32* %status, align 4
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [400 x i8], [400 x i8]* %dist, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %src)
  %cmp = icmp eq i32 %call.read, 0
  br i1 %cmp, label %ok, label %err

err:
  %stream.ptr = load i8*, i8** @__bss_start, align 8
  %fmt.ptr = getelementptr inbounds [13 x i8], [13 x i8]* @byte_40202C, i64 0, i64 0
  %call.fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream.ptr, i8* %fmt.ptr)
  store i32 1, i32* %status, align 4
  br label %exit

ok:
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  call void @dijkstra(i8* %graph.ptr, i32 %n.val, i32 %src.val, i8* %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i8* %dist.ptr, i32 %n.val2)
  store i32 0, i32* %status, align 4
  br label %exit

exit:
  %ret = load i32, i32* %status, align 4
  ret i32 %ret
}