; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Build a 64-bit value by extracting bits from mask per index array and accumulating (confidence=0.88). Evidence: shift by (base - arr[i]) and fold via (res<<1)|bit.
; Preconditions: arr points to at least n 32-bit integers; n is treated as signed. Shift count uses only the low 6 bits (x86 SHR semantics).

define dso_local i64 @permute(i64 %mask, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %res = phi i64 [ 0, %entry ], [ %res.next, %body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %diff = sub i32 %base, %elem
  %cnt6 = and i32 %diff, 63
  %cnt64 = zext i32 %cnt6 to i64
  %shifted = lshr i64 %mask, %cnt64
  %bit = and i64 %shifted, 1
  %res.shl = shl i64 %res, 1
  %res.next = or i64 %res.shl, %bit
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i64 %res
}