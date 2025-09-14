; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: linear search for key in int32 array; return index or -1 (confidence=0.98). Evidence: signed i loop over array, compare elements, returns -1 on miss.
; Preconditions: %arr points to at least %n 32-bit elements; %n is interpreted as signed length (typical non-negative).
; Postconditions: Returns the first index i (0-based) where arr[i] == key, else -1.

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %continue
  %i = phi i32 [ 0, %entry ], [ %i.next, %continue ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %ret_notfound

body:                                             ; preds = %loop
  %idxext = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idxext
  %val = load i32, i32* %eltptr, align 4
  %match = icmp eq i32 %val, %key
  br i1 %match, label %ret_found, label %continue

continue:                                         ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

ret_found:                                        ; preds = %body
  ret i32 %i

ret_notfound:                                     ; preds = %loop
  ret i32 -1
}