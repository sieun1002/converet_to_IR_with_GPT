; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %loop.check

loop.check:                                        ; loc_1400014FC
  %i = phi i64 [ 1, %entry ], [ %i.next, %insert ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %body.setup, label %exit

body.setup:                                         ; loc_14000146D
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  br label %inner.cond

inner.cond:                                         ; loc_1400014BE
  %j = phi i64 [ %i, %body.setup ], [ %j.dec, %shift ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %insert, label %check.key

check.key:                                          ; part of loc_1400014BE
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %shift, label %insert

shift:                                              ; loc_14000148F
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

insert:                                             ; loc_1400014DF
  %ptr.j.insert = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr.j.insert, align 4
  %i.next = add i64 %i, 1
  br label %loop.check

exit:
  ret void
}