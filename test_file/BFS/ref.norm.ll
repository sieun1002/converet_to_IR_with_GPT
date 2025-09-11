; ModuleID = 'cases/BFS/ref.ll'
source_filename = "/home/nata20034/workspace/file/src/BFS.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.3 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.5 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [49 x i32], align 16
  %2 = alloca [7 x i32], align 16
  %3 = alloca [7 x i64], align 16
  %4 = bitcast [49 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 196, i8* nonnull %4) #7
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %4, i8 0, i64 196, i1 false)
  %5 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 1
  store i32 1, i32* %5, align 4, !tbaa !5
  %6 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 7
  store i32 1, i32* %6, align 4, !tbaa !5
  %7 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 2
  store i32 1, i32* %7, align 8, !tbaa !5
  %8 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 14
  store i32 1, i32* %8, align 8, !tbaa !5
  %9 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 10
  store i32 1, i32* %9, align 8, !tbaa !5
  %10 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 22
  store i32 1, i32* %10, align 8, !tbaa !5
  %11 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 11
  store i32 1, i32* %11, align 4, !tbaa !5
  %12 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 29
  store i32 1, i32* %12, align 4, !tbaa !5
  %13 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 19
  store i32 1, i32* %13, align 4, !tbaa !5
  %14 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 37
  store i32 1, i32* %14, align 4, !tbaa !5
  %15 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 33
  store i32 1, i32* %15, align 4, !tbaa !5
  %16 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 39
  store i32 1, i32* %16, align 4, !tbaa !5
  %17 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 41
  store i32 1, i32* %17, align 4, !tbaa !5
  %18 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 47
  store i32 1, i32* %18, align 4, !tbaa !5
  %19 = bitcast [7 x i32]* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 28, i8* nonnull %19) #7
  %20 = bitcast [7 x i64]* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 56, i8* nonnull %20) #7
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(28) %19, i8 -1, i64 28, i1 false) #7, !tbaa !5
  %21 = tail call noalias dereferenceable_or_null(56) i8* @malloc(i64 noundef 56) #7
  %22 = bitcast i8* %21 to i64*
  %23 = icmp eq i8* %21, null
  br i1 %23, label %24, label %26

24:                                               ; preds = %0
  %25 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef 0)
  br label %138

26:                                               ; preds = %0
  %27 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 0
  store i32 0, i32* %27, align 16, !tbaa !5
  store i64 0, i64* %22, align 8, !tbaa !9
  %28 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 1
  %29 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 2
  %30 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 3
  %31 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 4
  %32 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 5
  %33 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 6
  br label %34

34:                                               ; preds = %133, %26
  %35 = phi i32 [ -1, %26 ], [ %130, %133 ]
  %36 = phi i32 [ -1, %26 ], [ %116, %133 ]
  %37 = phi i32 [ -1, %26 ], [ %102, %133 ]
  %38 = phi i32 [ -1, %26 ], [ %88, %133 ]
  %39 = phi i32 [ -1, %26 ], [ %74, %133 ]
  %40 = phi i32 [ -1, %26 ], [ %60, %133 ]
  %41 = phi i64 [ 0, %26 ], [ %44, %133 ]
  %42 = phi i64 [ 0, %26 ], [ %135, %133 ]
  %43 = phi i64 [ 1, %26 ], [ %131, %133 ]
  %44 = add nuw i64 %41, 1
  %45 = getelementptr inbounds [7 x i64], [7 x i64]* %3, i64 0, i64 %41
  store i64 %42, i64* %45, align 8, !tbaa !9
  %46 = mul i64 %42, 7
  %47 = getelementptr inbounds [7 x i32], [7 x i32]* %2, i64 0, i64 %42
  %48 = add i64 %46, 1
  %49 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %48
  %50 = load i32, i32* %49, align 4, !tbaa !5
  %51 = icmp ne i32 %50, 0
  %52 = icmp eq i32 %40, -1
  %53 = select i1 %51, i1 %52, i1 false
  br i1 %53, label %54, label %59

54:                                               ; preds = %34
  %55 = load i32, i32* %47, align 4, !tbaa !5
  %56 = add nsw i32 %55, 1
  store i32 %56, i32* %28, align 4, !tbaa !5
  %57 = add i64 %43, 1
  %58 = getelementptr inbounds i64, i64* %22, i64 %43
  store i64 1, i64* %58, align 8, !tbaa !9
  br label %59

59:                                               ; preds = %54, %34
  %60 = phi i32 [ %56, %54 ], [ %40, %34 ]
  %61 = phi i64 [ %57, %54 ], [ %43, %34 ]
  %62 = add i64 %46, 2
  %63 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %62
  %64 = load i32, i32* %63, align 4, !tbaa !5
  %65 = icmp ne i32 %64, 0
  %66 = icmp eq i32 %39, -1
  %67 = select i1 %65, i1 %66, i1 false
  br i1 %67, label %68, label %73

68:                                               ; preds = %59
  %69 = load i32, i32* %47, align 4, !tbaa !5
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %29, align 8, !tbaa !5
  %71 = add i64 %61, 1
  %72 = getelementptr inbounds i64, i64* %22, i64 %61
  store i64 2, i64* %72, align 8, !tbaa !9
  br label %73

73:                                               ; preds = %68, %59
  %74 = phi i32 [ %70, %68 ], [ %39, %59 ]
  %75 = phi i64 [ %71, %68 ], [ %61, %59 ]
  %76 = add i64 %46, 3
  %77 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %76
  %78 = load i32, i32* %77, align 4, !tbaa !5
  %79 = icmp ne i32 %78, 0
  %80 = icmp eq i32 %38, -1
  %81 = select i1 %79, i1 %80, i1 false
  br i1 %81, label %82, label %87

82:                                               ; preds = %73
  %83 = load i32, i32* %47, align 4, !tbaa !5
  %84 = add nsw i32 %83, 1
  store i32 %84, i32* %30, align 4, !tbaa !5
  %85 = add i64 %75, 1
  %86 = getelementptr inbounds i64, i64* %22, i64 %75
  store i64 3, i64* %86, align 8, !tbaa !9
  br label %87

87:                                               ; preds = %82, %73
  %88 = phi i32 [ %84, %82 ], [ %38, %73 ]
  %89 = phi i64 [ %85, %82 ], [ %75, %73 ]
  %90 = add i64 %46, 4
  %91 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %90
  %92 = load i32, i32* %91, align 4, !tbaa !5
  %93 = icmp ne i32 %92, 0
  %94 = icmp eq i32 %37, -1
  %95 = select i1 %93, i1 %94, i1 false
  br i1 %95, label %96, label %101

96:                                               ; preds = %87
  %97 = load i32, i32* %47, align 4, !tbaa !5
  %98 = add nsw i32 %97, 1
  store i32 %98, i32* %31, align 16, !tbaa !5
  %99 = add i64 %89, 1
  %100 = getelementptr inbounds i64, i64* %22, i64 %89
  store i64 4, i64* %100, align 8, !tbaa !9
  br label %101

101:                                              ; preds = %96, %87
  %102 = phi i32 [ %98, %96 ], [ %37, %87 ]
  %103 = phi i64 [ %99, %96 ], [ %89, %87 ]
  %104 = add i64 %46, 5
  %105 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %104
  %106 = load i32, i32* %105, align 4, !tbaa !5
  %107 = icmp ne i32 %106, 0
  %108 = icmp eq i32 %36, -1
  %109 = select i1 %107, i1 %108, i1 false
  br i1 %109, label %110, label %115

110:                                              ; preds = %101
  %111 = load i32, i32* %47, align 4, !tbaa !5
  %112 = add nsw i32 %111, 1
  store i32 %112, i32* %32, align 4, !tbaa !5
  %113 = add i64 %103, 1
  %114 = getelementptr inbounds i64, i64* %22, i64 %103
  store i64 5, i64* %114, align 8, !tbaa !9
  br label %115

115:                                              ; preds = %110, %101
  %116 = phi i32 [ %112, %110 ], [ %36, %101 ]
  %117 = phi i64 [ %113, %110 ], [ %103, %101 ]
  %118 = add i64 %46, 6
  %119 = getelementptr inbounds [49 x i32], [49 x i32]* %1, i64 0, i64 %118
  %120 = load i32, i32* %119, align 4, !tbaa !5
  %121 = icmp ne i32 %120, 0
  %122 = icmp eq i32 %35, -1
  %123 = select i1 %121, i1 %122, i1 false
  br i1 %123, label %124, label %129

124:                                              ; preds = %115
  %125 = load i32, i32* %47, align 4, !tbaa !5
  %126 = add nsw i32 %125, 1
  store i32 %126, i32* %33, align 8, !tbaa !5
  %127 = add i64 %117, 1
  %128 = getelementptr inbounds i64, i64* %22, i64 %117
  store i64 6, i64* %128, align 8, !tbaa !9
  br label %129

129:                                              ; preds = %124, %115
  %130 = phi i32 [ %126, %124 ], [ %35, %115 ]
  %131 = phi i64 [ %127, %124 ], [ %117, %115 ]
  %132 = icmp ult i64 %44, %131
  br i1 %132, label %133, label %136, !llvm.loop !11

133:                                              ; preds = %129
  %134 = getelementptr inbounds i64, i64* %22, i64 %44
  %135 = load i64, i64* %134, align 8, !tbaa !9
  br label %34

136:                                              ; preds = %129
  tail call void @free(i8* noundef nonnull %21) #7
  %137 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i64 noundef 0)
  br label %154

138:                                              ; preds = %154, %24
  %139 = phi i32 [ -1, %24 ], [ 0, %154 ]
  %140 = phi i32 [ -1, %24 ], [ %60, %154 ]
  %141 = phi i32 [ -1, %24 ], [ %74, %154 ]
  %142 = phi i32 [ -1, %24 ], [ %88, %154 ]
  %143 = phi i32 [ -1, %24 ], [ %102, %154 ]
  %144 = phi i32 [ -1, %24 ], [ %116, %154 ]
  %145 = phi i32 [ -1, %24 ], [ %130, %154 ]
  %146 = tail call i32 @putchar(i32 10)
  %147 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 0, i32 noundef %139)
  %148 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 1, i32 noundef %140)
  %149 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 2, i32 noundef %141)
  %150 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 3, i32 noundef %142)
  %151 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 4, i32 noundef %143)
  %152 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 5, i32 noundef %144)
  %153 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.5, i64 0, i64 0), i64 noundef 0, i64 noundef 6, i32 noundef %145)
  call void @llvm.lifetime.end.p0i8(i64 56, i8* nonnull %20) #7
  call void @llvm.lifetime.end.p0i8(i64 28, i8* nonnull %19) #7
  call void @llvm.lifetime.end.p0i8(i64 196, i8* nonnull %4) #7
  ret i32 0

154:                                              ; preds = %154, %136
  %155 = phi i64 [ %158, %154 ], [ 0, %136 ]
  %156 = getelementptr inbounds [7 x i64], [7 x i64]* %3, i64 0, i64 %155
  %157 = load i64, i64* %156, align 8, !tbaa !9
  %158 = add nuw i64 %155, 1
  %159 = icmp ult i64 %155, %41
  %160 = select i1 %159, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.3, i64 0, i64 0)
  %161 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i64 noundef %157, i8* noundef %160)
  %162 = icmp eq i64 %155, %41
  br i1 %162, label %138, label %154, !llvm.loop !13
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #5

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #6

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
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
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = !{!10, !10, i64 0}
!10 = !{!"long", !7, i64 0}
!11 = distinct !{!11, !12}
!12 = !{!"llvm.loop.mustprogress"}
!13 = distinct !{!13, !12}
