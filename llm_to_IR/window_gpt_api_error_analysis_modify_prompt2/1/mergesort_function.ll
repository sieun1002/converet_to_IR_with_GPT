; ModuleID = 'merge_sort'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %block_i8 = call i8* @malloc(i64 %size)
  %null = icmp eq i8* %block_i8, null
  br i1 %null, label %ret, label %init

init:
  %dstbuf.init = bitcast i8* %block_i8 to i32*
  br label %outer.header

outer.header:
  %src.phi = phi i32* [ %arr, %init ], [ %src.next, %after.inner ]
  %dst.phi = phi i32* [ %dstbuf.init, %init ], [ %dst.next, %after.inner ]
  %run.phi = phi i64 [ 1, %init ], [ %run.next, %after.inner ]
  %cond.outer = icmp ult i64 %run.phi, %n
  br i1 %cond.outer, label %outer.body, label %outer.done

outer.body:
  br label %inner.header

inner.header:
  %start.phi = phi i64 [ 0, %outer.body ], [ %start.next, %after.merge ]
  %cmp.start = icmp ult i64 %start.phi, %n
  br i1 %cmp.start, label %inner.body, label %after.inner

inner.body:
  %left = add i64 %start.phi, 0
  %tmpL = add i64 %start.phi, %run.phi
  %cmpTmpL = icmp ult i64 %tmpL, %n
  %mid = select i1 %cmpTmpL, i64 %tmpL, i64 %n
  %tworun = shl i64 %run.phi, 1
  %tmpR = add i64 %start.phi, %tworun
  %cmpTmpR = icmp ult i64 %tmpR, %n
  %end = select i1 %cmpTmpR, i64 %tmpR, i64 %n
  %i.init = add i64 %left, 0
  %j.init = add i64 %mid, 0
  %k.init = add i64 %left, 0
  br label %merge.header

merge.header:
  %i.phi = phi i64 [ %i.init, %inner.body ], [ %i.next.tl, %take_left ], [ %i.next.tr, %take_right ]
  %j.phi = phi i64 [ %j.init, %inner.body ], [ %j.phi, %take_left ], [ %j.next.tr, %take_right ]
  %k.phi = phi i64 [ %k.init, %inner.body ], [ %k.next.tl, %take_left ], [ %k.next.tr, %take_right ]
  %cmp.k = icmp ult i64 %k.phi, %end
  br i1 %cmp.k, label %merge.cmp, label %after.merge

merge.cmp:
  %cond_i = icmp ult i64 %i.phi, %mid
  br i1 %cond_i, label %check_right_exhausted, label %take_right

check_right_exhausted:
  %cond_j_exh = icmp uge i64 %j.phi, %end
  br i1 %cond_j_exh, label %take_left, label %compare_vals

compare_vals:
  %pi = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %vi = load i32, i32* %pi, align 4
  %pj = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %vj = load i32, i32* %pj, align 4
  %cmpvals = icmp sle i32 %vi, %vj
  br i1 %cmpvals, label %take_left, label %take_right

take_left:
  %pi2 = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %vi2 = load i32, i32* %pi2, align 4
  %pdstL = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %vi2, i32* %pdstL, align 4
  %i.next.tl = add i64 %i.phi, 1
  %k.next.tl = add i64 %k.phi, 1
  br label %merge.header

take_right:
  %pj2 = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %vj2 = load i32, i32* %pj2, align 4
  %pdstR = getelementptr inbounds i32, i32* %dst.phi, i64 %k.phi
  store i32 %vj2, i32* %pdstR, align 4
  %i.next.tr = add i64 %i.phi, 0
  %j.next.tr = add i64 %j.phi, 1
  %k.next.tr = add i64 %k.phi, 1
  br label %merge.header

after.merge:
  %start.next = add i64 %start.phi, %tworun
  br label %inner.header

after.inner:
  %src.next = bitcast i32* %dst.phi to i32*
  %dst.next = bitcast i32* %src.phi to i32*
  %run.next = shl i64 %run.phi, 1
  br label %outer.header

outer.done:
  %needcopy = icmp ne i32* %src.phi, %arr
  br i1 %needcopy, label %do_copy, label %post_copy

do_copy:
  %dst8 = bitcast i32* %arr to i8*
  %src8 = bitcast i32* %src.phi to i8*
  %sizecopy = shl i64 %n, 2
  %callmem = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %sizecopy)
  br label %post_copy

post_copy:
  call void @free(i8* %block_i8)
  br label %ret

ret:
  ret void
}