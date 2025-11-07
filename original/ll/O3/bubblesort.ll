; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/bubblesort.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/bubblesort.c"
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
  br label %4

4:                                                ; preds = %27, %0
  %5 = phi i64 [ 10, %0 ], [ %28, %27 ]
  %6 = icmp ugt i64 %5, 1
  br i1 %6, label %7, label %56

7:                                                ; preds = %4
  %8 = load i32, i32* %3, align 16, !tbaa !5
  %9 = add i64 %5, -1
  %10 = and i64 %9, 1
  %11 = icmp eq i64 %5, 2
  br i1 %11, label %14, label %12

12:                                               ; preds = %7
  %13 = and i64 %9, -2
  br label %30

14:                                               ; preds = %50, %7
  %15 = phi i64 [ undef, %7 ], [ %52, %50 ]
  %16 = phi i32 [ %8, %7 ], [ %51, %50 ]
  %17 = phi i64 [ 1, %7 ], [ %53, %50 ]
  %18 = phi i64 [ 0, %7 ], [ %52, %50 ]
  %19 = icmp eq i64 %10, 0
  br i1 %19, label %27, label %20

20:                                               ; preds = %14
  %21 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %17
  %22 = load i32, i32* %21, align 4, !tbaa !5
  %23 = icmp sgt i32 %16, %22
  br i1 %23, label %24, label %27

24:                                               ; preds = %20
  %25 = add i64 %17, -1
  %26 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %25
  store i32 %22, i32* %26, align 4, !tbaa !5
  store i32 %16, i32* %21, align 4, !tbaa !5
  br label %27

27:                                               ; preds = %20, %24, %14
  %28 = phi i64 [ %15, %14 ], [ %17, %24 ], [ %18, %20 ]
  %29 = icmp eq i64 %28, 0
  br i1 %29, label %56, label %4

30:                                               ; preds = %50, %12
  %31 = phi i32 [ %8, %12 ], [ %51, %50 ]
  %32 = phi i64 [ 1, %12 ], [ %53, %50 ]
  %33 = phi i64 [ 0, %12 ], [ %52, %50 ]
  %34 = phi i64 [ 0, %12 ], [ %54, %50 ]
  %35 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %32
  %36 = load i32, i32* %35, align 4, !tbaa !5
  %37 = icmp sgt i32 %31, %36
  br i1 %37, label %38, label %41

38:                                               ; preds = %30
  %39 = add nsw i64 %32, -1
  %40 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %39
  store i32 %36, i32* %40, align 4, !tbaa !5
  store i32 %31, i32* %35, align 4, !tbaa !5
  br label %41

41:                                               ; preds = %38, %30
  %42 = phi i32 [ %31, %38 ], [ %36, %30 ]
  %43 = phi i64 [ %32, %38 ], [ %33, %30 ]
  %44 = add nuw i64 %32, 1
  %45 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %44
  %46 = load i32, i32* %45, align 4, !tbaa !5
  %47 = icmp sgt i32 %42, %46
  br i1 %47, label %48, label %50

48:                                               ; preds = %41
  %49 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 %32
  store i32 %46, i32* %49, align 4, !tbaa !5
  store i32 %42, i32* %45, align 4, !tbaa !5
  br label %50

50:                                               ; preds = %48, %41
  %51 = phi i32 [ %42, %48 ], [ %46, %41 ]
  %52 = phi i64 [ %44, %48 ], [ %43, %41 ]
  %53 = add nuw i64 %32, 2
  %54 = add i64 %34, 2
  %55 = icmp eq i64 %54, %13
  br i1 %55, label %14, label %30, !llvm.loop !9

56:                                               ; preds = %4, %27
  %57 = load i32, i32* %3, align 16, !tbaa !5
  %58 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %57)
  %59 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 1
  %60 = load i32, i32* %59, align 4, !tbaa !5
  %61 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %60)
  %62 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 2
  %63 = load i32, i32* %62, align 8, !tbaa !5
  %64 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %63)
  %65 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 3
  %66 = load i32, i32* %65, align 4, !tbaa !5
  %67 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %66)
  %68 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 4
  %69 = load i32, i32* %68, align 16, !tbaa !5
  %70 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %69)
  %71 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 5
  %72 = load i32, i32* %71, align 4, !tbaa !5
  %73 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %72)
  %74 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 6
  %75 = load i32, i32* %74, align 8, !tbaa !5
  %76 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %75)
  %77 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 7
  %78 = load i32, i32* %77, align 4, !tbaa !5
  %79 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %78)
  %80 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 8
  %81 = load i32, i32* %80, align 16, !tbaa !5
  %82 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %81)
  %83 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 9
  %84 = load i32, i32* %83, align 4, !tbaa !5
  %85 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %84)
  %86 = tail call i32 @putchar(i32 10)
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
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
