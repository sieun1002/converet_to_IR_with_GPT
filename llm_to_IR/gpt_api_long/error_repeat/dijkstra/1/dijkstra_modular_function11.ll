; ModuleID = 'init_graph'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: init_graph  ; Address: 0x401130
; Intent: Zero the top-left n x n block of a row-major i32 adjacency matrix with row stride 100 (confidence=0.90). Evidence: nested loops with jge bounds; row offset 0x190 bytes (100 i32) and dword stores of 0.
; Preconditions: matrix points to a buffer laid out as rows of 100 i32 elements; n >= 0 and n <= 100 to avoid out-of-bounds.
; Postconditions: For 0 <= i,j < n, matrix[i*100 + j] == 0; other elements unchanged.

define dso_local void @init_graph(i32* %matrix, i32 %n) local_unnamed_addr {
entry:
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp sge i32 %i, %n
  br i1 %cmp.i, label %exit, label %inner.prep

inner.prep:                                       ; preds = %outer.loop
  %i64 = sext i32 %i to i64
  %row.off = mul i64 %i64, 100
  %row.ptr = getelementptr i32, i32* %matrix, i64 %row.off
  br label %inner.loop

inner.loop:                                       ; preds = %inner.body, %inner.prep
  %j = phi i32 [ 0, %inner.prep ], [ %j.next, %inner.body ]
  %cmp.j = icmp sge i32 %j, %n
  br i1 %cmp.j, label %outer.inc, label %inner.body

inner.body:                                       ; preds = %inner.loop
  %j64 = sext i32 %j to i64
  %elt.ptr = getelementptr i32, i32* %row.ptr, i64 %j64
  store i32 0, i32* %elt.ptr
  %j.next = add i32 %j, 1
  br label %inner.loop

outer.inc:                                        ; preds = %inner.loop
  %i.next = add i32 %i, 1
  br label %outer.loop

exit:                                             ; preds = %outer.loop
  ret void
}