; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Build a 64-bit value by extracting bits from an input word at positions (base - arr[i]) and appending them (confidence=0.90). Evidence: shift by (base - array[i]) and accumulate with (result << 1) | bit.
; Preconditions: arr points to at least n 32-bit integers; n is treated as signed (negative -> zero iterations).

define dso_local i64 @permute(i64 %value, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %sh.tmp = sub i32 %base, %elem
  %sh.mask6 = and i32 %sh.tmp, 63
  %shamt = zext i32 %sh.mask6 to i64
  %shifted = lshr i64 %value, %shamt
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i64 %acc
}