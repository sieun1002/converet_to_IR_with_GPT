; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Build a 64-bit value by concatenating bits from %x at positions (base - arr[i]) for i=0..n-1 (MSB-first). (confidence=0.83). Evidence: shift by (base - arr[i]), mask with 1, left-shift accumulator and OR.
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: Returns the constructed 64-bit value.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @permute(i64 %x, i32* %arr, i32 %n, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.new, %body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %done

body:
  %i64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %elem = load i32, i32* %elem.ptr, align 4
  %diff = sub i32 %base, %elem
  %shamt6 = and i32 %diff, 63
  %shamt64 = zext i32 %shamt6 to i64
  %shifted = lshr i64 %x, %shamt64
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.new = or i64 %acc.shl, %bit
  %inc = add i32 %i, 1
  br label %loop

done:
  ret i64 %acc
}