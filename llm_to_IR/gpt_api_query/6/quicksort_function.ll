; ModuleID = 'quick_sort_module'
source_filename = "quick_sort.ll"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %arr.addr = alloca i32*, align 8
  %left.addr = alloca i64, align 8
  %right.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %left, i64* %left.addr, align 8
  store i64 %right, i64* %right.addr, align 8
  br label %outer.cond

outer.cond:                                       ; while (left < right)
  %l = load i64, i64* %left.addr, align 8
  %r = load i64, i64* %right.addr, align 8
  %cond = icmp slt i64 %l, %r
  br i1 %cond, label %outer.body, label %return

outer.body:
  ; i = left; j = right
  store i64 %l, i64* %i.addr, align 8
  store i64 %r, i64* %j.addr, align 8
  ; pivot = arr[left + ((right-left)/2)]
  %arrp = load i32*, i32** %arr.addr, align 8
  %diff = sub i64 %r, %l
  %half = sdiv i64 %diff, 2
  %mid = add i64 %l, %half
  %gep.pivot = getelementptr inbounds i32, i32* %arrp, i64 %mid
  %pv = load i32, i32* %gep.pivot, align 4
  store i32 %pv, i32* %pivot, align 4
  br label %inc.i.loop

inc.i.loop:                                       ; while (arr[i] < pivot) i++
  %i.val = load i64, i64* %i.addr, align 8
  %pi.ptr = getelementptr inbounds i32, i32* %arrp, i64 %i.val
  %vi.cur = load i32, i32* %pi.ptr, align 4
  %pv2 = load i32, i32* %pivot, align 4
  %cmpi = icmp slt i32 %vi.cur, %pv2
  br i1 %cmpi, label %inc.i.body, label %after.inc.i

inc.i.body:
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %inc.i.loop

after.inc.i:
  br label %dec.j.loop

dec.j.loop:                                       ; while (arr[j] > pivot) j--
  %j.val = load i64, i64* %j.addr, align 8
  %pj.ptr = getelementptr inbounds i32, i32* %arrp, i64 %j.val
  %vj.cur = load i32, i32* %pj.ptr, align 4
  %pv3 = load i32, i32* %pivot, align 4
  %cmpj = icmp sgt i32 %vj.cur, %pv3
  br i1 %cmpj, label %dec.j.body, label %after.dec.j

dec.j.body:
  %j.next = add i64 %j.val, -1
  store i64 %j.next, i64* %j.addr, align 8
  br label %dec.j.loop

after.dec.j:
  %i.cur = load i64, i64* %i.addr, align 8
  %j.cur = load i64, i64* %j.addr, align 8
  %cmpIJ = icmp sgt i64 %i.cur, %j.cur
  br i1 %cmpIJ, label %after.partition, label %do.swap

do.swap:                                          ; swap(arr[i], arr[j]); i++; j--
  %pi.ptr2 = getelementptr inbounds i32, i32* %arrp, i64 %i.cur
  %pj.ptr2 = getelementptr inbounds i32, i32* %arrp, i64 %j.cur
  %vi = load i32, i32* %pi.ptr2, align 4
  store i32 %vi, i32* %tmp, align 4
  %vj = load i32, i32* %pj.ptr2, align 4
  store i32 %vj, i32* %pi.ptr2, align 4
  %vi2 = load i32, i32* %tmp, align 4
  store i32 %vi2, i32* %pj.ptr2, align 4
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i.addr, align 8
  %j.dec = add i64 %j.cur, -1
  store i64 %j.dec, i64* %j.addr, align 8
  br label %inc.i.loop

after.partition:                                   ; choose smaller side to recurse, then iterate on the other
  %l2 = load i64, i64* %left.addr, align 8
  %r2 = load i64, i64* %right.addr, align 8
  %i2 = load i64, i64* %i.addr, align 8
  %j2 = load i64, i64* %j.addr, align 8
  %left_size = sub i64 %j2, %l2
  %right_size = sub i64 %r2, %i2
  %cmp_sizes = icmp sge i64 %left_size, %right_size
  br i1 %cmp_sizes, label %rightFirst, label %leftFirst

leftFirst:                                        ; recurse left, iterate on right half
  %condLeft = icmp slt i64 %l2, %j2
  br i1 %condLeft, label %call.left, label %after.call.left

call.left:
  %arrL = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arrL, i64 %l2, i64 %j2)
  br label %after.call.left

after.call.left:
  store i64 %i2, i64* %left.addr, align 8
  br label %outer.cond

rightFirst:                                       ; recurse right, iterate on left half
  %condRight = icmp slt i64 %i2, %r2
  br i1 %condRight, label %call.right, label %after.call.right

call.right:
  %arrR = load i32*, i32** %arr.addr, align 8
  call void @quick_sort(i32* %arrR, i64 %i2, i64 %r2)
  br label %after.call.right

after.call.right:
  store i64 %j2, i64* %right.addr, align 8
  br label %outer.cond

return:
  ret void
}