; ModuleID = '/home/nata20034/workspace/file/src/quicksort.c'
source_filename = "/home/nata20034/workspace/file/src/quicksort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %2) #6
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(40) %2, i8* noundef nonnull align 16 dereferenceable(40) bitcast ([10 x i32]* @__const.main.a to i8*), i64 40, i1 false)
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  call fastcc void @quick_sort(i32* noundef nonnull %3, i64 noundef 0, i64 noundef 9)
  %4 = load i32, i32* %3, align 16, !tbaa !5
  %5 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %4)
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  %7 = load i32, i32* %6, align 4, !tbaa !5
  %8 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %7)
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 2
  %10 = load i32, i32* %9, align 8, !tbaa !5
  %11 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %10)
  %12 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  %13 = load i32, i32* %12, align 4, !tbaa !5
  %14 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %13)
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %16 = load i32, i32* %15, align 16, !tbaa !5
  %17 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %16)
  %18 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %19 = load i32, i32* %18, align 4, !tbaa !5
  %20 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %19)
  %21 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %22 = load i32, i32* %21, align 8, !tbaa !5
  %23 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %22)
  %24 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %25 = load i32, i32* %24, align 4, !tbaa !5
  %26 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %25)
  %27 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %28 = load i32, i32* %27, align 16, !tbaa !5
  %29 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %28)
  %30 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %31 = load i32, i32* %30, align 4, !tbaa !5
  %32 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %31)
  %33 = call i32 @putchar(i32 10)
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %2) #6
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: nofree nosync nounwind uwtable
define internal fastcc void @quick_sort(i32* noundef %0, i64 noundef %1, i64 noundef %2) unnamed_addr #3 {
  %4 = icmp sgt i64 %2, %1
  br i1 %4, label %5, label %52

5:                                                ; preds = %3, %48
  %6 = phi i64 [ %50, %48 ], [ %1, %3 ]
  %7 = phi i64 [ %49, %48 ], [ %2, %3 ]
  %8 = sub nsw i64 %7, %6
  %9 = sdiv i64 %8, 2
  %10 = add nsw i64 %9, %6
  %11 = getelementptr inbounds i32, i32* %0, i64 %10
  %12 = load i32, i32* %11, align 4, !tbaa !5
  br label %13

13:                                               ; preds = %34, %5
  %14 = phi i64 [ %6, %5 ], [ %35, %34 ]
  %15 = phi i64 [ %7, %5 ], [ %36, %34 ]
  br label %16

16:                                               ; preds = %16, %13
  %17 = phi i64 [ %14, %13 ], [ %21, %16 ]
  %18 = getelementptr inbounds i32, i32* %0, i64 %17
  %19 = load i32, i32* %18, align 4, !tbaa !5
  %20 = icmp slt i32 %19, %12
  %21 = add nsw i64 %17, 1
  br i1 %20, label %16, label %22, !llvm.loop !9

22:                                               ; preds = %16
  %23 = getelementptr inbounds i32, i32* %0, i64 %17
  br label %24

24:                                               ; preds = %24, %22
  %25 = phi i64 [ %29, %24 ], [ %15, %22 ]
  %26 = getelementptr inbounds i32, i32* %0, i64 %25
  %27 = load i32, i32* %26, align 4, !tbaa !5
  %28 = icmp sgt i32 %27, %12
  %29 = add nsw i64 %25, -1
  br i1 %28, label %24, label %30, !llvm.loop !11

30:                                               ; preds = %24
  %31 = icmp sgt i64 %17, %25
  br i1 %31, label %34, label %32

32:                                               ; preds = %30
  %33 = getelementptr inbounds i32, i32* %0, i64 %25
  store i32 %27, i32* %23, align 4, !tbaa !5
  store i32 %19, i32* %33, align 4, !tbaa !5
  br label %34

34:                                               ; preds = %30, %32
  %35 = phi i64 [ %21, %32 ], [ %17, %30 ]
  %36 = phi i64 [ %29, %32 ], [ %25, %30 ]
  %37 = icmp sgt i64 %35, %36
  br i1 %37, label %38, label %13, !llvm.loop !12

38:                                               ; preds = %34
  %39 = sub nsw i64 %36, %6
  %40 = sub nsw i64 %7, %35
  %41 = icmp slt i64 %39, %40
  br i1 %41, label %42, label %45

42:                                               ; preds = %38
  %43 = icmp sgt i64 %36, %6
  br i1 %43, label %44, label %48

44:                                               ; preds = %42
  tail call fastcc void @quick_sort(i32* noundef nonnull %0, i64 noundef %6, i64 noundef %36)
  br label %48

45:                                               ; preds = %38
  %46 = icmp sgt i64 %7, %35
  br i1 %46, label %47, label %48

47:                                               ; preds = %45
  tail call fastcc void @quick_sort(i32* noundef nonnull %0, i64 noundef %35, i64 noundef %7)
  br label %48

48:                                               ; preds = %45, %47, %42, %44
  %49 = phi i64 [ %7, %44 ], [ %7, %42 ], [ %36, %47 ], [ %36, %45 ]
  %50 = phi i64 [ %35, %44 ], [ %35, %42 ], [ %6, %47 ], [ %6, %45 ]
  %51 = icmp sgt i64 %49, %50
  br i1 %51, label %5, label %52, !llvm.loop !13

52:                                               ; preds = %48, %3
  ret void
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #4

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #5

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #3 = { nofree nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
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
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
!12 = distinct !{!12, !10}
!13 = distinct !{!13, !10}
