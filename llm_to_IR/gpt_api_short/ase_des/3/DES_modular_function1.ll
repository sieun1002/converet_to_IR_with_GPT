; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Extract and pack bits from a 64-bit word according to index array (confidence=0.79). Evidence: shr rdx,cl with cl=(base - arr[i]); acc=(acc<<1)|bit in loop
; Preconditions: arr points to at least n i32s; n >= 0
; Postconditions: returns n-bit value where bit i is taken from (bits >> ((base - arr[i]) & 63)) & 1, packed MSB-first

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i64 @permute(i64 %bits, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %loop.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %done

loop.body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %t = sub i32 %base, %elem
  %t8 = trunc i32 %t to i8
  %t64 = zext i8 %t8 to i64
  %shamt = and i64 %t64, 63
  %shifted = lshr i64 %bits, %shamt
  %bit = and i64 %shifted, 1
  %acc.shl1 = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl1, %bit
  %i.next = add nsw i32 %i, 1
  br label %loop

done:
  ret i64 %acc
}