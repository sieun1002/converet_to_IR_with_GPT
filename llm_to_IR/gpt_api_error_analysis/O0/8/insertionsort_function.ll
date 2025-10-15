; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val = load i32, i32* %gep.i, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %jgt0 = icmp ne i64 %j, 0
  br i1 %jgt0, label %inner.cmp, label %insert

inner.cmp:
  %jminus1 = add i64 %j, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %a.jm1 = load i32, i32* %gep.jm1, align 4
  %lt = icmp slt i32 %val, %a.jm1
  br i1 %lt, label %inner.body, label %insert

inner.body:
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a.jm1, i32* %gep.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

insert:
  %gep.j.ins = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val, i32* %gep.j.ins, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}