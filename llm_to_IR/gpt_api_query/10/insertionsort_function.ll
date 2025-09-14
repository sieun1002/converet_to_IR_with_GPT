; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr #0 {
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
  %j.notzero = icmp ne i64 %j, 0
  br i1 %j.notzero, label %while.check, label %while.end

while.check:                                       ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %a_jm1_ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a_jm1 = load i32, i32* %a_jm1_ptr, align 4
  %cmp2 = icmp slt i32 %key, %a_jm1
  br i1 %cmp2, label %while.body, label %while.end

while.body:                                        ; preds = %while.check
  %a_j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a_jm1, i32* %a_j_ptr, align 4
  %j.next = add i64 %j, -1
  br label %while.cond

while.end:                                         ; preds = %while.check, %while.cond
  %j.exit = phi i64 [ %j, %while.cond ], [ %j, %while.check ]
  %dstptr = getelementptr inbounds i32, i32* %arr, i64 %j.exit
  store i32 %key, i32* %dstptr, align 4
  br label %for.inc

for.inc:                                           ; preds = %while.end
  %inc = add i64 %i, 1
  br label %for.cond

for.end:                                           ; preds = %for.cond
  ret void
}

attributes #0 = { nounwind uwtable }