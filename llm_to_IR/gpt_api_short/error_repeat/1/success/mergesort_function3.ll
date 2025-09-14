; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* nocapture %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.le1 = icmp ule i64 %n, 1
  br i1 %cmp.le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmp8 = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmp8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp = bitcast i8* %tmp8 to i32*
  br label %outer

outer:
  %width.phi = phi i64 [ 1, %init ], [ %width.next, %swapwidth ]
  %src.phi = phi i32* [ %dest, %init ], [ %src2, %swapwidth ]
  %buf.phi = phi i32* [ %tmp, %init ], [ %buf2, %swapwidth ]
  %cmp.outer = icmp ult i64 %width.phi, %n
  br i1 %cmp.outer, label %inner.init, label %finish

inner.init:
  br label %inner.cond

inner.cond:
  %start.phi = phi i64 [ 0, %inner.init ], [ %start.next, %after.merge ]
  %cond = icmp ult i64 %start.phi, %n
  br i1 %cond, label %setup, label %swapwidth

setup:
  %left = add i64 %start.phi, 0
  %t1 = add i64 %left, %width.phi
  %n_ge_t1 = icmp uge i64 %n, %t1
  %right = select i1 %n_ge_t1, i64 %t1, i64 %n
  %tw = shl i64 %width.phi, 1
  %t2 = add i64 %left, %tw
  %n_ge_t2 = icmp uge i64 %n, %t2
  %end = select i1 %n_ge_t2, i64 %t2, i64 %n
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %left, %setup ], [ %i.next, %take_left ], [ %i, %take_right ]
  %j = phi i64 [ %right, %setup ], [ %j.next, %take_right ], [ %j, %take_left ]
  %k = phi i64 [ %left, %setup ], [ %k.next, %take_left ], [ %k.next.2, %take_right ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %check.i, label %after.merge

check.i:
  %i_lt_right = icmp ult i64 %i, %right
  br i1 %i_lt_right, label %check.j, label %take_right.pre_exhaust_i

check.j:
  %j_lt_end = icmp ult i64 %j, %end
  br i1 %j_lt_end, label %compare.ab, label %take_left.pre_exhaust_j

compare.ab:
  %ptr.ai = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %a = load i32, i32* %ptr.ai, align 4
  %ptr.bj = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %b = load i32, i32* %ptr.bj, align 4
  %a_gt_b = icmp sgt i32 %a, %b
  br i1 %a_gt_b, label %take_right.from_cmp, label %take_left.from_cmp

take_left.pre_exhaust_j:
  %ptr.ai.pe = getelementptr inbounds i32, i32* %src.phi, i64 %i
  %a.pe = load i32, i32* %ptr.ai.pe, align 4
  br label %take_left

take_left.from_cmp:
  br label %take_left

take_left:
  %a.phi = phi i32 [ %a.pe, %take_left.pre_exhaust_j ], [ %a, %take_left.from_cmp ]
  %ptr.out.k = getelementptr inbounds i32, i32* %buf.phi, i64 %k
  store i32 %a.phi, i32* %ptr.out.k, align 4
  %i.next = add i64 %i, 1
  %k.next = add i64 %k, 1
  br label %merge.cond

take_right.pre_exhaust_i:
  %ptr.bj.pe = getelementptr inbounds i32, i32* %src.phi, i64 %j
  %b.pe = load i32, i32* %ptr.bj.pe, align 4
  br label %take_right

take_right.from_cmp:
  br label %take_right

take_right:
  %b.phi = phi i32 [ %b.pe, %take_right.pre_exhaust_i ], [ %b, %take_right.from_cmp ]
  %ptr.out.k2 = getelementptr inbounds i32, i32* %buf.phi, i64 %k
  store i32 %b.phi, i32* %ptr.out.k2, align 4
  %j.next = add i64 %j, 1
  %k.next.2 = add i64 %k, 1
  br label %merge.cond

after.merge:
  %start.next = add i64 %start.phi, %tw
  br label %inner.cond

swapwidth:
  %src2 = getelementptr inbounds i32, i32* %buf.phi, i64 0
  %buf2 = getelementptr inbounds i32, i32* %src.phi, i64 0
  %width.next = shl i64 %width.phi, 1
  br label %outer

finish:
  %src8 = bitcast i32* %src.phi to i8*
  %dest8 = bitcast i32* %dest to i8*
  %needcpy = icmp ne i32* %src.phi, %dest
  br i1 %needcpy, label %do_cpy, label %do_free

do_cpy:
  %bytes = shl i64 %n, 2
  call i8* @memcpy(i8* %dest8, i8* %src8, i64 %bytes)
  br label %do_free

do_free:
  call void @free(i8* %tmp8)
  br label %ret

ret:
  ret void
}