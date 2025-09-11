; ModuleID = 'mergesort.ll'
target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  ; local array of 10 ints: [9,1,5,3,7,2,8,6,4,0]
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9,  i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1,  i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5,  i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3,  i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7,  i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2,  i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8,  i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6,  i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4,  i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0,  i32* %p9, align 4

  ; try to allocate 40 bytes (10 ints) temporary buffer
  %buf.raw = call i8* @malloc(i64 40)
  %have_buf = icmp ne i8* %buf.raw, null
  br i1 %have_buf, label %do_sort, label %print_only

do_sort:
  %buf = bitcast i8* %buf.raw to i32*
  ; initialization for 4 merge passes
  %src.init = phi i32* [ %arr0, %do_sort ]
  %dst.init = phi i32* [ %buf,  %do_sort ]
  %pass.init = phi i32 [ 0, %do_sort ]
  %w.init = phi i32 [ 1, %do_sort ]
  br label %pass.loop

pass.loop:
  ; loop over passes, up to 4
  %pass = phi i32 [ %pass.init, %do_sort ], [ %pass.next, %pass.end ]
  %w = phi i32 [ %w.init, %do_sort ], [ %w.next, %pass.end ]
  %src = phi i32* [ %src.init, %do_sort ], [ %src.swap, %pass.end ]
  %dst = phi i32* [ %dst.init, %do_sort ], [ %dst.swap, %pass.end ]

  ; inner loop: merge runs of width w across n=10
  br label %merge.loop

merge.loop:
  %start = phi i32 [ 0, %pass.loop ], [ %start.next, %merge.end ]
  %start.lt.n = icmp slt i32 %start, 10
  br i1 %start.lt.n, label %merge.body, label %pass.end

merge.body:
  %start.i64 = sext i32 %start to i64
  %mid.tmp = add nsw i32 %start, %w
  %mid.cmp = icmp sgt i32 %mid.tmp, 10
  %mid = select i1 %mid.cmp, i32 10, i32 %mid.tmp
  %end.tmp = add nsw i32 %start, %w
  %end.tmp2 = add nsw i32 %end.tmp, %w
  %end.cmp = icmp sgt i32 %end.tmp2, 10
  %end = select i1 %end.cmp, i32 10, i32 %end.tmp2

  ; destination pointer for this merge block
  %dst.block = getelementptr inbounds i32, i32* %dst, i64 %start.i64

  ; indices: l = start, r = mid, d = start
  br label %merge.core

merge.core:
  %l = phi i32 [ %start, %merge.body ], [ %l.next, %take.left ], [ %l, %take.right ]
  %r = phi i32 [ %mid,   %merge.body ], [ %r,     %take.left ], [ %r.next, %take.right ]
  %d = phi i32 [ %start, %merge.body ], [ %d.next, %take.left ], [ %d.next2, %take.right ]
  ; if d >= end: done with this block
  %d.ge.end = icmp sge i32 %d, %end
  br i1 %d.ge.end, label %merge.end, label %choose.side

choose.side:
  ; check if left has items: l < mid
  %l.has = icmp slt i32 %l, %mid
  ; check if right has items: r < end
  %r.has = icmp slt i32 %r, %end

  ; if left exhausted -> must take right
  %take.right.only = and i1 (xor i1 %l.has, true), %r.has
  br i1 %take.right.only, label %take.right, label %maybe.left

maybe.left:
  ; if right exhausted -> must take left
  %take.left.only = and i1 %l.has, (xor i1 %r.has, true)
  br i1 %take.left.only, label %take.left, label %compare

compare:
  ; both have elements: compare src[r] < src[l] ? take right : take left
  %l.i64 = sext i32 %l to i64
  %r.i64 = sext i32 %r to i64
  %l.ptr = getelementptr inbounds i32, i32* %src, i64 %l.i64
  %r.ptr = getelementptr inbounds i32, i32* %src, i64 %r.i64
  %l.val = load i32, i32* %l.ptr, align 4
  %r.val = load i32, i32* %r.ptr, align 4
  %r.lt.l = icmp slt i32 %r.val, %l.val
  br i1 %r.lt.l, label %take.right, label %take.left

take.left:
  ; dst[d] = src[l]; l++, d++
  %d.i64 = sext i32 %d to i64
  %d.ptr = getelementptr inbounds i32, i32* %dst.block, i64 %d.i64
  store i32 %l.val, i32* %d.ptr, align 4
  %l.next = add nsw i32 %l, 1
  %d.next = add nsw i32 %d, 1
  br label %merge.core

take.right:
  ; dst[d] = src[r]; r++, d++
  %d.i64.2 = sext i32 %d to i64
  %d.ptr.2 = getelementptr inbounds i32, i32* %dst.block, i64 %d.i64.2
  store i32 %r.val, i32* %d.ptr.2, align 4
  %r.next = add nsw i32 %r, 1
  %d.next2 = add nsw i32 %d, 1
  br label %merge.core

merge.end:
  ; next block
  %two.w = shl i32 %w, 1
  %start.next = add nsw i32 %start, %two.w
  br label %merge.loop

pass.end:
  ; increment pass, double width, and swap src/dst for next pass if any
  %pass.next = add nuw i32 %pass, 1
  %more = icmp ult i32 %pass.next, 4
  %w.next = shl i32 %w, 1
  ; swap
  %src.swap = select i1 %more, i32* %dst, i32* %src
  %dst.swap = select i1 %more, i32* %src, i32* %dst
  br i1 %more, label %pass.loop, label %sorted

sorted:
  ; result is in %dst (destination used in last pass). If it isn't the stack array, copy back.
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst.is.arr = icmp eq i32* %dst, %arr.base
  br i1 %dst.is.arr, label %free_and_print, label %copyback

copyback:
  ; copy 10 ints (40 bytes) from dst to arr
  %arr.i8 = bitcast i32* %arr.base to i8*
  %dst.i8 = bitcast i32* %dst to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %arr.i8, i8* %dst.i8, i64 40, i1 false)
  br label %free_and_print

free_and_print:
  call void @free(i8* %buf.raw)
  br label %print

print_only:
  br label %print

print:
  ; print array contents
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %print.loop

print.loop:
  %i = phi i32 [ 0, %print ], [ %i.next, %print.body ]
  %done = icmp eq i32 %i, 10
  br i1 %done, label %print.nl, label %print.body

print.body:
  %i.i64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %i.next = add nuw i32 %i, 1
  br label %print.loop

print.nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)