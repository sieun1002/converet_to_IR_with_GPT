; ModuleID = 'chkstk_ir'
target triple = "x86_64-pc-windows-msvc"

declare i8* @llvm.stacksave() #0

define void @sub_1400028E0(i64 %size) local_unnamed_addr #0 {
entry:
  %sp0 = call i8* @llvm.stacksave()
  %cmp0 = icmp ugt i64 %size, 4096
  br i1 %cmp0, label %loop, label %tail

loop:
  %base_l = phi i8* [ %sp0, %entry ], [ %base_dec, %loop ]
  %sz_l = phi i64 [ %size, %entry ], [ %sz_next, %loop ]
  %base_dec = getelementptr inbounds i8, i8* %base_l, i64 -4096
  %ld = load i8, i8* %base_dec, align 1, volatile
  %or0 = or i8 %ld, 0
  store i8 %or0, i8* %base_dec, align 1, volatile
  %sz_next = sub i64 %sz_l, 4096
  %cmp1 = icmp ugt i64 %sz_next, 4096
  br i1 %cmp1, label %loop, label %tail_from_loop

tail_from_loop:
  %base_after = phi i8* [ %base_dec, %loop ]
  %size_after = phi i64 [ %sz_next, %loop ]
  br label %tail

tail:
  %base_t = phi i8* [ %sp0, %entry ], [ %base_after, %tail_from_loop ]
  %size_t = phi i64 [ %size, %entry ], [ %size_after, %tail_from_loop ]
  %neg = sub i64 0, %size_t
  %final = getelementptr inbounds i8, i8* %base_t, i64 %neg
  %ld2 = load i8, i8* %final, align 1, volatile
  %or1 = or i8 %ld2, 0
  store i8 %or1, i8* %final, align 1, volatile
  ret void
}

attributes #0 = { nounwind }