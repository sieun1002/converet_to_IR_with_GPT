; ModuleID = 'cases/insertionsort/ref.ll'
source_filename = "/home/nata20034/workspace/file/src/insertionsort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %2) #5
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40) %2, i8* noundef nonnull align 16 dereferenceable(40) bitcast ([10 x i32]* @__const.main.a to i8*), i64 40, i1 false)
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  store i32 1, i32* %3, align 16, !tbaa !5
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 2
  store i32 9, i32* %5, align 8, !tbaa !5
  store i32 5, i32* %4, align 4, !tbaa !5
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  br i1 true, label %7, label %._crit_edge

._crit_edge:                                      ; preds = %0
  br label %10

7:                                                ; preds = %0
  store i32 9, i32* %6, align 4, !tbaa !5
  br i1 true, label %8, label %._crit_edge1

._crit_edge1:                                     ; preds = %7
  br label %10

8:                                                ; preds = %7
  store i32 5, i32* %5, align 8, !tbaa !5
  br i1 false, label %9, label %10

9:                                                ; preds = %8
  store i32 1, i32* %4, align 4, !tbaa !5
  br label %10

10:                                               ; preds = %._crit_edge1, %._crit_edge, %9, %8
  %11 = phi i32 [ 9, %._crit_edge1 ], [ 9, %._crit_edge ], [ 5, %9 ], [ 5, %8 ]
  %12 = phi i32 [ 9, %._crit_edge1 ], [ 3, %._crit_edge ], [ 9, %9 ], [ 9, %8 ]
  store i32 3, i32* %4, align 4, !tbaa !5
  %13 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %14 = icmp sgt i32 %12, 7
  br i1 %14, label %15, label %22

15:                                               ; preds = %10
  store i32 %12, i32* %13, align 16, !tbaa !5
  %16 = icmp sgt i32 %11, 7
  br i1 %16, label %17, label %22

17:                                               ; preds = %15
  store i32 %11, i32* %6, align 4, !tbaa !5
  br i1 false, label %18, label %22

18:                                               ; preds = %17
  store i32 3, i32* %5, align 8, !tbaa !5
  %19 = load i32, i32* %3, align 16, !tbaa !5
  %20 = icmp sgt i32 %19, 7
  br i1 %20, label %21, label %._crit_edge2

._crit_edge2:                                     ; preds = %18
  br label %22

21:                                               ; preds = %18
  store i32 %19, i32* %4, align 4, !tbaa !5
  br label %22

22:                                               ; preds = %._crit_edge2, %21, %17, %15, %10
  %23 = phi i64 [ 4, %10 ], [ 3, %15 ], [ 2, %17 ], [ poison, %._crit_edge2 ], [ poison, %21 ]
  %24 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %23
  store i32 7, i32* %24, align 4, !tbaa !5
  %25 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %26 = load i32, i32* %25, align 4, !tbaa !5
  %27 = load i32, i32* %13, align 16, !tbaa !5
  %28 = icmp sgt i32 %27, %26
  br i1 %28, label %29, label %42

29:                                               ; preds = %22
  store i32 %27, i32* %25, align 4, !tbaa !5
  %30 = load i32, i32* %6, align 4, !tbaa !5
  %31 = icmp sgt i32 %30, %26
  br i1 %31, label %32, label %42

32:                                               ; preds = %29
  store i32 %30, i32* %13, align 16, !tbaa !5
  %33 = load i32, i32* %5, align 8, !tbaa !5
  %34 = icmp sgt i32 %33, %26
  br i1 %34, label %35, label %42

35:                                               ; preds = %32
  store i32 %33, i32* %6, align 4, !tbaa !5
  %36 = load i32, i32* %4, align 4, !tbaa !5
  %37 = icmp sgt i32 %36, %26
  br i1 %37, label %38, label %42

38:                                               ; preds = %35
  store i32 %36, i32* %5, align 8, !tbaa !5
  %39 = load i32, i32* %3, align 16, !tbaa !5
  %40 = icmp sgt i32 %39, %26
  br i1 %40, label %41, label %42

41:                                               ; preds = %38
  store i32 %39, i32* %4, align 4, !tbaa !5
  br label %42

42:                                               ; preds = %41, %38, %35, %32, %29, %22
  %43 = phi i64 [ 5, %22 ], [ 4, %29 ], [ 3, %32 ], [ 2, %35 ], [ 1, %38 ], [ 0, %41 ]
  %44 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %43
  store i32 %26, i32* %44, align 4, !tbaa !5
  %45 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %46 = load i32, i32* %45, align 8, !tbaa !5
  %47 = load i32, i32* %25, align 4, !tbaa !5
  %48 = icmp sgt i32 %47, %46
  br i1 %48, label %49, label %65

49:                                               ; preds = %42
  store i32 %47, i32* %45, align 8, !tbaa !5
  %50 = load i32, i32* %13, align 16, !tbaa !5
  %51 = icmp sgt i32 %50, %46
  br i1 %51, label %52, label %65

52:                                               ; preds = %49
  store i32 %50, i32* %25, align 4, !tbaa !5
  %53 = load i32, i32* %6, align 4, !tbaa !5
  %54 = icmp sgt i32 %53, %46
  br i1 %54, label %55, label %65

55:                                               ; preds = %52
  store i32 %53, i32* %13, align 16, !tbaa !5
  %56 = load i32, i32* %5, align 8, !tbaa !5
  %57 = icmp sgt i32 %56, %46
  br i1 %57, label %58, label %65

58:                                               ; preds = %55
  store i32 %56, i32* %6, align 4, !tbaa !5
  %59 = load i32, i32* %4, align 4, !tbaa !5
  %60 = icmp sgt i32 %59, %46
  br i1 %60, label %61, label %65

61:                                               ; preds = %58
  store i32 %59, i32* %5, align 8, !tbaa !5
  %62 = load i32, i32* %3, align 16, !tbaa !5
  %63 = icmp sgt i32 %62, %46
  br i1 %63, label %64, label %65

64:                                               ; preds = %61
  store i32 %62, i32* %4, align 4, !tbaa !5
  br label %65

65:                                               ; preds = %64, %61, %58, %55, %52, %49, %42
  %66 = phi i64 [ 6, %42 ], [ 5, %49 ], [ 4, %52 ], [ 3, %55 ], [ 2, %58 ], [ 1, %61 ], [ 0, %64 ]
  %67 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %66
  store i32 %46, i32* %67, align 4, !tbaa !5
  %68 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %69 = load i32, i32* %68, align 4, !tbaa !5
  %70 = load i32, i32* %45, align 8, !tbaa !5
  %71 = icmp sgt i32 %70, %69
  br i1 %71, label %72, label %91

72:                                               ; preds = %65
  store i32 %70, i32* %68, align 4, !tbaa !5
  %73 = load i32, i32* %25, align 4, !tbaa !5
  %74 = icmp sgt i32 %73, %69
  br i1 %74, label %75, label %91

75:                                               ; preds = %72
  store i32 %73, i32* %45, align 8, !tbaa !5
  %76 = load i32, i32* %13, align 16, !tbaa !5
  %77 = icmp sgt i32 %76, %69
  br i1 %77, label %78, label %91

78:                                               ; preds = %75
  store i32 %76, i32* %25, align 4, !tbaa !5
  %79 = load i32, i32* %6, align 4, !tbaa !5
  %80 = icmp sgt i32 %79, %69
  br i1 %80, label %81, label %91

81:                                               ; preds = %78
  store i32 %79, i32* %13, align 16, !tbaa !5
  %82 = load i32, i32* %5, align 8, !tbaa !5
  %83 = icmp sgt i32 %82, %69
  br i1 %83, label %84, label %91

84:                                               ; preds = %81
  store i32 %82, i32* %6, align 4, !tbaa !5
  %85 = load i32, i32* %4, align 4, !tbaa !5
  %86 = icmp sgt i32 %85, %69
  br i1 %86, label %87, label %91

87:                                               ; preds = %84
  store i32 %85, i32* %5, align 8, !tbaa !5
  %88 = load i32, i32* %3, align 16, !tbaa !5
  %89 = icmp sgt i32 %88, %69
  br i1 %89, label %90, label %91

90:                                               ; preds = %87
  store i32 %88, i32* %4, align 4, !tbaa !5
  br label %91

91:                                               ; preds = %90, %87, %84, %81, %78, %75, %72, %65
  %92 = phi i64 [ 7, %65 ], [ 6, %72 ], [ 5, %75 ], [ 4, %78 ], [ 3, %81 ], [ 2, %84 ], [ 1, %87 ], [ 0, %90 ]
  %93 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %92
  store i32 %69, i32* %93, align 4, !tbaa !5
  %94 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %95 = load i32, i32* %94, align 16, !tbaa !5
  %96 = load i32, i32* %68, align 4, !tbaa !5
  %97 = icmp sgt i32 %96, %95
  br i1 %97, label %98, label %120

98:                                               ; preds = %91
  store i32 %96, i32* %94, align 16, !tbaa !5
  %99 = load i32, i32* %45, align 8, !tbaa !5
  %100 = icmp sgt i32 %99, %95
  br i1 %100, label %101, label %120

101:                                              ; preds = %98
  store i32 %99, i32* %68, align 4, !tbaa !5
  %102 = load i32, i32* %25, align 4, !tbaa !5
  %103 = icmp sgt i32 %102, %95
  br i1 %103, label %104, label %120

104:                                              ; preds = %101
  store i32 %102, i32* %45, align 8, !tbaa !5
  %105 = load i32, i32* %13, align 16, !tbaa !5
  %106 = icmp sgt i32 %105, %95
  br i1 %106, label %107, label %120

107:                                              ; preds = %104
  store i32 %105, i32* %25, align 4, !tbaa !5
  %108 = load i32, i32* %6, align 4, !tbaa !5
  %109 = icmp sgt i32 %108, %95
  br i1 %109, label %110, label %120

110:                                              ; preds = %107
  store i32 %108, i32* %13, align 16, !tbaa !5
  %111 = load i32, i32* %5, align 8, !tbaa !5
  %112 = icmp sgt i32 %111, %95
  br i1 %112, label %113, label %120

113:                                              ; preds = %110
  store i32 %111, i32* %6, align 4, !tbaa !5
  %114 = load i32, i32* %4, align 4, !tbaa !5
  %115 = icmp sgt i32 %114, %95
  br i1 %115, label %116, label %120

116:                                              ; preds = %113
  store i32 %114, i32* %5, align 8, !tbaa !5
  %117 = load i32, i32* %3, align 16, !tbaa !5
  %118 = icmp sgt i32 %117, %95
  br i1 %118, label %119, label %120

119:                                              ; preds = %116
  store i32 %117, i32* %4, align 4, !tbaa !5
  br label %120

120:                                              ; preds = %119, %116, %113, %110, %107, %104, %101, %98, %91
  %121 = phi i64 [ 8, %91 ], [ 7, %98 ], [ 6, %101 ], [ 5, %104 ], [ 4, %107 ], [ 3, %110 ], [ 2, %113 ], [ 1, %116 ], [ 0, %119 ]
  %122 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %121
  store i32 %95, i32* %122, align 4, !tbaa !5
  %123 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %124 = load i32, i32* %123, align 4, !tbaa !5
  %125 = load i32, i32* %94, align 16, !tbaa !5
  %126 = icmp sgt i32 %125, %124
  br i1 %126, label %127, label %152

127:                                              ; preds = %120
  store i32 %125, i32* %123, align 4, !tbaa !5
  %128 = load i32, i32* %68, align 4, !tbaa !5
  %129 = icmp sgt i32 %128, %124
  br i1 %129, label %130, label %152

130:                                              ; preds = %127
  store i32 %128, i32* %94, align 16, !tbaa !5
  %131 = load i32, i32* %45, align 8, !tbaa !5
  %132 = icmp sgt i32 %131, %124
  br i1 %132, label %133, label %152

133:                                              ; preds = %130
  store i32 %131, i32* %68, align 4, !tbaa !5
  %134 = load i32, i32* %25, align 4, !tbaa !5
  %135 = icmp sgt i32 %134, %124
  br i1 %135, label %136, label %152

136:                                              ; preds = %133
  store i32 %134, i32* %45, align 8, !tbaa !5
  %137 = load i32, i32* %13, align 16, !tbaa !5
  %138 = icmp sgt i32 %137, %124
  br i1 %138, label %139, label %152

139:                                              ; preds = %136
  store i32 %137, i32* %25, align 4, !tbaa !5
  %140 = load i32, i32* %6, align 4, !tbaa !5
  %141 = icmp sgt i32 %140, %124
  br i1 %141, label %142, label %152

142:                                              ; preds = %139
  store i32 %140, i32* %13, align 16, !tbaa !5
  %143 = load i32, i32* %5, align 8, !tbaa !5
  %144 = icmp sgt i32 %143, %124
  br i1 %144, label %145, label %152

145:                                              ; preds = %142
  store i32 %143, i32* %6, align 4, !tbaa !5
  %146 = load i32, i32* %4, align 4, !tbaa !5
  %147 = icmp sgt i32 %146, %124
  br i1 %147, label %148, label %152

148:                                              ; preds = %145
  store i32 %146, i32* %5, align 8, !tbaa !5
  %149 = load i32, i32* %3, align 16, !tbaa !5
  %150 = icmp sgt i32 %149, %124
  br i1 %150, label %151, label %152

151:                                              ; preds = %148
  store i32 %149, i32* %4, align 4, !tbaa !5
  br label %152

152:                                              ; preds = %151, %148, %145, %142, %139, %136, %133, %130, %127, %120
  %153 = phi i64 [ 9, %120 ], [ 8, %127 ], [ 7, %130 ], [ 6, %133 ], [ 5, %136 ], [ 4, %139 ], [ 3, %142 ], [ 2, %145 ], [ 1, %148 ], [ 0, %151 ]
  %154 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %153
  store i32 %124, i32* %154, align 4, !tbaa !5
  %155 = load i32, i32* %3, align 16, !tbaa !5
  %156 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %155)
  %157 = load i32, i32* %4, align 4, !tbaa !5
  %158 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %157)
  %159 = load i32, i32* %5, align 8, !tbaa !5
  %160 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %159)
  %161 = load i32, i32* %6, align 4, !tbaa !5
  %162 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %161)
  %163 = load i32, i32* %13, align 16, !tbaa !5
  %164 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %163)
  %165 = load i32, i32* %25, align 4, !tbaa !5
  %166 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %165)
  %167 = load i32, i32* %45, align 8, !tbaa !5
  %168 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %167)
  %169 = load i32, i32* %68, align 4, !tbaa !5
  %170 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %169)
  %171 = load i32, i32* %94, align 16, !tbaa !5
  %172 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %171)
  %173 = load i32, i32* %123, align 4, !tbaa !5
  %174 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %173)
  %175 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %2) #5
  ret i32 0
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nounwind }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
