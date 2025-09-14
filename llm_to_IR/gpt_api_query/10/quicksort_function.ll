; ModuleID = 'quick_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %arr.addr = alloca i32*, align 8
  %lo.addr = alloca i64, align 8
  %hi.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %lo, i64* %lo.addr, align 8
  store i64 %hi, i64* %hi.addr, align 8
  br label %outer.cond

outer.cond:                                       ; while (lo < hi)
  %lo.cur = load i64, i64* %lo.addr, align 8
  %hi.cur = load i64, i64* %hi.addr, align 8
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %partition.init, label %ret

partition.init:
  ; i = lo; j = hi
  store i64 %lo.cur, i64* %i.addr, align 8
  store i64 %hi.cur, i64* %j.addr, align 8
  ; pivot = arr[lo + (hi - lo)/2] with signed trunc-to-zero division
  %diff = sub i64 %hi.cur, %lo.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %arr.ld = load i32*, i32** %arr.addr, align 8
  %p.ptr = getelementptr inbounds i32, i32* %arr.ld, i64 %mid
  %p.val = load i32, i32* %p.ptr, align 4
  store i32 %p.val, i32* %pivot, align 4
  br label %inner.loop

inner.loop:
  ; while (true) { ... partition ... }
  br label %while.i

while.i:                                          ; while (arr[i] < pivot) i++
  %i.cur = load i64, i64* %i.addr, align 8
  %arr.ld1 = load i32*, i32** %arr.addr, align 8
  %ai.ptr = getelementptr inbounds i32, i32* %arr.ld1, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %piv1 = load i32, i32* %pivot, align 4
  %lt.i = icmp slt i32 %ai, %piv1
  br i1 %lt.i, label %inc.i, label %after.i

inc.i:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %while.i

after.i:                                          ; while (arr[j] > pivot) j--
  br label %while.j

while.j:
  %j.cur = load i64, i64* %j.addr, align 8
  %arr.ld2 = load i32*, i32** %arr.addr, align 8
  %aj.ptr = getelementptr inbounds i32, i32* %arr.ld2, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %piv2 = load i32, i32* %pivot, align 4
  %gt.j = icmp sgt i32 %aj, %piv2
  br i1 %gt.j, label %dec.j, label %after.j

dec.j:
  %j.next = add i64 %j.cur, -1
  store i64 %j.next, i64* %j.addr, align 8
  br label %while.j

after.j:
  %i.fin = load i64, i64* %i.addr, align 8
  %j.fin = load i64, i64* %j.addr, align 8
  %i.gt.j = icmp sgt i64 %i.fin, %j.fin
  br i1 %i.gt.j, label %end.partition, label %do.swap

do.swap:
  %arr.ld3 = load i32*, i32** %arr.addr, align 8
  %pi.ptr = getelementptr inbounds i32, i32* %arr.ld3, i64 %i.fin
  %pj.ptr = getelementptr inbounds i32, i32* %arr.ld3, i64 %j.fin
  %vi = load i32, i32* %pi.ptr, align 4
  %vj = load i32, i32* %pj.ptr, align 4
  store i32 %vi, i32* %tmp, align 4
  store i32 %vj, i32* %pi.ptr, align 4
  %vt = load i32, i32* %tmp, align 4
  store i32 %vt, i32* %pj.ptr, align 4
  ; i++; j--
  %i.fin.next = add i64 %i.fin, 1
  store i64 %i.fin.next, i64* %i.addr, align 8
  %j.fin.next = add i64 %j.fin, -1
  store i64 %j.fin.next, i64* %j.addr, align 8
  br label %inner.loop

end.partition:
  ; choose smaller side to recurse, then adjust bounds and iterate
  %i.part = load i64, i64* %i.addr, align 8
  %j.part = load i64, i64* %j.addr, align 8
  %lo.now = load i64, i64* %lo.addr, align 8
  %hi.now = load i64, i64* %hi.addr, align 8
  %left.sz = sub i64 %j.part, %lo.now
  %right.sz = sub i64 %hi.now, %i.part
  %left.lt.right = icmp slt i64 %left.sz, %right.sz
  br i1 %left.lt.right, label %case.left.smaller, label %case.right.smaller

case.left.smaller:
  %condL = icmp slt i64 %lo.now, %j.part
  br i1 %condL, label %call.left, label %skip.left

call.left:
  %arr.ld4 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld4, i64 %lo.now, i64 %j.part)
  br label %skip.left

skip.left:
  store i64 %i.part, i64* %lo.addr, align 8
  br label %outer.cond

case.right.smaller:
  %condR = icmp slt i64 %i.part, %hi.now
  br i1 %condR, label %call.right, label %skip.right

call.right:
  %arr.ld5 = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arr.ld5, i64 %i.part, i64 %hi.now)
  br label %skip.right

skip.right:
  store i64 %j.part, i64* %hi.addr, align 8
  br label %outer.cond

ret:
  ret void
}