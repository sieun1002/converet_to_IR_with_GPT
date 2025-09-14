; ModuleID = 'add_round_key'
source_filename = "binary"

define void @add_round_key(i8* %dst, i8* %src) {
entry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.body:
  %iv = load i32, i32* %i, align 4
  %idx = sext i32 %iv to i64
  %dp = getelementptr inbounds i8, i8* %dst, i64 %idx
  %d = load i8, i8* %dp, align 1
  %sp = getelementptr inbounds i8, i8* %src, i64 %idx
  %s = load i8, i8* %sp, align 1
  %x = xor i8 %d, %s
  store i8 %x, i8* %dp, align 1
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %iv2 = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv2, 15
  br i1 %cmp, label %loop.body, label %exit

exit:
  ret void
}