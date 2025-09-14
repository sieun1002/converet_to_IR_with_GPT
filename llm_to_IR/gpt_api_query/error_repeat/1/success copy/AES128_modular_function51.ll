; ModuleID = 'sub_bytes'
source_filename = "sub_bytes"

target triple = "x86_64-unknown-linux-gnu"

declare i8 @sbox_lookup(i32)

define void @_sub_bytes(i8* %buf) {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = zext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %idx64
  %val = load i8, i8* %ptr, align 1
  %val32 = zext i8 %val to i32
  %res = call i8 @sbox_lookup(i32 %val32)
  store i8 %res, i8* %ptr, align 1
  %inc = add nuw nsw i32 %i, 1
  br label %cond

exit:
  ret void
}