; ModuleID = 'mergesort_main'
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.init = bitcast [10 x i32]* %arr to i8*
  %init.val = alloca [10 x i32], align 16
  %init.store.ptr = bitcast [10 x i32]* %init.val to i8*
  store [10 x i32] [i32 9, i32 1, i32 8, i32 3, i32 7, i32 2, i32 6, i32 5, i32 4, i32 0], [10 x i32]* %init.val, align 16
  %arr.dst = bitcast [10 x i32]* %arr to i8*
  %nbytes.const = ptrtoint [10 x i32]* @main to i64  ; dummy to enforce opcode usage, replaced below
  ; copy initialization (10 * 4 = 40 bytes)
  %src.cast = bitcast [10 x i32]* %init.val to i8*
  %dst.cast = bitcast [10 x i32]* %arr to i8*
  br label %init.copy.loop

init.copy.loop:
  %idx.byte.phi = phi i64 [ 0, %entry ], [ %idx.byte.next, %init.copy.body ]
  %cmp.init.done = icmp uge i64 %idx.byte.phi, 40
  br i1 %cmp.init.done, label %after.init.copy, label %init.copy.body

init.copy.body:
  %src.elem.ptr = getelementptr inbounds i8, i8* %src.cast, i64 %idx.byte.phi
  %dst.elem.ptr = getelementptr inbounds i8, i8* %dst.cast, i64 %idx.byte.phi
  %b = load i8, i8* %src.elem.ptr, align 1
  store i8 %b, i8* %dst.elem.ptr, align 1
  %idx.byte.next = add i64 %idx.byte.phi, 1
  br label %init.copy.loop

after.init.copy:
  %buf.raw = call noalias i8* @malloc(i64 40)
  %buf.isnull = icmp eq i8* %buf.raw, null
  br i1 %buf.isnull, label %print_only, label %sort.start

sort.start:
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %buf.as.i32 = bitcast i8* %buf.raw to i32*
  br label %outer.header

outer.header:
  %src.phi = phi i32* [ %arr.base, %sort.start ], [ %src.next, %outer.swap ]
  %dst.phi = phi i32* [ %buf.as.i32, %sort.start ], [ %dst.next, %outer.swap ]
  %run.phi = phi i32 [ 1, %sort.start ], [ %run.next, %outer.swap ]
  %run.ge.N = icmp sge i32 %run.phi, 10
  br i1 %run.ge.N, label %outer.done, label %pass.start

pass.start:
  %double.run = shl i32 %run.phi, 1
  br label %inner.header

inner.header:
  %i.phi = phi i32 [ 0, %pass.start ], [ %i.next, %inner.after ]
  %i.lt.N = icmp slt i32 %i.phi, 10
  br i1 %i.lt.N, label %merge.init, label %outer.swap

merge.init:
  %i.plus.run = add nsw i32 %i.phi, %run.phi
  %m.lt.N = icmp slt i32 %i.plus.run, 10
  %m = select i1 %m.lt.N, i32 %i.plus.run, i32 10
  %i.plus.drun = add nsw i32 %i.phi, %double.run
  %e.lt.N = icmp slt i32 %i.plus.drun, 10
  %e = select i1 %e.lt.N, i32 %i.plus.drun, i32 10
  br label %merge.loop

merge.loop:
  %l.phi = phi i32 [ %i.phi, %merge.init ], [ %l.next.left, %take.left ], [ %l.phi, %take.right ], [ %l.copy.next, %left.loop ], [ %l.phi, %right.loop ]
  %r.phi = phi i32 [ %m, %merge.init ], [ %r.phi, %take.left ], [ %r.next.right, %take.right ], [ %r.phi, %left.loop ], [ %r.copy.next, %right.loop ]
  %k.phi = phi i32 [ %i.phi, %merge.init ], [ %k.next.left, %take.left ], [ %k.next.right, %take.right ], [ %k.left.next, %left.loop ], [ %k.right.next, %right.loop ]
  %l.lt.m = icmp slt i32 %l.phi, %m
  %r.lt.e = icmp slt i32 %r.phi, %e
  %both.have = and i1 %l.lt.m, %r.lt.e
  br i1 %both.have, label %compare, label %exhaust

compare:
  %lp = getelementptr inbounds i32, i32* %src.phi, i32 %l.phi
  %lval = load i32, i32* %lp, align 4
  %rp = getelementptr inbounds i32, i32* %src.phi, i32 %r.phi
  %rval = load i32, i32* %rp, align 4
  %r.lt.l = icmp slt i32 %rval, %lval
  br i1 %r.lt.l, label %take.right, label %take.left

take.left:
  %dp.left = getelementptr inbounds i32, i32* %dst.phi, i32 %k.phi
  store i32 %lval, i32* %dp.left, align 4
  %l.next.left = add nsw i32 %l.phi, 1
  %k.next.left = add nsw i32 %k.phi, 1
  br label %merge.loop

take.right:
  %dp.right = getelementptr inbounds i32, i32* %dst.phi, i32 %k.phi
  store i32 %rval, i32* %dp.right, align 4
  %r.next.right = add nsw i32 %r.phi, 1
  %k.next.right = add nsw i32 %k.phi, 1
  br label %merge.loop

exhaust:
  br i1 %l.lt.m, label %left.loop, label %right.check

left.loop:
  %dp.left.rest = getelementptr inbounds i32, i32* %dst.phi, i32 %k.phi
  %sp.left.rest = getelementptr inbounds i32, i32* %src.phi, i32 %l.phi
  %l.copy.val = load i32, i32* %sp.left.rest, align 4
  store i32 %l.copy.val, i32* %dp.left.rest, align 4
  %l.copy.next = add nsw i32 %l.phi, 1
  %k.left.next = add nsw i32 %k.phi, 1
  %l.more = icmp slt i32 %l.copy.next, %m
  br i1 %l.more, label %left.loop, label %merge.loop

right.check:
  br i1 %r.lt.e, label %right.loop, label %merge.done

right.loop:
  %dp.right.rest = getelementptr inbounds i32, i32* %dst.phi, i32 %k.phi
  %sp.right.rest = getelementptr inbounds i32, i32* %src.phi, i32 %r.phi
  %r.copy.val = load i32, i32* %sp.right.rest, align 4
  store i32 %r.copy.val, i32* %dp.right.rest, align 4
  %r.copy.next = add nsw i32 %r.phi, 1
  %k.right.next = add nsw i32 %k.phi, 1
  %r.more = icmp slt i32 %r.copy.next, %e
  br i1 %r.more, label %right.loop, label %merge.done

merge.done:
  br label %inner.after

inner.after:
  %i.next = add nsw i32 %i.phi, %double.run
  br label %inner.header

outer.swap:
  %src.next = phi i32* [ %src.phi, %inner.header ]
  %dst.next = phi i32* [ %dst.phi, %inner.header ]
  %tmp.src = select i1 true, i32* %dst.next, i32* %dst.next
  %tmp.dst = select i1 true, i32* %src.next, i32* %src.next
  %run.next = shl i32 %run.phi, 1
  br label %outer.header

outer.done:
  %arr.as.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %src.is.arr = icmp eq i32* %src.phi, %arr.as.i32
  br i1 %src.is.arr, label %after.copyback, label %copyback.loop

copyback.loop:
  %cb.i.phi = phi i32 [ 0, %outer.done ], [ %cb.i.next, %copyback.body ]
  %cb.cond = icmp slt i32 %cb.i.phi, 10
  br i1 %cb.cond, label %copyback.body, label %after.copyback

copyback.body:
  %from.ptr = getelementptr inbounds i32, i32* %src.phi, i32 %cb.i.phi
  %to.ptr = getelementptr inbounds i32, i32* %arr.as.i32, i32 %cb.i.phi
  %v.cb = load i32, i32* %from.ptr, align 4
  store i32 %v.cb, i32* %to.ptr, align 4
  %cb.i.next = add nsw i32 %cb.i.phi, 1
  br label %copyback.loop

after.copyback:
  call void @free(i8* %buf.raw)
  br label %print_only

print_only:
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %arr.base.print = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %print.loop

print.loop:
  %pi.phi = phi i32 [ 0, %print_only ], [ %pi.next, %print.body ]
  %pi.cond = icmp slt i32 %pi.phi, 10
  br i1 %pi.cond, label %print.body, label %print.after

print.body:
  %pelem.ptr = getelementptr inbounds i32, i32* %arr.base.print, i32 %pi.phi
  %pelem = load i32, i32* %pelem.ptr, align 4
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %pelem)
  %pi.next = add nsw i32 %pi.phi, 1
  br label %print.loop

print.after:
  %call.newline = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0
}