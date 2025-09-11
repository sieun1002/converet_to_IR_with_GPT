; ModuleID = 'mergesort.ll'
source_filename = "mergesort.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; Initialize array: 9,1,5,3,7,2,8,6,4,0
  store i32 9, i32* %arr.base, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %p9, align 4

  %buf = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %buf, null
  br i1 %isnull, label %print, label %sort

sort:
  %src0 = bitcast [10 x i32]* %arr to i32*
  %dst0 = bitcast i8* %buf to i32*
  br label %outer.cond

outer.cond:
  %passes = phi i32 [ 4, %sort ], [ %passes.dec, %do.swap ]
  %run = phi i32 [ 1, %sort ], [ %run.next, %do.swap ]
  %src.cur = phi i32* [ %src0, %sort ], [ %dst.cur.swap, %do.swap ]
  %dst.cur = phi i32* [ %dst0, %sort ], [ %src.cur.swap, %do.swap ]
  br label %inner.init

inner.init:
  %i = phi i32 [ 0, %outer.cond ], [ %end, %inner.after ]
  %cmp.i = icmp slt i32 %i, 10
  br i1 %cmp.i, label %merge.setup, label %outer.latch

merge.setup:
  %run2 = shl i32 %run, 1
  %mid.cand = add i32 %i, %run
  %mid.lt = icmp slt i32 %mid.cand, 10
  %mid = select i1 %mid.lt, i32 %mid.cand, i32 10
  %end.cand = add i32 %i, %run2
  %end.lt = icmp slt i32 %end.cand, 10
  %end = select i1 %end.lt, i32 %end.cand, i32 10
  br label %merge.loop

merge.loop:
  %a.idx = phi i32 [ %i, %merge.setup ], [ %a.next.a, %take.a ], [ %a.idx, %take.b ]
  %b.idx = phi i32 [ %mid, %merge.setup ], [ %b.idx, %take.a ], [ %b.next.b, %take.b ]
  %out.idx = phi i32 [ %i, %merge.setup ], [ %out.next.a, %take.a ], [ %out.next.b, %take.b ]
  %cond.out = icmp slt i32 %out.idx, %end
  br i1 %cond.out, label %choose, label %inner.after

choose:
  %a.has = icmp slt i32 %a.idx, %mid
  br i1 %a.has, label %b.check, label %take.b

b.check:
  %b.has = icmp slt i32 %b.idx, %end
  br i1 %b.has, label %compare, label %take.a

compare:
  %a.idx.ext = sext i32 %a.idx to i64
  %b.idx.ext = sext i32 %b.idx to i64
  %a.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %a.idx.ext
  %b.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %b.idx.ext
  %a.val = load i32, i32* %a.ptr, align 4
  %b.val = load i32, i32* %b.ptr, align 4
  %b.lt.a = icmp slt i32 %b.val, %a.val
  br i1 %b.lt.a, label %take.b, label %take.a

take.a:
  %a.idx.ext.store = sext i32 %a.idx to i64
  %out.idx.ext.a = sext i32 %out.idx to i64
  %a.load.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %a.idx.ext.store
  %out.store.ptr.a = getelementptr inbounds i32, i32* %dst.cur, i64 %out.idx.ext.a
  %a.val.store = load i32, i32* %a.load.ptr, align 4
  store i32 %a.val.store, i32* %out.store.ptr.a, align 4
  %a.next.a = add i32 %a.idx, 1
  %out.next.a = add i32 %out.idx, 1
  br label %merge.loop

take.b:
  %b.idx.ext.store = sext i32 %b.idx to i64
  %out.idx.ext.b = sext i32 %out.idx to i64
  %b.load.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %b.idx.ext.store
  %out.store.ptr.b = getelementptr inbounds i32, i32* %dst.cur, i64 %out.idx.ext.b
  %b.val.store = load i32, i32* %b.load.ptr, align 4
  store i32 %b.val.store, i32* %out.store.ptr.b, align 4
  %b.next.b = add i32 %b.idx, 1
  %out.next.b = add i32 %out.idx, 1
  br label %merge.loop

inner.after:
  ; advance to next block
  br label %inner.init

outer.latch:
  ; one pass finished
  %passes.dec = add nsw i32 %passes, -1
  %cont = icmp ne i32 %passes.dec, 0
  br i1 %cont, label %do.swap, label %post

do.swap:
  %run.next = shl i32 %run, 1
  ; swap src/dst for next pass
  %dst.cur.swap = %dst.cur
  %src.cur.swap = %src.cur
  br label %outer.cond

post:
  ; final result currently in dst.cur (last write target)
  %final.dst = phi i32* [ %dst.cur, %outer.latch ]
  %needcopy = icmp ne i32* %final.dst, %arr.base
  br i1 %needcopy, label %copy.loop, label %freeit

copy.loop:
  %k = phi i32 [ 0, %post ], [ %k.next, %copy.loop ]
  %k.ext = sext i32 %k to i64
  %src.k.ptr = getelementptr inbounds i32, i32* %final.dst, i64 %k.ext
  %dst.k.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %k.ext
  %v.k = load i32, i32* %src.k.ptr, align 4
  store i32 %v.k, i32* %dst.k.ptr, align 4
  %k.next = add i32 %k, 1
  %k.cont = icmp slt i32 %k.next, 10
  br i1 %k.cont, label %copy.loop, label %freeit

freeit:
  call void @free(i8* %buf)
  br label %print

print:
  %base.print = phi i32* [ %arr.base, %freeit ], [ %arr.base, %entry ]
  %i2 = phi i32 [ 0, %freeit ], [ 0, %entry ]
  %i2.ext = sext i32 %i2 to i64
  %elem.ptr = getelementptr inbounds i32, i32* %base.print, i64 %i2.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elem)
  %i2.next = add i32 %i2, 1
  %cont2 = icmp slt i32 %i2.next, 10
  br i1 %cont2, label %print, label %print.end

print.end:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.1, i64 0, i64 0
  %callp2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}