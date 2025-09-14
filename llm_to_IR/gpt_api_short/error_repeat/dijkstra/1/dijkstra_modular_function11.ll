; ModuleID = 'init_graph'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: init_graph ; Address: 0x401130
; Intent: Zero-initialize an n x n int matrix with row stride of 100 ints (400 bytes) (confidence=0.92). Evidence: row stride 0x190 bytes; dword stores with [rowBase + col*4].
; Preconditions: graph points to at least n*100 ints (n >= 0).
; Postconditions: For 0 <= i < n and 0 <= j < n, graph[i*100 + j] == 0.

; Only the necessary external declarations:

define dso_local void @init_graph(i32* %graph, i32 %n) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %cmp.i = icmp sge i32 %i, %n
  br i1 %cmp.i, label %exit, label %inner.preheader

inner.preheader:                                  ; preds = %outer
  br label %inner

inner:                                            ; preds = %store, %inner.preheader
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %store ]
  %cmp.j = icmp sge i32 %j, %n
  br i1 %cmp.j, label %outer.latch, label %store

store:                                            ; preds = %inner
  %i64 = sext i32 %i to i64
  %j64 = sext i32 %j to i64
  %row.off = mul nsw i64 %i64, 100
  %elem.off = add nsw i64 %row.off, %j64
  %ptr = getelementptr inbounds i32, i32* %graph, i64 %elem.off
  store i32 0, i32* %ptr, align 4
  %j.next = add nsw i32 %j, 1
  br label %inner

outer.latch:                                      ; preds = %inner
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:                                             ; preds = %outer
  ret void
}