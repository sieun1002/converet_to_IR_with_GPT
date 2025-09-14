; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elt.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.next, %while.body ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %while.end, label %while.check

while.check:                                      ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %a_jm1_ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a_jm1 = load i32, i32* %a_jm1_ptr, align 4
  %cmp.slt = icmp slt i32 %key, %a_jm1
  br i1 %cmp.slt, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %a_j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a_jm1, i32* %a_j_ptr, align 4
  %j.next = add i64 %j, -1
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.check ]
  %a_j_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %a_j_ptr2, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}