; ModuleID = 'mergesort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %elt0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %elt0.ptr, align 4
  %elt1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %elt1.ptr, align 4
  %elt2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %elt2.ptr, align 4
  %elt3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %elt3.ptr, align 4
  %elt4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %elt4.ptr, align 4
  %elt5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %elt5.ptr, align 4
  %elt6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %elt6.ptr, align 4
  %elt7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7.ptr, align 4
  %elt8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elt8.ptr, align 4
  %elt9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %elt9.ptr, align 4
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* noundef %arrdecay, i64 noundef 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %i.next = add i64 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %putchar.call = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %bytes = shl i64 %n, 2
  %rawbuf = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %rawbuf, null
  br i1 %isnull, label %ret, label %init

init:                                             ; preds = %alloc
  %buf = bitcast i8* %rawbuf to i32*
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %init
  %width = phi i64 [ 1, %init ], [ %width.next, %after.inner ]
  %src.cur = phi i32* [ %dest, %init ], [ %out.cur, %after.inner ]
  %out.cur = phi i32* [ %buf, %init ], [ %src.cur, %after.inner ]
  %cond.width = icmp ult i64 %width, %n
  br i1 %cond.width, label %inner.init, label %after.outer

inner.init:                                       ; preds = %outer.header
  br label %inner.header

inner.header:                                     ; preds = %merge.done, %inner.init
  %i = phi i64 [ 0, %inner.init ], [ %i.next, %merge.done ]
  %cond.i = icmp ult i64 %i, %n
  br i1 %cond.i, label %merge.prepare, label %after.inner

merge.prepare:                                    ; preds = %inner.header
  %i.plus.w = add i64 %i, %width
  %mid.lt.n = icmp ult i64 %i.plus.w, %n
  %mid = select i1 %mid.lt.n, i64 %i.plus.w, i64 %n
  %tw = add i64 %width, %width
  %i.plus.tw = add i64 %i, %tw
  %r.lt.n = icmp ult i64 %i.plus.tw, %n
  %r = select i1 %r.lt.n, i64 %i.plus.tw, i64 %n
  br label %merge.cond

merge.cond:                                       ; preds = %take.right, %take.left, %merge.prepare
  %li = phi i64 [ %i, %merge.prepare ], [ %li.next, %take.left ], [ %li, %take.right ]
  %ri = phi i64 [ %mid, %merge.prepare ], [ %ri, %take.left ], [ %ri.next, %take.right ]
  %oi = phi i64 [ %i, %merge.prepare ], [ %oi.nextL, %take.left ], [ %oi.nextR, %take.right ]
  %oi.lt.r = icmp ult i64 %oi, %r
  br i1 %oi.lt.r, label %choose, label %merge.done

choose:                                           ; preds = %merge.cond
  %li.lt.mid = icmp ult i64 %li, %mid
  br i1 %li.lt.mid, label %check.ri, label %take.right

check.ri:                                         ; preds = %choose
  %ri.lt.r = icmp ult i64 %ri, %r
  br i1 %ri.lt.r, label %compare, label %take.left

compare:                                          ; preds = %check.ri
  %lptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %lval.c = load i32, i32* %lptr.c, align 4
  %rptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %rval.c = load i32, i32* %rptr.c, align 4
  %l.gt.r = icmp sgt i32 %lval.c, %rval.c
  br i1 %l.gt.r, label %take.right, label %take.left

take.left:                                        ; preds = %compare, %check.ri
  %src.l.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %val.l = load i32, i32* %src.l.ptr, align 4
  %out.l.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.l, i32* %out.l.ptr, align 4
  %li.next = add i64 %li, 1
  %oi.nextL = add i64 %oi, 1
  br label %merge.cond

take.right:                                       ; preds = %compare, %choose
  %src.r.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %val.r = load i32, i32* %src.r.ptr, align 4
  %out.r.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.r, i32* %out.r.ptr, align 4
  %ri.next = add i64 %ri, 1
  %oi.nextR = add i64 %oi, 1
  br label %merge.cond

merge.done:                                       ; preds = %merge.cond
  %tw2 = add i64 %width, %width
  %i.next = add i64 %i, %tw2
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %width.next = shl i64 %width, 1
  br label %outer.header

after.outer:                                      ; preds = %outer.header
  %src.eq.dest = icmp eq i32* %src.cur, %dest
  br i1 %src.eq.dest, label %do.free, label %do.memcpy

do.memcpy:                                        ; preds = %after.outer
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %bytes.copy = shl i64 %n, 2
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes.copy)
  br label %do.free

do.free:                                          ; preds = %do.memcpy, %after.outer
  call void @free(i8* %rawbuf)
  br label %ret

ret:                                              ; preds = %do.free, %alloc, %entry
  ret void
}

declare noalias i8* @malloc(i64 noundef)

declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

declare void @free(i8* noundef)
