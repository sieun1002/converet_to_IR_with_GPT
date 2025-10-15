; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                          ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                          ; preds = %for.cond
  %keyptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %keyptr, align 4
  br label %while.cond

while.cond:                                        ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.next, %while.body ]
  %j_gt0 = icmp sgt i64 %j, 0
  br i1 %j_gt0, label %while.cmp, label %while.end

while.cmp:                                         ; preds = %while.cond
  %jminus1 = add nsw i64 %j, -1
  %prevptr = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %prev = load i32, i32* %prevptr, align 4
  %gt = icmp sgt i32 %prev, %key
  br i1 %gt, label %while.body, label %while.end

while.body:                                        ; preds = %while.cmp
  %destptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %destptr, align 4
  %j.next = add nsw i64 %j, -1
  br label %while.cond

while.end:                                         ; preds = %while.cmp, %while.cond
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.cmp ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:                                           ; preds = %while.end
  %inc = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:                                           ; preds = %for.cond
  ret void
}