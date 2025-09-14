; ModuleID = 'add_round_key.ll'
source_filename = "add_round_key"

define dso_local void @add_round_key(i8* nocapture noundef %state, i8* nocapture noundef %roundkey) #0 {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.body
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ule i64 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %p.state = getelementptr inbounds i8, i8* %state, i64 %i
  %p.key = getelementptr inbounds i8, i8* %roundkey, i64 %i
  %v.state = load i8, i8* %p.state, align 1
  %v.key = load i8, i8* %p.key, align 1
  %v.xor = xor i8 %v.state, %v.key
  store i8 %v.xor, i8* %p.state, align 1
  %inc = add nuw nsw i64 %i, 1
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}

attributes #0 = { nounwind }