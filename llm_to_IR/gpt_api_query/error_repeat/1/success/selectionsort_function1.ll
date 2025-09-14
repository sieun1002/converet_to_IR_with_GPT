; ModuleID = 'selection_sort'
source_filename = "selection_sort.c"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i.val = load i32, i32* %i, align 4
  %nminus = add i32 %n, -1
  %cmpouter = icmp slt i32 %i.val, %nminus
  br i1 %cmpouter, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer.cond
  store i32 %i.val, i32* %min, align 4
  %ip1 = add i32 %i.val, 1
  store i32 %ip1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %no_update, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmpj = icmp slt i32 %j.val, %n
  br i1 %cmpj, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j.idx64 = sext i32 %j.val to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %vj = load i32, i32* %j.ptr, align 4
  %min.val = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.val to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %vmin = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %vj, %vmin
  br i1 %lt, label %update_min, label %no_update

update_min:                                       ; preds = %inner.body
  store i32 %j.val, i32* %min, align 4
  br label %no_update

no_update:                                        ; preds = %update_min, %inner.body
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %i.idx64 = sext i32 %i.val to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %vi = load i32, i32* %i.ptr, align 4
  store i32 %vi, i32* %tmp, align 4
  %min2.val = load i32, i32* %min, align 4
  %min2.idx64 = sext i32 %min2.val to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.idx64
  %vmin2 = load i32, i32* %min2.ptr, align 4
  store i32 %vmin2, i32* %i.ptr, align 4
  %tmpval = load i32, i32* %tmp, align 4
  store i32 %tmpval, i32* %min2.ptr, align 4
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

outer.end:                                        ; preds = %outer.cond
  ret void
}