; ModuleID = 'main_module'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type opaque

@.str = private unnamed_addr constant [22 x i8] c"Error reading graph\0A\00", align 1
@stderr = external global %struct._IO_FILE*

declare dso_local i32 @read_graph(i8*, i32*, i32*)
declare dso_local void @dijkstra(i8*, i32, i32, i8*)
declare dso_local void @print_distances(i8*, i32)
declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...)

define dso_local i32 @main() {
entry:
  %ret = alloca i32, align 4
  %var8 = alloca i32, align 4
  %varC = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [40416 x i8], align 16
  store i32 0, i32* %ret, align 4
  %graph_ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %call_rg = call i32 @read_graph(i8* %graph_ptr, i32* %var8, i32* %varC)
  %cmp = icmp eq i32 %call_rg, 0
  br i1 %cmp, label %if.ok, label %if.err

if.err:
  %stderr_gvptr = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %fmtptr = getelementptr inbounds [22 x i8], [22 x i8]* @.str, i64 0, i64 0
  %call_fpr = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stderr_gvptr, i8* %fmtptr)
  store i32 1, i32* %ret, align 4
  br label %return

if.ok:
  %dist_ptr = getelementptr inbounds [40416 x i8], [40416 x i8]* %dist, i64 0, i64 0
  %val_n = load i32, i32* %var8, align 4
  %val_m = load i32, i32* %varC, align 4
  call void @dijkstra(i8* %graph_ptr, i32 %val_n, i32 %val_m, i8* %dist_ptr)
  %val_n2 = load i32, i32* %var8, align 4
  call void @print_distances(i8* %dist_ptr, i32 %val_n2)
  store i32 0, i32* %ret, align 4
  br label %return

return:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}