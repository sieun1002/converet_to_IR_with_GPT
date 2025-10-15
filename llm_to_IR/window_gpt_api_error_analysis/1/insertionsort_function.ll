; ModuleID = 'insertion_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %ret

outer.body:
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %jgt0 = icmp ne i64 %j, 0
  br i1 %jgt0, label %inner.check, label %inner.exit

inner.check:
  %jm1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %jm1.ptr, align 4
  %need_shift = icmp slt i32 %key, %val_jm1
  br i1 %need_shift, label %inner.body, label %inner.exit

inner.body:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.final = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %place.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %place.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:
  ret void
}