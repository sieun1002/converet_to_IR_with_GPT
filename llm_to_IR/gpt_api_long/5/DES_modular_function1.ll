; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute  ; Address: 0x1189
; Intent: Bit permutation/selection of a 64-bit word using a table of positions and a bit-width (confidence=0.92). Evidence: shift by (width - table[i]) and assemble bits via acc*2 | bit.
; Preconditions: table points to at least n i32s; 0 <= n <= 64; positions are intended 1..width from MSB (DES-style).
; Postconditions: Returns a 64-bit value whose bits are taken from x at positions specified by table, in order.

define dso_local i64 @permute(i64 %x, i32* %table, i32 %n, i32 %width) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %body, label %done

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %table, i64 %idx64
  %val = load i32, i32* %ptr, align 4
  %t = sub i32 %width, %val
  %t64 = sext i32 %t to i64
  %tmask = and i64 %t64, 63
  %shr = lshr i64 %x, %tmask
  %bit = and i64 %shr, 1
  %dbl = add i64 %acc, %acc
  %acc.next = or i64 %dbl, %bit
  %i.next = add i32 %i, 1
  br label %loop

done:                                             ; preds = %loop
  ret i64 %acc
}