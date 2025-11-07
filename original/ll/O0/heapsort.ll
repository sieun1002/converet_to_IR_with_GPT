; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/heapsort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/heapsort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.arr = private unnamed_addr constant [9 x i32] [i32 7, i32 3, i32 9, i32 1, i32 4, i32 8, i32 2, i32 6, i32 5], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @heap_sort(i32* noundef %0, i64 noundef %1) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i32, align 4
  %11 = alloca i64, align 8
  %12 = alloca i32, align 4
  %13 = alloca i64, align 8
  %14 = alloca i64, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i64 %1, i64* %4, align 8
  %18 = load i64, i64* %4, align 8
  %19 = icmp ult i64 %18, 2
  br i1 %19, label %20, label %21

20:                                               ; preds = %2
  br label %169

21:                                               ; preds = %2
  %22 = load i64, i64* %4, align 8
  %23 = udiv i64 %22, 2
  store i64 %23, i64* %5, align 8
  br label %24

24:                                               ; preds = %87, %21
  %25 = load i64, i64* %5, align 8
  %26 = add i64 %25, -1
  store i64 %26, i64* %5, align 8
  %27 = icmp ugt i64 %25, 0
  br i1 %27, label %28, label %88

28:                                               ; preds = %24
  %29 = load i64, i64* %5, align 8
  store i64 %29, i64* %6, align 8
  br label %30

30:                                               ; preds = %70, %28
  %31 = load i64, i64* %6, align 8
  %32 = mul i64 %31, 2
  %33 = add i64 %32, 1
  store i64 %33, i64* %7, align 8
  %34 = load i64, i64* %7, align 8
  %35 = load i64, i64* %4, align 8
  %36 = icmp uge i64 %34, %35
  br i1 %36, label %37, label %38

37:                                               ; preds = %30
  br label %87

38:                                               ; preds = %30
  %39 = load i64, i64* %7, align 8
  %40 = add i64 %39, 1
  store i64 %40, i64* %8, align 8
  %41 = load i64, i64* %8, align 8
  %42 = load i64, i64* %4, align 8
  %43 = icmp ult i64 %41, %42
  br i1 %43, label %44, label %56

44:                                               ; preds = %38
  %45 = load i32*, i32** %3, align 8
  %46 = load i64, i64* %8, align 8
  %47 = getelementptr inbounds i32, i32* %45, i64 %46
  %48 = load i32, i32* %47, align 4
  %49 = load i32*, i32** %3, align 8
  %50 = load i64, i64* %7, align 8
  %51 = getelementptr inbounds i32, i32* %49, i64 %50
  %52 = load i32, i32* %51, align 4
  %53 = icmp sgt i32 %48, %52
  br i1 %53, label %54, label %56

54:                                               ; preds = %44
  %55 = load i64, i64* %8, align 8
  br label %58

56:                                               ; preds = %44, %38
  %57 = load i64, i64* %7, align 8
  br label %58

58:                                               ; preds = %56, %54
  %59 = phi i64 [ %55, %54 ], [ %57, %56 ]
  store i64 %59, i64* %9, align 8
  %60 = load i32*, i32** %3, align 8
  %61 = load i64, i64* %6, align 8
  %62 = getelementptr inbounds i32, i32* %60, i64 %61
  %63 = load i32, i32* %62, align 4
  %64 = load i32*, i32** %3, align 8
  %65 = load i64, i64* %9, align 8
  %66 = getelementptr inbounds i32, i32* %64, i64 %65
  %67 = load i32, i32* %66, align 4
  %68 = icmp sge i32 %63, %67
  br i1 %68, label %69, label %70

69:                                               ; preds = %58
  br label %87

70:                                               ; preds = %58
  %71 = load i32*, i32** %3, align 8
  %72 = load i64, i64* %6, align 8
  %73 = getelementptr inbounds i32, i32* %71, i64 %72
  %74 = load i32, i32* %73, align 4
  store i32 %74, i32* %10, align 4
  %75 = load i32*, i32** %3, align 8
  %76 = load i64, i64* %9, align 8
  %77 = getelementptr inbounds i32, i32* %75, i64 %76
  %78 = load i32, i32* %77, align 4
  %79 = load i32*, i32** %3, align 8
  %80 = load i64, i64* %6, align 8
  %81 = getelementptr inbounds i32, i32* %79, i64 %80
  store i32 %78, i32* %81, align 4
  %82 = load i32, i32* %10, align 4
  %83 = load i32*, i32** %3, align 8
  %84 = load i64, i64* %9, align 8
  %85 = getelementptr inbounds i32, i32* %83, i64 %84
  store i32 %82, i32* %85, align 4
  %86 = load i64, i64* %9, align 8
  store i64 %86, i64* %6, align 8
  br label %30

87:                                               ; preds = %69, %37
  br label %24, !llvm.loop !6

88:                                               ; preds = %24
  %89 = load i64, i64* %4, align 8
  %90 = sub i64 %89, 1
  store i64 %90, i64* %11, align 8
  br label %91

91:                                               ; preds = %166, %88
  %92 = load i64, i64* %11, align 8
  %93 = icmp ugt i64 %92, 0
  br i1 %93, label %94, label %169

94:                                               ; preds = %91
  %95 = load i32*, i32** %3, align 8
  %96 = getelementptr inbounds i32, i32* %95, i64 0
  %97 = load i32, i32* %96, align 4
  store i32 %97, i32* %12, align 4
  %98 = load i32*, i32** %3, align 8
  %99 = load i64, i64* %11, align 8
  %100 = getelementptr inbounds i32, i32* %98, i64 %99
  %101 = load i32, i32* %100, align 4
  %102 = load i32*, i32** %3, align 8
  %103 = getelementptr inbounds i32, i32* %102, i64 0
  store i32 %101, i32* %103, align 4
  %104 = load i32, i32* %12, align 4
  %105 = load i32*, i32** %3, align 8
  %106 = load i64, i64* %11, align 8
  %107 = getelementptr inbounds i32, i32* %105, i64 %106
  store i32 %104, i32* %107, align 4
  store i64 0, i64* %13, align 8
  br label %108

108:                                              ; preds = %148, %94
  %109 = load i64, i64* %13, align 8
  %110 = mul i64 %109, 2
  %111 = add i64 %110, 1
  store i64 %111, i64* %14, align 8
  %112 = load i64, i64* %14, align 8
  %113 = load i64, i64* %11, align 8
  %114 = icmp uge i64 %112, %113
  br i1 %114, label %115, label %116

115:                                              ; preds = %108
  br label %165

116:                                              ; preds = %108
  %117 = load i64, i64* %14, align 8
  %118 = add i64 %117, 1
  store i64 %118, i64* %15, align 8
  %119 = load i64, i64* %15, align 8
  %120 = load i64, i64* %11, align 8
  %121 = icmp ult i64 %119, %120
  br i1 %121, label %122, label %134

122:                                              ; preds = %116
  %123 = load i32*, i32** %3, align 8
  %124 = load i64, i64* %15, align 8
  %125 = getelementptr inbounds i32, i32* %123, i64 %124
  %126 = load i32, i32* %125, align 4
  %127 = load i32*, i32** %3, align 8
  %128 = load i64, i64* %14, align 8
  %129 = getelementptr inbounds i32, i32* %127, i64 %128
  %130 = load i32, i32* %129, align 4
  %131 = icmp sgt i32 %126, %130
  br i1 %131, label %132, label %134

132:                                              ; preds = %122
  %133 = load i64, i64* %15, align 8
  br label %136

134:                                              ; preds = %122, %116
  %135 = load i64, i64* %14, align 8
  br label %136

136:                                              ; preds = %134, %132
  %137 = phi i64 [ %133, %132 ], [ %135, %134 ]
  store i64 %137, i64* %16, align 8
  %138 = load i32*, i32** %3, align 8
  %139 = load i64, i64* %13, align 8
  %140 = getelementptr inbounds i32, i32* %138, i64 %139
  %141 = load i32, i32* %140, align 4
  %142 = load i32*, i32** %3, align 8
  %143 = load i64, i64* %16, align 8
  %144 = getelementptr inbounds i32, i32* %142, i64 %143
  %145 = load i32, i32* %144, align 4
  %146 = icmp sge i32 %141, %145
  br i1 %146, label %147, label %148

147:                                              ; preds = %136
  br label %165

148:                                              ; preds = %136
  %149 = load i32*, i32** %3, align 8
  %150 = load i64, i64* %13, align 8
  %151 = getelementptr inbounds i32, i32* %149, i64 %150
  %152 = load i32, i32* %151, align 4
  store i32 %152, i32* %17, align 4
  %153 = load i32*, i32** %3, align 8
  %154 = load i64, i64* %16, align 8
  %155 = getelementptr inbounds i32, i32* %153, i64 %154
  %156 = load i32, i32* %155, align 4
  %157 = load i32*, i32** %3, align 8
  %158 = load i64, i64* %13, align 8
  %159 = getelementptr inbounds i32, i32* %157, i64 %158
  store i32 %156, i32* %159, align 4
  %160 = load i32, i32* %17, align 4
  %161 = load i32*, i32** %3, align 8
  %162 = load i64, i64* %16, align 8
  %163 = getelementptr inbounds i32, i32* %161, i64 %162
  store i32 %160, i32* %163, align 4
  %164 = load i64, i64* %16, align 8
  store i64 %164, i64* %13, align 8
  br label %108

165:                                              ; preds = %147, %115
  br label %166

166:                                              ; preds = %165
  %167 = load i64, i64* %11, align 8
  %168 = add i64 %167, -1
  store i64 %168, i64* %11, align 8
  br label %91, !llvm.loop !8

169:                                              ; preds = %20, %91
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [9 x i32], align 16
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  %6 = bitcast [9 x i32]* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %6, i8* align 16 bitcast ([9 x i32]* @__const.main.arr to i8*), i64 36, i1 false)
  store i64 9, i64* %3, align 8
  store i64 0, i64* %4, align 8
  br label %7

7:                                                ; preds = %16, %0
  %8 = load i64, i64* %4, align 8
  %9 = load i64, i64* %3, align 8
  %10 = icmp ult i64 %8, %9
  br i1 %10, label %11, label %19

11:                                               ; preds = %7
  %12 = load i64, i64* %4, align 8
  %13 = getelementptr inbounds [9 x i32], [9 x i32]* %2, i64 0, i64 %12
  %14 = load i32, i32* %13, align 4
  %15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %14)
  br label %16

16:                                               ; preds = %11
  %17 = load i64, i64* %4, align 8
  %18 = add i64 %17, 1
  store i64 %18, i64* %4, align 8
  br label %7, !llvm.loop !9

19:                                               ; preds = %7
  %20 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %21 = getelementptr inbounds [9 x i32], [9 x i32]* %2, i64 0, i64 0
  %22 = load i64, i64* %3, align 8
  call void @heap_sort(i32* noundef %21, i64 noundef %22)
  store i64 0, i64* %5, align 8
  br label %23

23:                                               ; preds = %32, %19
  %24 = load i64, i64* %5, align 8
  %25 = load i64, i64* %3, align 8
  %26 = icmp ult i64 %24, %25
  br i1 %26, label %27, label %35

27:                                               ; preds = %23
  %28 = load i64, i64* %5, align 8
  %29 = getelementptr inbounds [9 x i32], [9 x i32]* %2, i64 0, i64 %28
  %30 = load i32, i32* %29, align 4
  %31 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %30)
  br label %32

32:                                               ; preds = %27
  %33 = load i64, i64* %5, align 8
  %34 = add i64 %33, 1
  store i64 %34, i64* %5, align 8
  br label %23, !llvm.loop !10

35:                                               ; preds = %23
  %36 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

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
