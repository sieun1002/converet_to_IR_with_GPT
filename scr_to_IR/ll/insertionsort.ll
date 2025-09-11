; ModuleID = '/home/nata20034/workspace/file/src/insertionsort.c'
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
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  store i32 5, i32* %6, align 4, !tbaa !5
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  %8 = load i32, i32* %7, align 4, !tbaa !5
  %9 = icmp slt i32 %8, 9
  br i1 %9, label %10, label %17

10:                                               ; preds = %0
  store i32 9, i32* %7, align 4, !tbaa !5
  %11 = load i32, i32* %4, align 4, !tbaa !5
  %12 = icmp sgt i32 %11, %8
  br i1 %12, label %13, label %17

13:                                               ; preds = %10
  store i32 %11, i32* %5, align 8, !tbaa !5
  %14 = load i32, i32* %3, align 16, !tbaa !5
  %15 = icmp sgt i32 %14, %8
  br i1 %15, label %16, label %17

16:                                               ; preds = %13
  store i32 %14, i32* %4, align 4, !tbaa !5
  br label %17

17:                                               ; preds = %16, %13, %10, %0
  %18 = phi i64 [ 3, %0 ], [ 2, %10 ], [ 1, %13 ], [ 0, %16 ]
  %19 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %18
  store i32 %8, i32* %19, align 4, !tbaa !5
  %20 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %21 = load i32, i32* %20, align 16, !tbaa !5
  %22 = load i32, i32* %7, align 4, !tbaa !5
  %23 = icmp sgt i32 %22, %21
  br i1 %23, label %24, label %34

24:                                               ; preds = %17
  store i32 %22, i32* %20, align 16, !tbaa !5
  %25 = load i32, i32* %5, align 8, !tbaa !5
  %26 = icmp sgt i32 %25, %21
  br i1 %26, label %27, label %34

27:                                               ; preds = %24
  store i32 %25, i32* %7, align 4, !tbaa !5
  %28 = load i32, i32* %4, align 4, !tbaa !5
  %29 = icmp sgt i32 %28, %21
  br i1 %29, label %30, label %34

30:                                               ; preds = %27
  store i32 %28, i32* %5, align 8, !tbaa !5
  %31 = load i32, i32* %3, align 16, !tbaa !5
  %32 = icmp sgt i32 %31, %21
  br i1 %32, label %33, label %34

33:                                               ; preds = %30
  store i32 %31, i32* %4, align 4, !tbaa !5
  br label %34

34:                                               ; preds = %33, %30, %27, %24, %17
  %35 = phi i64 [ 4, %17 ], [ 3, %24 ], [ 2, %27 ], [ 1, %30 ], [ 0, %33 ]
  %36 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %35
  store i32 %21, i32* %36, align 4, !tbaa !5
  %37 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %38 = load i32, i32* %37, align 4, !tbaa !5
  %39 = load i32, i32* %20, align 16, !tbaa !5
  %40 = icmp sgt i32 %39, %38
  br i1 %40, label %41, label %54

41:                                               ; preds = %34
  store i32 %39, i32* %37, align 4, !tbaa !5
  %42 = load i32, i32* %7, align 4, !tbaa !5
  %43 = icmp sgt i32 %42, %38
  br i1 %43, label %44, label %54

44:                                               ; preds = %41
  store i32 %42, i32* %20, align 16, !tbaa !5
  %45 = load i32, i32* %5, align 8, !tbaa !5
  %46 = icmp sgt i32 %45, %38
  br i1 %46, label %47, label %54

47:                                               ; preds = %44
  store i32 %45, i32* %7, align 4, !tbaa !5
  %48 = load i32, i32* %4, align 4, !tbaa !5
  %49 = icmp sgt i32 %48, %38
  br i1 %49, label %50, label %54

50:                                               ; preds = %47
  store i32 %48, i32* %5, align 8, !tbaa !5
  %51 = load i32, i32* %3, align 16, !tbaa !5
  %52 = icmp sgt i32 %51, %38
  br i1 %52, label %53, label %54

53:                                               ; preds = %50
  store i32 %51, i32* %4, align 4, !tbaa !5
  br label %54

54:                                               ; preds = %53, %50, %47, %44, %41, %34
  %55 = phi i64 [ 5, %34 ], [ 4, %41 ], [ 3, %44 ], [ 2, %47 ], [ 1, %50 ], [ 0, %53 ]
  %56 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %55
  store i32 %38, i32* %56, align 4, !tbaa !5
  %57 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %58 = load i32, i32* %57, align 8, !tbaa !5
  %59 = load i32, i32* %37, align 4, !tbaa !5
  %60 = icmp sgt i32 %59, %58
  br i1 %60, label %61, label %77

61:                                               ; preds = %54
  store i32 %59, i32* %57, align 8, !tbaa !5
  %62 = load i32, i32* %20, align 16, !tbaa !5
  %63 = icmp sgt i32 %62, %58
  br i1 %63, label %64, label %77

64:                                               ; preds = %61
  store i32 %62, i32* %37, align 4, !tbaa !5
  %65 = load i32, i32* %7, align 4, !tbaa !5
  %66 = icmp sgt i32 %65, %58
  br i1 %66, label %67, label %77

67:                                               ; preds = %64
  store i32 %65, i32* %20, align 16, !tbaa !5
  %68 = load i32, i32* %5, align 8, !tbaa !5
  %69 = icmp sgt i32 %68, %58
  br i1 %69, label %70, label %77

70:                                               ; preds = %67
  store i32 %68, i32* %7, align 4, !tbaa !5
  %71 = load i32, i32* %4, align 4, !tbaa !5
  %72 = icmp sgt i32 %71, %58
  br i1 %72, label %73, label %77

73:                                               ; preds = %70
  store i32 %71, i32* %5, align 8, !tbaa !5
  %74 = load i32, i32* %3, align 16, !tbaa !5
  %75 = icmp sgt i32 %74, %58
  br i1 %75, label %76, label %77

76:                                               ; preds = %73
  store i32 %74, i32* %4, align 4, !tbaa !5
  br label %77

77:                                               ; preds = %76, %73, %70, %67, %64, %61, %54
  %78 = phi i64 [ 6, %54 ], [ 5, %61 ], [ 4, %64 ], [ 3, %67 ], [ 2, %70 ], [ 1, %73 ], [ 0, %76 ]
  %79 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %78
  store i32 %58, i32* %79, align 4, !tbaa !5
  %80 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %81 = load i32, i32* %80, align 4, !tbaa !5
  %82 = load i32, i32* %57, align 8, !tbaa !5
  %83 = icmp sgt i32 %82, %81
  br i1 %83, label %84, label %103

84:                                               ; preds = %77
  store i32 %82, i32* %80, align 4, !tbaa !5
  %85 = load i32, i32* %37, align 4, !tbaa !5
  %86 = icmp sgt i32 %85, %81
  br i1 %86, label %87, label %103

87:                                               ; preds = %84
  store i32 %85, i32* %57, align 8, !tbaa !5
  %88 = load i32, i32* %20, align 16, !tbaa !5
  %89 = icmp sgt i32 %88, %81
  br i1 %89, label %90, label %103

90:                                               ; preds = %87
  store i32 %88, i32* %37, align 4, !tbaa !5
  %91 = load i32, i32* %7, align 4, !tbaa !5
  %92 = icmp sgt i32 %91, %81
  br i1 %92, label %93, label %103

93:                                               ; preds = %90
  store i32 %91, i32* %20, align 16, !tbaa !5
  %94 = load i32, i32* %5, align 8, !tbaa !5
  %95 = icmp sgt i32 %94, %81
  br i1 %95, label %96, label %103

96:                                               ; preds = %93
  store i32 %94, i32* %7, align 4, !tbaa !5
  %97 = load i32, i32* %4, align 4, !tbaa !5
  %98 = icmp sgt i32 %97, %81
  br i1 %98, label %99, label %103

99:                                               ; preds = %96
  store i32 %97, i32* %5, align 8, !tbaa !5
  %100 = load i32, i32* %3, align 16, !tbaa !5
  %101 = icmp sgt i32 %100, %81
  br i1 %101, label %102, label %103

102:                                              ; preds = %99
  store i32 %100, i32* %4, align 4, !tbaa !5
  br label %103

103:                                              ; preds = %102, %99, %96, %93, %90, %87, %84, %77
  %104 = phi i64 [ 7, %77 ], [ 6, %84 ], [ 5, %87 ], [ 4, %90 ], [ 3, %93 ], [ 2, %96 ], [ 1, %99 ], [ 0, %102 ]
  %105 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %104
  store i32 %81, i32* %105, align 4, !tbaa !5
  %106 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %107 = load i32, i32* %106, align 16, !tbaa !5
  %108 = load i32, i32* %80, align 4, !tbaa !5
  %109 = icmp sgt i32 %108, %107
  br i1 %109, label %110, label %132

110:                                              ; preds = %103
  store i32 %108, i32* %106, align 16, !tbaa !5
  %111 = load i32, i32* %57, align 8, !tbaa !5
  %112 = icmp sgt i32 %111, %107
  br i1 %112, label %113, label %132

113:                                              ; preds = %110
  store i32 %111, i32* %80, align 4, !tbaa !5
  %114 = load i32, i32* %37, align 4, !tbaa !5
  %115 = icmp sgt i32 %114, %107
  br i1 %115, label %116, label %132

116:                                              ; preds = %113
  store i32 %114, i32* %57, align 8, !tbaa !5
  %117 = load i32, i32* %20, align 16, !tbaa !5
  %118 = icmp sgt i32 %117, %107
  br i1 %118, label %119, label %132

119:                                              ; preds = %116
  store i32 %117, i32* %37, align 4, !tbaa !5
  %120 = load i32, i32* %7, align 4, !tbaa !5
  %121 = icmp sgt i32 %120, %107
  br i1 %121, label %122, label %132

122:                                              ; preds = %119
  store i32 %120, i32* %20, align 16, !tbaa !5
  %123 = load i32, i32* %5, align 8, !tbaa !5
  %124 = icmp sgt i32 %123, %107
  br i1 %124, label %125, label %132

125:                                              ; preds = %122
  store i32 %123, i32* %7, align 4, !tbaa !5
  %126 = load i32, i32* %4, align 4, !tbaa !5
  %127 = icmp sgt i32 %126, %107
  br i1 %127, label %128, label %132

128:                                              ; preds = %125
  store i32 %126, i32* %5, align 8, !tbaa !5
  %129 = load i32, i32* %3, align 16, !tbaa !5
  %130 = icmp sgt i32 %129, %107
  br i1 %130, label %131, label %132

131:                                              ; preds = %128
  store i32 %129, i32* %4, align 4, !tbaa !5
  br label %132

132:                                              ; preds = %131, %128, %125, %122, %119, %116, %113, %110, %103
  %133 = phi i64 [ 8, %103 ], [ 7, %110 ], [ 6, %113 ], [ 5, %116 ], [ 4, %119 ], [ 3, %122 ], [ 2, %125 ], [ 1, %128 ], [ 0, %131 ]
  %134 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %133
  store i32 %107, i32* %134, align 4, !tbaa !5
  %135 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %136 = load i32, i32* %135, align 4, !tbaa !5
  %137 = load i32, i32* %106, align 16, !tbaa !5
  %138 = icmp sgt i32 %137, %136
  br i1 %138, label %139, label %164

139:                                              ; preds = %132
  store i32 %137, i32* %135, align 4, !tbaa !5
  %140 = load i32, i32* %80, align 4, !tbaa !5
  %141 = icmp sgt i32 %140, %136
  br i1 %141, label %142, label %164

142:                                              ; preds = %139
  store i32 %140, i32* %106, align 16, !tbaa !5
  %143 = load i32, i32* %57, align 8, !tbaa !5
  %144 = icmp sgt i32 %143, %136
  br i1 %144, label %145, label %164

145:                                              ; preds = %142
  store i32 %143, i32* %80, align 4, !tbaa !5
  %146 = load i32, i32* %37, align 4, !tbaa !5
  %147 = icmp sgt i32 %146, %136
  br i1 %147, label %148, label %164

148:                                              ; preds = %145
  store i32 %146, i32* %57, align 8, !tbaa !5
  %149 = load i32, i32* %20, align 16, !tbaa !5
  %150 = icmp sgt i32 %149, %136
  br i1 %150, label %151, label %164

151:                                              ; preds = %148
  store i32 %149, i32* %37, align 4, !tbaa !5
  %152 = load i32, i32* %7, align 4, !tbaa !5
  %153 = icmp sgt i32 %152, %136
  br i1 %153, label %154, label %164

154:                                              ; preds = %151
  store i32 %152, i32* %20, align 16, !tbaa !5
  %155 = load i32, i32* %5, align 8, !tbaa !5
  %156 = icmp sgt i32 %155, %136
  br i1 %156, label %157, label %164

157:                                              ; preds = %154
  store i32 %155, i32* %7, align 4, !tbaa !5
  %158 = load i32, i32* %4, align 4, !tbaa !5
  %159 = icmp sgt i32 %158, %136
  br i1 %159, label %160, label %164

160:                                              ; preds = %157
  store i32 %158, i32* %5, align 8, !tbaa !5
  %161 = load i32, i32* %3, align 16, !tbaa !5
  %162 = icmp sgt i32 %161, %136
  br i1 %162, label %163, label %164

163:                                              ; preds = %160
  store i32 %161, i32* %4, align 4, !tbaa !5
  br label %164

164:                                              ; preds = %132, %139, %142, %145, %148, %151, %154, %157, %160, %163
  %165 = phi i64 [ 9, %132 ], [ 8, %139 ], [ 7, %142 ], [ 6, %145 ], [ 5, %148 ], [ 4, %151 ], [ 3, %154 ], [ 2, %157 ], [ 1, %160 ], [ 0, %163 ]
  %166 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %165
  store i32 %136, i32* %166, align 4, !tbaa !5
  %167 = load i32, i32* %3, align 16, !tbaa !5
  %168 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %167)
  %169 = load i32, i32* %4, align 4, !tbaa !5
  %170 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %169)
  %171 = load i32, i32* %5, align 8, !tbaa !5
  %172 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %171)
  %173 = load i32, i32* %7, align 4, !tbaa !5
  %174 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %173)
  %175 = load i32, i32* %20, align 16, !tbaa !5
  %176 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %175)
  %177 = load i32, i32* %37, align 4, !tbaa !5
  %178 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %177)
  %179 = load i32, i32* %57, align 8, !tbaa !5
  %180 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %179)
  %181 = load i32, i32* %80, align 4, !tbaa !5
  %182 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %181)
  %183 = load i32, i32* %106, align 16, !tbaa !5
  %184 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %183)
  %185 = load i32, i32* %135, align 4, !tbaa !5
  %186 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %185)
  %187 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %2) #5
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind willreturn }
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
