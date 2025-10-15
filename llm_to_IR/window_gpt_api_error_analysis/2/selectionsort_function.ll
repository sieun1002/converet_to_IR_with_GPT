; ModuleID = 'selection_sort_module'
source_filename = "selection_sort.c"
target triple = "x86_64-pc-windows-msvc"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i.val = load i32, i32* %i, align 4
  %nminus1 = add i32 %n, -1
  %cmp = icmp slt i32 %i.val, %nminus1
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  store i32 %i.val, i32* %min, align 4
  %i.plus1 = add i32 %i.val, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %no.update, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmpj = icmp slt i32 %j.val, %n
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %j64 = sext i32 %j.val to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %aj = load i32, i32* %pj, align 4
  %min.val = load i32, i32* %min, align 4
  %min64 = sext i32 %min.val to i64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %amin = load i32, i32* %pmin, align 4
  %less = icmp slt i32 %aj, %amin
  br i1 %less, label %update.min, label %no.update

update.min:                                       ; preds = %inner.body
  store i32 %j.val, i32* %min, align 4
  br label %no.update

no.update:                                        ; preds = %update.min, %inner.body
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i64 = sext i32 %i.val to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i64
  %ai = load i32, i32* %pi, align 4
  store i32 %ai, i32* %tmp, align 4
  %min2 = load i32, i32* %min, align 4
  %min64b = sext i32 %min2 to i64
  %pmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %amin2 = load i32, i32* %pmin2, align 4
  store i32 %amin2, i32* %pi, align 4
  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %pmin2, align 4
  %i.inc = add i32 %i.val, 1
  store i32 %i.inc, i32* %i, align 4
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}