; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dllimport i32 @printf(i8* noundef, ...)
declare dllimport i32 @putchar(i32 noundef)
declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %start = alloca i64, align 8
  %N = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8

  store i64 7, i64* %N, align 8

  %0 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %0, i8 0, i64 196, i1 false)

  %1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %2, align 4

  %3 = load i64, i64* %N, align 8
  %4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %3
  store i32 1, i32* %4, align 4

  %5 = load i64, i64* %N, align 8
  %6 = shl i64 %5, 1
  %7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %6
  store i32 1, i32* %7, align 4

  %8 = load i64, i64* %N, align 8
  %9 = add i64 %8, 3
  %10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %9
  store i32 1, i32* %10, align 4

  %11 = load i64, i64* %N, align 8
  %12 = shl i64 %11, 1
  %13 = add i64 %12, %11
  %14 = add i64 %13, 1
  %15 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %14
  store i32 1, i32* %15, align 4

  %16 = load i64, i64* %N, align 8
  %17 = add i64 %16, 4
  %18 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %17
  store i32 1, i32* %18, align 4

  %19 = load i64, i64* %N, align 8
  %20 = shl i64 %19, 2
  %21 = add i64 %20, 1
  %22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %21
  store i32 1, i32* %22, align 4

  %23 = load i64, i64* %N, align 8
  %24 = shl i64 %23, 1
  %25 = add i64 %24, 5
  %26 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %25
  store i32 1, i32* %26, align 4

  %27 = load i64, i64* %N, align 8
  %28 = shl i64 %27, 2
  %29 = add i64 %28, %27
  %30 = add i64 %29, 2
  %31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %30
  store i32 1, i32* %31, align 4

  %32 = load i64, i64* %N, align 8
  %33 = shl i64 %32, 2
  %34 = add i64 %33, 5
  %35 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %34
  store i32 1, i32* %35, align 4

  %36 = load i64, i64* %N, align 8
  %37 = shl i64 %36, 2
  %38 = add i64 %37, %36
  %39 = add i64 %38, 4
  %40 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %39
  store i32 1, i32* %40, align 4

  %41 = load i64, i64* %N, align 8
  %42 = shl i64 %41, 2
  %43 = add i64 %42, %41
  %44 = add i64 %43, 6
  %45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %44
  store i32 1, i32* %45, align 4

  %46 = load i64, i64* %N, align 8
  %47 = shl i64 %46, 1
  %48 = add i64 %47, %46
  %49 = shl i64 %48, 1
  %50 = add i64 %49, 5
  %51 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %50
  store i32 1, i32* %51, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %len, align 8

  %52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %53 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %54 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %55 = load i64, i64* %N, align 8
  %56 = load i64, i64* %start, align 8
  call void @bfs(i32* %52, i64 %55, i64 %56, i32* %53, i64* %54, i64* %len)

  %57 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %58 = load i64, i64* %start, align 8
  %59 = call i32 (i8*, ...) @printf(i8* %57, i64 %58)

  store i64 0, i64* %i, align 8
  br label %cmp_order

cmp_order:                                        ; preds = %body_order, %entry
  %60 = load i64, i64* %i, align 8
  %61 = load i64, i64* %len, align 8
  %62 = icmp ult i64 %60, %61
  br i1 %62, label %body_order, label %after_order

body_order:                                       ; preds = %cmp_order
  %63 = add i64 %60, 1
  %64 = icmp uge i64 %63, %61
  %65 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %66 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 1
  %67 = select i1 %64, i8* %66, i8* %65
  %68 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %60
  %69 = load i64, i64* %68, align 8
  %70 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %71 = call i32 (i8*, ...) @printf(i8* %70, i64 %69, i8* %67)
  %72 = add i64 %60, 1
  store i64 %72, i64* %i, align 8
  br label %cmp_order

after_order:                                      ; preds = %cmp_order
  %73 = call i32 @putchar(i32 10)
  store i64 0, i64* %v, align 8
  br label %cmp_dist

cmp_dist:                                         ; preds = %body_dist, %after_order
  %74 = load i64, i64* %v, align 8
  %75 = load i64, i64* %N, align 8
  %76 = icmp ult i64 %74, %75
  br i1 %76, label %body_dist, label %ret

body_dist:                                        ; preds = %cmp_dist
  %77 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %74
  %78 = load i32, i32* %77, align 4
  %79 = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %80 = load i64, i64* %start, align 8
  %81 = call i32 (i8*, ...) @printf(i8* %79, i64 %80, i64 %74, i32 %78)
  %82 = add i64 %74, 1
  store i64 %82, i64* %v, align 8
  br label %cmp_dist

ret:                                              ; preds = %cmp_dist
  ret i32 0
}