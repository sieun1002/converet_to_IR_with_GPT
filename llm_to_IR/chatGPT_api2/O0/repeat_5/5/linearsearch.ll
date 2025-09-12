; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: linear_search  ; Address: 0x1189
; Intent: Linear search in an int32 array; return index or -1 if not found (confidence=0.98). Evidence: element access via index*4, compare to key, return index/-1.
; Preconditions: %arr points to at least %n consecutive i32 elements; %n >= 0.
; Postconditions: Returns index in [0, %n) if %key found; otherwise returns -1.

define dso_local i32 @linear_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp.loop = icmp slt i32 %i, %n
  br i1 %cmp.loop, label %body, label %not_found

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elt = load i32, i32* %elt.ptr, align 4
  %eq = icmp eq i32 %elt, %key
  br i1 %eq, label %found, label %inc

inc:                                              ; preds = %body
  %i.next = add i32 %i, 1
  br label %loop

found:                                            ; preds = %body
  ret i32 %i

not_found:                                        ; preds = %loop
  ret i32 -1
}