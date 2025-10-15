; ModuleID = 'bfs_main'
target triple = "x86_64-pc-linux-gnu"

@.str_bfs_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item_fmt  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space     = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty     = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist      = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32* %graph, i64 %n, i64 %src, i32* %dist, i64* %order, i64* %out_len)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %graph = alloca [48 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %out_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %0 = getelementptr inbounds [48 x i32], [48 x i32]* %graph, i64 0, i64 0
  %1 = bitcast i32* %0 to i8*
  call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 192, i1 false)
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %out_len, align 8
  %2 = load i64, i64* %n, align 8
  %3 = getelementptr inbounds i32, i32* %0, i64 %2
  store i32 1, i32* %3, align 4
  %4 = add i64 %2, %2
  %5 = getelementptr inbounds i32, i32* %0, i64 %4
  store i32 1, i32* %5, align 4
  %6 = add i64 %2, 3
  %7 = getelementptr inbounds i32, i32* %0, i64 %6
  store i32 1, i32* %7, align 4
  %8 = add i64 %4, %2
  %9 = add i64 %8, 1
  %10 = getelementptr inbounds i32, i32* %0, i64 %9
  store i32 1, i32* %10, align 4
  %11 = add i64 %2, 4
  %12 = getelementptr inbounds i32, i32* %0, i64 %11
  store i32 1, i32* %12, align 4
  %13 = shl i64 %2, 2
  %14 = add i64 %13, 1
  %15 = getelementptr inbounds i32, i32* %0, i64 %14
  store i32 1, i32* %15, align 4
  %16 = add i64 %4, 5
  %17 = getelementptr inbounds i32, i32* %0, i64 %16
  store i32 1, i32* %17, align 4
  %18 = add i64 %13, %2
  %19 = add i64 %18, 2
  %20 = getelementptr inbounds i32, i32* %0, i64 %19
  store i32 1, i32* %20, align 4
  %21 = add i64 %13, 5
  %22 = getelementptr inbounds i32, i32* %0, i64 %21
  store i32 1, i32* %22, align 4
  %23 = add i64 %18, 4
  %24 = getelementptr inbounds i32, i32* %0, i64 %23
  store i32 1, i32* %24, align 4
  %25 = add i64 %18, 6
  %26 = getelementptr inbounds i32, i32* %0, i64 %25
  store i32 1, i32* %26, align 4
  %27 = add i64 %4, %2
  %28 = shl i64 %27, 1
  %29 = add i64 %28, 5
  %30 = getelementptr inbounds i32, i32* %0, i64 %29
  store i32 1, i32* %30, align 4
  %31 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %32 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %33 = load i64, i64* %n, align 8
  %34 = load i64, i64* %src, align 8
  call void @bfs(i32* %0, i64 %33, i64 %34, i32* %31, i64* %32, i64* %out_len)
  %35 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs_header, i64 0, i64 0
  %36 = load i64, i64* %src, align 8
  %37 = call i32 (i8*, ...) @printf(i8* %35, i64 %36)
  store i64 0, i64* %i, align 8
  br label %loop_i.cond

loop_i.cond:                                      ; preds = %loop_i.body, %entry
  %38 = phi i64 [ 0, %entry ], [ %46, %loop_i.body ]
  %39 = load i64, i64* %out_len, align 8
  %40 = icmp ult i64 %38, %39
  br i1 %40, label %loop_i.body, label %loop_i.end

loop_i.body:                                      ; preds = %loop_i.cond
  %41 = add i64 %38, 1
  %42 = load i64, i64* %out_len, align 8
  %43 = icmp ult i64 %41, %42
  %44 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %45 = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sel = select i1 %43, i8* %44, i8* %45
  %46 = add i64 %38, 1
  %47 = getelementptr inbounds i64, i64* %32, i64 %38
  %48 = load i64, i64* %47, align 8
  %49 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item_fmt, i64 0, i64 0
  %50 = call i32 (i8*, ...) @printf(i8* %49, i64 %48, i8* %sel)
  br label %loop_i.cond

loop_i.end:                                       ; preds = %loop_i.cond
  %51 = call i32 @putchar(i32 10)
  store i64 0, i64* %j, align 8
  br label %loop_j.cond

loop_j.cond:                                      ; preds = %loop_j.body, %loop_i.end
  %52 = phi i64 [ 0, %loop_i.end ], [ %58, %loop_j.body ]
  %53 = load i64, i64* %n, align 8
  %54 = icmp ult i64 %52, %53
  br i1 %54, label %loop_j.body, label %loop_j.end

loop_j.body:                                      ; preds = %loop_j.cond
  %55 = getelementptr inbounds i32, i32* %31, i64 %52
  %56 = load i32, i32* %55, align 4
  %57 = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %58 = add i64 %52, 1
  %59 = load i64, i64* %src, align 8
  %60 = call i32 (i8*, ...) @printf(i8* %57, i64 %59, i64 %52, i32 %56)
  br label %loop_j.cond

loop_j.end:                                       ; preds = %loop_j.cond
  ret i32 0
}