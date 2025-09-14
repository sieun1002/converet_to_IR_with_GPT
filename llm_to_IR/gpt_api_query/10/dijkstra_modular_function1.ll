; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.header

outer.header:                                      ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.header, label %exit

inner.header:                                      ; preds = %inner.body, %outer.header
  %j = phi i32 [ 0, %outer.header ], [ %j.next, %inner.body ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.latch

inner.body:                                        ; preds = %inner.header
  %i64 = sext i32 %i to i64
  %row_base_elems = mul i64 %i64, 100
  %j64 = sext i32 %j to i64
  %elem_index = add i64 %row_base_elems, %j64
  %ptr = getelementptr i32, i32* %base, i64 %elem_index
  store i32 0, i32* %ptr, align 4
  %j.next = add i32 %j, 1
  br label %inner.header

outer.latch:                                       ; preds = %inner.header
  %i.next = add i32 %i, 1
  br label %outer.header

exit:                                              ; preds = %outer.header
  ret void
}