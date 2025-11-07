; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/bubblesort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/bubblesort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [10 x i32], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %5 = bitcast [10 x i32]* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %5, i8* align 16 bitcast ([10 x i32]* @__const.main.a to i8*), i64 40, i1 false)
  store i64 10, i64* %3, align 8
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i64 0, i64 0
  %7 = load i64, i64* %3, align 8
  call void @bubble_sort(i32* noundef %6, i64 noundef %7)
  store i64 0, i64* %4, align 8
  br label %8

8:                                                ; preds = %17, %0
  %9 = load i64, i64* %4, align 8
  %10 = load i64, i64* %3, align 8
  %11 = icmp ult i64 %9, %10
  br i1 %11, label %12, label %20

12:                                               ; preds = %8
  %13 = load i64, i64* %4, align 8
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i64 0, i64 %13
  %15 = load i32, i32* %14, align 4
  %16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %15)
  br label %17

17:                                               ; preds = %12
  %18 = load i64, i64* %4, align 8
  %19 = add i64 %18, 1
  store i64 %19, i64* %4, align 8
  br label %8, !llvm.loop !6

20:                                               ; preds = %8
  %21 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @bubble_sort(i32* noundef %0, i64 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i64 %1, i64* %4, align 8
  %9 = load i64, i64* %4, align 8
  %10 = icmp ult i64 %9, 2
  br i1 %10, label %11, label %12

11:                                               ; preds = %2
  br label %62

12:                                               ; preds = %2
  %13 = load i64, i64* %4, align 8
  store i64 %13, i64* %5, align 8
  br label %14

14:                                               ; preds = %60, %12
  %15 = load i64, i64* %5, align 8
  %16 = icmp ugt i64 %15, 1
  br i1 %16, label %17, label %62

17:                                               ; preds = %14
  store i64 0, i64* %6, align 8
  store i64 1, i64* %7, align 8
  br label %18

18:                                               ; preds = %53, %17
  %19 = load i64, i64* %7, align 8
  %20 = load i64, i64* %5, align 8
  %21 = icmp ult i64 %19, %20
  br i1 %21, label %22, label %56

22:                                               ; preds = %18
  %23 = load i32*, i32** %3, align 8
  %24 = load i64, i64* %7, align 8
  %25 = sub i64 %24, 1
  %26 = getelementptr inbounds i32, i32* %23, i64 %25
  %27 = load i32, i32* %26, align 4
  %28 = load i32*, i32** %3, align 8
  %29 = load i64, i64* %7, align 8
  %30 = getelementptr inbounds i32, i32* %28, i64 %29
  %31 = load i32, i32* %30, align 4
  %32 = icmp sgt i32 %27, %31
  br i1 %32, label %33, label %52

33:                                               ; preds = %22
  %34 = load i32*, i32** %3, align 8
  %35 = load i64, i64* %7, align 8
  %36 = sub i64 %35, 1
  %37 = getelementptr inbounds i32, i32* %34, i64 %36
  %38 = load i32, i32* %37, align 4
  store i32 %38, i32* %8, align 4
  %39 = load i32*, i32** %3, align 8
  %40 = load i64, i64* %7, align 8
  %41 = getelementptr inbounds i32, i32* %39, i64 %40
  %42 = load i32, i32* %41, align 4
  %43 = load i32*, i32** %3, align 8
  %44 = load i64, i64* %7, align 8
  %45 = sub i64 %44, 1
  %46 = getelementptr inbounds i32, i32* %43, i64 %45
  store i32 %42, i32* %46, align 4
  %47 = load i32, i32* %8, align 4
  %48 = load i32*, i32** %3, align 8
  %49 = load i64, i64* %7, align 8
  %50 = getelementptr inbounds i32, i32* %48, i64 %49
  store i32 %47, i32* %50, align 4
  %51 = load i64, i64* %7, align 8
  store i64 %51, i64* %6, align 8
  br label %52

52:                                               ; preds = %33, %22
  br label %53

53:                                               ; preds = %52
  %54 = load i64, i64* %7, align 8
  %55 = add i64 %54, 1
  store i64 %55, i64* %7, align 8
  br label %18, !llvm.loop !8

56:                                               ; preds = %18
  %57 = load i64, i64* %6, align 8
  %58 = icmp eq i64 %57, 0
  br i1 %58, label %59, label %60

59:                                               ; preds = %56
  br label %62

60:                                               ; preds = %56
  %61 = load i64, i64* %6, align 8
  store i64 %61, i64* %5, align 8
  br label %14, !llvm.loop !9

62:                                               ; preds = %11, %59, %14
  ret void
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
!9 = distinct !{!9, !7}
