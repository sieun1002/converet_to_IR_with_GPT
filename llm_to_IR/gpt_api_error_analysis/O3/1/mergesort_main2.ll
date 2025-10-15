; ModuleID = 'bottom_up_merge_10'
source_filename = "bottom_up_merge_10.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64) #0
declare void @free(i8*) #0
declare i32 @printf(i8*, ...) #0
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #1

define i32 @main() local_unnamed_addr #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %i0.ptr = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %i0.ptr, align 16
  %i1.ptr = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %i1.ptr, align 4
  %i2.ptr = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 8, i32* %i2.ptr, align 8
  %i3.ptr = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 2, i32* %i3.ptr, align 4
  %i4.ptr = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %i4.ptr, align 16
  %i5.ptr = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 3, i32* %i5.ptr, align 4
  %i6.ptr = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 6, i32* %i6.ptr, align 8
  %i7.ptr = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 5, i32* %i7.ptr, align 4
  %i8.ptr = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %i8.ptr, align 16
  %i9.ptr = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %i9.ptr, align 4
  %malloc.raw = call i8* @malloc(i64 40)
  %malloc.ok = icmp ne i8* %malloc.raw, null
  br i1 %malloc.ok, label %sort, label %print

sort:
  %src.init = bitcast i32* %arr.base to i32*
  %dst.init = bitcast i8* %malloc.raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %sort ], [ %width.next, %outer.latch ]
  %src.buf = phi i32* [ %src.init, %sort ], [ %src.swap, %outer.latch ]
  %dst.buf = phi i32* [ %dst.init, %sort ], [ %dst.swap, %outer.latch ]
  %width.ge.n = icmp sge i64 %width, 10
  br i1 %width.ge.n, label %sorted.done, label %inner

inner:
  %i = phi i64 [ 0, %outer ], [ %i.next, %merge.done ]
  %i.plus.w = add i64 %i, %width
  %m.gt = icmp sgt i64 %i.plus.w, 10
  %m = select i1 %m.gt, i64 10, i64 %i.plus.w
  %i.plus.2w = add i64 %i.plus.w, %width
  %e.gt = icmp sgt i64 %i.plus.2w, 10
  %e = select i1 %e.gt, i64 10, i64 %i.plus.2w
  %a.init = add i64 %i, 0
  %b.init = add i64 %m, 0
  %k.init = add i64 %i, 0
  br label %merge.loop

merge.loop:
  %a = phi i64 [ %a.init, %inner ], [ %a.next.cmp, %choose.left ], [ %a, %choose.right ]
  %b = phi i64 [ %b.init, %inner ], [ %b, %choose.left ], [ %b.next.cmp, %choose.right ]
  %k = phi i64 [ %k.init, %inner ], [ %k.next, %choose.left ], [ %k.next.r, %choose.right ]
  %a.lt.m = icmp slt i64 %a, %m
  %b.lt.e = icmp slt i64 %b, %e
  %both = and i1 %a.lt.m, %b.lt.e
  br i1 %both, label %compare, label %choose.copy

compare:
  %pa = getelementptr inbounds i32, i32* %src.buf, i64 %a
  %va = load i32, i32* %pa, align 4
  %pb = getelementptr inbounds i32, i32* %src.buf, i64 %b
  %vb = load i32, i32* %pb, align 4
  %take.left = icmp slt i32 %va, %vb
  br i1 %take.left, label %choose.left, label %choose.right

choose.left:
  %pdst.l = getelementptr inbounds i32, i32* %dst.buf, i64 %k
  store i32 %va, i32* %pdst.l, align 4
  %a.next.cmp = add i64 %a, 1
  %k.next = add i64 %k, 1
  br label %merge.loop

choose.right:
  %pdst.r = getelementptr inbounds i32, i32* %dst.buf, i64 %k
  store i32 %vb, i32* %pdst.r, align 4
  %b.next.cmp = add i64 %b, 1
  %k.next.r = add i64 %k, 1
  br label %merge.loop

choose.copy:
  %only.left = icmp slt i64 %a, %m
  br i1 %only.left, label %copy.left, label %copy.right.check

copy.left:
  %a.l = phi i64 [ %a, %choose.copy ], [ %a.l.next, %copy.left ]
  %k.l = phi i64 [ %k, %choose.copy ], [ %k.l.next, %copy.left ]
  %pa.rem = getelementptr inbounds i32, i32* %src.buf, i64 %a.l
  %va.rem = load i32, i32* %pa.rem, align 4
  %pdst.rem.l = getelementptr inbounds i32, i32* %dst.buf, i64 %k.l
  store i32 %va.rem, i32* %pdst.rem.l, align 4
  %a.l.next = add i64 %a.l, 1
  %k.l.next = add i64 %k.l, 1
  %more.left = icmp slt i64 %a.l.next, %m
  br i1 %more.left, label %copy.left, label %merge.done.pre

copy.right.check:
  %only.right = icmp slt i64 %b, %e
  br i1 %only.right, label %copy.right, label %merge.done.pre

copy.right:
  %b.r = phi i64 [ %b, %copy.right.check ], [ %b.r.next, %copy.right ]
  %k.r = phi i64 [ %k, %copy.right.check ], [ %k.r.next, %copy.right ]
  %pb.rem = getelementptr inbounds i32, i32* %src.buf, i64 %b.r
  %vb.rem = load i32, i32* %pb.rem, align 4
  %pdst.rem.r = getelementptr inbounds i32, i32* %dst.buf, i64 %k.r
  store i32 %vb.rem, i32* %pdst.rem.r, align 4
  %b.r.next = add i64 %b.r, 1
  %k.r.next = add i64 %k.r, 1
  %more.right = icmp slt i64 %b.r.next, %e
  br i1 %more.right, label %copy.right, label %merge.done.pre

merge.done.pre:
  br label %merge.done

merge.done:
  %i.next = add i64 %e, 0
  %at.end = icmp ult i64 %i.next, 10
  br i1 %at.end, label %inner, label %outer.latch

outer.latch:
  %src.swap = phi i32* [ %dst.buf, %merge.done ]
  %dst.swap = phi i32* [ %src.buf, %merge.done ]
  %width.next = shl i64 %width, 1
  br label %outer

sorted.done:
  %final.src = phi i32* [ %src.buf, %outer ]
  %orig.src = bitcast i32* %arr.base to i32*
  %same = icmp eq i32* %final.src, %orig.src
  br i1 %same, label %free.then, label %copy.back

copy.back:
  %dst.back.i8 = bitcast i32* %orig.src to i8*
  %src.back.i8 = bitcast i32* %final.src to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst.back.i8, i8* %src.back.i8, i64 40, i1 false)
  br label %free.then

free.then:
  call void @free(i8* %malloc.raw)
  br label %print

print:
  %print.idx = phi i64 [ 0, %entry ], [ 0, %free.then ]
  br label %print.loop

print.loop:
  %j = phi i64 [ %print.idx, %print ], [ %j.next, %print.loop ]
  %pje = getelementptr inbounds i32, i32* %arr.base, i64 %j
  %val = load i32, i32* %pje, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %j.next = add i64 %j, 1
  %cont = icmp ult i64 %j.next, 10
  br i1 %cont, label %print.loop, label %print.nl

print.nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call.nl = call i32 (i8*, ...) @printf(i8* %nl.ptr)
  ret i32 0
}

attributes #0 = { nounwind }
attributes #1 = { nounwind argmemonly }