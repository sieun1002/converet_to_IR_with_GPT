; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: Bottom-up mergesort of 10 ints, then print them (confidence=0.97). Evidence: iterative merge with doubling run size; prints with "%d " and newline.
; Preconditions: none
; Postconditions: Prints "0 1 2 3 4 5 6 7 8 9" (sorted input)

; Only the necessary external declarations:
declare dso_local noalias i8* @malloc(i64) local_unnamed_addr
declare dso_local void @free(i8*) local_unnamed_addr
declare dso_local i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00"
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00"

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize local array: [9,1,5,3,7,2,8,6,4,0]
  store i32 9, i32* %arr.base, align 16
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %p9, align 4

  %buf.raw = call i8* @malloc(i64 40)
  %malloc.null = icmp eq i8* %buf.raw, null
  br i1 %malloc.null, label %print, label %sort.setup

sort.setup:                                        ; preds = %entry
  %buf.i32 = bitcast i8* %buf.raw to i32*
  br label %outer.pre

outer.pre:                                         ; preds = %outer.end, %sort.setup
  %srcphi = phi i32* [ %arr.base, %sort.setup ], [ %src.swapped, %outer.end ]
  %dstphi = phi i32* [ %buf.i32, %sort.setup ], [ %dst.swapped, %outer.end ]
  %sphi = phi i32 [ 1, %sort.setup ], [ %s.next, %outer.end ]
  %cond = icmp slt i32 %sphi, 10
  br i1 %cond, label %inner.init, label %after.sort

inner.init:                                        ; preds = %outer.pre, %inner.end
  %start = phi i32 [ 0, %outer.pre ], [ %start.next, %inner.end ]
  %tmpa = add nsw i32 %start, %sphi
  %mid.lt = icmp slt i32 %tmpa, 10
  %mid = select i1 %mid.lt, i32 %tmpa, i32 10
  %tmpb = add nsw i32 %tmpa, %sphi
  %end.lt = icmp slt i32 %tmpb, 10
  %end = select i1 %end.lt, i32 %tmpb, i32 10
  %end.le.start = icmp sle i32 %end, %start
  br i1 %end.le.start, label %inner.end, label %merge.init

merge.init:                                        ; preds = %inner.init
  br label %merge.loop

merge.loop:                                        ; preds = %merge.loop.cont, %merge.init
  %i = phi i32 [ %start, %merge.init ], [ %i2phi, %merge.loop.cont ]
  %j = phi i32 [ %mid, %merge.init ], [ %j2phi, %merge.loop.cont ]
  %k = phi i32 [ %start, %merge.init ], [ %k2phi, %merge.loop.cont ]
  %k.end = icmp slt i32 %k, %end
  br i1 %k.end, label %choose, label %inner.done

choose:                                            ; preds = %merge.loop
  %left.avail = icmp slt i32 %i, %mid
  br i1 %left.avail, label %left.case, label %choose.right

left.case:                                         ; preds = %choose
  %right.exhausted = icmp sge i32 %j, %end
  br i1 %right.exhausted, label %take.left, label %compare

compare:                                           ; preds = %left.case
  %i.idx64 = sext i32 %i to i64
  %l.ptr = getelementptr inbounds i32, i32* %srcphi, i64 %i.idx64
  %l.val = load i32, i32* %l.ptr, align 4
  %j.idx64 = sext i32 %j to i64
  %r.ptr = getelementptr inbounds i32, i32* %srcphi, i64 %j.idx64
  %r.val = load i32, i32* %r.ptr, align 4
  %r.lt.l = icmp slt i32 %r.val, %l.val
  br i1 %r.lt.l, label %take.right.cmp, label %take.left

take.left:                                         ; preds = %compare, %left.case
  %i.idx64.2 = sext i32 %i to i64
  %l.ptr.2 = getelementptr inbounds i32, i32* %srcphi, i64 %i.idx64.2
  %l.val.2 = load i32, i32* %l.ptr.2, align 4
  %k.idx64 = sext i32 %k to i64
  %d.ptr = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx64
  store i32 %l.val.2, i32* %d.ptr, align 4
  %i.next = add nsw i32 %i, 1
  %k.next = add nsw i32 %k, 1
  br label %merge.loop.cont

take.right.cmp:                                    ; preds = %compare
  %j.idx64.2 = sext i32 %j to i64
  %r.ptr.2 = getelementptr inbounds i32, i32* %srcphi, i64 %j.idx64.2
  %r.val.2 = load i32, i32* %r.ptr.2, align 4
  %k.idx64.r = sext i32 %k to i64
  %d.ptr.r = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx64.r
  store i32 %r.val.2, i32* %d.ptr.r, align 4
  %j.next.r = add nsw i32 %j, 1
  %k.next.r = add nsw i32 %k, 1
  br label %merge.loop.cont

choose.right:                                      ; preds = %choose
  %j.idx64.3 = sext i32 %j to i64
  %r.ptr.3 = getelementptr inbounds i32, i32* %srcphi, i64 %j.idx64.3
  %r.val.3 = load i32, i32* %r.ptr.3, align 4
  %k.idx64.r3 = sext i32 %k to i64
  %d.ptr.r3 = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx64.r3
  store i32 %r.val.3, i32* %d.ptr.r3, align 4
  %j.next = add nsw i32 %j, 1
  %k.next.2 = add nsw i32 %k, 1
  br label %merge.loop.cont

merge.loop.cont:                                   ; preds = %choose.right, %take.right.cmp, %take.left
  %i2phi = phi i32 [ %i.next, %take.left ], [ %i, %take.right.cmp ], [ %i, %choose.right ]
  %j2phi = phi i32 [ %j, %take.left ], [ %j.next.r, %take.right.cmp ], [ %j.next, %choose.right ]
  %k2phi = phi i32 [ %k.next, %take.left ], [ %k.next.r, %take.right.cmp ], [ %k.next.2, %choose.right ]
  br label %merge.loop

inner.done:                                        ; preds = %merge.loop
  br label %inner.end

inner.end:                                         ; preds = %inner.init, %inner.done
  %two.s = shl i32 %sphi, 1
  %start.next = add nsw i32 %start, %two.s
  %cont.start = icmp slt i32 %start.next, 10
  br i1 %cont.start, label %inner.init, label %outer.end

outer.end:                                         ; preds = %inner.end
  %src.swapped = %dstphi
  %dst.swapped = %srcphi
  %s.next = shl i32 %sphi, 1
  br label %outer.pre

after.sort:                                        ; preds = %outer.pre
  ; If final data not in original array, copy back
  %need.copy = icmp ne i32* %srcphi, %arr.base
  br i1 %need.copy, label %copy.back, label %free.buf

copy.back:                                         ; preds = %after.sort
  br label %copy.loop

copy.loop:                                         ; preds = %copy.loop, %copy.back
  %ci = phi i32 [ 0, %copy.back ], [ %ci.next, %copy.loop ]
  %ci64 = sext i32 %ci to i64
  %src.elem = getelementptr inbounds i32, i32* %srcphi, i64 %ci64
  %val.c = load i32, i32* %src.elem, align 4
  %dst.elem = getelementptr inbounds i32, i32* %arr.base, i64 %ci64
  store i32 %val.c, i32* %dst.elem, align 4
  %ci.next = add nsw i32 %ci, 1
  %copy.done = icmp eq i32 %ci.next, 10
  br i1 %copy.done, label %free.buf, label %copy.loop

free.buf:                                          ; preds = %copy.loop, %after.sort
  call void @free(i8* %buf.raw)
  br label %print

print:                                             ; preds = %free.buf, %entry
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  br label %pr.loop

pr.loop:                                           ; preds = %pr.loop, %print
  %pi = phi i32 [ 0, %print ], [ %pi.next, %pr.loop ]
  %pi64 = sext i32 %pi to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %pi64
  %val = load i32, i32* %elem.ptr, align 4
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %pi.next = add nsw i32 %pi, 1
  %done = icmp eq i32 %pi.next, 10
  br i1 %done, label %newline, label %pr.loop

newline:                                           ; preds = %pr.loop
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}