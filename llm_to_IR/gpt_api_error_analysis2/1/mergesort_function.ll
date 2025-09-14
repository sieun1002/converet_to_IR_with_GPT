; ModuleID = 'merge_sort.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp.small = icmp ule i64 %n, 1
  br i1 %cmp.small, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw.mem = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw.mem, null
  br i1 %isnull, label %ret, label %after_alloc

after_alloc:
  %buf.init = bitcast i8* %raw.mem to i32*
  br label %outer.cond

outer.cond:
  %width.phi = phi i64 [ 1, %after_alloc ], [ %width.next, %outer.postswap ]
  %src.phi = phi i32* [ %dest, %after_alloc ], [ %src.next, %outer.postswap ]
  %buf.phi = phi i32* [ %buf.init, %after_alloc ], [ %buf.next, %outer.postswap ]
  %cmp.width = icmp ult i64 %width.phi, %n
  br i1 %cmp.width, label %outer.body.init, label %after.outer

outer.body.init:
  %twoW = shl i64 %width.phi, 1
  br label %inner.cond

inner.cond:
  %i.phi = phi i64 [ 0, %outer.body.init ], [ %i.next, %inner.aftermerge ]
  %cmp.i = icmp ult i64 %i.phi, %n
  br i1 %cmp.i, label %prepare.bounds, label %outer.postswap

prepare.bounds:
  %tmp.mid = add i64 %i.phi, %width.phi
  %mid.cmp = icmp ule i64 %tmp.mid, %n
  %mid = select i1 %mid.cmp, i64 %tmp.mid, i64 %n
  %tmp.right0 = add i64 %i.phi, %twoW
  %right.cmp = icmp ule i64 %tmp.right0, %n
  %right = select i1 %right.cmp, i64 %tmp.right0, i64 %n
  br label %merge.cond

merge.cond:
  %k.phi = phi i64 [ %i.phi, %prepare.bounds ], [ %k.next, %merge.step ]
  %a.phi = phi i64 [ %i.phi, %prepare.bounds ], [ %a.next.ph, %merge.step ]
  %b.phi = phi i64 [ %mid, %prepare.bounds ], [ %b.next.ph, %merge.step ]
  %cmp.k = icmp ult i64 %k.phi, %right
  br i1 %cmp.k, label %choose.aok, label %inner.aftermerge

choose.aok:
  %a.lt.mid = icmp ult i64 %a.phi, %mid
  br i1 %a.lt.mid, label %check.b, label %take.b

check.b:
  %b.lt.right = icmp ult i64 %b.phi, %right
  br i1 %b.lt.right, label %compare.values, label %take.a

compare.values:
  %ptr.a = getelementptr inbounds i32, i32* %src.phi, i64 %a.phi
  %val.a = load i32, i32* %ptr.a, align 4
  %ptr.b = getelementptr inbounds i32, i32* %src.phi, i64 %b.phi
  %val.b = load i32, i32* %ptr.b, align 4
  %a.gt.b = icmp sgt i32 %val.a, %val.b
  br i1 %a.gt.b, label %take.b, label %take.a

take.a:
  %ptr.a.store = getelementptr inbounds i32, i32* %src.phi, i64 %a.phi
  %val.a.store = load i32, i32* %ptr.a.store, align 4
  %dst.k.a = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.a.store, i32* %dst.k.a, align 4
  %a.inc = add i64 %a.phi, 1
  br label %merge.step

take.b:
  %ptr.b.store = getelementptr inbounds i32, i32* %src.phi, i64 %b.phi
  %val.b.store = load i32, i32* %ptr.b.store, align 4
  %dst.k.b = getelementptr inbounds i32, i32* %buf.phi, i64 %k.phi
  store i32 %val.b.store, i32* %dst.k.b, align 4
  %b.inc = add i64 %b.phi, 1
  br label %merge.step

merge.step:
  %a.next.ph = phi i64 [ %a.inc, %take.a ], [ %a.phi, %take.b ]
  %b.next.ph = phi i64 [ %b.phi, %take.a ], [ %b.inc, %take.b ]
  %k.next = add i64 %k.phi, 1
  br label %merge.cond

inner.aftermerge:
  %i.next = add i64 %i.phi, %twoW
  br label %inner.cond

outer.postswap:
  %src.next = phi i32* [ %buf.phi, %inner.cond ]
  %buf.next = phi i32* [ %src.phi, %inner.cond ]
  %width.next = shl i64 %width.phi, 1
  br label %outer.cond

after.outer:
  %src.ne.dest = icmp ne i32* %src.phi, %dest
  br i1 %src.ne.dest, label %do.memcpy, label %do.free

do.memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %size.copy = shl i64 %n, 2
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size.copy)
  br label %do.free

do.free:
  call void @free(i8* %raw.mem)
  br label %ret

ret:
  ret void
}