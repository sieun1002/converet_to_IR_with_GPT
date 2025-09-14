; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns in-place on 4 columns (16 bytes) (confidence=0.94). Evidence: 4-iteration loop, xtime on adjacent-byte xors and total xor, in-place column updates.
; Preconditions: state points to at least 16 bytes.
; Postconditions: Applies AES MixColumns transformation to state.

; Only the necessary external declarations:
declare zeroext i8 @xtime(i8)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx0_32 = shl i32 %i, 2
  %idx1_32 = add i32 %idx0_32, 1
  %idx2_32 = add i32 %idx0_32, 2
  %idx3_32 = add i32 %idx0_32, 3
  %idx0 = zext i32 %idx0_32 to i64
  %idx1 = zext i32 %idx1_32 to i64
  %idx2 = zext i32 %idx2_32 to i64
  %idx3 = zext i32 %idx3_32 to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3
  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1
  %sum1 = xor i8 %a, %b
  %sum2 = xor i8 %sum1, %c
  %sum = xor i8 %sum2, %d
  ; new a
  %ab = xor i8 %a, %b
  %xt_ab = call zeroext i8 @xtime(i8 %ab)
  %t0 = xor i8 %xt_ab, %sum
  %newa = xor i8 %a, %t0
  store i8 %newa, i8* %p0, align 1
  ; new b
  %bc = xor i8 %b, %c
  %xt_bc = call zeroext i8 @xtime(i8 %bc)
  %t1 = xor i8 %xt_bc, %sum
  %newb = xor i8 %b, %t1
  store i8 %newb, i8* %p1, align 1
  ; new c
  %cd = xor i8 %c, %d
  %xt_cd = call zeroext i8 @xtime(i8 %cd)
  %t2 = xor i8 %xt_cd, %sum
  %newc = xor i8 %c, %t2
  store i8 %newc, i8* %p2, align 1
  ; new d
  %da = xor i8 %d, %a
  %xt_da = call zeroext i8 @xtime(i8 %da)
  %t3 = xor i8 %xt_da, %sum
  %newd = xor i8 %d, %t3
  store i8 %newd, i8* %p3, align 1
  br label %inc

inc:                                              ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}