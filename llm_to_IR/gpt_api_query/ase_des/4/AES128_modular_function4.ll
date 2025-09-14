; ModuleID = 'add_round_key_module'
source_filename = "add_round_key.ll"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_round_key(i8* %state, i8* %roundKey) {
entry:
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %state.ptr = getelementptr inbounds i8, i8* %state, i64 %idx.ext
  %state.val = load i8, i8* %state.ptr, align 1
  %rk.ptr = getelementptr inbounds i8, i8* %roundKey, i64 %idx.ext
  %rk.val = load i8, i8* %rk.ptr, align 1
  %xor = xor i8 %state.val, %rk.val
  store i8 %xor, i8* %state.ptr, align 1
  %inc = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}