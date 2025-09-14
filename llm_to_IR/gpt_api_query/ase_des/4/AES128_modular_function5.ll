; ModuleID = '_sub_bytes.ll'
target triple = "x86_64-pc-linux-gnu"

declare i8 @sbox_lookup(i32)

define void @_sub_bytes(i8* %buf) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp sle i32 %i, 15
  br i1 %cond, label %loop.body, label %exit

loop.body:
  %idx.ext = zext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %idx.ext
  %val = load i8, i8* %ptr, align 1
  %val.z = zext i8 %val to i32
  %res = call i8 @sbox_lookup(i32 %val.z)
  store i8 %res, i8* %ptr, align 1
  %i.next = add i32 %i, 1
  br label %loop.header

exit:
  ret void
}