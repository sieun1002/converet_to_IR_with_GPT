; ModuleID = 'insertion_sort.ll'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* %arr, i64 %len) {
entry:
  br label %for.cond

for.cond:                                           ; preds = %for.latch, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.latch ]
  %cmp.len = icmp ult i64 %i, %len
  br i1 %cmp.len, label %for.body, label %for.end

for.body:                                           ; preds = %for.cond
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                         ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %cond0 = icmp ne i64 %j, 0
  br i1 %cond0, label %check.second, label %while.end

check.second:                                       ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %jm1.val = load i32, i32* %jm1.ptr, align 4
  %cmp = icmp slt i32 %key, %jm1.val
  br i1 %cmp, label %while.body, label %while.end

while.body:                                         ; preds = %check.second
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %jm1.val, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                          ; preds = %check.second, %while.cond
  %store.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %store.ptr, align 4
  br label %for.latch

for.latch:                                          ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                            ; preds = %for.cond
  ret void
}