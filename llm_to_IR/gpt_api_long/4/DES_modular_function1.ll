; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Select/pack bits from a 64-bit source using indices (bit at position base - arr[i]) into a 64-bit result, left-to-right (confidence=0.90). Evidence: SHR by variable CL from RDI; accumulator updated as (acc<<1)|bit.
; Preconditions: arr points to at least n 32-bit elements.

; Only the needed extern declarations:

define dso_local i64 @permute(i64 %bits, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body_end ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body_end ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = zext i32 %i to i64
  %p = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %val = load i32, i32* %p, align 4
  %t = sub i32 %base, %val
  %mask = and i32 %t, 63
  %mask64 = zext i32 %mask to i64
  %shifted = lshr i64 %bits, %mask64
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add i32 %i, 1
  br label %body_end

body_end:
  br label %loop

exit:
  ret i64 %acc
}