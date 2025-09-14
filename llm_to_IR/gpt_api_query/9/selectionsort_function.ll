; ModuleID = 'selection_sort'
source_filename = "selection_sort.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                    ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %ret

outer.body:                                    ; preds = %outer.cond
  %min.init = add i32 %i, 0
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:                                    ; preds = %inner.latch, %outer.body
  %min = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.latch ]
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                    ; preds = %inner.cond
  %j.idx = sext i32 %j to i64
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j.idx
  %valj = load i32, i32* %pj, align 4
  %min.idx = sext i32 %min to i64
  %pmin = getelementptr inbounds i32, i32* %arr, i64 %min.idx
  %valmin = load i32, i32* %pmin, align 4
  %isless = icmp slt i32 %valj, %valmin
  %min.sel = select i1 %isless, i32 %j, i32 %min
  br label %inner.latch

inner.latch:                                   ; preds = %inner.body
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:                                   ; preds = %inner.cond
  %min.out = phi i32 [ %min, %inner.cond ]
  %i.idx = sext i32 %i to i64
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i.idx
  %tmp = load i32, i32* %pi, align 4
  %min.out.idx = sext i32 %min.out to i64
  %pmin.out = getelementptr inbounds i32, i32* %arr, i64 %min.out.idx
  %valmin2 = load i32, i32* %pmin.out, align 4
  store i32 %valmin2, i32* %pi, align 4
  store i32 %tmp, i32* %pmin.out, align 4
  br label %outer.latch

outer.latch:                                   ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.cond

ret:                                           ; preds = %outer.cond
  ret void
}