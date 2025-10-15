; ModuleID = 'merge_sort'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %block.i8 = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %block.i8, null
  br i1 %isnull, label %exit, label %post_alloc

post_alloc:
  %dst.init = bitcast i8* %block.i8 to i32*
  br label %outer.cond

outer.cond:
  %run = phi i64 [ 1, %post_alloc ], [ %run.next, %outer.afterpass ]
  %src.cur = phi i32* [ %arr, %post_alloc ], [ %src.next, %outer.afterpass ]
  %dst.cur = phi i32* [ %dst.init, %post_alloc ], [ %dst.next, %outer.afterpass ]
  %cond = icmp ult i64 %run, %n
  br i1 %cond, label %outer.body.init, label %after.outer

outer.body.init:
  %two_run = add i64 %run, %run
  br label %for.i.cond

for.i.cond:
  %i = phi i64 [ 0, %outer.body.init ], [ %i.next, %for.i.aftermerge ]
  %two_run.phi = phi i64 [ %two_run, %outer.body.init ], [ %two_run.phi, %for.i.aftermerge ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %calc.bounds, label %for.i.exit

calc.bounds:
  %mid.tmp = add i64 %i, %run
  %n_ge_midtmp = icmp uge i64 %n, %mid.tmp
  %mid.sel = select i1 %n_ge_midtmp, i64 %mid.tmp, i64 %n
  %end.tmp = add i64 %i, %two_run.phi
  %n_ge_endtmp = icmp uge i64 %n, %end.tmp
  %end.sel = select i1 %n_ge_endtmp, i64 %end.tmp, i64 %n
  br label %merge.cond

merge.cond:
  %l = phi i64 [ %i, %calc.bounds ], [ %l.next, %do.left ], [ %l, %do.right ]
  %r = phi i64 [ %mid.sel, %calc.bounds ], [ %r, %do.left ], [ %r.next, %do.right ]
  %d = phi i64 [ %i, %calc.bounds ], [ %d.next, %do.left ], [ %d.next2, %do.right ]
  %mid.phi = phi i64 [ %mid.sel, %calc.bounds ], [ %mid.phi, %do.left ], [ %mid.phi, %do.right ]
  %end.phi = phi i64 [ %end.sel, %calc.bounds ], [ %end.phi, %do.left ], [ %end.phi, %do.right ]
  %d_lt_end = icmp ult i64 %d, %end.phi
  br i1 %d_lt_end, label %choose.ltest, label %merge.exit

choose.ltest:
  %l_lt_mid = icmp ult i64 %l, %mid.phi
  br i1 %l_lt_mid, label %check.r, label %do.right

check.r:
  %r_lt_end = icmp ult i64 %r, %end.phi
  br i1 %r_lt_end, label %compare.vals, label %do.left

compare.vals:
  %ptr.l = getelementptr inbounds i32, i32* %src.cur, i64 %l
  %val.l = load i32, i32* %ptr.l, align 4
  %ptr.r = getelementptr inbounds i32, i32* %src.cur, i64 %r
  %val.r = load i32, i32* %ptr.r, align 4
  %cmp.gt = icmp sgt i32 %val.l, %val.r
  br i1 %cmp.gt, label %do.right, label %do.left

do.left:
  %ptr.src.l = getelementptr inbounds i32, i32* %src.cur, i64 %l
  %val.to.store.l = load i32, i32* %ptr.src.l, align 4
  %ptr.dst.l = getelementptr inbounds i32, i32* %dst.cur, i64 %d
  store i32 %val.to.store.l, i32* %ptr.dst.l, align 4
  %l.next = add i64 %l, 1
  %d.next = add i64 %d, 1
  br label %merge.cond

do.right:
  %ptr.src.r = getelementptr inbounds i32, i32* %src.cur, i64 %r
  %val.to.store.r = load i32, i32* %ptr.src.r, align 4
  %ptr.dst.r = getelementptr inbounds i32, i32* %dst.cur, i64 %d
  store i32 %val.to.store.r, i32* %ptr.dst.r, align 4
  %r.next = add i64 %r, 1
  %d.next2 = add i64 %d, 1
  br label %merge.cond

merge.exit:
  br label %for.i.aftermerge

for.i.aftermerge:
  %i.next = add i64 %i, %two_run.phi
  br label %for.i.cond

for.i.exit:
  br label %outer.afterpass

outer.afterpass:
  %src.next = phi i32* [ %dst.cur, %for.i.exit ]
  %dst.next = phi i32* [ %src.cur, %for.i.exit ]
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src.final = phi i32* [ %src.cur, %outer.cond ]
  %need.copy = icmp eq i32* %src.final, %arr
  br i1 %need.copy, label %skip.copy, label %do.copy

do.copy:
  %size2 = shl i64 %n, 2
  %dst.i8 = bitcast i32* %arr to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %memcpy.call = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %size2)
  br label %skip.copy

skip.copy:
  call void @free(i8* %block.i8)
  br label %exit

exit:
  ret void
}