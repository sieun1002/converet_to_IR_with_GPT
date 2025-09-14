; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr #0 {
entry:
  br label %for.cond

for.cond:                                           ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                           ; preds = %for.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:                                         ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %is_zero = icmp eq i64 %j, 0
  br i1 %is_zero, label %while.end, label %while.cmp

while.cmp:                                          ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %t = load i32, i32* %gep.jm1, align 4
  %cmp.slt = icmp slt i32 %key, %t
  br i1 %cmp.slt, label %while.body, label %while.end

while.body:                                         ; preds = %while.cmp
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %t, i32* %gep.j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                          ; preds = %while.cmp, %while.cond
  %j.end = phi i64 [ %j, %while.cond ], [ %j, %while.cmp ]
  %gep.j.end = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %gep.j.end, align 4
  br label %for.inc

for.inc:                                            ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                            ; preds = %for.cond
  ret void
}

attributes #0 = { nounwind uwtable "frame-pointer"="all" }