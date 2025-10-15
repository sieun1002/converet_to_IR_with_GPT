; ModuleID = 'main_from_asm'
source_filename = "main_from_asm.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global i8*, align 8
@.str = private unnamed_addr constant [19 x i8] c"read_graph failed\0A\00", align 1

declare i32 @read_graph(i8*, i32*, i32*)
declare void @dijkstra(i8*, i32, i32, i32*)
declare void @print_distances(i32*, i32)
declare i32 @fprintf(i8*, i8*, ...)

define i32 @main() {
entry:
  %var4 = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40000 x i8], align 16
  %dist = alloca [10104 x i32], align 16
  store i32 0, i32* %var4, align 4
  %graph_ptr0 = getelementptr inbounds [40000 x i8], [40000 x i8]* %graph, i64 0, i64 0
  %call_rg = call i32 @read_graph(i8* %graph_ptr0, i32* %n, i32* %src)
  %cmp = icmp eq i32 %call_rg, 0
  br i1 %cmp, label %loc_401724, label %loc_4016FF

loc_4016FF:
  %stderrp = load i8*, i8** @stderr, align 8
  %fmtptr = getelementptr inbounds [19 x i8], [19 x i8]* @.str, i64 0, i64 0
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stderrp, i8* %fmtptr)
  store i32 1, i32* %var4, align 4
  br label %loc_401753

loc_401724:
  %graph_ptr1 = getelementptr inbounds [40000 x i8], [40000 x i8]* %graph, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist_ptr = getelementptr inbounds [10104 x i32], [10104 x i32]* %dist, i64 0, i64 0
  call void @dijkstra(i8* %graph_ptr1, i32 %nval, i32 %srcval, i32* %dist_ptr)
  %dist_ptr2 = getelementptr inbounds [10104 x i32], [10104 x i32]* %dist, i64 0, i64 0
  %nval2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist_ptr2, i32 %nval2)
  store i32 0, i32* %var4, align 4
  br label %loc_401753

loc_401753:
  %retv = load i32, i32* %var4, align 4
  ret i32 %retv
}