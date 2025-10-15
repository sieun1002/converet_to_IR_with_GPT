; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i64 %size) #0 {
entry:
  %cmp0 = icmp eq i64 %size, 0
  br i1 %cmp0, label %ret, label %alloc

alloc:
  %p = alloca i8, i64 %size, align 16
  %div = udiv i64 %size, 4096
  %cond_full = icmp eq i64 %div, 0
  br i1 %cond_full, label %after_full, label %full_loop

full_loop:
  %i = phi i64 [ 1, %alloc ], [ %i.next, %full_loop ]
  %mul = mul i64 %i, 4096
  %offm1 = add i64 %mul, -1
  %ptr = getelementptr inbounds i8, i8* %p, i64 %offm1
  %old = load volatile i8, i8* %ptr, align 1
  store volatile i8 %old, i8* %ptr, align 1
  %i.next = add i64 %i, 1
  %cond.cont = icmp ule i64 %i.next, %div
  br i1 %cond.cont, label %full_loop, label %after_full

after_full:
  %rem = urem i64 %size, 4096
  %has_rem = icmp eq i64 %rem, 0
  br i1 %has_rem, label %ret, label %tail_touch

tail_touch:
  %last_off = add i64 %size, -1
  %last_ptr = getelementptr inbounds i8, i8* %p, i64 %last_off
  %old2 = load volatile i8, i8* %last_ptr, align 1
  store volatile i8 %old2, i8* %last_ptr, align 1
  br label %ret

ret:
  ret void
}

attributes #0 = { nounwind }