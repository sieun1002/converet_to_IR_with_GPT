; ModuleID = 'insertion_sort_print.ll'
source_filename = "insertion_sort_print"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @insertion_sort(i32* %arr, i64 %len) {
entry:
  %cmp_len = icmp ult i64 %len, 2
  br i1 %cmp_len, label %ret, label %outer_header

outer_header:
  %i = phi i64 [ 1, %entry ], [ %i_next, %inner_end ]
  %key_ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key_ptr, align 4
  %j.init = add nsw i64 %i, -1
  br label %inner_cond

inner_cond:
  %j = phi i64 [ %j.init, %outer_header ], [ %j.dec, %inner_body ]
  %cond1 = icmp sge i64 %j, 0
  br i1 %cond1, label %inner_check, label %inner_end

inner_check:
  %e.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %e.val = load i32, i32* %e.ptr, align 4
  %gt = icmp sgt i32 %e.val, %key
  br i1 %gt, label %inner_body, label %inner_end

inner_body:
  %j.plus1 = add nsw i64 %j, 1
  %dst.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  store i32 %e.val, i32* %dst.ptr, align 4
  %j.dec = add nsw i64 %j, -1
  br label %inner_cond

inner_end:
  %j.final = phi i64 [ %j, %inner_check ], [ %j, %inner_cond ]
  %j1.final = add nsw i64 %j.final, 1
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j1.final
  store i32 %key, i32* %ins.ptr, align 4
  %i_next = add nuw nsw i64 %i, 1
  %cont = icmp ult i64 %i_next, %len
  br i1 %cont, label %outer_header, label %ret

ret:
  ret void
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* %p0, i64 10)
  br label %loop_header

loop_header:
  %idx = phi i64 [ 0, %entry ], [ %idx.next, %loop_latch ]
  %cmp = icmp ult i64 %idx, 10
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i32 0, i32 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %loop_latch

loop_latch:
  %idx.next = add nuw nsw i64 %idx, 1
  br label %loop_header

after_loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}