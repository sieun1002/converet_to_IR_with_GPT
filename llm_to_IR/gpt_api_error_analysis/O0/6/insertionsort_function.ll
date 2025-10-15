target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.check

for.check:
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp.for = icmp ult i64 %i.ph, %n
  br i1 %cmp.for, label %for.body, label %for.end

for.body:
  %gep.key = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key.load = load i32, i32* %gep.key, align 4
  br label %while.cond

while.cond:
  %j.ph = phi i64 [ %i.ph, %for.body ], [ %j.dec, %while.shift ]
  %j.gt0 = icmp ugt i64 %j.ph, 0
  br i1 %j.gt0, label %while.cmp, label %while.exit

while.cmp:
  %j.minus1 = add i64 %j.ph, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.sgt = icmp sgt i32 %val.jm1, %key.load
  br i1 %cmp.sgt, label %while.shift, label %while.exit

while.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j.ph, -1
  br label %while.cond

while.exit:
  %j.final = phi i64 [ 0, %while.cond ], [ %j.ph, %while.cmp ]
  %ptr.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key.load, i32* %ptr.final, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i.ph, 1
  br label %for.check

for.end:
  ret void
}