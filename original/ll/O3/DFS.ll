; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/DFS.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/DFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [49 x i32], align 16
  %2 = alloca [7 x i64], align 16
  %3 = bitcast [49 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 196, i8* nonnull %3) #7
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %3, i8 0, i64 196, i1 false)
  %4 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 1
  store i32 1, i32* %4, align 4, !tbaa !5
  %5 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 7
  store i32 1, i32* %5, align 4, !tbaa !5
  %6 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 2
  store i32 1, i32* %6, align 8, !tbaa !5
  %7 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 14
  store i32 1, i32* %7, align 8, !tbaa !5
  %8 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 10
  store i32 1, i32* %8, align 8, !tbaa !5
  %9 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 22
  store i32 1, i32* %9, align 8, !tbaa !5
  %10 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 11
  store i32 1, i32* %10, align 4, !tbaa !5
  %11 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 29
  store i32 1, i32* %11, align 4, !tbaa !5
  %12 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 19
  store i32 1, i32* %12, align 4, !tbaa !5
  %13 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 37
  store i32 1, i32* %13, align 4, !tbaa !5
  %14 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 33
  store i32 1, i32* %14, align 4, !tbaa !5
  %15 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 39
  store i32 1, i32* %15, align 4, !tbaa !5
  %16 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 41
  store i32 1, i32* %16, align 4, !tbaa !5
  %17 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 47
  store i32 1, i32* %17, align 4, !tbaa !5
  %18 = bitcast [7 x i64]* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 56, i8* nonnull %18) #7
  %19 = tail call noalias dereferenceable_or_null(28) i8* @malloc(i64 noundef 28) #7
  %20 = bitcast i8* %19 to i32*
  %21 = tail call noalias dereferenceable_or_null(56) i8* @malloc(i64 noundef 56) #7
  %22 = bitcast i8* %21 to i64*
  %23 = tail call noalias dereferenceable_or_null(56) i8* @malloc(i64 noundef 56) #7
  %24 = bitcast i8* %23 to i64*
  %25 = icmp ne i8* %19, null
  %26 = icmp ne i8* %21, null
  %27 = and i1 %25, %26
  %28 = icmp ne i8* %23, null
  %29 = and i1 %27, %28
  br i1 %29, label %30, label %33

30:                                               ; preds = %0
  %31 = getelementptr inbounds [7 x i64], [7 x i64]* %2, i64 0, i64 0
  %32 = getelementptr inbounds i8, i8* %19, i64 4
  tail call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(28) %32, i8 0, i64 24, i1 false) #7, !tbaa !5
  tail call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(56) %21, i8 0, i64 56, i1 false) #7, !tbaa !9
  store i64 0, i64* %24, align 8, !tbaa !9
  store i32 1, i32* %20, align 4, !tbaa !5
  store i64 0, i64* %31, align 16, !tbaa !9
  br label %35

33:                                               ; preds = %0
  tail call void @free(i8* noundef %19) #7
  tail call void @free(i8* noundef %21) #7
  tail call void @free(i8* noundef %23) #7
  %34 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0)
  br label %145

35:                                               ; preds = %134, %30
  %36 = phi i64 [ 1, %30 ], [ %135, %134 ]
  %37 = phi i64 [ 1, %30 ], [ %140, %134 ]
  %38 = add i64 %37, -1
  %39 = getelementptr inbounds i64, i64* %24, i64 %38
  %40 = load i64, i64* %39, align 8, !tbaa !9
  %41 = getelementptr inbounds i64, i64* %22, i64 %40
  %42 = load i64, i64* %41, align 8, !tbaa !9
  %43 = icmp ult i64 %42, 7
  br i1 %43, label %44, label %134

44:                                               ; preds = %35
  %45 = mul i64 %40, 7
  %46 = add i64 %42, %45
  %47 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %46
  %48 = load i32, i32* %47, align 4, !tbaa !5
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %62, label %50

50:                                               ; preds = %44
  %51 = getelementptr inbounds i32, i32* %20, i64 %42
  %52 = load i32, i32* %51, align 4, !tbaa !5
  %53 = icmp eq i32 %52, 0
  br i1 %53, label %54, label %62

54:                                               ; preds = %130, %118, %106, %94, %82, %70, %50
  %55 = phi i64 [ %42, %50 ], [ %63, %70 ], [ %75, %82 ], [ %87, %94 ], [ %99, %106 ], [ %111, %118 ], [ %123, %130 ]
  %56 = getelementptr inbounds i32, i32* %20, i64 %55
  %57 = add nuw nsw i64 %55, 1
  store i64 %57, i64* %41, align 8, !tbaa !9
  store i32 1, i32* %56, align 4, !tbaa !5
  %58 = add i64 %36, 1
  %59 = getelementptr inbounds [7 x i64], [7 x i64]* %2, i64 0, i64 %36
  store i64 %55, i64* %59, align 8, !tbaa !9
  %60 = add i64 %37, 1
  %61 = getelementptr inbounds i64, i64* %24, i64 %37
  store i64 %55, i64* %61, align 8, !tbaa !9
  br label %134

62:                                               ; preds = %50, %44
  %63 = add i64 %42, 1
  %64 = icmp eq i64 %63, 7
  br i1 %64, label %134, label %65, !llvm.loop !11

65:                                               ; preds = %62
  %66 = add i64 %63, %45
  %67 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %66
  %68 = load i32, i32* %67, align 4, !tbaa !5
  %69 = icmp eq i32 %68, 0
  br i1 %69, label %74, label %70

70:                                               ; preds = %65
  %71 = getelementptr inbounds i32, i32* %20, i64 %63
  %72 = load i32, i32* %71, align 4, !tbaa !5
  %73 = icmp eq i32 %72, 0
  br i1 %73, label %54, label %74

74:                                               ; preds = %70, %65
  %75 = add i64 %42, 2
  %76 = icmp eq i64 %75, 7
  br i1 %76, label %134, label %77, !llvm.loop !11

77:                                               ; preds = %74
  %78 = add i64 %75, %45
  %79 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %78
  %80 = load i32, i32* %79, align 4, !tbaa !5
  %81 = icmp eq i32 %80, 0
  br i1 %81, label %86, label %82

82:                                               ; preds = %77
  %83 = getelementptr inbounds i32, i32* %20, i64 %75
  %84 = load i32, i32* %83, align 4, !tbaa !5
  %85 = icmp eq i32 %84, 0
  br i1 %85, label %54, label %86

86:                                               ; preds = %82, %77
  %87 = add i64 %42, 3
  %88 = icmp eq i64 %87, 7
  br i1 %88, label %134, label %89, !llvm.loop !11

89:                                               ; preds = %86
  %90 = add i64 %87, %45
  %91 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %90
  %92 = load i32, i32* %91, align 4, !tbaa !5
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %98, label %94

94:                                               ; preds = %89
  %95 = getelementptr inbounds i32, i32* %20, i64 %87
  %96 = load i32, i32* %95, align 4, !tbaa !5
  %97 = icmp eq i32 %96, 0
  br i1 %97, label %54, label %98

98:                                               ; preds = %94, %89
  %99 = add i64 %42, 4
  %100 = icmp eq i64 %99, 7
  br i1 %100, label %134, label %101, !llvm.loop !11

101:                                              ; preds = %98
  %102 = add i64 %99, %45
  %103 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %102
  %104 = load i32, i32* %103, align 4, !tbaa !5
  %105 = icmp eq i32 %104, 0
  br i1 %105, label %110, label %106

106:                                              ; preds = %101
  %107 = getelementptr inbounds i32, i32* %20, i64 %99
  %108 = load i32, i32* %107, align 4, !tbaa !5
  %109 = icmp eq i32 %108, 0
  br i1 %109, label %54, label %110

110:                                              ; preds = %106, %101
  %111 = add i64 %42, 5
  %112 = icmp eq i64 %111, 7
  br i1 %112, label %134, label %113, !llvm.loop !11

113:                                              ; preds = %110
  %114 = add i64 %111, %45
  %115 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %114
  %116 = load i32, i32* %115, align 4, !tbaa !5
  %117 = icmp eq i32 %116, 0
  br i1 %117, label %122, label %118

118:                                              ; preds = %113
  %119 = getelementptr inbounds i32, i32* %20, i64 %111
  %120 = load i32, i32* %119, align 4, !tbaa !5
  %121 = icmp eq i32 %120, 0
  br i1 %121, label %54, label %122

122:                                              ; preds = %118, %113
  %123 = add i64 %42, 6
  %124 = icmp eq i64 %123, 7
  br i1 %124, label %134, label %125, !llvm.loop !11

125:                                              ; preds = %122
  %126 = add i64 %123, %45
  %127 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %126
  %128 = load i32, i32* %127, align 4, !tbaa !5
  %129 = icmp eq i32 %128, 0
  br i1 %129, label %134, label %130

130:                                              ; preds = %125
  %131 = getelementptr inbounds i32, i32* %20, i64 %123
  %132 = load i32, i32* %131, align 4, !tbaa !5
  %133 = icmp eq i32 %132, 0
  br i1 %133, label %54, label %134

134:                                              ; preds = %62, %74, %86, %98, %110, %122, %130, %125, %54, %35
  %135 = phi i64 [ %58, %54 ], [ %36, %35 ], [ %36, %125 ], [ %36, %130 ], [ %36, %122 ], [ %36, %110 ], [ %36, %98 ], [ %36, %86 ], [ %36, %74 ], [ %36, %62 ]
  %136 = phi i64 [ %55, %54 ], [ %42, %35 ], [ 7, %125 ], [ 7, %130 ], [ 7, %122 ], [ 7, %110 ], [ 7, %98 ], [ 7, %86 ], [ 7, %74 ], [ 7, %62 ]
  %137 = phi i64 [ %60, %54 ], [ %37, %35 ], [ %37, %125 ], [ %37, %130 ], [ %37, %122 ], [ %37, %110 ], [ %37, %98 ], [ %37, %86 ], [ %37, %74 ], [ %37, %62 ]
  %138 = icmp eq i64 %136, 7
  %139 = sext i1 %138 to i64
  %140 = add i64 %137, %139
  %141 = icmp eq i64 %140, 0
  br i1 %141, label %142, label %35, !llvm.loop !13

142:                                              ; preds = %134
  tail call void @free(i8* noundef %19) #7
  tail call void @free(i8* noundef %21) #7
  tail call void @free(i8* noundef %23) #7
  %143 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str, i64 0, i64 0), i64 noundef 0)
  %144 = icmp eq i64 %135, 0
  br i1 %144, label %145, label %147

145:                                              ; preds = %147, %33, %142
  %146 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 56, i8* nonnull %18) #7
  call void @llvm.lifetime.end.p0i8(i64 196, i8* nonnull %3) #7
  ret i32 0

147:                                              ; preds = %142, %147
  %148 = phi i64 [ %151, %147 ], [ 0, %142 ]
  %149 = getelementptr inbounds [7 x i64], [7 x i64]* %2, i64 0, i64 %148
  %150 = load i64, i64* %149, align 8, !tbaa !9
  %151 = add nuw i64 %148, 1
  %152 = icmp ult i64 %151, %135
  %153 = select i1 %152, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0)
  %154 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %150, i8* noundef %153)
  %155 = icmp eq i64 %151, %135
  br i1 %155, label %145, label %147, !llvm.loop !14
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #5

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #6

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #3 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree nounwind }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!10, !10, i64 0}
!10 = !{!"long", !7, i64 0}
!11 = distinct !{!11, !12}
!12 = !{!"llvm.loop.mustprogress"}
!13 = distinct !{!13, !12}
!14 = distinct !{!14, !12}
