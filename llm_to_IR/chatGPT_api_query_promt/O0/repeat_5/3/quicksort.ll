; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  %low.addr = alloca i64, align 8
  %high.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %pivot.addr = alloca i32, align 4
  %tmp.addr = alloca i32, align 4
  store i64 %low, i64* %low.addr, align 8
  store i64 %high, i64* %high.addr, align 8
  br label %outer.cond

outer.cond:                                      ; preds = %skip.right, %skip.left, %entry
  %lowv = load i64, i64* %low.addr, align 8
  %highv = load i64, i64* %high.addr, align 8
  %cmp = icmp slt i64 %lowv, %highv
  br i1 %cmp, label %partition, label %ret

partition:                                       ; preds = %outer.cond
  store i64 %lowv, i64* %i.addr, align 8
  store i64 %highv, i64* %j.addr, align 8
  %diff = sub i64 %highv, %lowv
  %sign = lshr i64 %diff, 63
  %tmp = add i64 %diff, %sign
  %half = ashr i64 %tmp, 1
  %mid = add i64 %lowv, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %ptr.mid, align 4
  store i32 %pivot, i32* %pivot.addr, align 4
  br label %scan.i

scan.i:                                          ; preds = %inc.i, %post.swap, %partition
  %i = load i64, i64* %i.addr, align 8
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %pv = load i32, i32* %pivot.addr, align 4
  %cmpi = icmp sgt i32 %pv, %val.i
  br i1 %cmpi, label %inc.i, label %scan.j

inc.i:                                           ; preds = %scan.i
  %i.next = add i64 %i, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %scan.i

scan.j:                                          ; preds = %scan.i
  %j = load i64, i64* %j.addr, align 8
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  %val.j = load i32, i32* %ptr.j, align 4
  %pv2 = load i32, i32* %pivot.addr, align 4
  %cmpj = icmp slt i32 %pv2, %val.j
  br i1 %cmpj, label %dec.j, label %check.swap

dec.j:                                           ; preds = %scan.j
  %j.next = add i64 %j, -1
  store i64 %j.next, i64* %j.addr, align 8
  br label %scan.j

check.swap:                                      ; preds = %scan.j
  %i2 = load i64, i64* %i.addr, align 8
  %j2 = load i64, i64* %j.addr, align 8
  %break = icmp sgt i64 %i2, %j2
  br i1 %break, label %after.inner, label %do.swap

do.swap:                                         ; preds = %check.swap
  %ptr.i2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %ai = load i32, i32* %ptr.i2, align 4
  store i32 %ai, i32* %tmp.addr, align 4
  %ptr.j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %aj = load i32, i32* %ptr.j2, align 4
  store i32 %aj, i32* %ptr.i2, align 4
  %tmpv = load i32, i32* %tmp.addr, align 4
  store i32 %tmpv, i32* %ptr.j2, align 4
  %i3 = add i64 %i2, 1
  store i64 %i3, i64* %i.addr, align 8
  %j3 = add i64 %j2, -1
  store i64 %j3, i64* %j.addr, align 8
  br label %post.swap

post.swap:                                       ; preds = %do.swap
  %i4 = load i64, i64* %i.addr, align 8
  %j4 = load i64, i64* %j.addr, align 8
  %cont = icmp sle i64 %i4, %j4
  br i1 %cont, label %scan.i, label %after.inner

after.inner:                                     ; preds = %post.swap, %check.swap
  %lowc = load i64, i64* %low.addr, align 8
  %highc = load i64, i64* %high.addr, align 8
  %jv = load i64, i64* %j.addr, align 8
  %iv = load i64, i64* %i.addr, align 8
  %leftsz = sub i64 %jv, %lowc
  %rightsz = sub i64 %highc, %iv
  %left_ge_right = icmp sge i64 %leftsz, %rightsz
  br i1 %left_ge_right, label %right.first, label %left.first

left.first:                                      ; preds = %after.inner
  %condL = icmp slt i64 %lowc, %jv
  br i1 %condL, label %do.left, label %skip.left

do.left:                                         ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lowc, i64 %jv)
  br label %skip.left

skip.left:                                       ; preds = %do.left, %left.first
  store i64 %iv, i64* %low.addr, align 8
  br label %outer.cond

right.first:                                     ; preds = %after.inner
  %condR = icmp slt i64 %iv, %highc
  br i1 %condR, label %do.right, label %skip.right

do.right:                                        ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %iv, i64 %highc)
  br label %skip.right

skip.right:                                      ; preds = %do.right, %right.first
  store i64 %jv, i64* %high.addr, align 8
  br label %outer.cond

ret:                                             ; preds = %outer.cond
  ret void
}