; ModuleID = 'main.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@stderr = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [26 x i8] c"Error: read_graph failed\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %var_4 = alloca i32, align 4
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [164 x i32], align 16
  store i32 0, i32* %var_4, align 4
  %graph.ptr0 = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call.read_graph = call i32 @read_graph(i8* %graph.ptr0, i32* %var_8, i32* %var_C)
  %cmp.zero = icmp eq i32 %call.read_graph, 0
  br i1 %cmp.zero, label %ok, label %err

err:
  %stderr.ld = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %fmt.gep = getelementptr inbounds [26 x i8], [26 x i8]* @.str, i64 0, i64 0
  %call.fprintf = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stderr.ld, i8* %fmt.gep)
  store i32 1, i32* %var_4, align 4
  br label %exit

ok:
  %n.ld = load i32, i32* %var_8, align 4
  %start.ld = load i32, i32* %var_C, align 4
  %dist.ptr0 = getelementptr inbounds [164 x i32], [164 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph.ptr0, i32 %n.ld, i32 %start.ld, i32* %dist.ptr0)
  %n.ld2 = load i32, i32* %var_8, align 4
  call void @print_distances(i32* %dist.ptr0, i32 %n.ld2)
  store i32 0, i32* %var_4, align 4
  br label %exit

exit:
  %ret.ld = load i32, i32* %var_4, align 4
  ret i32 %ret.ld
}