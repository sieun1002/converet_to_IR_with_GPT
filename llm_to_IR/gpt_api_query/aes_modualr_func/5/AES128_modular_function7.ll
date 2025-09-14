; ModuleID = 'mix_columns'
source_filename = "mix_columns"

declare i8 @xtime(i8 zeroext)

define void @mix_columns(i8* nocapture %state) {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %i.zext = zext i32 %i to i64
  %base = shl nuw nsw i64 %i.zext, 2
  %p0 = getelementptr inbounds i8, i8* %state, i64 %base
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3

  %b0 = load i8, i8* %p0, align 1
  %b1 = load i8, i8* %p1, align 1
  %b2 = load i8, i8* %p2, align 1
  %b3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %b0, %b1
  %t23 = xor i8 %b2, %b3
  %sum = xor i8 %t01, %t23

  ; new b0 = xtime(b0 ^ b1) ^ (b0 ^ b1 ^ b2 ^ b3) ^ b0
  %x01 = call i8 @xtime(i8 zeroext %t01)
  %tmp0 = xor i8 %x01, %sum
  %new0 = xor i8 %tmp0, %b0
  store i8 %new0, i8* %p0, align 1

  ; new b1 = xtime(b1 ^ b2) ^ (b0 ^ b1 ^ b2 ^ b3) ^ b1
  %t12 = xor i8 %b1, %b2
  %x12 = call i8 @xtime(i8 zeroext %t12)
  %tmp1 = xor i8 %x12, %sum
  %new1 = xor i8 %tmp1, %b1
  store i8 %new1, i8* %p1, align 1

  ; new b2 = xtime(b2 ^ b3) ^ (b0 ^ b1 ^ b2 ^ b3) ^ b2
  %t23b = xor i8 %b2, %b3
  %x23 = call i8 @xtime(i8 zeroext %t23b)
  %tmp2 = xor i8 %x23, %sum
  %new2 = xor i8 %tmp2, %b2
  store i8 %new2, i8* %p2, align 1

  ; new b3 = xtime(b3 ^ b0) ^ (b0 ^ b1 ^ b2 ^ b3) ^ b3
  %t30 = xor i8 %b3, %b0
  %x30 = call i8 @xtime(i8 zeroext %t30)
  %tmp3 = xor i8 %x30, %sum
  %new3 = xor i8 %tmp3, %b3
  store i8 %new3, i8* %p3, align 1

  %i.next = add nuw nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}