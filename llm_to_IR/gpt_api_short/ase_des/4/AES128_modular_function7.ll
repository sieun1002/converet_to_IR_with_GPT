; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns in-place on a 16-byte state (confidence=0.95). Evidence: 4-byte column ops, xtime() usage pattern
; Preconditions: state points to at least 16 writable bytes
; Postconditions: state[0..15] transformed by AES MixColumns

; Only the necessary external declarations:
declare i8 @xtime(i32)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; i = 0..3
  %i = phi i32 [ 0, %entry ], [ %inc, %body_end ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %idx0.i32 = shl i32 %i, 2
  %idx1.i32 = add i32 %idx0.i32, 1
  %idx2.i32 = add i32 %idx0.i32, 2
  %idx3.i32 = add i32 %idx0.i32, 3
  %idx0 = zext i32 %idx0.i32 to i64
  %idx1 = zext i32 %idx1.i32 to i64
  %idx2 = zext i32 %idx2.i32 to i64
  %idx3 = zext i32 %idx3.i32 to i64

  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3

  %a0 = load i8, i8* %p0, align 1
  %a1 = load i8, i8* %p1, align 1
  %a2 = load i8, i8* %p2, align 1
  %a3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %a0, %a1
  %t012 = xor i8 %t01, %a2
  %s = xor i8 %t012, %a3

  ; new0 = a0 ^ s ^ xtime(a0 ^ a1)
  %t0.z = zext i8 %t01 to i32
  %xt0 = call i8 @xtime(i32 %t0.z)
  %n0.tmp = xor i8 %xt0, %s
  %n0 = xor i8 %n0.tmp, %a0
  store i8 %n0, i8* %p0, align 1

  ; new1 = a1 ^ s ^ xtime(a1 ^ a2)
  %t12 = xor i8 %a1, %a2
  %t1.z = zext i8 %t12 to i32
  %xt1 = call i8 @xtime(i32 %t1.z)
  %n1.tmp = xor i8 %xt1, %s
  %n1 = xor i8 %n1.tmp, %a1
  store i8 %n1, i8* %p1, align 1

  ; new2 = a2 ^ s ^ xtime(a2 ^ a3)
  %t23 = xor i8 %a2, %a3
  %t2.z = zext i8 %t23 to i32
  %xt2 = call i8 @xtime(i32 %t2.z)
  %n2.tmp = xor i8 %xt2, %s
  %n2 = xor i8 %n2.tmp, %a2
  store i8 %n2, i8* %p2, align 1

  ; new3 = a3 ^ s ^ xtime(a3 ^ a0)
  %t30 = xor i8 %a3, %a0
  %t3.z = zext i8 %t30 to i32
  %xt3 = call i8 @xtime(i32 %t3.z)
  %n3.tmp = xor i8 %xt3, %s
  %n3 = xor i8 %n3.tmp, %a3
  store i8 %n3, i8* %p3, align 1

body_end:
  %inc = add i32 %i, 1
  br label %loop

exit:
  ret void
}