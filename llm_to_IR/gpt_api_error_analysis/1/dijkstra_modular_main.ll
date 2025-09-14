; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i8 }

@stderr = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [13 x i8] c"input error\0A\00", align 1

declare i32 @read_graph(i8* nocapture, i32* nocapture, i32* nocapture)
declare void @dijkstra(i8* nocapture, i32, i32, i32* nocapture)
declare void @print_distances(i32* nocapture, i32)
declare i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture, ...)

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [164 x i32], align 16
  store i32 0, i32* %ret, align 4
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %rg = call i32 @read_graph(i8* %graph.ptr, i32* %n, i32* %src)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %L_ok, label %L_err

L_err:
  %stderr.val = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %ignored = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stderr.val, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %L_end

L_ok:
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [164 x i32], [164 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr, i32 %n.val, i32 %src.val, i32* %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist.ptr, i32 %n.val2)
  store i32 0, i32* %ret, align 4
  br label %L_end

L_end:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}