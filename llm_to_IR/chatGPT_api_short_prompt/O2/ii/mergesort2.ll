; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: Iterative merge sort of 10 ints then print them (confidence=0.98). Evidence: run-length doubling merge loops; printing with "%d ".
; Preconditions: None
; Postconditions: Prints 10 integers to stdout, ascending if malloc succeeds; returns 0

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0

  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  %p0 = getelementptr inbounds i32, i32* %arr.ptr, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.ptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.ptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.ptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.ptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.ptr, i64 9
  store i32 0, i32* %p9, align 4

  %buf.raw = call noalias i8* @malloc(i64 40)
  %buf.isnull = icmp eq i8* %buf.raw, null
  br i1 %buf.isnull, label %print, label %sort

sort:
  %buf = bitcast i8* %buf.raw to i32*
  br label %outer

outer:
  ; phis for passes, run, src, dst
  %src.phi = phi i32* [ %arr.ptr, %sort ], [ %src.next, %swap ]
  %dst.phi = phi i32* [ %buf, %sort ], [ %dst.next, %swap ]
  %run.phi = phi i32 [ 1, %sort ], [ %run.next, %swap ]
  %passes.phi = phi i32 [ 4, %sort ], [ %passes.next, %swap ]

  br label %for

for:
  %i = phi i32 [ 0, %outer ], [ %i.next, %after.merge ]
  %i.lt.n = icmp slt i32 %i, 10
  br i1 %i.lt.n, label %do.merge, label %after.for

do.merge:
  %run.dbl = shl i32 %run.phi, 1
  %sum1 = add i32 %i, %run.phi
  %le.cmp = icmp slt i32 %sum1, 10
  %le = select i1 %le.cmp, i32 %sum1, i32 10
  %sum2 = add i32 %i, %run.dbl
  %re.cmp = icmp slt i32 %sum2, 10
  %re = select i1 %re.cmp, i32 %sum2, i32 10
  ; init merge indices
  br label %merge.loop

merge.loop:
  %k = phi i32 [ %i, %do.merge ], [ %k.next, %merge.loop ]
  %l = phi i32 [ %i, %do.merge ], [ %l.next, %merge.loop ]
  %r = phi i32 [ %le, %do.merge ], [ %r.next, %merge.loop ]
  %k.lt.re = icmp slt i32 %k, %re
  br i1 %k.lt.re, label %choose, label %after.merge

choose:
  %l.av = icmp slt i32 %l, %le
  %r.av = icmp slt i32 %r, %re
  br i1 %l.av, label %if.left.av, label %choose.right.only

if.left.av:
  br i1 %r.av, label %load.both, label %choose.left

load.both:
  ; load left and right
  %l.idx64 = sext i32 %l to i64
  %r.idx64 = sext i32 %r to i64
  %lp = getelementptr inbounds i32, i32* %src.phi, i64 %l.idx64
  %rp = getelementptr inbounds i32, i32* %src.phi, i64 %r.idx64
  %lv = load i32, i32* %lp, align 4
  %rv = load i32, i32* %rp, align 4
  %rv.lt.lv = icmp slt i32 %rv, %lv
  br i1 %rv.lt.lv, label %choose.right, label %choose.left.val

choose.left:
  %l.idx64.a = sext i32 %l to i64
  %lp.a = getelementptr inbounds i32, i32* %src.phi, i64 %l.idx64.a
  %lv.a = load i32, i32* %lp.a, align 4
  br label %store.left

choose.left.val:
  ; have lv and rv already
  br label %store.left

store.left:
  %lv.final = phi i32 [ %lv.a, %choose.left ], [ %lv, %choose.left.val ]
  %k.idx64.l = sext i32 %k to i64
  %dp.l = getelementptr inbounds i32, i32* %dst.phi, i64 %k.idx64.l
  store i32 %lv.final, i32* %dp.l, align 4
  %k.next.l = add i32 %k, 1
  %l.next = add i32 %l, 1
  %r.next.ldummy = add i32 %r, 0
  br label %merge.loop

choose.right.only:
  ; left not available, must choose right
  %r.idx64.only = sext i32 %r to i64
  %rp.only = getelementptr inbounds i32, i32* %src.phi, i64 %r.idx64.only
  %rv.only = load i32, i32* %rp.only, align 4
  br label %store.right

choose.right:
  ; both available and right < left
  ; have rv loaded in %rv from load.both
  br label %store.right

store.right:
  %rv.final = phi i32 [ %rv.only, %choose.right.only ], [ %rv, %choose.right ]
  %k.idx64.r = sext i32 %k to i64
  %dp.r = getelementptr inbounds i32, i32* %dst.phi, i64 %k.idx64.r
  store i32 %rv.final, i32* %dp.r, align 4
  %k.next = add i32 %k, 1
  %r.next = add i32 %r, 1
  %l.next.rdummy = add i32 %l, 0
  br label %merge.loop

after.merge:
  %i.next = add i32 %i, %run.dbl
  br label %for

after.for:
  %passes.next = add i32 %passes.phi, -1
  %passes.done = icmp eq i32 %passes.next, 0
  br i1 %passes.done, label %finish, label %swap

swap:
  %src.next = %dst.phi
  %dst.next = %src.phi
  %run.next = shl i32 %run.phi, 1
  br label %outer

finish:
  ; if src != arr.ptr then copy 10 ints to arr
  %src.ne.arr = icmp ne i32* %src.phi, %arr.ptr
  br i1 %src.ne.arr, label %copy.loop, label %free.buf

copy.loop:
  %ci = phi i32 [ 0, %finish ], [ %ci.next, %copy.loop ]
  %ci.lt = icmp slt i32 %ci, 10
  br i1 %ci.lt, label %copy.body, label %free.buf

copy.body:
  %ci64 = sext i32 %ci to i64
  %sp = getelementptr inbounds i32, i32* %src.phi, i64 %ci64
  %dv = load i32, i32* %sp, align 4
  %dp.arr = getelementptr inbounds i32, i32* %arr.ptr, i64 %ci64
  store i32 %dv, i32* %dp.arr, align 4
  %ci.next = add i32 %ci, 1
  br label %copy.loop

free.buf:
  call void @free(i8* %buf.raw)
  br label %print

print:
  ; print arr[0..9]
  %pi = phi i32 [ 0, %entry ], [ 0, %free.buf ]
  br label %print.loop

print.loop:
  %i.p = phi i32 [ %pi, %print ], [ %i.next.p, %print.loop.body ]
  %cond.p = icmp slt i32 %i.p, 10
  br i1 %cond.p, label %print.loop.body, label %print.done

print.loop.body:
  %i64.p = sext i32 %i.p to i64
  %pp = getelementptr inbounds i32, i32* %arr.ptr, i64 %i64.p
  %val = load i32, i32* %pp, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %i.next.p = add i32 %i.p, 1
  br label %print.loop

print.done:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}