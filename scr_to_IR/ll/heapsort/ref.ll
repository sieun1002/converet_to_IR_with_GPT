; ModuleID = '/home/nata20034/workspace/file/src/heapsort.c'
source_filename = "/home/nata20034/workspace/file/src/heapsort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.arr = private unnamed_addr constant [9 x i32] [i32 7, i32 3, i32 9, i32 1, i32 4, i32 8, i32 2, i32 6, i32 5], align 16
@.str = private unnamed_addr constant [9 x i8] c"\EC\9B\90\EB\B3\B8: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.3 = private unnamed_addr constant [13 x i8] c"\EC\A0\95\EB\A0\AC \ED\9B\84: \00", align 1

; Function Attrs: nofree norecurse nosync nounwind uwtable
define dso_local void @heap_sort(i32* nocapture noundef %0, i64 noundef %1) local_unnamed_addr #0 {
  %3 = icmp ult i64 %1, 2
  br i1 %3, label %82, label %4

4:                                                ; preds = %2
  %5 = lshr i64 %1, 1
  br label %8

6:                                                ; preds = %34, %40, %8
  %7 = icmp eq i64 %10, 0
  br i1 %7, label %14, label %8, !llvm.loop !5

8:                                                ; preds = %4, %6
  %9 = phi i64 [ %10, %6 ], [ %5, %4 ]
  %10 = add nsw i64 %9, -1
  %11 = shl i64 %10, 1
  %12 = or i64 %11, 1
  %13 = icmp ult i64 %12, %1
  br i1 %13, label %17, label %6

14:                                               ; preds = %6
  %15 = add i64 %1, -1
  %16 = icmp eq i64 %15, 0
  br i1 %16, label %82, label %48

17:                                               ; preds = %8, %40
  %18 = phi i64 [ %43, %40 ], [ %12, %8 ]
  %19 = phi i64 [ %42, %40 ], [ %11, %8 ]
  %20 = phi i64 [ %36, %40 ], [ %10, %8 ]
  %21 = add i64 %19, 2
  %22 = icmp ult i64 %21, %1
  br i1 %22, label %26, label %23

23:                                               ; preds = %17
  %24 = getelementptr inbounds i32, i32* %0, i64 %18
  %25 = load i32, i32* %24, align 4, !tbaa !7
  br label %32

26:                                               ; preds = %17
  %27 = getelementptr inbounds i32, i32* %0, i64 %21
  %28 = load i32, i32* %27, align 4, !tbaa !7
  %29 = getelementptr inbounds i32, i32* %0, i64 %18
  %30 = load i32, i32* %29, align 4, !tbaa !7
  %31 = icmp sgt i32 %28, %30
  br i1 %31, label %34, label %32

32:                                               ; preds = %23, %26
  %33 = phi i32 [ %25, %23 ], [ %30, %26 ]
  br label %34

34:                                               ; preds = %26, %32
  %35 = phi i32 [ %33, %32 ], [ %28, %26 ]
  %36 = phi i64 [ %18, %32 ], [ %21, %26 ]
  %37 = getelementptr inbounds i32, i32* %0, i64 %20
  %38 = load i32, i32* %37, align 4, !tbaa !7
  %39 = icmp slt i32 %38, %35
  br i1 %39, label %40, label %6

40:                                               ; preds = %34
  %41 = getelementptr inbounds i32, i32* %0, i64 %36
  store i32 %35, i32* %37, align 4, !tbaa !7
  store i32 %38, i32* %41, align 4, !tbaa !7
  %42 = shl i64 %36, 1
  %43 = or i64 %42, 1
  %44 = icmp ult i64 %43, %1
  br i1 %44, label %17, label %6

45:                                               ; preds = %71, %77, %48
  %46 = add i64 %49, -1
  %47 = icmp eq i64 %46, 0
  br i1 %47, label %82, label %48, !llvm.loop !11

48:                                               ; preds = %14, %45
  %49 = phi i64 [ %46, %45 ], [ %15, %14 ]
  %50 = load i32, i32* %0, align 4, !tbaa !7
  %51 = getelementptr inbounds i32, i32* %0, i64 %49
  %52 = load i32, i32* %51, align 4, !tbaa !7
  store i32 %52, i32* %0, align 4, !tbaa !7
  store i32 %50, i32* %51, align 4, !tbaa !7
  %53 = icmp ugt i64 %49, 1
  br i1 %53, label %54, label %45

54:                                               ; preds = %48, %77
  %55 = phi i64 [ %80, %77 ], [ 1, %48 ]
  %56 = phi i64 [ %79, %77 ], [ 0, %48 ]
  %57 = phi i64 [ %73, %77 ], [ 0, %48 ]
  %58 = add i64 %56, 2
  %59 = icmp ult i64 %58, %49
  br i1 %59, label %63, label %60

60:                                               ; preds = %54
  %61 = getelementptr inbounds i32, i32* %0, i64 %55
  %62 = load i32, i32* %61, align 4, !tbaa !7
  br label %69

63:                                               ; preds = %54
  %64 = getelementptr inbounds i32, i32* %0, i64 %58
  %65 = load i32, i32* %64, align 4, !tbaa !7
  %66 = getelementptr inbounds i32, i32* %0, i64 %55
  %67 = load i32, i32* %66, align 4, !tbaa !7
  %68 = icmp sgt i32 %65, %67
  br i1 %68, label %71, label %69

69:                                               ; preds = %60, %63
  %70 = phi i32 [ %62, %60 ], [ %67, %63 ]
  br label %71

71:                                               ; preds = %63, %69
  %72 = phi i32 [ %70, %69 ], [ %65, %63 ]
  %73 = phi i64 [ %55, %69 ], [ %58, %63 ]
  %74 = getelementptr inbounds i32, i32* %0, i64 %57
  %75 = load i32, i32* %74, align 4, !tbaa !7
  %76 = icmp slt i32 %75, %72
  br i1 %76, label %77, label %45

77:                                               ; preds = %71
  %78 = getelementptr inbounds i32, i32* %0, i64 %73
  store i32 %72, i32* %74, align 4, !tbaa !7
  store i32 %75, i32* %78, align 4, !tbaa !7
  %79 = shl i64 %73, 1
  %80 = or i64 %79, 1
  %81 = icmp ult i64 %80, %49
  br i1 %81, label %54, label %45

82:                                               ; preds = %45, %14, %2
  ret void
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #2 {
  %1 = alloca [9 x i32], align 16
  %2 = bitcast [9 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 36, i8* nonnull %2) #6
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(36) %2, i8* noundef nonnull align 16 dereferenceable(36) bitcast ([9 x i32]* @__const.main.arr to i8*), i64 36, i1 false)
  %3 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0))
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 0
  %5 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 7)
  %6 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 3)
  %7 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 9)
  %8 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 1)
  %9 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 4)
  %10 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 8)
  %11 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 2)
  %12 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 6)
  %13 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef 5)
  %14 = tail call i32 @putchar(i32 10)
  %15 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 8
  %16 = load i32, i32* %15, align 16, !tbaa !7
  %17 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 7
  %18 = load i32, i32* %17, align 4, !tbaa !7
  %19 = icmp sgt i32 %16, %18
  %20 = select i1 %19, i32 %16, i32 %18
  %21 = icmp sgt i32 %20, 1
  br i1 %21, label %94, label %22

22:                                               ; preds = %94, %0
  %23 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 6
  %24 = load i32, i32* %23, align 8, !tbaa !7
  %25 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 5
  %26 = load i32, i32* %25, align 4, !tbaa !7
  %27 = icmp sgt i32 %24, %26
  %28 = select i1 %27, i32 %24, i32 %26
  %29 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 2
  %30 = load i32, i32* %29, align 8, !tbaa !7
  %31 = icmp slt i32 %30, %28
  br i1 %31, label %32, label %35

32:                                               ; preds = %22
  %33 = select i1 %27, i64 6, i64 5
  %34 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %33
  store i32 %28, i32* %29, align 8, !tbaa !7
  store i32 %30, i32* %34, align 4, !tbaa !7
  br label %35

35:                                               ; preds = %32, %22
  br label %36

36:                                               ; preds = %35, %59
  %37 = phi i64 [ %62, %59 ], [ 3, %35 ]
  %38 = phi i64 [ %61, %59 ], [ 2, %35 ]
  %39 = phi i64 [ %55, %59 ], [ 1, %35 ]
  %40 = add nuw nsw i64 %38, 2
  %41 = icmp ult i64 %38, 7
  br i1 %41, label %45, label %42

42:                                               ; preds = %36
  %43 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %37
  %44 = load i32, i32* %43, align 4, !tbaa !7
  br label %51

45:                                               ; preds = %36
  %46 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %40
  %47 = load i32, i32* %46, align 8, !tbaa !7
  %48 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %37
  %49 = load i32, i32* %48, align 4, !tbaa !7
  %50 = icmp sgt i32 %47, %49
  br i1 %50, label %53, label %51

51:                                               ; preds = %45, %42
  %52 = phi i32 [ %44, %42 ], [ %49, %45 ]
  br label %53

53:                                               ; preds = %51, %45
  %54 = phi i32 [ %52, %51 ], [ %47, %45 ]
  %55 = phi i64 [ %37, %51 ], [ %40, %45 ]
  %56 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %39
  %57 = load i32, i32* %56, align 4, !tbaa !7
  %58 = icmp slt i32 %57, %54
  br i1 %58, label %59, label %64

59:                                               ; preds = %53
  %60 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %55
  store i32 %54, i32* %56, align 4, !tbaa !7
  store i32 %57, i32* %60, align 4, !tbaa !7
  %61 = shl nuw nsw i64 %55, 1
  %62 = or i64 %61, 1
  %63 = icmp ult i64 %62, 9
  br i1 %63, label %36, label %64

64:                                               ; preds = %59, %53
  br label %65

65:                                               ; preds = %64, %88
  %66 = phi i64 [ %91, %88 ], [ 1, %64 ]
  %67 = phi i64 [ %90, %88 ], [ 0, %64 ]
  %68 = phi i64 [ %84, %88 ], [ 0, %64 ]
  %69 = add nuw nsw i64 %67, 2
  %70 = icmp ult i64 %67, 7
  br i1 %70, label %74, label %71

71:                                               ; preds = %65
  %72 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %66
  %73 = load i32, i32* %72, align 4, !tbaa !7
  br label %80

74:                                               ; preds = %65
  %75 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %69
  %76 = load i32, i32* %75, align 8, !tbaa !7
  %77 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %66
  %78 = load i32, i32* %77, align 4, !tbaa !7
  %79 = icmp sgt i32 %76, %78
  br i1 %79, label %82, label %80

80:                                               ; preds = %74, %71
  %81 = phi i32 [ %73, %71 ], [ %78, %74 ]
  br label %82

82:                                               ; preds = %80, %74
  %83 = phi i32 [ %81, %80 ], [ %76, %74 ]
  %84 = phi i64 [ %66, %80 ], [ %69, %74 ]
  %85 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %68
  %86 = load i32, i32* %85, align 4, !tbaa !7
  %87 = icmp slt i32 %86, %83
  br i1 %87, label %88, label %93

88:                                               ; preds = %82
  %89 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %84
  store i32 %83, i32* %85, align 4, !tbaa !7
  store i32 %86, i32* %89, align 4, !tbaa !7
  %90 = shl nuw nsw i64 %84, 1
  %91 = or i64 %90, 1
  %92 = icmp ult i64 %91, 9
  br i1 %92, label %65, label %93

93:                                               ; preds = %82, %88
  br label %101

94:                                               ; preds = %0
  %95 = select i1 %19, i64 8, i64 7
  %96 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 3
  %97 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %95
  store i32 %20, i32* %96, align 4, !tbaa !7
  store i32 1, i32* %97, align 4, !tbaa !7
  br label %22

98:                                               ; preds = %130, %124, %101
  %99 = add nsw i64 %102, -1
  %100 = icmp eq i64 %99, 0
  br i1 %100, label %135, label %101, !llvm.loop !11

101:                                              ; preds = %93, %98
  %102 = phi i64 [ %99, %98 ], [ 8, %93 ]
  %103 = load i32, i32* %4, align 16, !tbaa !7
  %104 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %102
  %105 = load i32, i32* %104, align 4, !tbaa !7
  store i32 %105, i32* %4, align 16, !tbaa !7
  store i32 %103, i32* %104, align 4, !tbaa !7
  %106 = icmp ugt i64 %102, 1
  br i1 %106, label %107, label %98

107:                                              ; preds = %101, %130
  %108 = phi i64 [ %133, %130 ], [ 1, %101 ]
  %109 = phi i64 [ %132, %130 ], [ 0, %101 ]
  %110 = phi i64 [ %126, %130 ], [ 0, %101 ]
  %111 = add i64 %109, 2
  %112 = icmp ult i64 %111, %102
  br i1 %112, label %116, label %113

113:                                              ; preds = %107
  %114 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %108
  %115 = load i32, i32* %114, align 4, !tbaa !7
  br label %122

116:                                              ; preds = %107
  %117 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %111
  %118 = load i32, i32* %117, align 8, !tbaa !7
  %119 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %108
  %120 = load i32, i32* %119, align 4, !tbaa !7
  %121 = icmp sgt i32 %118, %120
  br i1 %121, label %124, label %122

122:                                              ; preds = %116, %113
  %123 = phi i32 [ %115, %113 ], [ %120, %116 ]
  br label %124

124:                                              ; preds = %122, %116
  %125 = phi i32 [ %123, %122 ], [ %118, %116 ]
  %126 = phi i64 [ %108, %122 ], [ %111, %116 ]
  %127 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %110
  %128 = load i32, i32* %127, align 4, !tbaa !7
  %129 = icmp slt i32 %128, %125
  br i1 %129, label %130, label %98

130:                                              ; preds = %124
  %131 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %126
  store i32 %125, i32* %127, align 4, !tbaa !7
  store i32 %128, i32* %131, align 4, !tbaa !7
  %132 = shl i64 %126, 1
  %133 = or i64 %132, 1
  %134 = icmp ult i64 %133, %102
  br i1 %134, label %107, label %98

135:                                              ; preds = %98
  %136 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 8
  %137 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 7
  %138 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 6
  %139 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 5
  %140 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 4
  %141 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 3
  %142 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 2
  %143 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 1
  %144 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i64 0, i64 0))
  %145 = load i32, i32* %4, align 16, !tbaa !7
  %146 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %145)
  %147 = load i32, i32* %143, align 4, !tbaa !7
  %148 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %147)
  %149 = load i32, i32* %142, align 8, !tbaa !7
  %150 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %149)
  %151 = load i32, i32* %141, align 4, !tbaa !7
  %152 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %151)
  %153 = load i32, i32* %140, align 16, !tbaa !7
  %154 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %153)
  %155 = load i32, i32* %139, align 4, !tbaa !7
  %156 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %155)
  %157 = load i32, i32* %138, align 8, !tbaa !7
  %158 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %157)
  %159 = load i32, i32* %137, align 4, !tbaa !7
  %160 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %159)
  %161 = load i32, i32* %136, align 16, !tbaa !7
  %162 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 noundef %161)
  %163 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 36, i8* nonnull %2) #6
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nofree norecurse nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #4 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !6}
