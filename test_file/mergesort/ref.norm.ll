; ModuleID = 'cases/mergesort/ref.ll'
source_filename = "/home/nata20034/workspace/file/src/mergesort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %2) #6
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  %4 = tail call noalias dereferenceable_or_null(40) i8* @malloc(i64 noundef 40) #6
  %5 = icmp eq i8* %4, null
  br i1 %5, label %72, label %6

6:                                                ; preds = %0
  %7 = bitcast i8* %4 to i32*
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  %9 = getelementptr inbounds i32, i32* %7, i64 1
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 2
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  %12 = getelementptr inbounds i32, i32* %7, i64 2
  %13 = getelementptr inbounds i32, i32* %7, i64 3
  %14 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %16 = getelementptr inbounds i32, i32* %7, i64 4
  %17 = getelementptr inbounds i32, i32* %7, i64 5
  %18 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %19 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %20 = getelementptr inbounds i32, i32* %7, i64 6
  %21 = bitcast i32* %13 to <4 x i32>*
  store <4 x i32> <i32 5, i32 2, i32 7, i32 6>, <4 x i32>* %21, align 4, !tbaa !5
  %22 = getelementptr inbounds i32, i32* %7, i64 7
  store i32 8, i32* %22, align 4, !tbaa !5
  %23 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %24 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %25 = getelementptr inbounds i32, i32* %7, i64 8
  store i32 0, i32* %25, align 4, !tbaa !5
  %26 = getelementptr inbounds i32, i32* %7, i64 9
  store i32 4, i32* %26, align 4, !tbaa !5
  %27 = bitcast [10 x i32]* %1 to <4 x i32>*
  store <4 x i32> <i32 1, i32 3, i32 5, i32 9>, <4 x i32>* %27, align 16, !tbaa !5
  %28 = bitcast i32* %14 to <4 x i32>*
  store <4 x i32> <i32 2, i32 6, i32 7, i32 8>, <4 x i32>* %28, align 16, !tbaa !5
  store i32 0, i32* %23, align 16, !tbaa !5
  store i32 4, i32* %24, align 4, !tbaa !5
  store i32 1, i32* %7, align 4, !tbaa !5
  store i32 2, i32* %9, align 4, !tbaa !5
  store i32 3, i32* %12, align 4, !tbaa !5
  br i1 false, label %30, label %29

29:                                               ; preds = %6
  store i32 5, i32* %13, align 4, !tbaa !5
  br label %31

30:                                               ; preds = %6
  store i32 6, i32* %13, align 4, !tbaa !5
  br label %31

31:                                               ; preds = %30, %29
  br i1 true, label %36, label %32

32:                                               ; preds = %31
  store i32 9, i32* %16, align 4, !tbaa !5
  %33 = icmp ult i64 3, 3
  br i1 %33, label %34, label %35

34:                                               ; preds = %32
  br label %37

35:                                               ; preds = %32
  br label %40

36:                                               ; preds = %31
  store i32 6, i32* %16, align 4, !tbaa !5
  br i1 true, label %37, label %._crit_edge

._crit_edge:                                      ; preds = %36
  br label %38

37:                                               ; preds = %36, %34
  br i1 true, label %40, label %._crit_edge1

._crit_edge1:                                     ; preds = %37
  br label %38

38:                                               ; preds = %._crit_edge1, %._crit_edge
  %39 = phi i32 [ 6, %._crit_edge1 ], [ 6, %._crit_edge ]
  br label %41

40:                                               ; preds = %37, %35
  br label %41

41:                                               ; preds = %40, %38
  %42 = phi i32 [ 6, %40 ], [ %39, %38 ]
  store i32 7, i32* %17, align 4, !tbaa !5
  br label %43

43:                                               ; preds = %41
  br label %47

44:                                               ; No predecessors!
  br label %._crit_edge2

._crit_edge2:                                     ; preds = %44
  br label %46

45:                                               ; No predecessors!
  br label %._crit_edge3

._crit_edge3:                                     ; preds = %45
  br label %46

46:                                               ; preds = %._crit_edge3, %._crit_edge2
  br label %48

47:                                               ; preds = %43
  br label %48

48:                                               ; preds = %47, %46
  store i32 8, i32* %20, align 4, !tbaa !5
  br label %49

49:                                               ; preds = %48
  br label %52

50:                                               ; No predecessors!
  br label %53

51:                                               ; No predecessors!
  br label %52

._crit_edge4:                                     ; No predecessors!
  br label %53

52:                                               ; preds = %51, %49
  br label %53

53:                                               ; preds = %50, %._crit_edge4, %52
  store i32 9, i32* %22, align 4, !tbaa !5
  store i32 0, i32* %25, align 4, !tbaa !5
  store i32 4, i32* %26, align 4, !tbaa !5
  store i32 0, i32* %3, align 16, !tbaa !5
  store i32 1, i32* %8, align 4, !tbaa !5
  store i32 2, i32* %10, align 8, !tbaa !5
  br i1 false, label %55, label %54

54:                                               ; preds = %53
  store i32 3, i32* %11, align 4, !tbaa !5
  br i1 true, label %58, label %56

55:                                               ; preds = %53
  store i32 4, i32* %11, align 4, !tbaa !5
  br label %58

56:                                               ; preds = %54
  store i32 5, i32* %14, align 16, !tbaa !5
  %57 = icmp sgt i32 %42, 4
  br i1 %57, label %._crit_edge5, label %59

._crit_edge5:                                     ; preds = %56
  br label %60

58:                                               ; preds = %55, %54
  store i32 4, i32* %14, align 16, !tbaa !5
  br label %60

59:                                               ; preds = %56
  store i32 %42, i32* %15, align 4, !tbaa !5
  br i1 true, label %._crit_edge6, label %61

._crit_edge6:                                     ; preds = %59
  br label %68

60:                                               ; preds = %._crit_edge5, %58
  store i32 5, i32* %15, align 4, !tbaa !5
  br label %68

61:                                               ; preds = %59
  %62 = getelementptr inbounds i32, i32* %7, i64 6
  %63 = load i32, i32* %62, align 4, !tbaa !5
  %64 = getelementptr inbounds i32, i32* %7, i64 9
  %65 = load i32, i32* %64, align 4, !tbaa !5
  %66 = icmp sgt i32 %63, %65
  br i1 %66, label %67, label %69

67:                                               ; preds = %61
  store i32 %65, i32* %19, align 4, !tbaa !5
  br label %70

68:                                               ; preds = %._crit_edge6, %60
  store i32 %42, i32* %18, align 8, !tbaa !5
  br label %70

69:                                               ; preds = %61
  br label %71

70:                                               ; preds = %68, %67
  br label %71

71:                                               ; preds = %70, %69
  tail call void @free(i8* noundef nonnull %4) #6
  br label %72

72:                                               ; preds = %71, %0
  %73 = phi i32 [ 0, %0 ], [ 9, %71 ]
  %74 = phi i32 [ 4, %0 ], [ 8, %71 ]
  %75 = phi i32 [ 6, %0 ], [ 7, %71 ]
  %76 = phi i32 [ 8, %0 ], [ %42, %71 ]
  %77 = phi i32 [ 2, %0 ], [ 5, %71 ]
  %78 = phi i32 [ 7, %0 ], [ 4, %71 ]
  %79 = phi i32 [ 5, %0 ], [ 2, %71 ]
  %80 = phi i32 [ 9, %0 ], [ 0, %71 ]
  %81 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %80)
  %82 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 1)
  %83 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %79)
  %84 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef 3)
  %85 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %78)
  %86 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %77)
  %87 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %76)
  %88 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %75)
  %89 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %74)
  %90 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %73)
  %91 = tail call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %2) #6
  ret i32 0
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

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
