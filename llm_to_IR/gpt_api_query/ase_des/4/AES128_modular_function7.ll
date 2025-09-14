; ModuleID = 'mix_columns.ll'
; LLVM 14 IR

declare zeroext i8 @xtime(i8 zeroext)

define void @mix_columns(i8* nocapture %state) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp sle i32 %i, 3
  br i1 %cond, label %loop.body, label %exit

loop.body:
  %i64 = zext i32 %i to i64
  %col_off = mul nuw i64 %i64, 4

  %p0 = getelementptr inbounds i8, i8* %state, i64 %col_off
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3

  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1

  %ab = xor i8 %a, %b
  %abc = xor i8 %ab, %c
  %abcd = xor i8 %abc, %d

  ; out0 = a ^ (xtime(a^b) ^ (a^b^c^d))
  %xt0 = call zeroext i8 @xtime(i8 zeroext %ab)
  %t0 = xor i8 %xt0, %abcd
  %out0 = xor i8 %a, %t0
  store i8 %out0, i8* %p0, align 1

  ; out1 = b ^ (xtime(b^c) ^ (a^b^c^d))
  %bc = xor i8 %b, %c
  %xt1 = call zeroext i8 @xtime(i8 zeroext %bc)
  %t1 = xor i8 %xt1, %abcd
  %out1 = xor i8 %b, %t1
  store i8 %out1, i8* %p1, align 1

  ; out2 = c ^ (xtime(c^d) ^ (a^b^c^d))
  %cd = xor i8 %c, %d
  %xt2 = call zeroext i8 @xtime(i8 zeroext %cd)
  %t2 = xor i8 %xt2, %abcd
  %out2 = xor i8 %c, %t2
  store i8 %out2, i8* %p2, align 1

  ; out3 = d ^ (xtime(d^a) ^ (a^b^c^d))
  %da = xor i8 %d, %a
  %xt3 = call zeroext i8 @xtime(i8 zeroext %da)
  %t3 = xor i8 %xt3, %abcd
  %out3 = xor i8 %d, %t3
  store i8 %out3, i8* %p3, align 1

  %i.next = add nuw nsw i32 %i, 1
  br label %loop.check

exit:
  ret void
}