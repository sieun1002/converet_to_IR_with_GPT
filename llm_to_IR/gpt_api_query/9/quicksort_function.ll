; ModuleID = 'quick_sort'
source_filename = "quick_sort.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %left.addr = alloca i64, align 8
  %right.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i64 %left, i64* %left.addr, align 8
  store i64 %right, i64* %right.addr, align 8
  br label %outer.cond

outer.cond:                                       ; while (left < right)
  %lcur = load i64, i64* %left.addr, align 8
  %rcur = load i64, i64* %right.addr, align 8
  %cmp.lr = icmp slt i64 %lcur, %rcur
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:
  ; i = left; j = right
  store i64 %lcur, i64* %i.addr, align 8
  store i64 %rcur, i64* %j.addr, align 8
  ; pivot = arr[left + (right - left)/2]  (signed div, trunc toward zero)
  %diff = sub i64 %rcur, %lcur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lcur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  store i32 %pivot.val, i32* %pivot, align 4
  br label %partition.loop.top

partition.loop.top:
  br label %i.scan

i.scan:
  %i.cur = load i64, i64* %i.addr, align 8
  %i.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.elem = load i32, i32* %i.elem.ptr, align 4
  %pvt0 = load i32, i32* %pivot, align 4
  %lt.pivot = icmp slt i32 %i.elem, %pvt0
  br i1 %lt.pivot, label %i.inc, label %i.done

i.inc:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %i.scan

i.done:
  br label %j.scan

j.scan:
  %j.cur = load i64, i64* %j.addr, align 8
  %j.elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.elem = load i32, i32* %j.elem.ptr, align 4
  %pvt1 = load i32, i32* %pivot, align 4
  %gt.pivot = icmp sgt i32 %j.elem, %pvt1
  br i1 %gt.pivot, label %j.dec, label %j.done

j.dec:
  %j.next = add i64 %j.cur, -1
  store i64 %j.next, i64* %j.addr, align 8
  br label %j.scan

j.done:
  %i2 = load i64, i64* %i.addr, align 8
  %j2 = load i64, i64* %j.addr, align 8
  %le.ij = icmp sle i64 %i2, %j2
  br i1 %le.ij, label %do.swap, label %partition.done

do.swap:
  ; tmp = arr[i]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i2
  %ai = load i32, i32* %ai.ptr, align 4
  store i32 %ai, i32* %tmp, align 4
  ; arr[i] = arr[j]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %aj = load i32, i32* %aj.ptr, align 4
  store i32 %aj, i32* %ai.ptr, align 4
  ; arr[j] = tmp
  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %aj.ptr, align 4
  ; i++, j--
  %i3 = add i64 %i2, 1
  store i64 %i3, i64* %i.addr, align 8
  %j3 = add i64 %j2, -1
  store i64 %j3, i64* %j.addr, align 8
  br label %partition.loop.top

partition.done:
  ; choose smaller side to recurse first
  %lcur2 = load i64, i64* %left.addr, align 8
  %rcur2 = load i64, i64* %right.addr, align 8
  %i.out = load i64, i64* %i.addr, align 8
  %j.out = load i64, i64* %j.addr, align 8
  %left.len = sub i64 %j.out, %lcur2
  %right.len = sub i64 %rcur2, %i.out
  %left.ge.right = icmp sge i64 %left.len, %right.len
  br i1 %left.ge.right, label %rightFirst, label %leftFirst

leftFirst:
  ; if (left < j) recurse on left..j
  %condLeft = icmp slt i64 %lcur2, %j.out
  br i1 %condLeft, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i64 %lcur2, i64 %j.out)
  br label %skip.left

skip.left:
  ; then set left = i and iterate
  store i64 %i.out, i64* %left.addr, align 8
  br label %outer.cond

rightFirst:
  ; if (i < right) recurse on i..right
  %condRight = icmp slt i64 %i.out, %rcur2
  br i1 %condRight, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i64 %i.out, i64 %rcur2)
  br label %skip.right

skip.right:
  ; then set right = j and iterate
  store i64 %j.out, i64* %right.addr, align 8
  br label %outer.cond

ret:
  ret void
}