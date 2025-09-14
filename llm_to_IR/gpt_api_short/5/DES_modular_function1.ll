; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Build a 64-bit result by selecting bits from x at positions (w - arr[i]) and appending them left-to-right (bit permutation). Evidence: shr x by (w - arr[i]); result = (result << 1) | bit
; Preconditions: arr points to at least n 32-bit integers; typical use expects 0 <= (w - arr[i]) < 64
; Postconditions: Returns a 64-bit value formed by concatenating the selected bits

; Only the necessary external declarations:

define dso_local i64 @permute(i64 %x, i32* %arr, i32 %n, i32 %w) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %res = phi i64 [ 0, %entry ], [ %res.next, %body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %pos = load i32, i32* %ptr, align 4
  %diff = sub i32 %w, %pos
  %diff64 = zext i32 %diff to i64
  %amt = and i64 %diff64, 63
  %shifted = lshr i64 %x, %amt
  %bit = and i64 %shifted, 1
  %res_shl = shl i64 %res, 1
  %res.next = or i64 %res_shl, %bit
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret i64 %res
}