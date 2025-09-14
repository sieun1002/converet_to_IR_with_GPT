; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Extract and pack bits from a 64-bit value per an index array (confidence=0.95). Evidence: SHR of RDI by CL from array-derived shift; accumulate acc = (acc<<1)|bit over loop.
; Preconditions: idx points to at least n 32-bit elements. Recommended 0 <= n <= 64; shift amount is masked to 0..63 to match x86 semantics.
; Postconditions: Returns the n-bit value (in the low bits) formed left-to-right from the selected bits.

; Only the needed extern declarations:

define dso_local i64 @permute(i64 %x, i32* %idx, i32 %n, i32 %width) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %i.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %idx, i64 %i.ext
  %v = load i32, i32* %elem.ptr, align 4
  %s = sub i32 %width, %v
  %s.mask = and i32 %s, 63
  %s64 = zext i32 %s.mask to i64
  %shr = lshr i64 %x, %s64
  %bit = and i64 %shr, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i64 %acc
}