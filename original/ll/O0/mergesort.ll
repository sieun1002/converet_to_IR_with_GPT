; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/mergesort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/mergesort.c"
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
  call void @merge_sort(i32* noundef %6, i64 noundef %7)
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
define internal void @merge_sort(i32* noundef %0, i64 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca i32*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  %13 = alloca i64, align 8
  %14 = alloca i64, align 8
  %15 = alloca i64, align 8
  %16 = alloca i32*, align 8
  store i32* %0, i32** %3, align 8
  store i64 %1, i64* %4, align 8
  %17 = load i64, i64* %4, align 8
  %18 = icmp ult i64 %17, 2
  br i1 %18, label %19, label %20

19:                                               ; preds = %2
  br label %134

20:                                               ; preds = %2
  %21 = load i64, i64* %4, align 8
  %22 = mul i64 %21, 4
  %23 = call noalias i8* @malloc(i64 noundef %22) #4
  %24 = bitcast i8* %23 to i32*
  store i32* %24, i32** %5, align 8
  %25 = load i32*, i32** %5, align 8
  %26 = icmp ne i32* %25, null
  br i1 %26, label %28, label %27

27:                                               ; preds = %20
  br label %134

28:                                               ; preds = %20
  %29 = load i32*, i32** %3, align 8
  store i32* %29, i32** %6, align 8
  %30 = load i32*, i32** %5, align 8
  store i32* %30, i32** %7, align 8
  store i64 1, i64* %8, align 8
  br label %31

31:                                               ; preds = %117, %28
  %32 = load i64, i64* %8, align 8
  %33 = load i64, i64* %4, align 8
  %34 = icmp ult i64 %32, %33
  br i1 %34, label %35, label %120

35:                                               ; preds = %31
  store i64 0, i64* %9, align 8
  br label %36

36:                                               ; preds = %108, %35
  %37 = load i64, i64* %9, align 8
  %38 = load i64, i64* %4, align 8
  %39 = icmp ult i64 %37, %38
  br i1 %39, label %40, label %113

40:                                               ; preds = %36
  %41 = load i64, i64* %9, align 8
  store i64 %41, i64* %10, align 8
  %42 = load i64, i64* %9, align 8
  %43 = load i64, i64* %8, align 8
  %44 = add i64 %42, %43
  store i64 %44, i64* %11, align 8
  %45 = load i64, i64* %11, align 8
  %46 = load i64, i64* %4, align 8
  %47 = icmp ugt i64 %45, %46
  br i1 %47, label %48, label %50

48:                                               ; preds = %40
  %49 = load i64, i64* %4, align 8
  store i64 %49, i64* %11, align 8
  br label %50

50:                                               ; preds = %48, %40
  %51 = load i64, i64* %9, align 8
  %52 = load i64, i64* %8, align 8
  %53 = mul i64 2, %52
  %54 = add i64 %51, %53
  store i64 %54, i64* %12, align 8
  %55 = load i64, i64* %12, align 8
  %56 = load i64, i64* %4, align 8
  %57 = icmp ugt i64 %55, %56
  br i1 %57, label %58, label %60

58:                                               ; preds = %50
  %59 = load i64, i64* %4, align 8
  store i64 %59, i64* %12, align 8
  br label %60

60:                                               ; preds = %58, %50
  %61 = load i64, i64* %10, align 8
  store i64 %61, i64* %13, align 8
  %62 = load i64, i64* %11, align 8
  store i64 %62, i64* %14, align 8
  %63 = load i64, i64* %10, align 8
  store i64 %63, i64* %15, align 8
  br label %64

64:                                               ; preds = %105, %60
  %65 = load i64, i64* %15, align 8
  %66 = load i64, i64* %12, align 8
  %67 = icmp ult i64 %65, %66
  br i1 %67, label %68, label %108

68:                                               ; preds = %64
  %69 = load i64, i64* %13, align 8
  %70 = load i64, i64* %11, align 8
  %71 = icmp ult i64 %69, %70
  br i1 %71, label %72, label %95

72:                                               ; preds = %68
  %73 = load i64, i64* %14, align 8
  %74 = load i64, i64* %12, align 8
  %75 = icmp uge i64 %73, %74
  br i1 %75, label %86, label %76

76:                                               ; preds = %72
  %77 = load i32*, i32** %6, align 8
  %78 = load i64, i64* %13, align 8
  %79 = getelementptr inbounds i32, i32* %77, i64 %78
  %80 = load i32, i32* %79, align 4
  %81 = load i32*, i32** %6, align 8
  %82 = load i64, i64* %14, align 8
  %83 = getelementptr inbounds i32, i32* %81, i64 %82
  %84 = load i32, i32* %83, align 4
  %85 = icmp sle i32 %80, %84
  br i1 %85, label %86, label %95

86:                                               ; preds = %76, %72
  %87 = load i32*, i32** %6, align 8
  %88 = load i64, i64* %13, align 8
  %89 = add i64 %88, 1
  store i64 %89, i64* %13, align 8
  %90 = getelementptr inbounds i32, i32* %87, i64 %88
  %91 = load i32, i32* %90, align 4
  %92 = load i32*, i32** %7, align 8
  %93 = load i64, i64* %15, align 8
  %94 = getelementptr inbounds i32, i32* %92, i64 %93
  store i32 %91, i32* %94, align 4
  br label %104

95:                                               ; preds = %76, %68
  %96 = load i32*, i32** %6, align 8
  %97 = load i64, i64* %14, align 8
  %98 = add i64 %97, 1
  store i64 %98, i64* %14, align 8
  %99 = getelementptr inbounds i32, i32* %96, i64 %97
  %100 = load i32, i32* %99, align 4
  %101 = load i32*, i32** %7, align 8
  %102 = load i64, i64* %15, align 8
  %103 = getelementptr inbounds i32, i32* %101, i64 %102
  store i32 %100, i32* %103, align 4
  br label %104

104:                                              ; preds = %95, %86
  br label %105

105:                                              ; preds = %104
  %106 = load i64, i64* %15, align 8
  %107 = add i64 %106, 1
  store i64 %107, i64* %15, align 8
  br label %64, !llvm.loop !8

108:                                              ; preds = %64
  %109 = load i64, i64* %8, align 8
  %110 = mul i64 2, %109
  %111 = load i64, i64* %9, align 8
  %112 = add i64 %111, %110
  store i64 %112, i64* %9, align 8
  br label %36, !llvm.loop !9

113:                                              ; preds = %36
  %114 = load i32*, i32** %6, align 8
  store i32* %114, i32** %16, align 8
  %115 = load i32*, i32** %7, align 8
  store i32* %115, i32** %6, align 8
  %116 = load i32*, i32** %16, align 8
  store i32* %116, i32** %7, align 8
  br label %117

117:                                              ; preds = %113
  %118 = load i64, i64* %8, align 8
  %119 = shl i64 %118, 1
  store i64 %119, i64* %8, align 8
  br label %31, !llvm.loop !10

120:                                              ; preds = %31
  %121 = load i32*, i32** %6, align 8
  %122 = load i32*, i32** %3, align 8
  %123 = icmp ne i32* %121, %122
  br i1 %123, label %124, label %131

124:                                              ; preds = %120
  %125 = load i32*, i32** %3, align 8
  %126 = bitcast i32* %125 to i8*
  %127 = load i32*, i32** %6, align 8
  %128 = bitcast i32* %127 to i8*
  %129 = load i64, i64* %4, align 8
  %130 = mul i64 %129, 4
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %126, i8* align 4 %128, i64 %130, i1 false)
  br label %131

131:                                              ; preds = %124, %120
  %132 = load i32*, i32** %5, align 8
  %133 = bitcast i32* %132 to i8*
  call void @free(i8* noundef %133) #4
  br label %134

134:                                              ; preds = %131, %27, %19
  ret void
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

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
