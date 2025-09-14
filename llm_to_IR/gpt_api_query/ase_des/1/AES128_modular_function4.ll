; ModuleID = 'add_round_key'
source_filename = "add_round_key.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @add_round_key(i8* %state, i8* %round) {
entry:
  br label %cond

cond:
  %i = phi i64 [ 0, %entry ], [ %next, %body ]
  %cmp = icmp ule i64 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %state_ptr = getelementptr inbounds i8, i8* %state, i64 %i
  %s = load i8, i8* %state_ptr, align 1
  %round_ptr = getelementptr inbounds i8, i8* %round, i64 %i
  %r = load i8, i8* %round_ptr, align 1
  %x = xor i8 %s, %r
  store i8 %x, i8* %state_ptr, align 1
  %next = add nuw nsw i64 %i, 1
  br label %cond

exit:
  ret void
}