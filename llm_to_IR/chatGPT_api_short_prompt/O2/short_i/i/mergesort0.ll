; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 ints and print them (confidence=0.93). Evidence: malloc(40) tmp buffer, iterative merge passes (width doubling), printing with "%d ".
; Preconditions: none
; Postconditions: Prints 10 integers followed by newline; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  ; initialize stack array with: 9,1,5,3,7,2,8,6,4,0
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arrp, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %p9, align 4

  %tmpbuf.i8 = call noalias i8* @malloc(i64 40)
  %have_tmp = icmp ne i8* %tmpbuf.i8, null
  br i1 %have_tmp, label %sort.prep, label %print

sort.prep:
  %tmpbuf = bitcast i8* %tmpbuf.i8 to i32*
  ; outer loop: width doubling
  br label %outer.header

outer.header:
  %src.ph = phi i32* [ %arrp, %sort.prep ], [ %src.next, %outer.end ]
  %dst.ph = phi i32* [ %tmpbuf, %sort.prep ], [ %dst.next, %outer.end ]
  %width.ph = phi i32 [ 1, %sort.prep ], [ %width.next, %outer.end ]
  %cmpw = icmp slt i32 %width.ph, 10
  br i1 %cmpw, label %inner.header, label %after.outer

inner.header:
  %i.ph = phi i32 [ 0, %outer.header ], [ %i.next, %after.merge ]
  %ic = icmp slt i32 %i.ph, 10
  br i1 %ic, label %merge.setup, label %outer.end

merge.setup:
  %i.plus.w = add nsw i32 %i.ph, %width.ph
  %mid.sel.cmp = icmp slt i32 %i.plus.w, 10
  %mid = select i1 %mid.sel.cmp, i32 %i.plus.w, i32 10
  %tw = shl i32 %width.ph, 1
  %i.plus.2w = add nsw i32 %i.ph, %tw
  %right.sel.cmp = icmp slt i32 %i.plus.2w, 10
  %right = select i1 %right.sel.cmp, i32 %i.plus.2w, i32 10
  br label %merge.loop

merge.loop:
  %il.ph = phi i32 [ %i.ph, %merge.setup ], [ %il.next, %merge.cont ]
  %ir.ph = phi i32 [ %mid, %merge.setup ], [ %ir.next, %merge.cont ]
  %k.ph  = phi i32 [ %i.ph, %merge.setup ], [ %k.next, %merge.cont ]
  ; while k < right
  %k.lt.r = icmp slt i32 %k.ph, %right
  br i1 %k.lt.r, label %choose, label %after.merge

choose:
  %il.lt.mid = icmp slt i32 %il.ph, %mid
  %ir.lt.r = icmp slt i32 %ir.ph, %right
  ; default take_right if left exhausted
  br i1 %il.lt.mid, label %load.both.check, label %take.right

load.both.check:
  ; if right exhausted -> take left
  br i1 %ir.lt.r, label %load.values, label %take.left

load.values:
  ; load src[il] and src[ir]
  %il64 = sext i32 %il.ph to i64
  %ir64 = sext i32 %ir.ph to i64
  %src.il.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %il64
  %src.ir.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %ir64
  %val.l = load i32, i32* %src.il.ptr, align 4
  %val.r = load i32, i32* %src.ir.ptr, align 4
  ; if right < left -> take right else take left
  %r.lt.l = icmp slt i32 %val.r, %val.l
  br i1 %r.lt.l, label %take.right.loaded, label %take.left.loaded

take.left:
  ; left available, right exhausted
  %il64.a = sext i32 %il.ph to i64
  %src.il.ptr.a = getelementptr inbounds i32, i32* %src.ph, i64 %il64.a
  %val.l.a = load i32, i32* %src.il.ptr.a, align 4
  br label %store.left

take.left.loaded:
  br label %store.left

store.left:
  ; value to store is %val.l or %val.l.a depending path
  %val.left = phi i32 [ %val.l, %load.values ], [ %val.l.a, %take.left ]
  %k64.l = sext i32 %k.ph to i64
  %dst.k.ptr.l = getelementptr inbounds i32, i32* %dst.ph, i64 %k64.l
  store i32 %val.left, i32* %dst.k.ptr.l, align 4
  %il.next = add nsw i32 %il.ph, 1
  %ir.next.l = phi i32 [ %ir.ph, %load.values ], [ %ir.ph, %take.left ]
  %k.next.l = add nsw i32 %k.ph, 1
  br label %merge.cont

take.right:
  ; left exhausted, take right
  %ir64.b = sext i32 %ir.ph to i64
  %src.ir.ptr.b = getelementptr inbounds i32, i32* %src.ph, i64 %ir64.b
  %val.r.b = load i32, i32* %src.ir.ptr.b, align 4
  br label %store.right

take.right.loaded:
  ; chose right by comparison
  br label %store.right

store.right:
  %val.right = phi i32 [ %val.r, %load.values ], [ %val.r.b, %take.right ]
  %k64.r = sext i32 %k.ph to i64
  %dst.k.ptr.r = getelementptr inbounds i32, i32* %dst.ph, i64 %k64.r
  store i32 %val.right, i32* %dst.k.ptr.r, align 4
  %ir.next = add nsw i32 %ir.ph, 1
  %il.next.r = phi i32 [ %il.ph, %load.values ], [ %il.ph, %take.right ]
  %k.next.r = add nsw i32 %k.ph, 1
  br label %merge.cont

merge.cont:
  ; unify increments
  %il.unified = phi i32 [ %il.next, %store.left ], [ %il.next.r, %store.right ]
  %ir.unified = phi i32 [ %ir.next.l, %store.left ], [ %ir.next, %store.right ]
  %k.unified = phi i32 [ %k.next.l, %store.left ], [ %k.next.r, %store.right ]
  br label %merge.loop

after.merge:
  ; next run segment
  %i.next = add nsw i32 %i.ph, %tw
  br label %inner.header

outer.end:
  ; swap src/dst, double width
  %src.next = %dst.ph
  %dst.next = %src.ph
  %width.next = shl i32 %width.ph, 1
  br label %outer.header

after.outer:
  ; if final data not in arr, copy back
  %need.copy = icmp ne i32* %src.ph, %arrp
  br i1 %need.copy, label %copy.loop, label %free.tmp

copy.loop:
  %ci.ph = phi i32 [ 0, %after.outer ], [ %ci.next, %copy.loop ]
  %ci.lt = icmp slt i32 %ci.ph, 10
  br i1 %ci.lt, label %copy.body, label %free.tmp

copy.body:
  %ci64 = sext i32 %ci.ph to i64
  %src.c.ptr = getelementptr inbounds i32, i32* %src.ph, i64 %ci64
  %val.c = load i32, i32* %src.c.ptr, align 4
  %dst.c.ptr = getelementptr inbounds i32, i32* %arrp, i64 %ci64
  store i32 %val.c, i32* %dst.c.ptr, align 4
  %ci.next = add nsw i32 %ci.ph, 1
  br label %copy.loop

free.tmp:
  call void @free(i8* %tmpbuf.i8)
  br label %print

print:
  ; print 10 integers from stack array
  %i.pr.ph = phi i32 [ 0, %free.tmp ], [ 0, %entry ]
  br label %print.loop

print.loop:
  %i.pr = phi i32 [ %i.pr.ph, %print ], [ %i.pr.next, %print.loop ]
  %i.pr.cmp = icmp slt i32 %i.pr, 10
  br i1 %i.pr.cmp, label %print.body, label %print.nl

print.body:
  %i64.pr = sext i32 %i.pr to i64
  %ptr.pr = getelementptr inbounds i32, i32* %arrp, i64 %i64.pr
  %val.pr = load i32, i32* %ptr.pr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val.pr)
  %i.pr.next = add nsw i32 %i.pr, 1
  br label %print.loop

print.nl:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}