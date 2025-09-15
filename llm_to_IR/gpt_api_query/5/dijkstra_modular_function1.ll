; ModuleID = 'init_graph.ll'
source_filename = "init_graph.ll"
target triple = "x86_64-pc-linux-gnu"

; void init_graph(int *graph, int n)
; Sets graph[i*100 + j] = 0 for 0 <= i < n, 0 <= j < n
define void @init_graph(i32* nocapture noundef %graph, i32 noundef %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; i-loop header
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; j-loop header
  %j = phi i32 [ 0, %outer.cond ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %rowIndex = mul nsw i64 %i64, 100             ; 0x190 bytes / 4 bytes = 100 ints per row
  %idx = add nsw i64 %rowIndex, %j64
  %elem.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  store i32 0, i32* %elem.ptr, align 4
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}