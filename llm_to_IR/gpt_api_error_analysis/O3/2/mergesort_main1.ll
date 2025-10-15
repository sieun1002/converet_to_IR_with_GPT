; ModuleID = 'merged-sort-10'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@init = private unnamed_addr constant [10 x i32] [i32 9, i32 1, i32 8, i32 2, i32 7, i32 3, i32 6, i32 4, i32 5, i32 0], align 16

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %init.i8 = bitcast [10 x i32]* @init to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %arr.i8, i8* %init.i8, i64 40, i1 false)
  %tmp.buf = call i8* @malloc(i64 40)
  %tmp.isnull = icmp eq i8* %tmp.buf, null
  br i1 %tmp.isnull, label %print_unsorted, label %sort.setup

sort.setup:
  %src.start = bitcast [10 x i32]* %arr to i32*
  %dst.start = bitcast i8* %tmp.buf to i32*
  br label %pass.loop

pass.loop:
  %pass.iv = phi i32 [ 0, %sort.setup ], [ %pass.next, %pass.end ]
  %src.cur = phi i32* [ %src.start, %sort.setup ], [ %src.new, %pass.end ]
  %dst.cur = phi i32* [ %dst.start, %sort.setup ], [ %dst.new, %pass.end ]
  %run.shift = shl i32 1, %pass.iv
  br label %base.loop

base.loop:
  %base.iv = phi i32 [ 0, %pass.loop ], [ %base.next, %merge.end ]
  %base.cmp = icmp slt i32 %base.iv, 10
  br i1 %base.cmp, label %merge.init, label %pass.end

merge.init:
  %right.tmp = add i32 %base.iv, %run.shift
  %right.slt = icmp slt i32 %right.tmp, 10
  %right = select i1 %right.slt, i32 %right.tmp, i32 10
  %end.tmp = add i32 %right, %run.shift
  %end.slt = icmp slt i32 %end.tmp, 10
  %end = select i1 %end.slt, i32 %end.tmp, i32 10
  br label %merge.loop

merge.loop:
  %i.iv = phi i32 [ %base.iv, %merge.init ], [ %i.next.i, %take.i ], [ %i.iv, %take.j ]
  %j.iv = phi i32 [ %right, %merge.init ], [ %j.iv, %take.i ], [ %j.next.j, %take.j ]
  %k.iv = phi i32 [ %base.iv, %merge.init ], [ %k.next.i, %take.i ], [ %k.next.j, %take.j ]
  %i.lt.right = icmp slt i32 %i.iv, %right
  %j.lt.end = icmp slt i32 %j.iv, %end
  %both.lt = and i1 %i.lt.right, %j.lt.end
  br i1 %both.lt, label %merge.choose, label %copyI.init

merge.choose:
  %i.idx = zext i32 %i.iv to i64
  %j.idx = zext i32 %j.iv to i64
  %i.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %i.idx
  %j.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %j.idx
  %i.val = load i32, i32* %i.ptr, align 4
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.ij = icmp sle i32 %i.val, %j.val
  br i1 %cmp.ij, label %take.i, label %take.j

take.i:
  %k.idx.i = zext i32 %k.iv to i64
  %d.ptr.i = getelementptr inbounds i32, i32* %dst.cur, i64 %k.idx.i
  store i32 %i.val, i32* %d.ptr.i, align 4
  %i.next.i = add i32 %i.iv, 1
  %k.next.i = add i32 %k.iv, 1
  br label %merge.loop

take.j:
  %k.idx.j = zext i32 %k.iv to i64
  %d.ptr.j = getelementptr inbounds i32, i32* %dst.cur, i64 %k.idx.j
  store i32 %j.val, i32* %d.ptr.j, align 4
  %j.next.j = add i32 %j.iv, 1
  %k.next.j = add i32 %k.iv, 1
  br label %merge.loop

copyI.init:
  br label %copyI.loop

copyI.loop:
  %i.tail = phi i32 [ %i.iv, %copyI.init ], [ %i.next.ti, %copyI.loop ]
  %k.tail = phi i32 [ %k.iv, %copyI.init ], [ %k.next.ti, %copyI.loop ]
  %i.has = icmp slt i32 %i.tail, %right
  br i1 %i.has, label %copyI.body, label %copyJ.init

copyI.body:
  %i.idx.ti = zext i32 %i.tail to i64
  %k.idx.ti = zext i32 %k.tail to i64
  %i.ptr.ti = getelementptr inbounds i32, i32* %src.cur, i64 %i.idx.ti
  %d.ptr.ti = getelementptr inbounds i32, i32* %dst.cur, i64 %k.idx.ti
  %i.val.ti = load i32, i32* %i.ptr.ti, align 4
  store i32 %i.val.ti, i32* %d.ptr.ti, align 4
  %i.next.ti = add i32 %i.tail, 1
  %k.next.ti = add i32 %k.tail, 1
  br label %copyI.loop

copyJ.init:
  br label %copyJ.loop

copyJ.loop:
  %j.tail = phi i32 [ %j.iv, %copyJ.init ], [ %j.next.tj, %copyJ.loop ]
  %k.tail2 = phi i32 [ %k.tail, %copyJ.init ], [ %k.next.tj, %copyJ.loop ]
  %j.has = icmp slt i32 %j.tail, %end
  br i1 %j.has, label %copyJ.body, label %merge.end

copyJ.body:
  %j.idx.tj = zext i32 %j.tail to i64
  %k.idx.tj = zext i32 %k.tail2 to i64
  %j.ptr.tj = getelementptr inbounds i32, i32* %src.cur, i64 %j.idx.tj
  %d.ptr.tj = getelementptr inbounds i32, i32* %dst.cur, i64 %k.idx.tj
  %j.val.tj = load i32, i32* %j.ptr.tj, align 4
  store i32 %j.val.tj, i32* %d.ptr.tj, align 4
  %j.next.tj = add i32 %j.tail, 1
  %k.next.tj = add i32 %k.tail2, 1
  br label %copyJ.loop

merge.end:
  %two.run = shl i32 %run.shift, 1
  %base.next = add i32 %base.iv, %two.run
  br label %base.loop

pass.end:
  %src.new = phi i32* [ %dst.cur, %base.loop ]
  %dst.new = phi i32* [ %src.cur, %base.loop ]
  %pass.next = add i32 %pass.iv, 1
  %pass.cont = icmp slt i32 %pass.next, 4
  br i1 %pass.cont, label %pass.loop, label %after.sort

after.sort:
  %arr.ptr.i32 = bitcast [10 x i32]* %arr to i32*
  %need.copy = icmp ne i32* %src.cur, %arr.ptr.i32
  br i1 %need.copy, label %copy.back.init, label %free.and.print

copy.back.init:
  br label %copy.back.loop

copy.back.loop:
  %cb.i = phi i32 [ 0, %copy.back.init ], [ %cb.next, %copy.back.loop ]
  %cb.cond = icmp slt i32 %cb.i, 10
  br i1 %cb.cond, label %copy.back.body, label %free.and.print

copy.back.body:
  %cb.idx = zext i32 %cb.i to i64
  %src.cb.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %cb.idx
  %dst.cb.ptr = getelementptr inbounds i32, i32* %arr.ptr.i32, i64 %cb.idx
  %cb.val = load i32, i32* %src.cb.ptr, align 4
  store i32 %cb.val, i32* %dst.cb.ptr, align 4
  %cb.next = add i32 %cb.i, 1
  br label %copy.back.loop

free.and.print:
  call void @free(i8* %tmp.buf)
  br label %print_common

print_unsorted:
  br label %print_common

print_common:
  %i.print = phi i32 [ 0, %print_unsorted ], [ 0, %free.and.print ]
  br label %print.loop

print.loop:
  %p.iv = phi i32 [ %i.print, %print_common ], [ %p.next, %print.loop ]
  %p.cond = icmp slt i32 %p.iv, 10
  br i1 %p.cond, label %print.body, label %print.nl

print.body:
  %p.idx = zext i32 %p.iv to i64
  %arr.i32.ptr = bitcast [10 x i32]* %arr to i32*
  %elem.ptr = getelementptr inbounds i32, i32* %arr.i32.ptr, i64 %p.idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %elem)
  %p.next = add i32 %p.iv, 1
  br label %print.loop

print.nl:
  %fmt.nl = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %call.printf.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.nl)
  ret i32 0
}