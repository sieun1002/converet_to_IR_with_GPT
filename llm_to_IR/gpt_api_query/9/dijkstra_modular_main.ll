; ModuleID = 'recovered.ll'
source_filename = "recovered.c"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global i8*, align 8
@.str.40202C = external constant [0 x i8]

declare i32 @read_graph(i8* nocapture, i32* nocapture, i32* nocapture)
declare void @dijkstra(i8* nocapture, i32, i32, i32* nocapture)
declare void @print_distances(i32* nocapture, i32)
declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16        ; 0x9C50 bytes
  %dist = alloca [100 x i32], align 16          ; 0x190 bytes
  store i32 0, i32* %ret, align 4

  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call.read = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %src)
  %ok = icmp eq i32 %call.read, 0
  br i1 %ok, label %do_ok, label %do_err

do_err:
  %stderr.val = load i8*, i8** @stderr, align 8
  %fmt = getelementptr inbounds [0 x i8], [0 x i8]* @.str.40202C, i64 0, i64 0
  call i32 (i8*, i8*, ...) @fprintf(i8* %stderr.val, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %exit

do_ok:
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr, i32 %n.val, i32 %src.val, i32* %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist.ptr, i32 %n.val2)
  store i32 0, i32* %ret, align 4
  br label %exit

exit:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}