; ModuleID = 'init_graph.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @init_graph(i32* %a, i32 %n) {
entry:
  br label %outer

outer:                                             ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmpi = icmp slt i32 %i, %n
  br i1 %cmpi, label %inner.preheader, label %exit

inner.preheader:                                   ; preds = %outer
  br label %inner

inner:                                             ; preds = %body, %inner.preheader
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %body ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %body, label %inner.exit

body:                                              ; preds = %inner
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %mul = mul nsw i64 %i64, 100
  %idx = add nsw i64 %mul, %j64
  %ptr = getelementptr inbounds i32, i32* %a, i64 %idx
  store i32 0, i32* %ptr, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner

inner.exit:                                        ; preds = %inner
  br label %outer.latch

outer.latch:                                       ; preds = %inner.exit
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:                                              ; preds = %outer
  ret void
}