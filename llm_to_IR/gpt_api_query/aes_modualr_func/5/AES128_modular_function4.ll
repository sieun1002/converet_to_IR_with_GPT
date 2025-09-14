; ModuleID = 'add_round_key'
source_filename = "add_round_key"
target triple = "x86_64-unknown-linux-gnu"

define void @add_round_key(i8* %dst, i8* %src) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx = sext i32 %i to i64
  %dst.ptr = getelementptr i8, i8* %dst, i64 %idx
  %dst.val = load i8, i8* %dst.ptr, align 1
  %src.ptr = getelementptr i8, i8* %src, i64 %idx
  %src.val = load i8, i8* %src.ptr, align 1
  %xor = xor i8 %dst.val, %src.val
  store i8 %xor, i8* %dst.ptr, align 1
  %inc = add i32 %i, 1
  br label %loop.cond

exit:
  ret void
}