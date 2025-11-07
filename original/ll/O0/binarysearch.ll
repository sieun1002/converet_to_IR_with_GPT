; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/binarysearch.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/binarysearch.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], align 16
@__const.main.keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5], align 4
@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [9 x i32], align 16
  %3 = alloca i64, align 8
  %4 = alloca [3 x i32], align 4
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %8 = bitcast [9 x i32]* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %8, i8* align 16 bitcast ([9 x i32]* @__const.main.a to i8*), i64 36, i1 false)
  store i64 9, i64* %3, align 8
  %9 = bitcast [3 x i32]* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %9, i8* align 4 bitcast ([3 x i32]* @__const.main.keys to i8*), i64 12, i1 false)
  store i64 3, i64* %5, align 8
  store i64 0, i64* %6, align 8
  br label %10

10:                                               ; preds = %35, %0
  %11 = load i64, i64* %6, align 8
  %12 = load i64, i64* %5, align 8
  %13 = icmp ult i64 %11, %12
  br i1 %13, label %14, label %38

14:                                               ; preds = %10
  %15 = getelementptr inbounds [9 x i32], [9 x i32]* %2, i64 0, i64 0
  %16 = load i64, i64* %3, align 8
  %17 = load i64, i64* %6, align 8
  %18 = getelementptr inbounds [3 x i32], [3 x i32]* %4, i64 0, i64 %17
  %19 = load i32, i32* %18, align 4
  %20 = call i64 @binary_search(i32* noundef %15, i64 noundef %16, i32 noundef %19)
  store i64 %20, i64* %7, align 8
  %21 = load i64, i64* %7, align 8
  %22 = icmp sge i64 %21, 0
  br i1 %22, label %23, label %29

23:                                               ; preds = %14
  %24 = load i64, i64* %6, align 8
  %25 = getelementptr inbounds [3 x i32], [3 x i32]* %4, i64 0, i64 %24
  %26 = load i32, i32* %25, align 4
  %27 = load i64, i64* %7, align 8
  %28 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 noundef %26, i64 noundef %27)
  br label %34

29:                                               ; preds = %14
  %30 = load i64, i64* %6, align 8
  %31 = getelementptr inbounds [3 x i32], [3 x i32]* %4, i64 0, i64 %30
  %32 = load i32, i32* %31, align 4
  %33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef %32)
  br label %34

34:                                               ; preds = %29, %23
  br label %35

35:                                               ; preds = %34
  %36 = load i64, i64* %6, align 8
  %37 = add i64 %36, 1
  store i64 %37, i64* %6, align 8
  br label %10, !llvm.loop !6

38:                                               ; preds = %10
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal i64 @binary_search(i32* noundef %0, i64 noundef %1, i32 noundef %2) #0 {
  %4 = alloca i64, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  store i32* %0, i32** %5, align 8
  store i64 %1, i64* %6, align 8
  store i32 %2, i32* %7, align 4
  store i64 0, i64* %8, align 8
  %11 = load i64, i64* %6, align 8
  store i64 %11, i64* %9, align 8
  br label %12

12:                                               ; preds = %34, %3
  %13 = load i64, i64* %8, align 8
  %14 = load i64, i64* %9, align 8
  %15 = icmp ult i64 %13, %14
  br i1 %15, label %16, label %35

16:                                               ; preds = %12
  %17 = load i64, i64* %8, align 8
  %18 = load i64, i64* %9, align 8
  %19 = load i64, i64* %8, align 8
  %20 = sub i64 %18, %19
  %21 = udiv i64 %20, 2
  %22 = add i64 %17, %21
  store i64 %22, i64* %10, align 8
  %23 = load i32*, i32** %5, align 8
  %24 = load i64, i64* %10, align 8
  %25 = getelementptr inbounds i32, i32* %23, i64 %24
  %26 = load i32, i32* %25, align 4
  %27 = load i32, i32* %7, align 4
  %28 = icmp slt i32 %26, %27
  br i1 %28, label %29, label %32

29:                                               ; preds = %16
  %30 = load i64, i64* %10, align 8
  %31 = add i64 %30, 1
  store i64 %31, i64* %8, align 8
  br label %34

32:                                               ; preds = %16
  %33 = load i64, i64* %10, align 8
  store i64 %33, i64* %9, align 8
  br label %34

34:                                               ; preds = %32, %29
  br label %12, !llvm.loop !8

35:                                               ; preds = %12
  %36 = load i64, i64* %8, align 8
  %37 = load i64, i64* %6, align 8
  %38 = icmp ult i64 %36, %37
  br i1 %38, label %39, label %48

39:                                               ; preds = %35
  %40 = load i32*, i32** %5, align 8
  %41 = load i64, i64* %8, align 8
  %42 = getelementptr inbounds i32, i32* %40, i64 %41
  %43 = load i32, i32* %42, align 4
  %44 = load i32, i32* %7, align 4
  %45 = icmp eq i32 %43, %44
  br i1 %45, label %46, label %48

46:                                               ; preds = %39
  %47 = load i64, i64* %8, align 8
  store i64 %47, i64* %4, align 8
  br label %49

48:                                               ; preds = %39, %35
  store i64 -1, i64* %4, align 8
  br label %49

49:                                               ; preds = %48, %46
  %50 = load i64, i64* %4, align 8
  ret i64 %50
}

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
