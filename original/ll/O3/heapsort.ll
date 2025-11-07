; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/heapsort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/heapsort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.arr = private unnamed_addr constant [9 x i32] [i32 7, i32 3, i32 9, i32 1, i32 4, i32 8, i32 2, i32 6, i32 5], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

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
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 0
  %4 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 7)
  %5 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 3)
  %6 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 9)
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 3
  %8 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 1)
  %9 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 4
  %10 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 4)
  %11 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 5
  %12 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 8)
  %13 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 6
  %14 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 2)
  %15 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 7
  %16 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 6)
  %17 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 8
  %18 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 5)
  %19 = tail call i32 @putchar(i32 10)
  %20 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 8
  %21 = load i32, i32* %20, align 16, !tbaa !7
  %22 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 7
  %23 = load i32, i32* %22, align 4, !tbaa !7
  %24 = icmp sgt i32 %21, %23
  %25 = select i1 %24, i32 %21, i32 %23
  %26 = icmp sgt i32 %25, 1
  br i1 %26, label %98, label %27

27:                                               ; preds = %98, %0
  %28 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 6
  %29 = load i32, i32* %28, align 8, !tbaa !7
  %30 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 5
  %31 = load i32, i32* %30, align 4, !tbaa !7
  %32 = icmp sgt i32 %29, %31
  %33 = select i1 %32, i32 %29, i32 %31
  %34 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 2
  %35 = load i32, i32* %34, align 8, !tbaa !7
  %36 = icmp slt i32 %35, %33
  br i1 %36, label %37, label %40

37:                                               ; preds = %27
  %38 = select i1 %32, i64 6, i64 5
  %39 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %38
  store i32 %33, i32* %34, align 8, !tbaa !7
  store i32 %35, i32* %39, align 4, !tbaa !7
  br label %40

40:                                               ; preds = %37, %27
  br label %41

41:                                               ; preds = %40, %64
  %42 = phi i64 [ %67, %64 ], [ 3, %40 ]
  %43 = phi i64 [ %66, %64 ], [ 2, %40 ]
  %44 = phi i64 [ %60, %64 ], [ 1, %40 ]
  %45 = add nuw nsw i64 %43, 2
  %46 = icmp ult i64 %43, 7
  br i1 %46, label %50, label %47

47:                                               ; preds = %41
  %48 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %42
  %49 = load i32, i32* %48, align 4, !tbaa !7
  br label %56

50:                                               ; preds = %41
  %51 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %45
  %52 = load i32, i32* %51, align 8, !tbaa !7
  %53 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %42
  %54 = load i32, i32* %53, align 4, !tbaa !7
  %55 = icmp sgt i32 %52, %54
  br i1 %55, label %58, label %56

56:                                               ; preds = %50, %47
  %57 = phi i32 [ %49, %47 ], [ %54, %50 ]
  br label %58

58:                                               ; preds = %56, %50
  %59 = phi i32 [ %57, %56 ], [ %52, %50 ]
  %60 = phi i64 [ %42, %56 ], [ %45, %50 ]
  %61 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %44
  %62 = load i32, i32* %61, align 4, !tbaa !7
  %63 = icmp slt i32 %62, %59
  br i1 %63, label %64, label %69

64:                                               ; preds = %58
  %65 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %60
  store i32 %59, i32* %61, align 4, !tbaa !7
  store i32 %62, i32* %65, align 4, !tbaa !7
  %66 = shl nuw nsw i64 %60, 1
  %67 = or i64 %66, 1
  %68 = icmp ult i64 %67, 9
  br i1 %68, label %41, label %69

69:                                               ; preds = %64, %58
  br label %70

70:                                               ; preds = %69, %93
  %71 = phi i64 [ %96, %93 ], [ 1, %69 ]
  %72 = phi i64 [ %95, %93 ], [ 0, %69 ]
  %73 = phi i64 [ %89, %93 ], [ 0, %69 ]
  %74 = add nuw nsw i64 %72, 2
  %75 = icmp ult i64 %72, 7
  br i1 %75, label %79, label %76

76:                                               ; preds = %70
  %77 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %71
  %78 = load i32, i32* %77, align 4, !tbaa !7
  br label %85

79:                                               ; preds = %70
  %80 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %74
  %81 = load i32, i32* %80, align 8, !tbaa !7
  %82 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %71
  %83 = load i32, i32* %82, align 4, !tbaa !7
  %84 = icmp sgt i32 %81, %83
  br i1 %84, label %87, label %85

85:                                               ; preds = %79, %76
  %86 = phi i32 [ %78, %76 ], [ %83, %79 ]
  br label %87

87:                                               ; preds = %85, %79
  %88 = phi i32 [ %86, %85 ], [ %81, %79 ]
  %89 = phi i64 [ %71, %85 ], [ %74, %79 ]
  %90 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %73
  %91 = load i32, i32* %90, align 4, !tbaa !7
  %92 = icmp slt i32 %91, %88
  br i1 %92, label %93, label %277

93:                                               ; preds = %87
  %94 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %89
  store i32 %88, i32* %90, align 4, !tbaa !7
  store i32 %91, i32* %94, align 4, !tbaa !7
  %95 = shl nuw nsw i64 %89, 1
  %96 = or i64 %95, 1
  %97 = icmp ult i64 %96, 9
  br i1 %97, label %70, label %277

98:                                               ; preds = %0
  %99 = select i1 %24, i64 8, i64 7
  %100 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 3
  %101 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %99
  store i32 %25, i32* %100, align 4, !tbaa !7
  store i32 1, i32* %101, align 4, !tbaa !7
  br label %27

102:                                              ; preds = %297, %301
  %103 = load i32, i32* %3, align 16, !tbaa !7
  %104 = load i32, i32* %15, align 4, !tbaa !7
  store i32 %104, i32* %3, align 16, !tbaa !7
  store i32 %103, i32* %15, align 4, !tbaa !7
  br label %105

105:                                              ; preds = %126, %102
  %106 = phi i64 [ %130, %126 ], [ 1, %102 ]
  %107 = phi i64 [ %129, %126 ], [ 0, %102 ]
  %108 = phi i64 [ %124, %126 ], [ 0, %102 ]
  %109 = add nuw nsw i64 %107, 2
  %110 = icmp ult i64 %107, 5
  br i1 %110, label %114, label %111

111:                                              ; preds = %105
  %112 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %106
  %113 = load i32, i32* %112, align 4, !tbaa !7
  br label %120

114:                                              ; preds = %105
  %115 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %109
  %116 = load i32, i32* %115, align 8, !tbaa !7
  %117 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %106
  %118 = load i32, i32* %117, align 4, !tbaa !7
  %119 = icmp sgt i32 %116, %118
  br i1 %119, label %122, label %120

120:                                              ; preds = %114, %111
  %121 = phi i32 [ %113, %111 ], [ %118, %114 ]
  br label %122

122:                                              ; preds = %120, %114
  %123 = phi i32 [ %121, %120 ], [ %116, %114 ]
  %124 = phi i64 [ %106, %120 ], [ %109, %114 ]
  %125 = icmp slt i32 %104, %123
  br i1 %125, label %126, label %132

126:                                              ; preds = %122
  %127 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %108
  %128 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %124
  store i32 %123, i32* %127, align 4, !tbaa !7
  store i32 %104, i32* %128, align 4, !tbaa !7
  %129 = shl i64 %124, 1
  %130 = or i64 %129, 1
  %131 = icmp ult i64 %130, 7
  br i1 %131, label %105, label %132

132:                                              ; preds = %126, %122
  %133 = load i32, i32* %3, align 16, !tbaa !7
  %134 = load i32, i32* %13, align 8, !tbaa !7
  store i32 %134, i32* %3, align 16, !tbaa !7
  store i32 %133, i32* %13, align 8, !tbaa !7
  br label %135

135:                                              ; preds = %156, %132
  %136 = phi i64 [ %160, %156 ], [ 1, %132 ]
  %137 = phi i64 [ %159, %156 ], [ 0, %132 ]
  %138 = phi i64 [ %154, %156 ], [ 0, %132 ]
  %139 = add nuw nsw i64 %137, 2
  %140 = icmp ult i64 %137, 4
  br i1 %140, label %144, label %141

141:                                              ; preds = %135
  %142 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %136
  %143 = load i32, i32* %142, align 4, !tbaa !7
  br label %150

144:                                              ; preds = %135
  %145 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %139
  %146 = load i32, i32* %145, align 8, !tbaa !7
  %147 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %136
  %148 = load i32, i32* %147, align 4, !tbaa !7
  %149 = icmp sgt i32 %146, %148
  br i1 %149, label %152, label %150

150:                                              ; preds = %144, %141
  %151 = phi i32 [ %143, %141 ], [ %148, %144 ]
  br label %152

152:                                              ; preds = %150, %144
  %153 = phi i32 [ %151, %150 ], [ %146, %144 ]
  %154 = phi i64 [ %136, %150 ], [ %139, %144 ]
  %155 = icmp slt i32 %134, %153
  br i1 %155, label %156, label %162

156:                                              ; preds = %152
  %157 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %138
  %158 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %154
  store i32 %153, i32* %157, align 4, !tbaa !7
  store i32 %134, i32* %158, align 4, !tbaa !7
  %159 = shl i64 %154, 1
  %160 = or i64 %159, 1
  %161 = icmp ult i64 %160, 6
  br i1 %161, label %135, label %162

162:                                              ; preds = %156, %152
  %163 = load i32, i32* %3, align 16, !tbaa !7
  %164 = load i32, i32* %11, align 4, !tbaa !7
  store i32 %164, i32* %3, align 16, !tbaa !7
  store i32 %163, i32* %11, align 4, !tbaa !7
  br label %165

165:                                              ; preds = %186, %162
  %166 = phi i64 [ %190, %186 ], [ 1, %162 ]
  %167 = phi i64 [ %189, %186 ], [ 0, %162 ]
  %168 = phi i64 [ %184, %186 ], [ 0, %162 ]
  %169 = add nuw nsw i64 %167, 2
  %170 = icmp ult i64 %167, 3
  br i1 %170, label %174, label %171

171:                                              ; preds = %165
  %172 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %166
  %173 = load i32, i32* %172, align 4, !tbaa !7
  br label %180

174:                                              ; preds = %165
  %175 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %169
  %176 = load i32, i32* %175, align 8, !tbaa !7
  %177 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %166
  %178 = load i32, i32* %177, align 4, !tbaa !7
  %179 = icmp sgt i32 %176, %178
  br i1 %179, label %182, label %180

180:                                              ; preds = %174, %171
  %181 = phi i32 [ %173, %171 ], [ %178, %174 ]
  br label %182

182:                                              ; preds = %180, %174
  %183 = phi i32 [ %181, %180 ], [ %176, %174 ]
  %184 = phi i64 [ %166, %180 ], [ %169, %174 ]
  %185 = icmp slt i32 %164, %183
  br i1 %185, label %186, label %192

186:                                              ; preds = %182
  %187 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %168
  %188 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %184
  store i32 %183, i32* %187, align 4, !tbaa !7
  store i32 %164, i32* %188, align 4, !tbaa !7
  %189 = shl i64 %184, 1
  %190 = or i64 %189, 1
  %191 = icmp ult i64 %190, 5
  br i1 %191, label %165, label %192

192:                                              ; preds = %186, %182
  %193 = load i32, i32* %3, align 16, !tbaa !7
  %194 = load i32, i32* %9, align 16, !tbaa !7
  store i32 %194, i32* %3, align 16, !tbaa !7
  store i32 %193, i32* %9, align 16, !tbaa !7
  br label %195

195:                                              ; preds = %216, %192
  %196 = phi i64 [ %220, %216 ], [ 1, %192 ]
  %197 = phi i64 [ %219, %216 ], [ 0, %192 ]
  %198 = phi i64 [ %214, %216 ], [ 0, %192 ]
  %199 = add nuw nsw i64 %197, 2
  %200 = icmp eq i64 %197, 0
  br i1 %200, label %204, label %201

201:                                              ; preds = %195
  %202 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %196
  %203 = load i32, i32* %202, align 4, !tbaa !7
  br label %210

204:                                              ; preds = %195
  %205 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %199
  %206 = load i32, i32* %205, align 8, !tbaa !7
  %207 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %196
  %208 = load i32, i32* %207, align 4, !tbaa !7
  %209 = icmp sgt i32 %206, %208
  br i1 %209, label %212, label %210

210:                                              ; preds = %204, %201
  %211 = phi i32 [ %203, %201 ], [ %208, %204 ]
  br label %212

212:                                              ; preds = %210, %204
  %213 = phi i32 [ %211, %210 ], [ %206, %204 ]
  %214 = phi i64 [ %196, %210 ], [ %199, %204 ]
  %215 = icmp slt i32 %194, %213
  br i1 %215, label %216, label %222

216:                                              ; preds = %212
  %217 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %198
  %218 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %214
  store i32 %213, i32* %217, align 4, !tbaa !7
  store i32 %194, i32* %218, align 4, !tbaa !7
  %219 = shl i64 %214, 1
  %220 = or i64 %219, 1
  %221 = icmp ult i64 %220, 4
  br i1 %221, label %195, label %222

222:                                              ; preds = %216, %212
  %223 = load i32, i32* %3, align 16, !tbaa !7
  %224 = load i32, i32* %7, align 4, !tbaa !7
  store i32 %224, i32* %3, align 16, !tbaa !7
  store i32 %223, i32* %7, align 4, !tbaa !7
  br label %225

225:                                              ; preds = %246, %222
  %226 = phi i64 [ %250, %246 ], [ 1, %222 ]
  %227 = phi i64 [ %249, %246 ], [ 0, %222 ]
  %228 = phi i64 [ %244, %246 ], [ 0, %222 ]
  %229 = icmp eq i64 %227, 0
  br i1 %229, label %233, label %230

230:                                              ; preds = %225
  %231 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %226
  %232 = load i32, i32* %231, align 4, !tbaa !7
  br label %240

233:                                              ; preds = %225
  %234 = add nuw nsw i64 %227, 2
  %235 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %234
  %236 = load i32, i32* %235, align 8, !tbaa !7
  %237 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %226
  %238 = load i32, i32* %237, align 4, !tbaa !7
  %239 = icmp sgt i32 %236, %238
  br i1 %239, label %242, label %240

240:                                              ; preds = %233, %230
  %241 = phi i32 [ %232, %230 ], [ %238, %233 ]
  br label %242

242:                                              ; preds = %240, %233
  %243 = phi i32 [ %241, %240 ], [ %236, %233 ]
  %244 = phi i64 [ %226, %240 ], [ 2, %233 ]
  %245 = icmp slt i32 %224, %243
  br i1 %245, label %246, label %252

246:                                              ; preds = %242
  %247 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %228
  %248 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %244
  store i32 %243, i32* %247, align 4, !tbaa !7
  store i32 %224, i32* %248, align 4, !tbaa !7
  %249 = shl i64 %244, 1
  %250 = or i64 %249, 1
  %251 = icmp ult i64 %250, 3
  br i1 %251, label %225, label %252

252:                                              ; preds = %242, %246
  %253 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 2
  %254 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 1
  %255 = load i32, i32* %3, align 16, !tbaa !7
  %256 = load i32, i32* %253, align 8, !tbaa !7
  %257 = load i32, i32* %254, align 4, !tbaa !7
  %258 = icmp slt i32 %256, %257
  %259 = select i1 %258, i32 %256, i32 %257
  %260 = select i1 %258, i32 %257, i32 %256
  %261 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %259)
  %262 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %260)
  %263 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %255)
  %264 = load i32, i32* %7, align 4, !tbaa !7
  %265 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %264)
  %266 = load i32, i32* %9, align 16, !tbaa !7
  %267 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %266)
  %268 = load i32, i32* %11, align 4, !tbaa !7
  %269 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %268)
  %270 = load i32, i32* %13, align 8, !tbaa !7
  %271 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %270)
  %272 = load i32, i32* %15, align 4, !tbaa !7
  %273 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %272)
  %274 = load i32, i32* %17, align 16, !tbaa !7
  %275 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %274)
  %276 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 36, i8* nonnull %2) #6
  ret i32 0

277:                                              ; preds = %93, %87
  %278 = load i32, i32* %3, align 16, !tbaa !7
  %279 = load i32, i32* %17, align 16, !tbaa !7
  store i32 %279, i32* %3, align 16, !tbaa !7
  store i32 %278, i32* %17, align 16, !tbaa !7
  br label %280

280:                                              ; preds = %277, %301
  %281 = phi i64 [ %305, %301 ], [ 1, %277 ]
  %282 = phi i64 [ %304, %301 ], [ 0, %277 ]
  %283 = phi i64 [ %299, %301 ], [ 0, %277 ]
  %284 = add nuw nsw i64 %282, 2
  %285 = icmp ult i64 %282, 6
  br i1 %285, label %289, label %286

286:                                              ; preds = %280
  %287 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %281
  %288 = load i32, i32* %287, align 4, !tbaa !7
  br label %295

289:                                              ; preds = %280
  %290 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %284
  %291 = load i32, i32* %290, align 8, !tbaa !7
  %292 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %281
  %293 = load i32, i32* %292, align 4, !tbaa !7
  %294 = icmp sgt i32 %291, %293
  br i1 %294, label %297, label %295

295:                                              ; preds = %289, %286
  %296 = phi i32 [ %288, %286 ], [ %293, %289 ]
  br label %297

297:                                              ; preds = %295, %289
  %298 = phi i32 [ %296, %295 ], [ %291, %289 ]
  %299 = phi i64 [ %281, %295 ], [ %284, %289 ]
  %300 = icmp slt i32 %279, %298
  br i1 %300, label %301, label %102

301:                                              ; preds = %297
  %302 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %283
  %303 = getelementptr inbounds [9 x i32], [9 x i32]* %1, i64 0, i64 %299
  store i32 %298, i32* %302, align 4, !tbaa !7
  store i32 %279, i32* %303, align 4, !tbaa !7
  %304 = shl i64 %299, 1
  %305 = or i64 %304, 1
  %306 = icmp ult i64 %305, 8
  br i1 %306, label %280, label %102
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
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = distinct !{!11, !6}
