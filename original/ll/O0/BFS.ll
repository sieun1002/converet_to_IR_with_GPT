; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/BFS.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/BFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca [49 x i32], align 16
  %4 = alloca i64, align 8
  %5 = alloca [7 x i32], align 16
  %6 = alloca [7 x i64], align 16
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 0, i32* %1, align 4
  store i64 7, i64* %2, align 8
  %10 = bitcast [49 x i32]* %3 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %10, i8 0, i64 196, i1 false)
  br label %11

11:                                               ; preds = %0
  %12 = load i64, i64* %2, align 8
  %13 = mul i64 0, %12
  %14 = add i64 %13, 1
  %15 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %14
  store i32 1, i32* %15, align 4
  %16 = load i64, i64* %2, align 8
  %17 = mul i64 1, %16
  %18 = add i64 %17, 0
  %19 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %18
  store i32 1, i32* %19, align 4
  br label %20

20:                                               ; preds = %11
  br label %21

21:                                               ; preds = %20
  %22 = load i64, i64* %2, align 8
  %23 = mul i64 0, %22
  %24 = add i64 %23, 2
  %25 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %24
  store i32 1, i32* %25, align 4
  %26 = load i64, i64* %2, align 8
  %27 = mul i64 2, %26
  %28 = add i64 %27, 0
  %29 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %28
  store i32 1, i32* %29, align 4
  br label %30

30:                                               ; preds = %21
  br label %31

31:                                               ; preds = %30
  %32 = load i64, i64* %2, align 8
  %33 = mul i64 1, %32
  %34 = add i64 %33, 3
  %35 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %34
  store i32 1, i32* %35, align 4
  %36 = load i64, i64* %2, align 8
  %37 = mul i64 3, %36
  %38 = add i64 %37, 1
  %39 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %38
  store i32 1, i32* %39, align 4
  br label %40

40:                                               ; preds = %31
  br label %41

41:                                               ; preds = %40
  %42 = load i64, i64* %2, align 8
  %43 = mul i64 1, %42
  %44 = add i64 %43, 4
  %45 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %44
  store i32 1, i32* %45, align 4
  %46 = load i64, i64* %2, align 8
  %47 = mul i64 4, %46
  %48 = add i64 %47, 1
  %49 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %48
  store i32 1, i32* %49, align 4
  br label %50

50:                                               ; preds = %41
  br label %51

51:                                               ; preds = %50
  %52 = load i64, i64* %2, align 8
  %53 = mul i64 2, %52
  %54 = add i64 %53, 5
  %55 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %54
  store i32 1, i32* %55, align 4
  %56 = load i64, i64* %2, align 8
  %57 = mul i64 5, %56
  %58 = add i64 %57, 2
  %59 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %58
  store i32 1, i32* %59, align 4
  br label %60

60:                                               ; preds = %51
  br label %61

61:                                               ; preds = %60
  %62 = load i64, i64* %2, align 8
  %63 = mul i64 4, %62
  %64 = add i64 %63, 5
  %65 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %64
  store i32 1, i32* %65, align 4
  %66 = load i64, i64* %2, align 8
  %67 = mul i64 5, %66
  %68 = add i64 %67, 4
  %69 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %68
  store i32 1, i32* %69, align 4
  br label %70

70:                                               ; preds = %61
  br label %71

71:                                               ; preds = %70
  %72 = load i64, i64* %2, align 8
  %73 = mul i64 5, %72
  %74 = add i64 %73, 6
  %75 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %74
  store i32 1, i32* %75, align 4
  %76 = load i64, i64* %2, align 8
  %77 = mul i64 6, %76
  %78 = add i64 %77, 5
  %79 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 %78
  store i32 1, i32* %79, align 4
  br label %80

80:                                               ; preds = %71
  store i64 0, i64* %4, align 8
  store i64 0, i64* %7, align 8
  %81 = getelementptr inbounds [49 x i32], [49 x i32]* %3, i64 0, i64 0
  %82 = load i64, i64* %2, align 8
  %83 = load i64, i64* %4, align 8
  %84 = getelementptr inbounds [7 x i32], [7 x i32]* %5, i64 0, i64 0
  %85 = getelementptr inbounds [7 x i64], [7 x i64]* %6, i64 0, i64 0
  call void @bfs(i32* noundef %81, i64 noundef %82, i64 noundef %83, i32* noundef %84, i64* noundef %85, i64* noundef %7)
  %86 = load i64, i64* %4, align 8
  %87 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef %86)
  store i64 0, i64* %8, align 8
  br label %88

88:                                               ; preds = %103, %80
  %89 = load i64, i64* %8, align 8
  %90 = load i64, i64* %7, align 8
  %91 = icmp ult i64 %89, %90
  br i1 %91, label %92, label %106

92:                                               ; preds = %88
  %93 = load i64, i64* %8, align 8
  %94 = getelementptr inbounds [7 x i64], [7 x i64]* %6, i64 0, i64 %93
  %95 = load i64, i64* %94, align 8
  %96 = load i64, i64* %8, align 8
  %97 = add i64 %96, 1
  %98 = load i64, i64* %7, align 8
  %99 = icmp ult i64 %97, %98
  %100 = zext i1 %99 to i64
  %101 = select i1 %99, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0)
  %102 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %95, i8* noundef %101)
  br label %103

103:                                              ; preds = %92
  %104 = load i64, i64* %8, align 8
  %105 = add i64 %104, 1
  store i64 %105, i64* %8, align 8
  br label %88, !llvm.loop !6

106:                                              ; preds = %88
  %107 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0))
  store i64 0, i64* %9, align 8
  br label %108

108:                                              ; preds = %119, %106
  %109 = load i64, i64* %9, align 8
  %110 = load i64, i64* %2, align 8
  %111 = icmp ult i64 %109, %110
  br i1 %111, label %112, label %122

112:                                              ; preds = %108
  %113 = load i64, i64* %4, align 8
  %114 = load i64, i64* %9, align 8
  %115 = load i64, i64* %9, align 8
  %116 = getelementptr inbounds [7 x i32], [7 x i32]* %5, i64 0, i64 %115
  %117 = load i32, i32* %116, align 4
  %118 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef %113, i64 noundef %114, i32 noundef %117)
  br label %119

119:                                              ; preds = %112
  %120 = load i64, i64* %9, align 8
  %121 = add i64 %120, 1
  store i64 %121, i64* %9, align 8
  br label %108, !llvm.loop !8

122:                                              ; preds = %108
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal void @bfs(i32* noundef %0, i64 noundef %1, i64 noundef %2, i32* noundef %3, i64* noundef %4, i64* noundef %5) #0 {
  %7 = alloca i32*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i32*, align 8
  %11 = alloca i64*, align 8
  %12 = alloca i64*, align 8
  %13 = alloca i64, align 8
  %14 = alloca i64*, align 8
  %15 = alloca i64, align 8
  %16 = alloca i64, align 8
  %17 = alloca i64, align 8
  %18 = alloca i64, align 8
  store i32* %0, i32** %7, align 8
  store i64 %1, i64* %8, align 8
  store i64 %2, i64* %9, align 8
  store i32* %3, i32** %10, align 8
  store i64* %4, i64** %11, align 8
  store i64* %5, i64** %12, align 8
  %19 = load i64, i64* %8, align 8
  %20 = icmp eq i64 %19, 0
  br i1 %20, label %25, label %21

21:                                               ; preds = %6
  %22 = load i64, i64* %9, align 8
  %23 = load i64, i64* %8, align 8
  %24 = icmp uge i64 %22, %23
  br i1 %24, label %25, label %27

25:                                               ; preds = %21, %6
  %26 = load i64*, i64** %12, align 8
  store i64 0, i64* %26, align 8
  br label %116

27:                                               ; preds = %21
  store i64 0, i64* %13, align 8
  br label %28

28:                                               ; preds = %36, %27
  %29 = load i64, i64* %13, align 8
  %30 = load i64, i64* %8, align 8
  %31 = icmp ult i64 %29, %30
  br i1 %31, label %32, label %39

32:                                               ; preds = %28
  %33 = load i32*, i32** %10, align 8
  %34 = load i64, i64* %13, align 8
  %35 = getelementptr inbounds i32, i32* %33, i64 %34
  store i32 -1, i32* %35, align 4
  br label %36

36:                                               ; preds = %32
  %37 = load i64, i64* %13, align 8
  %38 = add i64 %37, 1
  store i64 %38, i64* %13, align 8
  br label %28, !llvm.loop !9

39:                                               ; preds = %28
  %40 = load i64, i64* %8, align 8
  %41 = mul i64 %40, 8
  %42 = call noalias i8* @malloc(i64 noundef %41) #4
  %43 = bitcast i8* %42 to i64*
  store i64* %43, i64** %14, align 8
  %44 = load i64*, i64** %14, align 8
  %45 = icmp ne i64* %44, null
  br i1 %45, label %48, label %46

46:                                               ; preds = %39
  %47 = load i64*, i64** %12, align 8
  store i64 0, i64* %47, align 8
  br label %116

48:                                               ; preds = %39
  store i64 0, i64* %15, align 8
  store i64 0, i64* %16, align 8
  %49 = load i32*, i32** %10, align 8
  %50 = load i64, i64* %9, align 8
  %51 = getelementptr inbounds i32, i32* %49, i64 %50
  store i32 0, i32* %51, align 4
  %52 = load i64, i64* %9, align 8
  %53 = load i64*, i64** %14, align 8
  %54 = load i64, i64* %16, align 8
  %55 = add i64 %54, 1
  store i64 %55, i64* %16, align 8
  %56 = getelementptr inbounds i64, i64* %53, i64 %54
  store i64 %52, i64* %56, align 8
  %57 = load i64*, i64** %12, align 8
  store i64 0, i64* %57, align 8
  br label %58

58:                                               ; preds = %112, %48
  %59 = load i64, i64* %15, align 8
  %60 = load i64, i64* %16, align 8
  %61 = icmp ult i64 %59, %60
  br i1 %61, label %62, label %113

62:                                               ; preds = %58
  %63 = load i64*, i64** %14, align 8
  %64 = load i64, i64* %15, align 8
  %65 = add i64 %64, 1
  store i64 %65, i64* %15, align 8
  %66 = getelementptr inbounds i64, i64* %63, i64 %64
  %67 = load i64, i64* %66, align 8
  store i64 %67, i64* %17, align 8
  %68 = load i64, i64* %17, align 8
  %69 = load i64*, i64** %11, align 8
  %70 = load i64*, i64** %12, align 8
  %71 = load i64, i64* %70, align 8
  %72 = add i64 %71, 1
  store i64 %72, i64* %70, align 8
  %73 = getelementptr inbounds i64, i64* %69, i64 %71
  store i64 %68, i64* %73, align 8
  store i64 0, i64* %18, align 8
  br label %74

74:                                               ; preds = %109, %62
  %75 = load i64, i64* %18, align 8
  %76 = load i64, i64* %8, align 8
  %77 = icmp ult i64 %75, %76
  br i1 %77, label %78, label %112

78:                                               ; preds = %74
  %79 = load i32*, i32** %7, align 8
  %80 = load i64, i64* %17, align 8
  %81 = load i64, i64* %8, align 8
  %82 = mul i64 %80, %81
  %83 = load i64, i64* %18, align 8
  %84 = add i64 %82, %83
  %85 = getelementptr inbounds i32, i32* %79, i64 %84
  %86 = load i32, i32* %85, align 4
  %87 = icmp ne i32 %86, 0
  br i1 %87, label %88, label %108

88:                                               ; preds = %78
  %89 = load i32*, i32** %10, align 8
  %90 = load i64, i64* %18, align 8
  %91 = getelementptr inbounds i32, i32* %89, i64 %90
  %92 = load i32, i32* %91, align 4
  %93 = icmp eq i32 %92, -1
  br i1 %93, label %94, label %108

94:                                               ; preds = %88
  %95 = load i32*, i32** %10, align 8
  %96 = load i64, i64* %17, align 8
  %97 = getelementptr inbounds i32, i32* %95, i64 %96
  %98 = load i32, i32* %97, align 4
  %99 = add nsw i32 %98, 1
  %100 = load i32*, i32** %10, align 8
  %101 = load i64, i64* %18, align 8
  %102 = getelementptr inbounds i32, i32* %100, i64 %101
  store i32 %99, i32* %102, align 4
  %103 = load i64, i64* %18, align 8
  %104 = load i64*, i64** %14, align 8
  %105 = load i64, i64* %16, align 8
  %106 = add i64 %105, 1
  store i64 %106, i64* %16, align 8
  %107 = getelementptr inbounds i64, i64* %104, i64 %105
  store i64 %103, i64* %107, align 8
  br label %108

108:                                              ; preds = %94, %88, %78
  br label %109

109:                                              ; preds = %108
  %110 = load i64, i64* %18, align 8
  %111 = add i64 %110, 1
  store i64 %111, i64* %18, align 8
  br label %74, !llvm.loop !10

112:                                              ; preds = %74
  br label %58, !llvm.loop !11

113:                                              ; preds = %58
  %114 = load i64*, i64** %14, align 8
  %115 = bitcast i64* %114 to i8*
  call void @free(i8* noundef %115) #4
  br label %116

116:                                              ; preds = %113, %46, %25
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
!11 = distinct !{!11, !7}
