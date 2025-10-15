; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aBfsOrderFromZu = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00", align 1
@unk_140004017 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @sub_1400019C0()
declare void @sub_140001450(i32*, i64, i64, i8*, i64*, i64*)
declare i32 @sub_140002A40(i8*, ...)
declare i32 @sub_140002BD0(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @sub_14000165D() {
entry:
  %rbp_anchor = alloca i8, align 1
  %var_28 = alloca i64, align 8
  %var_30 = alloca i64, align 8
  %var_168 = alloca i64, align 8
  %var_18 = alloca i64, align 8
  %var_20 = alloca i64, align 8
  %adj = alloca [48 x i32], align 16
  %arr160 = alloca [64 x i64], align 16
  %dist120 = alloca [64 x i32], align 16
  call void @sub_1400019C0()
  store i64 7, i64* %var_28, align 8
  %0 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %0, i8 0, i64 192, i1 false)
  %1 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  store i32 0, i32* %1, align 4
  %2 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %3, align 4
  %4 = load i64, i64* %var_28, align 8
  %5 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %6 = getelementptr inbounds i32, i32* %5, i64 %4
  store i32 1, i32* %6, align 4
  %7 = shl i64 %4, 1
  %8 = getelementptr inbounds i32, i32* %5, i64 %7
  store i32 1, i32* %8, align 4
  %9 = add i64 %4, 3
  %10 = getelementptr inbounds i32, i32* %5, i64 %9
  store i32 1, i32* %10, align 4
  %11 = add i64 %4, %7
  %12 = add i64 %11, 1
  %13 = getelementptr inbounds i32, i32* %5, i64 %12
  store i32 1, i32* %13, align 4
  %14 = add i64 %4, 4
  %15 = getelementptr inbounds i32, i32* %5, i64 %14
  store i32 1, i32* %15, align 4
  %16 = shl i64 %4, 2
  %17 = add i64 %16, 1
  %18 = getelementptr inbounds i32, i32* %5, i64 %17
  store i32 1, i32* %18, align 4
  %19 = add i64 %7, 5
  %20 = getelementptr inbounds i32, i32* %5, i64 %19
  store i32 1, i32* %20, align 4
  %21 = add i64 %16, %4
  %22 = add i64 %21, 2
  %23 = getelementptr inbounds i32, i32* %5, i64 %22
  store i32 1, i32* %23, align 4
  %24 = add i64 %16, 5
  %25 = getelementptr inbounds i32, i32* %5, i64 %24
  store i32 1, i32* %25, align 4
  %26 = add i64 %21, 4
  %27 = getelementptr inbounds i32, i32* %5, i64 %26
  store i32 1, i32* %27, align 4
  %28 = add i64 %21, 6
  %29 = getelementptr inbounds i32, i32* %5, i64 %28
  store i32 1, i32* %29, align 4
  %30 = shl i64 %11, 1
  %31 = add i64 %30, 5
  %32 = getelementptr inbounds i32, i32* %5, i64 %31
  store i32 1, i32* %32, align 4
  store i64 0, i64* %var_30, align 8
  store i64 0, i64* %var_168, align 8
  %33 = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %34 = load i64, i64* %var_28, align 8
  %35 = load i64, i64* %var_30, align 8
  %36 = getelementptr inbounds [64 x i64], [64 x i64]* %arr160, i64 0, i64 0
  call void @sub_140001450(i32* %33, i64 %34, i64 %35, i8* %rbp_anchor, i64* %36, i64* %var_168)
  %37 = load i64, i64* %var_30, align 8
  %38 = getelementptr inbounds [21 x i8], [21 x i8]* @aBfsOrderFromZu, i64 0, i64 0
  %39 = call i32 (i8*, ...) @sub_140002A40(i8* %38, i64 %37)
  store i64 0, i64* %var_18, align 8
  br label %loop_check

loop_body:                                       ; preds = %loop_check
  %40 = load i64, i64* %var_18, align 8
  %41 = add i64 %40, 1
  %42 = load i64, i64* %var_168, align 8
  %43 = icmp ult i64 %41, %42
  %44 = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i64 0, i64 0
  %45 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i64 0, i64 0
  %46 = select i1 %43, i8* %44, i8* %45
  %47 = getelementptr inbounds [64 x i64], [64 x i64]* %arr160, i64 0, i64 %40
  %48 = load i64, i64* %47, align 8
  %49 = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i64 0, i64 0
  %50 = call i32 (i8*, ...) @sub_140002A40(i8* %49, i64 %48, i8* %46)
  %51 = add i64 %40, 1
  store i64 %51, i64* %var_18, align 8
  br label %loop_check

loop_check:                                      ; preds = %loop_body, %entry
  %52 = load i64, i64* %var_18, align 8
  %53 = load i64, i64* %var_168, align 8
  %54 = icmp ult i64 %52, %53
  br i1 %54, label %loop_body, label %after_loop

after_loop:                                      ; preds = %loop_check
  %55 = call i32 @sub_140002BD0(i32 10)
  store i64 0, i64* %var_20, align 8
  br label %loop2_check

loop2_body:                                      ; preds = %loop2_check
  %56 = load i64, i64* %var_20, align 8
  %57 = getelementptr inbounds [64 x i32], [64 x i32]* %dist120, i64 0, i64 0
  %58 = getelementptr inbounds i32, i32* %57, i64 %56
  %59 = load i32, i32* %58, align 4
  %60 = load i64, i64* %var_20, align 8
  %61 = load i64, i64* %var_30, align 8
  %62 = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i64 0, i64 0
  %63 = call i32 (i8*, ...) @sub_140002A40(i8* %62, i64 %61, i64 %60, i32 %59)
  %64 = add i64 %56, 1
  store i64 %64, i64* %var_20, align 8
  br label %loop2_check

loop2_check:                                     ; preds = %loop2_body, %after_loop
  %65 = load i64, i64* %var_20, align 8
  %66 = load i64, i64* %var_28, align 8
  %67 = icmp ult i64 %65, %66
  br i1 %67, label %loop2_body, label %retblock

retblock:                                        ; preds = %loop2_check
  ret i32 0
}