; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/BFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/8/BFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

define i32 @main() {
entry:
  %graph = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  %0 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %1 = bitcast [48 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(192) %1, i8 0, i64 192, i1 false)
  store i64 0, i64* %out_len, align 8
  %2 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 7
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 14
  store i32 1, i32* %3, align 8
  %4 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 10
  store i32 1, i32* %4, align 8
  %5 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 22
  store i32 1, i32* %5, align 8
  %6 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 11
  store i32 1, i32* %6, align 4
  %7 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 29
  store i32 1, i32* %7, align 4
  %8 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 19
  store i32 1, i32* %8, align 4
  %9 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 37
  store i32 1, i32* %9, align 4
  %10 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 33
  store i32 1, i32* %10, align 4
  %11 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 39
  store i32 1, i32* %11, align 4
  %12 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 41
  store i32 1, i32* %12, align 4
  %13 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 47
  store i32 1, i32* %13, align 4
  %14 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %15 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %0, i64 7, i64 0, i32* nonnull %14, i64* nonnull %15, i64* nonnull %out_len)
  %16 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs_header, i64 0, i64 0), i64 0)
  br label %loop_i.cond

loop_i.cond:                                      ; preds = %loop_i.body, %entry
  %17 = phi i64 [ 0, %entry ], [ %20, %loop_i.body ]
  %18 = load i64, i64* %out_len, align 8
  %19 = icmp ult i64 %17, %18
  br i1 %19, label %loop_i.body, label %loop_i.end

loop_i.body:                                      ; preds = %loop_i.cond
  %20 = add i64 %17, 1
  %21 = icmp ult i64 %20, %18
  %sel = select i1 %21, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %22 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %17
  %23 = load i64, i64* %22, align 8
  %24 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str_item_fmt, i64 0, i64 0), i64 %23, i8* %sel)
  br label %loop_i.cond

loop_i.end:                                       ; preds = %loop_i.cond
  %25 = call i32 @putchar(i32 10)
  br label %loop_j.cond

loop_j.cond:                                      ; preds = %loop_j.body, %loop_i.end
  %26 = phi i64 [ 0, %loop_i.end ], [ %30, %loop_j.body ]
  %27 = icmp ult i64 %26, 7
  br i1 %27, label %loop_j.body, label %loop_j.end

loop_j.body:                                      ; preds = %loop_j.cond
  %28 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %26
  %29 = load i32, i32* %28, align 4
  %30 = add i64 %26, 1
  %31 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %26, i32 %29)
  br label %loop_j.cond

loop_j.end:                                       ; preds = %loop_j.cond
  ret i32 0
}

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
