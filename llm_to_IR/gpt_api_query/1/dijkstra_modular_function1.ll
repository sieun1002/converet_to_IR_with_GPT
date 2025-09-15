; ModuleID = 'init_graph'
source_filename = "init_graph.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @init_graph(i32* nocapture %base, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  store i32 0, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.body, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmp2 = icmp slt i32 %j.val, %n
  br i1 %cmp2, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %ival = load i32, i32* %i, align 4
  %i64 = sext i32 %ival to i64
  %j64 = sext i32 %j.val to i64
  %row = mul nsw i64 %i64, 100
  %offset = add nsw i64 %row, %j64
  %ptr = getelementptr inbounds i32, i32* %base, i64 %offset
  store i32 0, i32* %ptr, align 4
  %incj = add nsw i32 %j.val, 1
  store i32 %incj, i32* %j, align 4
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %ival2 = load i32, i32* %i, align 4
  %inci = add nsw i32 %ival2, 1
  store i32 %inci, i32* %i, align 4
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}