; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of 32-bit integers (confidence=0.98). Evidence: heapify loops with 2*i+1 children, max-heap comparisons and end-phase root swap/heap-size decrement.
; Preconditions: %a points to at least %n contiguous i32 elements.
; Postconditions: %a[0..n-1] sorted in nondecreasing (ascending) order.

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.init = icmp ule i64 %n, 1
  br i1 %cmp.init, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.loop.hdr

build.loop.hdr:
  %i.ph = phi i64 [ %half, %build.init ], [ %i.dec, %build.after ]
  %cond.i = icmp ne i64 %i.ph, 0
  br i1 %cond.i, label %build.pre, label %sort.init

build.pre:
  %i.dec = add i64 %i.ph, -1
  br label %sift1.hdr

sift1.hdr:
  %j1 = phi i64 [ %i.dec, %build.pre ], [ %j1.next, %sift1.swap ]
  %left1.tmp = shl i64 %j1, 1
  %left1 = add i64 %left1.tmp, 1
  %left1.ge.n = icmp uge i64 %left1, %n
  br i1 %left1.ge.n, label %build.after, label %sift1.has.left

sift1.has.left:
  %right1 = add i64 %left1, 1
  %right1.lt.n = icmp ult i64 %right1, %n
  br i1 %right1.lt.n, label %s1.compare.children, label %s1.k.left

s1.compare.children:
  %gep.ar = getelementptr inbounds i32, i32* %a, i64 %right1
  %val.ar = load i32, i32* %gep.ar, align 4
  %gep.al = getelementptr inbounds i32, i32* %a, i64 %left1
  %val.al = load i32, i32* %gep.al, align 4
  %cmp.children = icmp sgt i32 %val.ar, %val.al
  %k1.sel = select i1 %cmp.children, i64 %right1, i64 %left1
  br label %s1.k.merge

s1.k.left:
  br label %s1.k.merge

s1.k.merge:
  %k1 = phi i64 [ %k1.sel, %s1.compare.children ], [ %left1, %s1.k.left ]
  %gep.aj = getelementptr inbounds i32, i32* %a, i64 %j1
  %val.aj = load i32, i32* %gep.aj, align 4
  %gep.ak = getelementptr inbounds i32, i32* %a, i64 %k1
  %val.ak = load i32, i32* %gep.ak, align 4
  %cmp.jk = icmp slt i32 %val.aj, %val.ak
  br i1 %cmp.jk, label %sift1.swap, label %build.after

sift1.swap:
  store i32 %val.ak, i32* %gep.aj, align 4
  store i32 %val.aj, i32* %gep.ak, align 4
  %j1.next = %k1
  br label %sift1.hdr

build.after:
  br label %build.loop.hdr

sort.init:
  %n.minus1 = add i64 %n, -1
  br label %sort.loop.hdr

sort.loop.hdr:
  %sz = phi i64 [ %n.minus1, %sort.init ], [ %sz.dec, %after.sift2 ]
  %cmp.sz.zero = icmp eq i64 %sz, 0
  br i1 %cmp.sz.zero, label %ret, label %sort.swap

sort.swap:
  %a0 = load i32, i32* %a, align 4
  %gep.asz = getelementptr inbounds i32, i32* %a, i64 %sz
  %asz = load i32, i32* %gep.asz, align 4
  store i32 %asz, i32* %a, align 4
  store i32 %a0, i32* %gep.asz, align 4
  br label %sift2.hdr

sift2.hdr:
  %j2 = phi i64 [ 0, %sort.swap ], [ %j2.next, %sift2.swap ]
  %left2.tmp = shl i64 %j2, 1
  %left2 = add i64 %left2.tmp, 1
  %left2.ge.sz = icmp uge i64 %left2, %sz
  br i1 %left2.ge.sz, label %after.sift2, label %sift2.has.left

sift2.has.left:
  %right2 = add i64 %left2, 1
  %right2.lt.sz = icmp ult i64 %right2, %sz
  br i1 %right2.lt.sz, label %s2.compare.children, label %s2.k.left

s2.compare.children:
  %gep2.ar = getelementptr inbounds i32, i32* %a, i64 %right2
  %val2.ar = load i32, i32* %gep2.ar, align 4
  %gep2.al = getelementptr inbounds i32, i32* %a, i64 %left2
  %val2.al = load i32, i32* %gep2.al, align 4
  %cmp2.children = icmp sgt i32 %val2.ar, %val2.al
  %k2.sel = select i1 %cmp2.children, i64 %right2, i64 %left2
  br label %s2.k.merge

s2.k.left:
  br label %s2.k.merge

s2.k.merge:
  %k2 = phi i64 [ %k2.sel, %s2.compare.children ], [ %left2, %s2.k.left ]
  %gep2.aj = getelementptr inbounds i32, i32* %a, i64 %j2
  %val2.aj = load i32, i32* %gep2.aj, align 4
  %gep2.ak = getelementptr inbounds i32, i32* %a, i64 %k2
  %val2.ak = load i32, i32* %gep2.ak, align 4
  %cmp2.jk = icmp slt i32 %val2.aj, %val2.ak
  br i1 %cmp2.jk, label %sift2.swap, label %after.sift2

sift2.swap:
  store i32 %val2.ak, i32* %gep2.aj, align 4
  store i32 %val2.aj, i32* %gep2.ak, align 4
  %j2.next = %k2
  br label %sift2.hdr

after.sift2:
  %sz.dec = add i64 %sz, -1
  br label %sort.loop.hdr

ret:
  ret void
}