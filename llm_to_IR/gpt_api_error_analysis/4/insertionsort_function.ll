target triple = "x86_64-unknown-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %for.body, label %for.end

for.body:
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j.nonzero = icmp ne i64 %j, 0
  br i1 %j.nonzero, label %while.cmp, label %while.end

while.cmp:
  %jm1 = add i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a_jm1 = load i32, i32* %gep.jm1, align 4
  %key_lt = icmp slt i32 %key, %a_jm1
  br i1 %key_lt, label %while.body, label %while.end

while.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a_jm1, i32* %gep.j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.cmp ]
  %gep.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %gep.final, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:
  ret void
}