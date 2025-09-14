; External: xtime multiplies by x (2) in GF(2^8), returns i8 in AL/EAX
declare zeroext i8 @xtime(i32 noundef) local_unnamed_addr

define dso_local void @mix_columns(i8* noundef %state) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %idx0 = mul nuw nsw i32 %i, 4
  %p0 = getelementptr inbounds i8, i8* %state, i32 %idx0
  %idx1 = add nuw nsw i32 %idx0, 1
  %p1 = getelementptr inbounds i8, i8* %state, i32 %idx1
  %idx2 = add nuw nsw i32 %idx0, 2
  %p2 = getelementptr inbounds i8, i8* %state, i32 %idx2
  %idx3 = add nuw nsw i32 %idx0, 3
  %p3 = getelementptr inbounds i8, i8* %state, i32 %idx3

  %x0 = load i8, i8* %p0, align 1
  %x1 = load i8, i8* %p1, align 1
  %x2 = load i8, i8* %p2, align 1
  %x3 = load i8, i8* %p3, align 1

  %s01 = xor i8 %x0, %x1
  %s23 = xor i8 %x2, %x3
  %sum = xor i8 %s01, %s23

  ; out0
  %t0in = zext i8 %s01 to i32
  %t0 = call zeroext i8 @xtime(i32 %t0in)
  %t0e = xor i8 %t0, %sum
  %y0 = xor i8 %x0, %t0e
  store i8 %y0, i8* %p0, align 1

  ; out1
  %s12 = xor i8 %x1, %x2
  %t1in = zext i8 %s12 to i32
  %t1 = call zeroext i8 @xtime(i32 %t1in)
  %t1e = xor i8 %t1, %sum
  %y1 = xor i8 %x1, %t1e
  store i8 %y1, i8* %p1, align 1

  ; out2
  %s23b = xor i8 %x2, %x3
  %t2in = zext i8 %s23b to i32
  %t2 = call zeroext i8 @xtime(i32 %t2in)
  %t2e = xor i8 %t2, %sum
  %y2 = xor i8 %x2, %t2e
  store i8 %y2, i8* %p2, align 1

  ; out3
  %s30 = xor i8 %x3, %x0
  %t3in = zext i8 %s30 to i32
  %t3 = call zeroext i8 @xtime(i32 %t3in)
  %t3e = xor i8 %t3, %sum
  %y3 = xor i8 %x3, %t3e
  store i8 %y3, i8* %p3, align 1

  br label %latch

latch:                                            ; preds = %body
  %inc = add nuw nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}