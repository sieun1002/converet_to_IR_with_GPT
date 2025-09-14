; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns in-place on 16-byte state (confidence=0.95). Evidence: 4-column loop, xtime GF(2^8) calls and XOR combination pattern.
; Preconditions: %state points to at least 16 bytes (4 columns of 4 bytes).
; Postconditions: Applies AES MixColumns to each column of the state.

declare i32 @xtime(i32)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i.mul4 = shl i32 %i, 2
  %idx0 = sext i32 %i.mul4 to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %i.add1 = add i32 %i.mul4, 1
  %idx1 = sext i32 %i.add1 to i64
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %i.add2 = add i32 %i.mul4, 2
  %idx2 = sext i32 %i.add2 to i64
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %i.add3 = add i32 %i.mul4, 3
  %idx3 = sext i32 %i.add3 to i64
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3

  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1

  %ab0 = xor i8 %a, %b
  %abc0 = xor i8 %ab0, %c
  %abcd = xor i8 %abc0, %d

  ; r0
  %ab = xor i8 %a, %b
  %ab.z = zext i8 %ab to i32
  %xt0.i32 = call i32 @xtime(i32 %ab.z)
  %xt0.i8 = trunc i32 %xt0.i32 to i8
  %t0 = xor i8 %xt0.i8, %abcd
  %r0 = xor i8 %a, %t0
  store i8 %r0, i8* %p0, align 1

  ; r1
  %bc = xor i8 %b, %c
  %bc.z = zext i8 %bc to i32
  %xt1.i32 = call i32 @xtime(i32 %bc.z)
  %xt1.i8 = trunc i32 %xt1.i32 to i8
  %t1 = xor i8 %xt1.i8, %abcd
  %r1 = xor i8 %b, %t1
  store i8 %r1, i8* %p1, align 1

  ; r2
  %cd = xor i8 %c, %d
  %cd.z = zext i8 %cd to i32
  %xt2.i32 = call i32 @xtime(i32 %cd.z)
  %xt2.i8 = trunc i32 %xt2.i32 to i8
  %t2 = xor i8 %xt2.i8, %abcd
  %r2 = xor i8 %c, %t2
  store i8 %r2, i8* %p2, align 1

  ; r3
  %da = xor i8 %d, %a
  %da.z = zext i8 %da to i32
  %xt3.i32 = call i32 @xtime(i32 %da.z)
  %xt3.i8 = trunc i32 %xt3.i32 to i8
  %t3 = xor i8 %xt3.i8, %abcd
  %r3 = xor i8 %d, %t3
  store i8 %r3, i8* %p3, align 1

  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i.next = add i32 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}