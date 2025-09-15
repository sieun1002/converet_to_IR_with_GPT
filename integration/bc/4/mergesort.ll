; ModuleID = 'mergesort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0.ptr, align 4
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2.ptr, align 4
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4.ptr, align 4
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6.ptr, align 4
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8.ptr, align 4
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9.ptr, align 4
  store i64 10, i64* %n, align 8
  %arr.decay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  call void @merge_sort(i32* noundef %arr.decay, i64 noundef %n.val)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.cur, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.body = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.body
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %i.next = add i64 %i.body, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %bytes.alloc = shl i64 %n, 2
  %buf.i8 = call i8* @malloc(i64 %bytes.alloc)
  %buf.i32 = bitcast i8* %buf.i8 to i32*
  %buf.null = icmp eq i32* %buf.i32, null
  br i1 %buf.null, label %ret, label %init

init:                                             ; preds = %alloc
  %src.init = bitcast i32* %dest to i32*
  %tmp.init = bitcast i32* %buf.i32 to i32*
  br label %outer

outer:                                            ; preds = %swap, %init
  %run.phi = phi i64 [ 1, %init ], [ %run.next, %swap ]
  %src.phi = phi i32* [ %src.init, %init ], [ %src.next, %swap ]
  %tmp.phi = phi i32* [ %tmp.init, %init ], [ %tmp.next, %swap ]
  %cmp.run.lt = icmp ult i64 %run.phi, %n
  br i1 %cmp.run.lt, label %inner.init, label %finalize

inner.init:                                       ; preds = %outer
  %base.init = add i64 0, 0
  br label %inner.loop

inner.loop:                                       ; preds = %after.merge, %inner.init
  %base.phi = phi i64 [ %base.init, %inner.init ], [ %base.next, %after.merge ]
  %cmp.base.lt = icmp ult i64 %base.phi, %n
  br i1 %cmp.base.lt, label %merge.prelude, label %swap

merge.prelude:                                    ; preds = %inner.loop
  %l.cur = add i64 %base.phi, 0
  %mid.raw = add i64 %base.phi, %run.phi
  %mid.gt.n = icmp ugt i64 %mid.raw, %n
  %mid.clamp = select i1 %mid.gt.n, i64 %n, i64 %mid.raw
  %two.run = shl i64 %run.phi, 1
  %rend.raw = add i64 %base.phi, %two.run
  %rend.gt.n = icmp ugt i64 %rend.raw, %n
  %rend.clamp = select i1 %rend.gt.n, i64 %n, i64 %rend.raw
  %i.start = add i64 %l.cur, 0
  %j.start = add i64 %mid.clamp, 0
  %k.start = add i64 %l.cur, 0
  br label %merge.loop

merge.loop:                                       ; preds = %copy.right, %copy.left, %merge.prelude
  %i.phi = phi i64 [ %i.start, %merge.prelude ], [ %i.next.left, %copy.left ], [ %i.next.right, %copy.right ]
  %j.phi = phi i64 [ %j.start, %merge.prelude ], [ %j.next.left, %copy.left ], [ %j.next.right, %copy.right ]
  %k.phi = phi i64 [ %k.start, %merge.prelude ], [ %k.next.left, %copy.left ], [ %k.next.right, %copy.right ]
  %cmp.k.lt = icmp ult i64 %k.phi, %rend.clamp
  br i1 %cmp.k.lt, label %compare, label %after.merge

compare:                                          ; preds = %merge.loop
  %i.lt.mid = icmp ult i64 %i.phi, %mid.clamp
  br i1 %i.lt.mid, label %checkJ, label %take.right

checkJ:                                           ; preds = %compare
  %j.lt.rend = icmp ult i64 %j.phi, %rend.clamp
  br i1 %j.lt.rend, label %load.both, label %take.left

load.both:                                        ; preds = %checkJ
  %ptr.i = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.vi.gt = icmp sgt i32 %val.i, %val.j
  br i1 %cmp.vi.gt, label %take.right, label %take.left

take.left:                                        ; preds = %load.both, %checkJ
  %src.ptr.left = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.left = load i32, i32* %src.ptr.left, align 4
  %tmp.ptr.left = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.left, i32* %tmp.ptr.left, align 4
  %i.next.left = add i64 %i.phi, 1
  %j.next.left = add i64 %j.phi, 0
  %k.next.left = add i64 %k.phi, 1
  br label %copy.left

copy.left:                                        ; preds = %take.left
  br label %merge.loop

take.right:                                       ; preds = %load.both, %compare
  %src.ptr.right = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.right = load i32, i32* %src.ptr.right, align 4
  %tmp.ptr.right = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.right, i32* %tmp.ptr.right, align 4
  %i.next.right = add i64 %i.phi, 0
  %j.next.right = add i64 %j.phi, 1
  %k.next.right = add i64 %k.phi, 1
  br label %copy.right

copy.right:                                       ; preds = %take.right
  br label %merge.loop

after.merge:                                      ; preds = %merge.loop
  %base.next = add i64 %base.phi, %two.run
  br label %inner.loop

swap:                                             ; preds = %inner.loop
  %src.next = bitcast i32* %tmp.phi to i32*
  %tmp.next = bitcast i32* %src.phi to i32*
  %run.next = shl i64 %run.phi, 1
  br label %outer

finalize:                                         ; preds = %outer
  %src.eq.dest = icmp eq i32* %src.phi, %dest
  br i1 %src.eq.dest, label %freebuf, label %docopy

docopy:                                           ; preds = %finalize
  %bytes.copy = shl i64 %n, 2
  %dest.i8.ptr = bitcast i32* %dest to i8*
  %src.i8.ptr = bitcast i32* %src.phi to i8*
  %memcpy.r = call i8* @memcpy(i8* %dest.i8.ptr, i8* %src.i8.ptr, i64 %bytes.copy)
  br label %freebuf

freebuf:                                          ; preds = %docopy, %finalize
  %buf.free.i8 = bitcast i32* %buf.i32 to i8*
  call void @free(i8* %buf.free.i8)
  br label %ret

ret:                                              ; preds = %freebuf, %alloc, %entry
  ret void
}

declare i8* @malloc(i64)

declare i8* @memcpy(i8*, i8*, i64)

declare void @free(i8*)
