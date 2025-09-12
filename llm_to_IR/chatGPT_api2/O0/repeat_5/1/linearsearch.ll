; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: linear search for target in int32 array; return index or -1 (confidence=0.98). Evidence: loop over arr[i] with i*4 stride; compare to target and return index.
; Preconditions: arr points to at least n elements if n > 0; n >= 0 for meaningful search.
; Postconditions: Returns index of first match in [0, n), or -1 if not found.

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %cont
  %i = phi i32 [ 0, %entry ], [ %inc, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %notfound

body:                                             ; preds = %loop
  %i64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %target
  br i1 %eq, label %found, label %cont

cont:                                             ; preds = %body
  %inc = add nsw i32 %i, 1
  br label %loop

found:                                            ; preds = %body
  ret i32 %i

notfound:                                         ; preds = %loop
  ret i32 -1
}