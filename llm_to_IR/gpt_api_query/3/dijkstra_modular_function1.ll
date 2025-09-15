; ModuleID = 'init_graph.ll'
source_filename = "init_graph.c"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @init_graph(i32* nocapture %base, i32 %n) local_unnamed_addr #0 {
entry:
  br label %outer

outer:                                            ; preds = %inner.exit, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inner.exit ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %inner.preheader, label %exit

inner.preheader:                                  ; preds = %outer
  %row_off_i32 = mul i32 %i, 400
  %row_off = sext i32 %row_off_i32 to i64
  %base_i8 = bitcast i32* %base to i8*
  %row_ptr_i8 = getelementptr inbounds i8, i8* %base_i8, i64 %row_off
  %row_ptr = bitcast i8* %row_ptr_i8 to i32*
  br label %inner

inner:                                            ; preds = %store, %inner.preheader
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %store ]
  %jcmp = icmp slt i32 %j, %n
  br i1 %jcmp, label %store, label %inner.exit

store:                                            ; preds = %inner
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr, i64 %j64
  store i32 0, i32* %elem_ptr
  %j.next = add nsw i32 %j, 1
  br label %inner

inner.exit:                                       ; preds = %inner
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:                                             ; preds = %outer
  ret void
}

attributes #0 = { nounwind uwtable mustprogress "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }