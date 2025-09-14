; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns on a 4x4 state (in-place) (confidence=0.98). Evidence: xtime calls and per-column XOR pattern across 4-byte groups.
; Preconditions: %state points to at least 16 bytes; operates on four 4-byte columns in-place.
; Postconditions: %state is transformed by AES MixColumns.

declare i32 @xtime(i32) local_unnamed_addr

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %i4 = mul nuw nsw i32 %i, 4
  %idx0 = zext i32 %i4 to i64
  %idx1.i32 = add nuw nsw i32 %i4, 1
  %idx1 = zext i32 %idx1.i32 to i64
  %idx2.i32 = add nuw nsw i32 %i4, 2
  %idx2 = zext i32 %idx2.i32 to i64
  %idx3.i32 = add nuw nsw i32 %i4, 3
  %idx3 = zext i32 %idx3.i32 to i64

  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3

  %a = load i8, i8* %p0
  %b = load i8, i8* %p1
  %c = load i8, i8* %p2
  %d = load i8, i8* %p3

  %ab = xor i8 %a, %b
  %abc = xor i8 %ab, %c
  %abcd = xor i8 %abc, %d

  ; a' = a ^ xtime(a^b) ^ (a^b^c^d)
  %ab.z = zext i8 %ab to i32
  %xt1.i32 = call i32 @xtime(i32 %ab.z)
  %xt1 = trunc i32 %xt1.i32 to i8
  %t1 = xor i8 %xt1, %abcd
  %na = xor i8 %a, %t1
  store i8 %na, i8* %p0

  ; b' = b ^ xtime(b^c) ^ (a^b^c^d)
  %bc = xor i8 %b, %c
  %bc.z = zext i8 %bc to i32
  %xt2.i32 = call i32 @xtime(i32 %bc.z)
  %xt2 = trunc i32 %xt2.i32 to i8
  %t2 = xor i8 %xt2, %abcd
  %nb = xor i8 %b, %t2
  store i8 %nb, i8* %p1

  ; c' = c ^ xtime(c^d) ^ (a^b^c^d)
  %cd = xor i8 %c, %d
  %cd.z = zext i8 %cd to i32
  %xt3.i32 = call i32 @xtime(i32 %cd.z)
  %xt3 = trunc i32 %xt3.i32 to i8
  %t3 = xor i8 %xt3, %abcd
  %nc = xor i8 %c, %t3
  store i8 %nc, i8* %p2

  ; d' = d ^ xtime(d^a) ^ (a^b^c^d)
  %da = xor i8 %d, %a
  %da.z = zext i8 %da to i32
  %xt4.i32 = call i32 @xtime(i32 %da.z)
  %xt4 = trunc i32 %xt4.i32 to i8
  %t4 = xor i8 %xt4, %abcd
  %nd = xor i8 %d, %t4
  store i8 %nd, i8* %p3

  br label %latch

latch:                                            ; preds = %body
  %inc = add nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}