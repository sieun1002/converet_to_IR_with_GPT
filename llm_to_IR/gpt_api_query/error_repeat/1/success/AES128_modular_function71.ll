; ModuleID = 'aes_mix_columns'
source_filename = "aes_mix_columns"

declare i8 @xtime(i32)

define void @mix_columns(i8* %state) {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %base = mul nsw i32 %i, 4
  %idx0.i64 = sext i32 %base to i64
  %idx1.i32 = add i32 %base, 1
  %idx1.i64 = sext i32 %idx1.i32 to i64
  %idx2.i32 = add i32 %base, 2
  %idx2.i64 = sext i32 %idx2.i32 to i64
  %idx3.i32 = add i32 %base, 3
  %idx3.i64 = sext i32 %idx3.i32 to i64

  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0.i64
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1.i64
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2.i64
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3.i64

  %a0 = load i8, i8* %p0, align 1
  %a1 = load i8, i8* %p1, align 1
  %a2 = load i8, i8* %p2, align 1
  %a3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %a0, %a1
  %t12 = xor i8 %a1, %a2
  %t23 = xor i8 %a2, %a3
  %t30 = xor i8 %a3, %a0

  %sum0 = xor i8 %a0, %a1
  %sum1 = xor i8 %sum0, %a2
  %sum = xor i8 %sum1, %a3

  %t01.z = zext i8 %t01 to i32
  %xt01 = call i8 @xtime(i32 %t01.z)
  %b0.tmp = xor i8 %xt01, %sum
  %b0 = xor i8 %a0, %b0.tmp
  store i8 %b0, i8* %p0, align 1

  %t12.z = zext i8 %t12 to i32
  %xt12 = call i8 @xtime(i32 %t12.z)
  %b1.tmp = xor i8 %xt12, %sum
  %b1 = xor i8 %a1, %b1.tmp
  store i8 %b1, i8* %p1, align 1

  %t23.z = zext i8 %t23 to i32
  %xt23 = call i8 @xtime(i32 %t23.z)
  %b2.tmp = xor i8 %xt23, %sum
  %b2 = xor i8 %a2, %b2.tmp
  store i8 %b2, i8* %p2, align 1

  %t30.z = zext i8 %t30 to i32
  %xt30 = call i8 @xtime(i32 %t30.z)
  %b3.tmp = xor i8 %xt30, %sum
  %b3 = xor i8 %a3, %b3.tmp
  store i8 %b3, i8* %p3, align 1

  br label %latch

latch:
  %inc = add nsw i32 %i, 1
  br label %cond

exit:
  ret void
}