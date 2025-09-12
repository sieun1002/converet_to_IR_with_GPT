; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort.ll"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %arr.addr = alloca i32*, align 8
  %left.addr = alloca i64, align 8
  %right.addr = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %left, i64* %left.addr, align 8
  store i64 %right, i64* %right.addr, align 8
  br label %outer.cond

outer.cond:                                       ; preds = %right.skip, %left.skip, %entry
  %l.cur = load i64, i64* %left.addr, align 8
  %r.cur = load i64, i64* %right.addr, align 8
  %cmp.lr = icmp slt i64 %l.cur, %r.cur
  br i1 %cmp.lr, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.cond
  ; i = left; j = right
  store i64 %l.cur, i64* %i, align 8
  store i64 %r.cur, i64* %j, align 8
  ; pivot = arr[left + (right - left) / 2] (signed, trunc toward zero)
  %diff = sub i64 %r.cur, %l.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %l.cur, %half
  %arr.ld0 = load i32*, i32** %arr.addr, align 8
  %pivot.ptr = getelementptr inbounds i32, i32* %arr.ld0, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  store i32 %pivot.val, i32* %pivot, align 4
  br label %scan.i

scan.i:                                           ; preds = %swap.done, %scan.i.inc, %outer.body
  %i.cur = load i64, i64* %i, align 8
  %arr.ld1 = load i32*, i32** %arr.addr, align 8
  %i.elem.ptr = getelementptr inbounds i32, i32* %arr.ld1, i64 %i.cur
  %i.elem = load i32, i32* %i.elem.ptr, align 4
  %pvt = load i32, i32* %pivot, align 4
  %cmp.i = icmp slt i32 %i.elem, %pvt
  br i1 %cmp.i, label %scan.i.inc, label %scan.j

scan.i.inc:                                       ; preds = %scan.i
  %i.old = load i64, i64* %i, align 8
  %i.next = add i64 %i.old, 1
  store i64 %i.next, i64* %i, align 8
  br label %scan.i

scan.j:                                           ; preds = %scan.i
  %j.cur = load i64, i64* %j, align 8
  %arr.ld2 = load i32*, i32** %arr.addr, align 8
  %j.elem.ptr = getelementptr inbounds i32, i32* %arr.ld2, i64 %j.cur
  %j.elem = load i32, i32* %j.elem.ptr, align 4
  %pvt2 = load i32, i32* %pivot, align 4
  %cmp.j = icmp sgt i32 %j.elem, %pvt2
  br i1 %cmp.j, label %scan.j.dec, label %cmp.ij

scan.j.dec:                                       ; preds = %scan.j
  %j.old = load i64, i64* %j, align 8
  %j.next = add i64 %j.old, -1
  store i64 %j.next, i64* %j, align 8
  br label %scan.j

cmp.ij:                                           ; preds = %scan.j
  %i.now = load i64, i64* %i, align 8
  %j.now = load i64, i64* %j, align 8
  %le.ij = icmp sle i64 %i.now, %j.now
  br i1 %le.ij, label %do.swap, label %after.partition

do.swap:                                          ; preds = %cmp.ij
  %arr.ld3 = load i32*, i32** %arr.addr, align 8
  %i.ptr = getelementptr inbounds i32, i32* %arr.ld3, i64 %i.now
  %arr.ld4 = load i32*, i32** %arr.addr, align 8
  %j.ptr = getelementptr inbounds i32, i32* %arr.ld4, i64 %j.now
  %vi = load i32, i32* %i.ptr, align 4
  %vj = load i32, i32* %j.ptr, align 4
  store i32 %vj, i32* %i.ptr, align 4
  store i32 %vi, i32* %j.ptr, align 4
  ; i++, j--
  %i.plus = add i64 %i.now, 1
  %j.minus = add i64 %j.now, -1
  store i64 %i.plus, i64* %i, align 8
  store i64 %j.minus, i64* %j, align 8
  br label %swap.done

swap.done:                                        ; preds = %do.swap
  br label %scan.i

after.partition:                                  ; preds = %cmp.ij
  %l.a = load i64, i64* %left.addr, align 8
  %r.a = load i64, i64* %right.addr, align 8
  %i.a = load i64, i64* %i, align 8
  %j.a = load i64, i64* %j, align 8
  %left.len = sub i64 %j.a, %l.a
  %right.len = sub i64 %r.a, %i.a
  %left.smaller = icmp slt i64 %left.len, %right.len
  br i1 %left.smaller, label %left.first, label %right.first

left.first:                                       ; preds = %after.partition
  %need.left = icmp slt i64 %l.a, %j.a
  br i1 %need.left, label %left.call, label %left.skip

left.call:                                        ; preds = %left.first
  %arr.ld5 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld5, i64 %l.a, i64 %j.a)
  br label %left.skip

left.skip:                                        ; preds = %left.call, %left.first
  store i64 %i.a, i64* %left.addr, align 8
  br label %outer.cond

right.first:                                      ; preds = %after.partition
  %need.right = icmp slt i64 %i.a, %r.a
  br i1 %need.right, label %right.call, label %right.skip

right.call:                                       ; preds = %right.first
  %arr.ld6 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld6, i64 %i.a, i64 %r.a)
  br label %right.skip

right.skip:                                       ; preds = %right.call, %right.first
  store i64 %j.a, i64* %right.addr, align 8
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}