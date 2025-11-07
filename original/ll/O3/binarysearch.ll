; ModuleID = '/home/sieun/workspace/converet_to_IR_with_GPT/original/src/binarysearch.c'
source_filename = "/home/sieun/workspace/converet_to_IR_with_GPT/original/src/binarysearch.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %1, %0
  %2 = phi i64 [ 9, %0 ], [ %10, %1 ]
  %3 = phi i64 [ 0, %0 ], [ %9, %1 ]
  %4 = sub i64 %2, %3
  %5 = lshr i64 %4, 1
  %6 = add i64 %5, %3
  %7 = icmp ult i64 %6, 3
  %8 = add i64 %6, 1
  %9 = select i1 %7, i64 %8, i64 %3
  %10 = select i1 %7, i64 %2, i64 %6
  %11 = icmp ugt i64 %10, %9
  br i1 %11, label %1, label %12, !llvm.loop !5

12:                                               ; preds = %1
  %13 = icmp ult i64 %9, 9
  %14 = add nsw i64 %9, -3
  %15 = icmp ult i64 %14, 2
  %16 = select i1 %13, i1 %15, i1 false
  br i1 %16, label %17, label %19

17:                                               ; preds = %12
  %18 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 noundef 2, i64 noundef %9)
  br label %21

19:                                               ; preds = %12
  %20 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 2)
  br label %21

21:                                               ; preds = %17, %19
  %22 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef 5)
  %23 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 noundef -5, i64 noundef 0)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #1

attributes #0 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
