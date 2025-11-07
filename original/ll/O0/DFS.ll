; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/DFS.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/DFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca [49 x i32], align 16
  %4 = alloca i64, align 8
  %5 = alloca [7 x i64], align 16
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  store i64 7, i64* %2, align 8
  %8 = bitcast [49 x i32]* %3 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %8, i8 0, i64 196, i1 false)
  br label %9

9:                                                ; preds = %0
  %10 = load i64, i64* %2, align 8
  %11 = mul i64 0, %10
  %12 = add i64 %11, 1
  %13 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %12
  store i32 1, i32* %13, align 4
  %14 = load i64, i64* %2, align 8
  %15 = mul i64 1, %14
  %16 = add i64 %15, 0
  %17 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %16
  store i32 1, i32* %17, align 4
  br label %18

18:                                               ; preds = %9
  br label %19

19:                                               ; preds = %18
  %20 = load i64, i64* %2, align 8
  %21 = mul i64 0, %20
  %22 = add i64 %21, 2
  %23 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %22
  store i32 1, i32* %23, align 4
  %24 = load i64, i64* %2, align 8
  %25 = mul i64 2, %24
  %26 = add i64 %25, 0
  %27 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %26
  store i32 1, i32* %27, align 4
  br label %28

28:                                               ; preds = %19
  br label %29

29:                                               ; preds = %28
  %30 = load i64, i64* %2, align 8
  %31 = mul i64 1, %30
  %32 = add i64 %31, 3
  %33 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %32
  store i32 1, i32* %33, align 4
  %34 = load i64, i64* %2, align 8
  %35 = mul i64 3, %34
  %36 = add i64 %35, 1
  %37 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %36
  store i32 1, i32* %37, align 4
  br label %38

38:                                               ; preds = %29
  br label %39

39:                                               ; preds = %38
  %40 = load i64, i64* %2, align 8
  %41 = mul i64 1, %40
  %42 = add i64 %41, 4
  %43 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %42
  store i32 1, i32* %43, align 4
  %44 = load i64, i64* %2, align 8
  %45 = mul i64 4, %44
  %46 = add i64 %45, 1
  %47 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %46
  store i32 1, i32* %47, align 4
  br label %48

48:                                               ; preds = %39
  br label %49

49:                                               ; preds = %48
  %50 = load i64, i64* %2, align 8
  %51 = mul i64 2, %50
  %52 = add i64 %51, 5
  %53 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %52
  store i32 1, i32* %53, align 4
  %54 = load i64, i64* %2, align 8
  %55 = mul i64 5, %54
  %56 = add i64 %55, 2
  %57 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %56
  store i32 1, i32* %57, align 4
  br label %58

58:                                               ; preds = %49
  br label %59

59:                                               ; preds = %58
  %60 = load i64, i64* %2, align 8
  %61 = mul i64 4, %60
  %62 = add i64 %61, 5
  %63 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %62
  store i32 1, i32* %63, align 4
  %64 = load i64, i64* %2, align 8
  %65 = mul i64 5, %64
  %66 = add i64 %65, 4
  %67 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %66
  store i32 1, i32* %67, align 4
  br label %68

68:                                               ; preds = %59
  br label %69

69:                                               ; preds = %68
  %70 = load i64, i64* %2, align 8
  %71 = mul i64 5, %70
  %72 = add i64 %71, 6
  %73 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %72
  store i32 1, i32* %73, align 4
  %74 = load i64, i64* %2, align 8
  %75 = mul i64 6, %74
  %76 = add i64 %75, 5
  %77 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %76
  store i32 1, i32* %77, align 4
  br label %78

78:                                               ; preds = %69
  store i64 0, i64* %4, align 8
  store i64 0, i64* %6, align 8
  %79 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 0
  %80 = load i64, i64* %2, align 8
  %81 = load i64, i64* %4, align 8
  %82 = getelementptr inbounds [7 x i64], [7 x i64]* %5, i64 0, i64 0
  call void @dfs(i32* noundef %79, i64 noundef %80, i64 noundef %81, i64* noundef %82, i64* noundef %6)
  %83 = load i64, i64* %4, align 8
  %84 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef %83)
  store i64 0, i64* %7, align 8
  br label %85

85:                                               ; preds = %100, %78
  %86 = load i64, i64* %7, align 8
  %87 = load i64, i64* %6, align 8
  %88 = icmp ult i64 %86, %87
  br i1 %88, label %89, label %103

89:                                               ; preds = %85
  %90 = load i64, i64* %7, align 8
  %91 = getelementptr inbounds [7 x i64], [7 x i64]* %5, i64 0, i64 %90
  %92 = load i64, i64* %91, align 8
  %93 = load i64, i64* %7, align 8
  %94 = add i64 %93, 1
  %95 = load i64, i64* %6, align 8
  %96 = icmp ult i64 %94, %95
  %97 = zext i1 %96 to i64
  %98 = select i1 %96, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0)
  %99 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %92, i8* noundef %98)
  br label %100

100:                                              ; preds = %89
  %101 = load i64, i64* %7, align 8
  %102 = add i64 %101, 1
  store i64 %102, i64* %7, align 8
  br label %85, !llvm.loop !6

103:                                              ; preds = %85
  %104 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @dfs(i32* noundef %0, i64 noundef %1, i64 noundef %2, i64* noundef %3, i64* noundef %4) #0 {
  %6 = alloca i32*, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64*, align 8
  %10 = alloca i64*, align 8
  %11 = alloca i32*, align 8
  %12 = alloca i64*, align 8
  %13 = alloca i64*, align 8
  %14 = alloca i64, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  store i32* %0, i32** %6, align 8
  store i64 %1, i64* %7, align 8
  store i64 %2, i64* %8, align 8
  store i64* %3, i64** %9, align 8
  store i64* %4, i64** %10, align 8
  %18 = load i64, i64* %7, align 8
  %19 = icmp eq i64 %18, 0
  br i1 %19, label %24, label %20

20:                                               ; preds = %5
  %21 = load i64, i64* %8, align 8
  %22 = load i64, i64* %7, align 8
  %23 = icmp uge i64 %21, %22
  br i1 %23, label %24, label %26

24:                                               ; preds = %20, %5
  %25 = load i64*, i64** %10, align 8
  store i64 0, i64* %25, align 8
  br label %158

26:                                               ; preds = %20
  %27 = load i64, i64* %7, align 8
  %28 = mul i64 %27, 4
  %29 = call noalias i8* @malloc(i64 noundef %28) #4
  %30 = bitcast i8* %29 to i32*
  store i32* %30, i32** %11, align 8
  %31 = load i64, i64* %7, align 8
  %32 = mul i64 %31, 8
  %33 = call noalias i8* @malloc(i64 noundef %32) #4
  %34 = bitcast i8* %33 to i64*
  store i64* %34, i64** %12, align 8
  %35 = load i64, i64* %7, align 8
  %36 = mul i64 %35, 8
  %37 = call noalias i8* @malloc(i64 noundef %36) #4
  %38 = bitcast i8* %37 to i64*
  store i64* %38, i64** %13, align 8
  %39 = load i32*, i32** %11, align 8
  %40 = icmp ne i32* %39, null
  br i1 %40, label %41, label %47

41:                                               ; preds = %26
  %42 = load i64*, i64** %12, align 8
  %43 = icmp ne i64* %42, null
  br i1 %43, label %44, label %47

44:                                               ; preds = %41
  %45 = load i64*, i64** %13, align 8
  %46 = icmp ne i64* %45, null
  br i1 %46, label %55, label %47

47:                                               ; preds = %44, %41, %26
  %48 = load i32*, i32** %11, align 8
  %49 = bitcast i32* %48 to i8*
  call void @free(i8* noundef %49) #4
  %50 = load i64*, i64** %12, align 8
  %51 = bitcast i64* %50 to i8*
  call void @free(i8* noundef %51) #4
  %52 = load i64*, i64** %13, align 8
  %53 = bitcast i64* %52 to i8*
  call void @free(i8* noundef %53) #4
  %54 = load i64*, i64** %10, align 8
  store i64 0, i64* %54, align 8
  br label %158

55:                                               ; preds = %44
  store i64 0, i64* %14, align 8
  br label %56

56:                                               ; preds = %67, %55
  %57 = load i64, i64* %14, align 8
  %58 = load i64, i64* %7, align 8
  %59 = icmp ult i64 %57, %58
  br i1 %59, label %60, label %70

60:                                               ; preds = %56
  %61 = load i32*, i32** %11, align 8
  %62 = load i64, i64* %14, align 8
  %63 = getelementptr inbounds i32, i32* %61, i64 %62
  store i32 0, i32* %63, align 4
  %64 = load i64*, i64** %12, align 8
  %65 = load i64, i64* %14, align 8
  %66 = getelementptr inbounds i64, i64* %64, i64 %65
  store i64 0, i64* %66, align 8
  br label %67

67:                                               ; preds = %60
  %68 = load i64, i64* %14, align 8
  %69 = add i64 %68, 1
  store i64 %69, i64* %14, align 8
  br label %56, !llvm.loop !8

70:                                               ; preds = %56
  store i64 0, i64* %15, align 8
  %71 = load i64*, i64** %10, align 8
  store i64 0, i64* %71, align 8
  %72 = load i64, i64* %8, align 8
  %73 = load i64*, i64** %13, align 8
  %74 = load i64, i64* %15, align 8
  %75 = add i64 %74, 1
  store i64 %75, i64* %15, align 8
  %76 = getelementptr inbounds i64, i64* %73, i64 %74
  store i64 %72, i64* %76, align 8
  %77 = load i32*, i32** %11, align 8
  %78 = load i64, i64* %8, align 8
  %79 = getelementptr inbounds i32, i32* %77, i64 %78
  store i32 1, i32* %79, align 4
  %80 = load i64, i64* %8, align 8
  %81 = load i64*, i64** %9, align 8
  %82 = load i64*, i64** %10, align 8
  %83 = load i64, i64* %82, align 8
  %84 = add i64 %83, 1
  store i64 %84, i64* %82, align 8
  %85 = getelementptr inbounds i64, i64* %81, i64 %83
  store i64 %80, i64* %85, align 8
  br label %86

86:                                               ; preds = %150, %70
  %87 = load i64, i64* %15, align 8
  %88 = icmp ugt i64 %87, 0
  br i1 %88, label %89, label %151

89:                                               ; preds = %86
  %90 = load i64*, i64** %13, align 8
  %91 = load i64, i64* %15, align 8
  %92 = sub i64 %91, 1
  %93 = getelementptr inbounds i64, i64* %90, i64 %92
  %94 = load i64, i64* %93, align 8
  store i64 %94, i64* %16, align 8
  %95 = load i64*, i64** %12, align 8
  %96 = load i64, i64* %16, align 8
  %97 = getelementptr inbounds i64, i64* %95, i64 %96
  %98 = load i64, i64* %97, align 8
  store i64 %98, i64* %17, align 8
  br label %99

99:                                               ; preds = %140, %89
  %100 = load i64, i64* %17, align 8
  %101 = load i64, i64* %7, align 8
  %102 = icmp ult i64 %100, %101
  br i1 %102, label %103, label %143

103:                                              ; preds = %99
  %104 = load i32*, i32** %6, align 8
  %105 = load i64, i64* %16, align 8
  %106 = load i64, i64* %7, align 8
  %107 = mul i64 %105, %106
  %108 = load i64, i64* %17, align 8
  %109 = add i64 %107, %108
  %110 = getelementptr inbounds i32, i32* %104, i64 %109
  %111 = load i32, i32* %110, align 4
  %112 = icmp ne i32 %111, 0
  br i1 %112, label %113, label %139

113:                                              ; preds = %103
  %114 = load i32*, i32** %11, align 8
  %115 = load i64, i64* %17, align 8
  %116 = getelementptr inbounds i32, i32* %114, i64 %115
  %117 = load i32, i32* %116, align 4
  %118 = icmp ne i32 %117, 0
  br i1 %118, label %139, label %119

119:                                              ; preds = %113
  %120 = load i64, i64* %17, align 8
  %121 = add i64 %120, 1
  %122 = load i64*, i64** %12, align 8
  %123 = load i64, i64* %16, align 8
  %124 = getelementptr inbounds i64, i64* %122, i64 %123
  store i64 %121, i64* %124, align 8
  %125 = load i32*, i32** %11, align 8
  %126 = load i64, i64* %17, align 8
  %127 = getelementptr inbounds i32, i32* %125, i64 %126
  store i32 1, i32* %127, align 4
  %128 = load i64, i64* %17, align 8
  %129 = load i64*, i64** %9, align 8
  %130 = load i64*, i64** %10, align 8
  %131 = load i64, i64* %130, align 8
  %132 = add i64 %131, 1
  store i64 %132, i64* %130, align 8
  %133 = getelementptr inbounds i64, i64* %129, i64 %131
  store i64 %128, i64* %133, align 8
  %134 = load i64, i64* %17, align 8
  %135 = load i64*, i64** %13, align 8
  %136 = load i64, i64* %15, align 8
  %137 = add i64 %136, 1
  store i64 %137, i64* %15, align 8
  %138 = getelementptr inbounds i64, i64* %135, i64 %136
  store i64 %134, i64* %138, align 8
  br label %143

139:                                              ; preds = %113, %103
  br label %140

140:                                              ; preds = %139
  %141 = load i64, i64* %17, align 8
  %142 = add i64 %141, 1
  store i64 %142, i64* %17, align 8
  br label %99, !llvm.loop !9

143:                                              ; preds = %119, %99
  %144 = load i64, i64* %17, align 8
  %145 = load i64, i64* %7, align 8
  %146 = icmp eq i64 %144, %145
  br i1 %146, label %147, label %150

147:                                              ; preds = %143
  %148 = load i64, i64* %15, align 8
  %149 = add i64 %148, -1
  store i64 %149, i64* %15, align 8
  br label %150

150:                                              ; preds = %147, %143
  br label %86, !llvm.loop !10

151:                                              ; preds = %86
  %152 = load i32*, i32** %11, align 8
  %153 = bitcast i32* %152 to i8*
  call void @free(i8* noundef %153) #4
  %154 = load i64*, i64** %12, align 8
  %155 = bitcast i64* %154 to i8*
  call void @free(i8* noundef %155) #4
  %156 = load i64*, i64** %13, align 8
  %157 = bitcast i64* %156 to i8*
  call void @free(i8* noundef %157) #4
  br label %158

158:                                              ; preds = %151, %47, %24
  ret void
}

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
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
