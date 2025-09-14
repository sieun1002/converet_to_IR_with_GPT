; ModuleID = 'mix_columns.ll'
target triple = "x86_64-unknown-linux-gnu"

declare zeroext i8 @xtime(i32 noundef)

define dso_local void @mix_columns(i8* noundef %state) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %idx0 = mul nuw nsw i32 %i, 4
  %idx1 = add nuw nsw i32 %idx0, 1
  %idx2 = add nuw nsw i32 %idx0, 2
  %idx3 = add nuw nsw i32 %idx0, 3
  %idx0_i64 = sext i32 %idx0 to i64
  %idx1_i64 = sext i32 %idx1 to i64
  %idx2_i64 = sext i32 %idx2 to i64
  %idx3_i64 = sext i32 %idx3 to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0_i64
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1_i64
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2_i64
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3_i64
  %s0 = load i8, i8* %p0, align 1
  %s1 = load i8, i8* %p1, align 1
  %s2 = load i8, i8* %p2, align 1
  %s3 = load i8, i8* %p3, align 1
  %tmp01 = xor i8 %s0, %s1
  %tmp012 = xor i8 %tmp01, %s2
  %total = xor i8 %tmp012, %s3

  %t01_z = zext i8 %tmp01 to i32
  %xt01 = call zeroext i8 @xtime(i32 %t01_z)
  %c0 = xor i8 %xt01, %total
  %new0 = xor i8 %c0, %s0
  store i8 %new0, i8* %p0, align 1

  %t12 = xor i8 %s1, %s2
  %t12_z = zext i8 %t12 to i32
  %xt12 = call zeroext i8 @xtime(i32 %t12_z)
  %c1 = xor i8 %xt12, %total
  %new1 = xor i8 %c1, %s1
  store i8 %new1, i8* %p1, align 1

  %t23 = xor i8 %s2, %s3
  %t23_z = zext i8 %t23 to i32
  %xt23 = call zeroext i8 @xtime(i32 %t23_z)
  %c2 = xor i8 %xt23, %total
  %new2 = xor i8 %c2, %s2
  store i8 %new2, i8* %p2, align 1

  %t30 = xor i8 %s3, %s0
  %t30_z = zext i8 %t30 to i32
  %xt30 = call zeroext i8 @xtime(i32 %t30_z)
  %c3 = xor i8 %xt30, %total
  %new3 = xor i8 %c3, %s3
  store i8 %new3, i8* %p3, align 1

  %i.next = add nuw nsw i32 %i, 1
  %cont = icmp sle i32 %i.next, 3
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}