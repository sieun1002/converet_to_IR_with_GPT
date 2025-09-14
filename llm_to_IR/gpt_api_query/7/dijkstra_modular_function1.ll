; ModuleID = 'init_graph'
source_filename = "init_graph.c"

define dso_local void @init_graph(i32* nocapture %base, i32 %n) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmpi = icmp sge i32 %i, %n
  br i1 %cmpi, label %exit, label %inner.preheader

inner.preheader:                                  ; preds = %outer
  br label %inner

inner:                                            ; preds = %inner.body, %inner.preheader
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %inner.body ]
  %cmpj = icmp sge i32 %j, %n
  br i1 %cmpj, label %outer.latch, label %inner.body

inner.body:                                       ; preds = %inner
  %i.ext = sext i32 %i to i64
  %j.ext = sext i32 %j to i64
  %rowmul = mul nsw i64 %i.ext, 100
  %idx = add nsw i64 %rowmul, %j.ext
  %gep = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 0, i32* %gep, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner

outer.latch:                                      ; preds = %inner
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:                                             ; preds = %outer
  ret void
}