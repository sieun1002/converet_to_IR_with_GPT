; ModuleID = 'bubble_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %outer_init

outer_init:
  br label %outer_loop

outer_loop:
  %bound = phi i64 [ %n, %outer_init ], [ %new_bound, %outer_continue ]
  %cond_outer = icmp ugt i64 %bound, 1
  br i1 %cond_outer, label %outer_body, label %ret

outer_body:
  br label %inner_loop

inner_loop:
  %i = phi i64 [ 1, %outer_body ], [ %i.next, %inner_after_iter ]
  %lastswap = phi i64 [ 0, %outer_body ], [ %lastswap.upd, %inner_after_iter ]
  %cond_inner = icmp ult i64 %i, %bound
  br i1 %cond_inner, label %inner_body, label %after_inner

inner_body:
  %im1 = add i64 %i, -1
  %ptr0 = getelementptr inbounds i32, i32* %a, i64 %im1
  %ptr1 = getelementptr inbounds i32, i32* %a, i64 %i
  %v0 = load i32, i32* %ptr0, align 4
  %v1 = load i32, i32* %ptr1, align 4
  %cmp_vals = icmp sgt i32 %v0, %v1
  br i1 %cmp_vals, label %swap, label %noswap

swap:
  store i32 %v1, i32* %ptr0, align 4
  store i32 %v0, i32* %ptr1, align 4
  br label %inner_after_iter

noswap:
  br label %inner_after_iter

inner_after_iter:
  %lastswap.upd = phi i64 [ %i, %swap ], [ %lastswap, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner_loop

after_inner:
  %is_zero = icmp eq i64 %lastswap, 0
  br i1 %is_zero, label %ret, label %outer_continue

outer_continue:
  %new_bound = add i64 %lastswap, 0
  br label %outer_loop

ret:
  ret void
}