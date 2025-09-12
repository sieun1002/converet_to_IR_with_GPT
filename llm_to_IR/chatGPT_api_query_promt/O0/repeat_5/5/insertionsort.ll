; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.c"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %tmp = load i32, i32* %idxptr, align 4
  %j.init = %i
  br label %while.cond

while.cond:
  %j = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %zero = icmp eq i64 %j, 0
  br i1 %zero, label %insert, label %check

check:
  %jminus1 = add i64 %j, -1
  %ptrjm1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %valjm1 = load i32, i32* %ptrjm1, align 4
  %cmpjl = icmp slt i32 %tmp, %valjm1
  br i1 %cmpjl, label %while.body, label %insert

while.body:
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %valjm1, i32* %ptrj, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

insert:
  %ptr.ins = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %tmp, i32* %ptr.ins, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:
  ret void
}