; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %cond = icmp ule i64 %n, 1
  br i1 %cond, label %exit, label %outer.loop.pre

outer.loop.pre:
  br label %outer.check

outer.check:
  %var8 = phi i64 [ %n, %outer.loop.pre ], [ %new_var8, %outer.update ]
  %outer_cond = icmp ugt i64 %var8, 1
  br i1 %outer_cond, label %outer.body, label %exit

outer.body:
  br label %inner.check

inner.check:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.body ], [ %last.next, %inner.latch ]
  %cmp_inner = icmp ult i64 %i, %var8
  br i1 %cmp_inner, label %inner.body, label %after.inner

inner.body:
  %idxm1 = add i64 %i, -1
  %ptr_m1 = getelementptr inbounds i32, i32* %arr, i64 %idxm1
  %val_m1 = load i32, i32* %ptr_m1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %needSwap = icmp sgt i32 %val_m1, %val_i
  br i1 %needSwap, label %swap, label %noswap

swap:
  store i32 %val_i, i32* %ptr_m1, align 4
  store i32 %val_m1, i32* %ptr_i, align 4
  br label %inner.latch

noswap:
  br label %inner.latch

inner.latch:
  %last.next = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner.check

after.inner:
  %haveSwap = icmp eq i64 %last, 0
  br i1 %haveSwap, label %exit, label %outer.update

outer.update:
  %new_var8 = phi i64 [ %last, %after.inner ]
  br label %outer.check

exit:
  ret void
}