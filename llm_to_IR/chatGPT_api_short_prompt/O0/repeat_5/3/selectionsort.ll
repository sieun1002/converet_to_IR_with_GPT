; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort on an int32 array (confidence=0.99). Evidence: nested i/j loops updating min index; swap of a[i] and a[min].
; Preconditions: arr points to at least n 32-bit integers (n may be <= 1).
; Postconditions: Array segment arr[0..n-1] sorted in non-decreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %loop_i

loop_i:                                           ; i loop header
  %i = phi i32 [ 0, %entry ], [ %i.next, %after_j ]
  %n.minus1 = add nsw i32 %n, -1
  %i.cond = icmp slt i32 %i, %n.minus1
  br i1 %i.cond, label %pre_j, label %ret

pre_j:                                            ; init min and j
  %min.init = %i
  %j.init = add nsw i32 %i, 1
  br label %loop_j

loop_j:                                           ; j loop header
  %min = phi i32 [ %min.init, %pre_j ], [ %min.new, %loop_j_latch ]
  %j = phi i32 [ %j.init, %pre_j ], [ %j.next, %loop_j_latch ]
  %j.cond = icmp slt i32 %j, %n
  br i1 %j.cond, label %body_j, label %after_j

body_j:                                           ; compare and maybe update min
  %j64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %a.j = load i32, i32* %j.ptr, align 4
  %min64 = sext i32 %min to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %a.min = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %a.j, %a.min
  %min.sel = select i1 %is.less, i32 %j, i32 %min
  br label %loop_j_latch

loop_j_latch:
  %min.new = phi i32 [ %min.sel, %body_j ]
  %j.next = add nsw i32 %j, 1
  br label %loop_j

after_j:                                          ; swap a[i] and a[min]
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %a.i = load i32, i32* %i.ptr, align 4
  %min64.2 = sext i32 %min to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min64.2
  %a.min2 = load i32, i32* %min.ptr2, align 4
  store i32 %a.min2, i32* %i.ptr, align 4
  store i32 %a.i, i32* %min.ptr2, align 4
  %i.next = add nsw i32 %i, 1
  br label %loop_i

ret:
  ret void
}