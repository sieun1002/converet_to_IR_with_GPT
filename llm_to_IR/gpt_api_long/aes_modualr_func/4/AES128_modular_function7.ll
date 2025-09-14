; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns in-place on 16-byte state (confidence=0.95). Evidence: xtime calls and XOR of four-byte column groups.
; Preconditions: %state points to at least 16 bytes, mutable.
; Postconditions: %state columns [4*i..4*i+3], i=0..3, are transformed per AES MixColumns.

; Only the needed extern declarations:
declare i8 @xtime(i32) local_unnamed_addr

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %base32 = shl i32 %i, 2
  %base = sext i32 %base32 to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %base
  %base1 = add i64 %base, 1
  %p1 = getelementptr inbounds i8, i8* %state, i64 %base1
  %base2 = add i64 %base, 2
  %p2 = getelementptr inbounds i8, i8* %state, i64 %base2
  %base3 = add i64 %base, 3
  %p3 = getelementptr inbounds i8, i8* %state, i64 %base3

  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1

  %abcdn1 = xor i8 %a, %b
  %abcdn2 = xor i8 %c, %d
  %total = xor i8 %abcdn1, %abcdn2

  ; new a
  %ab = xor i8 %a, %b
  %ab.z = zext i8 %ab to i32
  %t0 = call i8 @xtime(i32 %ab.z)
  %t0t = xor i8 %t0, %total
  %newa = xor i8 %a, %t0t
  store i8 %newa, i8* %p0, align 1

  ; new b
  %bc = xor i8 %b, %c
  %bc.z = zext i8 %bc to i32
  %t1 = call i8 @xtime(i32 %bc.z)
  %t1t = xor i8 %t1, %total
  %newb = xor i8 %b, %t1t
  store i8 %newb, i8* %p1, align 1

  ; new c
  %cd = xor i8 %c, %d
  %cd.z = zext i8 %cd to i32
  %t2 = call i8 @xtime(i32 %cd.z)
  %t2t = xor i8 %t2, %total
  %newc = xor i8 %c, %t2t
  store i8 %newc, i8* %p2, align 1

  ; new d
  %da = xor i8 %d, %a
  %da.z = zext i8 %da to i32
  %t3 = call i8 @xtime(i32 %da.z)
  %t3t = xor i8 %t3, %total
  %newd = xor i8 %d, %t3t
  store i8 %newd, i8* %p3, align 1

  br label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}