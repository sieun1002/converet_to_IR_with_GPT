; ModuleID: 'selection_sort_module'
source_filename = "selection_sort.c"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %len) {
entry:
  %len_minus1 = add i32 %len, -1
  br label %for.i.cond

for.i.cond:                                      ; preds = %for.i.end, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %for.i.end ]
  %i_cmp = icmp slt i32 %i, %len_minus1
  br i1 %i_cmp, label %for.j.init, label %exit

for.j.init:                                      ; preds = %for.i.cond
  %j0 = add i32 %i, 1
  br label %for.j.cond

for.j.cond:                                      ; preds = %for.j.body, %for.j.init
  %min.cur = phi i32 [ %i, %for.j.init ], [ %min.next, %for.j.body ]
  %j.cur = phi i32 [ %j0, %for.j.init ], [ %j.next, %for.j.body ]
  %j_cmp = icmp slt i32 %j.cur, %len
  br i1 %j_cmp, label %for.j.body, label %for.j.end

for.j.body:                                      ; preds = %for.j.cond
  %j64 = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %j.val = load i32, i32* %j.ptr, align 4
  %min64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %min.val = load i32, i32* %min.ptr, align 4
  %is_less = icmp slt i32 %j.val, %min.val
  %min.candidate = select i1 %is_less, i32 %j.cur, i32 %min.cur
  %min.next = add i32 %min.candidate, 0
  %j.next = add i32 %j.cur, 1
  br label %for.j.cond

for.j.end:                                       ; preds = %for.j.cond
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %i.val = load i32, i32* %i.ptr, align 4
  %min.end64 = sext i32 %min.cur to i64
  %min.end.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.end64
  %min.end.val = load i32, i32* %min.end.ptr, align 4
  store i32 %min.end.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %min.end.ptr, align 4
  %i.next = add i32 %i, 1
  br label %for.i.cond

exit:                                             ; preds = %for.i.cond
  ret void
}