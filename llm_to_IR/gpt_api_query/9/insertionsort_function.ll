; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.c"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                          ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                          ; preds = %for.cond
  %arr.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %arr.i.ptr, align 4
  br label %while.cond

while.cond:                                        ; preds = %while.shift, %for.body
  %j.phi = phi i64 [ %i, %for.body ], [ %j.dec, %while.shift ]
  %j.nonzero = icmp ne i64 %j.phi, 0
  br i1 %j.nonzero, label %while.test, label %while.end

while.test:                                        ; preds = %while.cond
  %jminus1 = add nsw i64 %j.phi, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key_lt = icmp slt i32 %key, %val.jm1
  br i1 %key_lt, label %while.shift, label %while.end

while.shift:                                       ; preds = %while.test
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.phi
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add nsw i64 %j.phi, -1
  br label %while.cond

while.end:                                         ; preds = %while.test, %while.cond
  %j.final = phi i64 [ %j.phi, %while.cond ], [ %j.phi, %while.test ]
  %ptr.out = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ptr.out, align 4
  br label %for.inc

for.inc:                                           ; preds = %while.end
  %i.next = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:                                           ; preds = %for.cond
  ret void
}