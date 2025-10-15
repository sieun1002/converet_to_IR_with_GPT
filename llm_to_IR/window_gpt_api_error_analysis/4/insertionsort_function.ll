; ModuleID = 'insertion_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                        ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                        ; preds = %for.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  %j.init = add i64 %i, 0
  br label %while.cond

while.cond:                                      ; preds = %while.body, %for.body
  %j = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %while.end, label %check

check:                                           ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %prev = load i32, i32* %prev.ptr, align 4
  %lt = icmp slt i32 %key, %prev
  br i1 %lt, label %while.body, label %while.end

while.body:                                      ; preds = %check
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                       ; preds = %check, %while.cond
  %j.end = phi i64 [ %j, %while.cond ], [ %j, %check ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:                                         ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                         ; preds = %for.cond
  ret void
}