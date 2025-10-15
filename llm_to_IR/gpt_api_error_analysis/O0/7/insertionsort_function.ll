target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.check

for.check:
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp.for = icmp ult i64 %i.ph, %n
  br i1 %cmp.for, label %for.body, label %for.end

for.body:
  %gep.key = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key = load i32, i32* %gep.key, align 4
  br label %while.check

while.check:
  %j.ph = phi i64 [ %i.ph, %for.body ], [ %j.dec, %while.body ]
  %cond.jgt0 = icmp ugt i64 %j.ph, 0
  br i1 %cond.jgt0, label %cmp.load, label %while.end

cmp.load:
  %j.minus1 = add i64 %j.ph, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %gep.jm1, align 4
  %cmp.lt = icmp slt i32 %key, %val.jm1
  br i1 %cmp.lt, label %while.body, label %while.end

while.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %val.jm1, i32* %gep.j, align 4
  %j.dec = add i64 %j.ph, -1
  br label %while.check

while.end:
  %j.end = phi i64 [ %j.ph, %while.check ], [ %j.ph, %cmp.load ]
  %gep.dest = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %gep.dest, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i.ph, 1
  br label %for.check

for.end:
  ret void
}