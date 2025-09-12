; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                         ; i from 1 to n-1
  %i = phi i64 [ 1, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; key = arr[i]
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:                                       ; while (j > 0 && key < arr[j-1])
  %j = phi i64 [ %i, %for.body ], [ %j.next, %while.body ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %while.end.left, label %check

check:
  %jm1 = add nsw i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %gep.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %while.body, label %while.end.right

while.body:                                       ; arr[j] = arr[j-1]; j--;
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %gep.j, align 4
  %j.next = add i64 %j, -1
  br label %while.cond

while.end.left:
  br label %while.end

while.end.right:
  br label %while.end

while.end:                                        ; arr[j] = key
  %j.end = phi i64 [ %j, %while.end.left ], [ %j, %while.end.right ]
  %gep.dest = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %gep.dest, align 4
  br label %for.inc

for.inc:
  %inc = add nuw i64 %i, 1
  br label %for.cond

for.end:
  ret void
}