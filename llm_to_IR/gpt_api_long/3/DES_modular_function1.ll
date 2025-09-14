; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Build a result by concatenating selected bits from x based on positions (base - arr[i]). (confidence=0.85). Evidence: shift-right by (base - arr[i]) & 63, mask bit, accumulate as (res<<1)|bit in a loop.
; Preconditions: arr points to at least n i32 elements.
; Postconditions: Shift count is masked with 63 to model x86 shr semantics.

; Only the needed extern declarations:

define dso_local i64 @permute(i64 %x, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                       ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %res = phi i64 [ 0, %entry ], [ %res.next, %body ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %exit

body:                                              ; preds = %loop.header
  %i.zext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.zext
  %elem = load i32, i32* %elem.ptr, align 4
  %shift32 = sub i32 %base, %elem
  %shift32.mask = and i32 %shift32, 63
  %shift = zext i32 %shift32.mask to i64
  %shifted = lshr i64 %x, %shift
  %bit = and i64 %shifted, 1
  %res.shl = shl i64 %res, 1
  %res.next = or i64 %res.shl, %bit
  %inc = add i32 %i, 1
  br label %loop.header

exit:                                              ; preds = %loop.header
  ret i64 %res
}