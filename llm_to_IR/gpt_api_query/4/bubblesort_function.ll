; LLVM IR (LLVM 14) for function: bubble_sort
; Signature: void bubble_sort(int* arr, size_t n)

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %upper.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %lastSwap.addr = alloca i64, align 8
  %tmp.addr = alloca i32, align 4

  %early_exit = icmp ule i64 %n, 1
  br i1 %early_exit, label %ret, label %init

init:
  store i64 %n, i64* %upper.addr, align 8
  br label %outer.cond

outer.cond:
  %upper.cur = load i64, i64* %upper.addr, align 8
  %outer_more = icmp ugt i64 %upper.cur, 1
  br i1 %outer_more, label %outer.body, label %ret

outer.body:
  store i64 0, i64* %lastSwap.addr, align 8
  store i64 1, i64* %i.addr, align 8
  br label %inner.cond

inner.cond:
  %i.cur = load i64, i64* %i.addr, align 8
  %upper.cur2 = load i64, i64* %upper.addr, align 8
  %inner_more = icmp ult i64 %i.cur, %upper.cur2
  br i1 %inner_more, label %inner.body, label %inner.after

inner.body:
  %i.prev = sub i64 %i.cur, 1
  %p.prev = getelementptr inbounds i32, i32* %arr, i64 %i.prev
  %prev.val = load i32, i32* %p.prev, align 4
  %p.curr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %curr.val = load i32, i32* %p.curr, align 4
  %need.swap = icmp sgt i32 %prev.val, %curr.val
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %prev.val, i32* %tmp.addr, align 4
  store i32 %curr.val, i32* %p.prev, align 4
  %tmp.val = load i32, i32* %tmp.addr, align 4
  store i32 %tmp.val, i32* %p.curr, align 4
  store i64 %i.cur, i64* %lastSwap.addr, align 8
  %i.next.swap = add i64 %i.cur, 1
  store i64 %i.next.swap, i64* %i.addr, align 8
  br label %inner.cond

no.swap:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %inner.cond

inner.after:
  %lastSwap.cur = load i64, i64* %lastSwap.addr, align 8
  %no_swaps = icmp eq i64 %lastSwap.cur, 0
  br i1 %no_swaps, label %ret, label %set.upper

set.upper:
  store i64 %lastSwap.cur, i64* %upper.addr, align 8
  br label %outer.cond

ret:
  ret void
}