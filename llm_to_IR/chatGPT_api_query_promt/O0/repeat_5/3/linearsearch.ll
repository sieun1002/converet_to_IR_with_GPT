; ModuleID = 'linear_search.ll'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* nocapture readonly %arr, i32 %len, i32 %key) {
entry:
  br label %loop

loop:                                             ; preds = %entry, %inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %len
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %ret_found, label %inc

inc:                                              ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

ret_found:                                        ; preds = %body
  ret i32 %i

exit:                                             ; preds = %loop
  ret i32 -1
}