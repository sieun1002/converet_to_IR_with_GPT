; ModuleID = 'main_module'
source_filename = "main_module"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = dso_local constant <4 x i32> <i32 5, i32 1, i32 4, i32 2>, align 16
@xmmword_2020 = dso_local constant <4 x i32> <i32 8, i32 5, i32 7, i32 3>, align 16
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare dso_local i32 @___printf_chk(i32, i8*, ...)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  %p0.vec = bitcast i32* %p0 to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %p0.vec, align 16
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 4
  %p4.vec = bitcast i32* %p4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %p4.vec, align 16
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 9
  store i32 0, i32* %p9, align 4
  br label %outer.header

outer.header:                                      ; preds = %entry, %outer.after
  %limit = phi i32 [ 10, %entry ], [ %newlimit, %outer.after ]
  br label %inner.header

inner.header:                                      ; preds = %outer.header, %inner.latch
  %i = phi i32 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %lastSwap = phi i32 [ 0, %outer.header ], [ %lastSwap.next, %inner.latch ]
  %cmp.i.limit = icmp slt i32 %i, %limit
  br i1 %cmp.i.limit, label %inner.body, label %outer.after

inner.body:                                        ; preds = %inner.header
  %idx.prev = add nsw i32 %i, -1
  %p.prev = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %idx.prev
  %p.cur = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %i
  %a = load i32, i32* %p.prev, align 4
  %b = load i32, i32* %p.cur, align 4
  %cmp.ab = icmp sgt i32 %a, %b
  br i1 %cmp.ab, label %inner.swap, label %inner.noswap

inner.swap:                                        ; preds = %inner.body
  store i32 %b, i32* %p.prev, align 4
  store i32 %a, i32* %p.cur, align 4
  br label %inner.latch

inner.noswap:                                      ; preds = %inner.body
  br label %inner.latch

inner.latch:                                       ; preds = %inner.swap, %inner.noswap
  %lastSwap.updated = select i1 %cmp.ab, i32 %i, i32 %lastSwap
  %lastSwap.next = %lastSwap.updated
  %i.next = add nsw i32 %i, 1
  br label %inner.header

outer.after:                                       ; preds = %inner.header
  %no.swap = icmp eq i32 %lastSwap, 0
  br i1 %no.swap, label %print.entry, label %check.one

check.one:                                         ; preds = %outer.after
  %is.one = icmp eq i32 %lastSwap, 1
  br i1 %is.one, label %print.entry, label %reduce.limit

reduce.limit:                                      ; preds = %check.one
  %newlimit = %lastSwap
  br label %outer.header

print.entry:                                       ; preds = %check.one, %outer.after
  br label %print.loop

print.loop:                                        ; preds = %print.entry, %print.loop
  %j = phi i32 [ 0, %print.entry ], [ %j.next, %print.loop ]
  %pj = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 %j
  %val = load i32, i32* %pj, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i32 0, i32 0
  %fmt.i8 = bitcast i8* %fmt.ptr to i8*
  %call.print = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.i8, i32 %val)
  %j.next = add nsw i32 %j, 1
  %cont = icmp slt i32 %j.next, 10
  br i1 %cont, label %print.loop, label %print.after

print.after:                                       ; preds = %print.loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i32 0, i32 0
  %nl.i8 = bitcast i8* %nl.ptr to i8*
  %call.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %nl.i8)
  ret i32 0
}