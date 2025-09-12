; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cond = icmp ule i64 %n, 1
  br i1 %cond, label %ret, label %outer_header

outer_header:
  %end = phi i64 [ %n, %entry ], [ %last0, %after_inner ]
  %end_gt1 = icmp ugt i64 %end, 1
  br i1 %end_gt1, label %inner_header, label %ret

inner_header:
  %i = phi i64 [ 1, %outer_header ], [ %i.next, %inner_latch ]
  %last0 = phi i64 [ 0, %outer_header ], [ %last.next, %inner_latch ]
  %i_lt_end = icmp ult i64 %i, %end
  br i1 %i_lt_end, label %inner_body, label %after_inner

inner_body:
  %i_minus1 = add i64 %i, -1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %v1 = load i32, i32* %p1, align 4
  %v2 = load i32, i32* %p2, align 4
  %gt = icmp sgt i32 %v1, %v2
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %v2, i32* %p1, align 4
  store i32 %v1, i32* %p2, align 4
  br label %inner_latch

noswap:
  br label %inner_latch

inner_latch:
  %last.next = phi i64 [ %i, %swap ], [ %last0, %noswap ]
  %i.next = add i64 %i, 1
  br label %inner_header

after_inner:
  %no_swaps = icmp eq i64 %last0, 0
  br i1 %no_swaps, label %ret, label %outer_header

ret:
  ret void
}