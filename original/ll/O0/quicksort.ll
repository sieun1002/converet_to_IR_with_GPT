; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/quicksort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/quicksort.c"
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
  %6 = load i64, i64* %3, align 8
  %7 = icmp ugt i64 %6, 1
  br i1 %7, label %8, label %12

8:                                                ; preds = %0
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i64 0, i64 0
  %10 = load i64, i64* %3, align 8
  %11 = sub nsw i64 %10, 1
  call void @quick_sort(i32* noundef %9, i64 noundef 0, i64 noundef %11)
  br label %12

12:                                               ; preds = %8, %0
  store i64 0, i64* %4, align 8
  br label %13

13:                                               ; preds = %22, %12
  %14 = load i64, i64* %4, align 8
  %15 = load i64, i64* %3, align 8
  %16 = icmp ult i64 %14, %15
  br i1 %16, label %17, label %25

17:                                               ; preds = %13
  %18 = load i64, i64* %4, align 8
  %19 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i64 0, i64 %18
  %20 = load i32, i32* %19, align 4
  %21 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %20)
  br label %22

22:                                               ; preds = %17
  %23 = load i64, i64* %4, align 8
  %24 = add i64 %23, 1
  store i64 %24, i64* %4, align 8
  br label %13, !llvm.loop !6

25:                                               ; preds = %13
  %26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @quick_sort(i32* noundef %0, i64 noundef %1, i64 noundef %2) #0 {
  %4 = alloca i32*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32* %0, i32** %4, align 8
  store i64 %1, i64* %5, align 8
  store i64 %2, i64* %6, align 8
  br label %11

11:                                               ; preds = %106, %3
  %12 = load i64, i64* %5, align 8
  %13 = load i64, i64* %6, align 8
  %14 = icmp slt i64 %12, %13
  br i1 %14, label %15, label %107

15:                                               ; preds = %11
  %16 = load i64, i64* %5, align 8
  store i64 %16, i64* %7, align 8
  %17 = load i64, i64* %6, align 8
  store i64 %17, i64* %8, align 8
  %18 = load i32*, i32** %4, align 8
  %19 = load i64, i64* %5, align 8
  %20 = load i64, i64* %6, align 8
  %21 = load i64, i64* %5, align 8
  %22 = sub nsw i64 %20, %21
  %23 = sdiv i64 %22, 2
  %24 = add nsw i64 %19, %23
  %25 = getelementptr inbounds i32, i32* %18, i64 %24
  %26 = load i32, i32* %25, align 4
  store i32 %26, i32* %9, align 4
  br label %27

27:                                               ; preds = %74, %15
  br label %28

28:                                               ; preds = %35, %27
  %29 = load i32*, i32** %4, align 8
  %30 = load i64, i64* %7, align 8
  %31 = getelementptr inbounds i32, i32* %29, i64 %30
  %32 = load i32, i32* %31, align 4
  %33 = load i32, i32* %9, align 4
  %34 = icmp slt i32 %32, %33
  br i1 %34, label %35, label %38

35:                                               ; preds = %28
  %36 = load i64, i64* %7, align 8
  %37 = add nsw i64 %36, 1
  store i64 %37, i64* %7, align 8
  br label %28, !llvm.loop !8

38:                                               ; preds = %28
  br label %39

39:                                               ; preds = %46, %38
  %40 = load i32*, i32** %4, align 8
  %41 = load i64, i64* %8, align 8
  %42 = getelementptr inbounds i32, i32* %40, i64 %41
  %43 = load i32, i32* %42, align 4
  %44 = load i32, i32* %9, align 4
  %45 = icmp sgt i32 %43, %44
  br i1 %45, label %46, label %49

46:                                               ; preds = %39
  %47 = load i64, i64* %8, align 8
  %48 = add nsw i64 %47, -1
  store i64 %48, i64* %8, align 8
  br label %39, !llvm.loop !9

49:                                               ; preds = %39
  %50 = load i64, i64* %7, align 8
  %51 = load i64, i64* %8, align 8
  %52 = icmp sle i64 %50, %51
  br i1 %52, label %53, label %73

53:                                               ; preds = %49
  %54 = load i32*, i32** %4, align 8
  %55 = load i64, i64* %7, align 8
  %56 = getelementptr inbounds i32, i32* %54, i64 %55
  %57 = load i32, i32* %56, align 4
  store i32 %57, i32* %10, align 4
  %58 = load i32*, i32** %4, align 8
  %59 = load i64, i64* %8, align 8
  %60 = getelementptr inbounds i32, i32* %58, i64 %59
  %61 = load i32, i32* %60, align 4
  %62 = load i32*, i32** %4, align 8
  %63 = load i64, i64* %7, align 8
  %64 = getelementptr inbounds i32, i32* %62, i64 %63
  store i32 %61, i32* %64, align 4
  %65 = load i32, i32* %10, align 4
  %66 = load i32*, i32** %4, align 8
  %67 = load i64, i64* %8, align 8
  %68 = getelementptr inbounds i32, i32* %66, i64 %67
  store i32 %65, i32* %68, align 4
  %69 = load i64, i64* %7, align 8
  %70 = add nsw i64 %69, 1
  store i64 %70, i64* %7, align 8
  %71 = load i64, i64* %8, align 8
  %72 = add nsw i64 %71, -1
  store i64 %72, i64* %8, align 8
  br label %73

73:                                               ; preds = %53, %49
  br label %74

74:                                               ; preds = %73
  %75 = load i64, i64* %7, align 8
  %76 = load i64, i64* %8, align 8
  %77 = icmp sle i64 %75, %76
  br i1 %77, label %27, label %78, !llvm.loop !10

78:                                               ; preds = %74
  %79 = load i64, i64* %8, align 8
  %80 = load i64, i64* %5, align 8
  %81 = sub nsw i64 %79, %80
  %82 = load i64, i64* %6, align 8
  %83 = load i64, i64* %7, align 8
  %84 = sub nsw i64 %82, %83
  %85 = icmp slt i64 %81, %84
  br i1 %85, label %86, label %96

86:                                               ; preds = %78
  %87 = load i64, i64* %5, align 8
  %88 = load i64, i64* %8, align 8
  %89 = icmp slt i64 %87, %88
  br i1 %89, label %90, label %94

90:                                               ; preds = %86
  %91 = load i32*, i32** %4, align 8
  %92 = load i64, i64* %5, align 8
  %93 = load i64, i64* %8, align 8
  call void @quick_sort(i32* noundef %91, i64 noundef %92, i64 noundef %93)
  br label %94

94:                                               ; preds = %90, %86
  %95 = load i64, i64* %7, align 8
  store i64 %95, i64* %5, align 8
  br label %106

96:                                               ; preds = %78
  %97 = load i64, i64* %7, align 8
  %98 = load i64, i64* %6, align 8
  %99 = icmp slt i64 %97, %98
  br i1 %99, label %100, label %104

100:                                              ; preds = %96
  %101 = load i32*, i32** %4, align 8
  %102 = load i64, i64* %7, align 8
  %103 = load i64, i64* %6, align 8
  call void @quick_sort(i32* noundef %101, i64 noundef %102, i64 noundef %103)
  br label %104

104:                                              ; preds = %100, %96
  %105 = load i64, i64* %8, align 8
  store i64 %105, i64* %6, align 8
  br label %106

106:                                              ; preds = %104, %94
  br label %11, !llvm.loop !11

107:                                              ; preds = %11
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
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
