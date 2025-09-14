; ModuleID = 'print_distances.ll'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @print_distances(i32* %arr, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cont = icmp slt i32 %i, %n
  br i1 %cont, label %body, label %end

body:
  %idx64 = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i32 %i)
  br label %inc

print_val:
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %i, i32 %val)
  br label %inc

inc:
  %i.next = add i32 %i, 1
  br label %loop

end:
  ret void
}