target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i8* %base, i64 %size) nounwind {
entry:
  %cmp_ge = icmp uge i64 %size, 4096
  br i1 %cmp_ge, label %loop, label %tail

loop:
  %rcx_prev = phi i8* [ %base, %entry ], [ %rcx_next, %loop ]
  %rem_prev = phi i64 [ %size, %entry ], [ %rem_sub, %loop ]
  %rcx_next = getelementptr i8, i8* %rcx_prev, i64 -4096
  %ptr_loop = bitcast i8* %rcx_next to i64*
  %val_loop = load volatile i64, i64* %ptr_loop, align 1
  %or_loop = or i64 %val_loop, 0
  store volatile i64 %or_loop, i64* %ptr_loop, align 1
  %rem_sub = sub i64 %rem_prev, 4096
  %cmp_gt = icmp ugt i64 %rem_sub, 4096
  br i1 %cmp_gt, label %loop, label %tail

tail:
  %rcx_in = phi i8* [ %base, %entry ], [ %rcx_next, %loop ]
  %rem_in = phi i64 [ %size, %entry ], [ %rem_sub, %loop ]
  %negrem = sub i64 0, %rem_in
  %rcx_target = getelementptr i8, i8* %rcx_in, i64 %negrem
  %ptr_tail = bitcast i8* %rcx_target to i64*
  %val_tail = load volatile i64, i64* %ptr_tail, align 1
  %or_tail = or i64 %val_tail, 0
  store volatile i64 %or_tail, i64* %ptr_tail, align 1
  ret void
}